//
//  RepoSearchViewModelTest.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Combine
import XCTest
@testable import PR_Diff_Tool

final class RepoSearchViewModelTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func test_init() {
        let viewModel = RepoSearchViewModel(repo: GitHubRepoRepositoryMock())
        XCTAssertEqual(viewModel.title, .localize(.gitHubRepositoryDiffTool))
        switch viewModel.state {
        case .loading, .error, .loaded:
            XCTFail()
        case .initial:
            break
        }
    }
    
    func test_searchRepos_invalid_emptyInput() {
        let viewModel = RepoSearchViewModel(repo: GitHubRepoRepositoryMock())
        let expect = expectation(description: "loaded state")
        expect.expectedFulfillmentCount = 2
        viewModel.$state
            .sink { state in
                switch state {
                case .loaded, .error, .loading:
                    break
                case .initial:
                    expect.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchRepos(with: "")
        wait(for: [expect], timeout: 3)
    }
    
    func test_searchRepos_invalid_whitespaceInput() {
        let viewModel = RepoSearchViewModel(repo: GitHubRepoRepositoryMock())
        let expect = expectation(description: "loaded state")
        expect.expectedFulfillmentCount = 2
        viewModel.$state
            .sink { state in
                switch state {
                case .loaded, .error, .loading:
                    break
                case .initial:
                    expect.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchRepos(with: "    ")
        wait(for: [expect], timeout: 3)
    }
    
    func test_searchRepos_Success() {
        let viewModel = RepoSearchViewModel(repo: GitHubRepoRepositoryMock())
        let expect = expectation(description: "loaded state")
        viewModel.$state
            .sink { state in
                switch state {
                case .initial, .error, .loading:
                    break
                case .loaded(let items):
                    XCTAssertEqual(items, GitHubRepoRepositoryMock.generateSearch().items)
                    expect.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchRepos(with: "test")
        wait(for: [expect], timeout: 3)
    }
    
    func test_searchRepos_Fail() {
        let viewModel = RepoSearchViewModel(repo: GitHubRepoRepositoryMockFail())
        let expect = expectation(description: "error state")
        viewModel.$state
            .sink { state in
                switch state {
                case .initial, .loaded, .loading:
                    break
                case .error(let error):
                    XCTAssertEqual(error as? GitHubRepoRepositoryMockError, GitHubRepoRepositoryMockError.fail)
                    expect.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchRepos(with: "test")
        wait(for: [expect], timeout: 3)
    }
}
