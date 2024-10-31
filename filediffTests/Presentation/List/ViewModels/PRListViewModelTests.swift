//
//  PRListViewModelTests.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import XCTest
import Combine
@testable import PR_Diff_Tool

final class PRListViewModelTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func test_init() {
        let viewModel = PRListViewModel(repo: .init(id: 0, name: "name", fullName: "fullName"),
                                        prRepo: GitHubPRRepositoryMock())
        XCTAssertEqual(viewModel.navTitle, "name \(String.localize(.openPullRequest))")
        switch viewModel.state {
        case .loading, .error, .loaded:
            XCTFail()
        case .initial:
            break
        }
    }
    
    func test_refreshData_Loading() {
        let viewModel = PRListViewModel(repo: .init(id: 0, name: "name", fullName: "fullName"),
                                        prRepo: GitHubPRRepositoryMock())
        viewModel.refreshData()
        switch viewModel.state {
        case .initial, .error, .loaded:
            XCTFail()
        case .loading:
            break
        }
    }
    
    func test_searchData_LoadSuccess() {
        let viewModel = PRListViewModel(repo: .init(id: 0, name: "name", fullName: "fullName"),
                                        prRepo: GitHubPRRepositoryMock())
        let expect = expectation(description: "loaded state")
        viewModel.$state
            .sink { state in
                switch state {
                case .initial, .error, .loading:
                    break
                case .loaded(let items):
                    XCTAssertEqual(items, [GitHubPRRepositoryMock.generatePR()])
                    expect.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.refreshData()
        wait(for: [expect], timeout: 3)
    }
    
    func test_Initialization_Refresh_Fail() {
        let viewModel = PRListViewModel(repo: .init(id: 0, name: "name", fullName: "fullName"),
                                        prRepo: GitHubPRRepositoryMockFail())
        let expect = expectation(description: "error state")
        viewModel.$state
            .sink { state in
                switch state {
                case .initial, .loaded, .loading:
                    break
                case .error(let error):
                    XCTAssertEqual(error as? GitHubPRRepositoryMockError, GitHubPRRepositoryMockError.fail)
                    expect.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.refreshData()
        wait(for: [expect], timeout: 3)
    }
}
