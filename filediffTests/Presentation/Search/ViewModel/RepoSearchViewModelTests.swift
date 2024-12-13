//
//  RepoSearchViewModelTest.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Combine
import Testing
@testable import PR_Diff_Tool

struct RepoSearchViewModelTests_Success {
    enum TestError: Error {
        case invalidState
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: RepoSearchViewModel = {
        let viewModel = RepoSearchViewModel()
        viewModel.repo = GitHubRepoRepositoryMock()
        return viewModel
    }()
    
    @Test
    func init_State() {
        switch viewModel.state {
        case .loading, .error, .loaded:
            Issue.record("Invalid state: \(viewModel.state)")
        case .initial:
            #expect(viewModel.title == "GitHub Repository Diff Tool")
        }
    }
    
    @Test
    mutating func searchRepos_invalid_emptyInput() async {
        viewModel.searchRepos(with: "")
        do {
            let _: Void = try await withCheckedThrowingContinuation { continuation in
                viewModel.$state
                    .sink { state in
                        switch state {
                        case .initial:
                            break
                        case .loaded, .loading:
                            continuation.resume(throwing: RepoSearchViewModelTests_Success.TestError.invalidState)
                        case .error(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                    .store(in: &cancellables)
            }
        } catch {
            switch error {
            case RepoSearchViewModelError.invalidSearchText:
                break
            default:
                Issue.record(error)
            }
        }
    }
    
    @Test
    mutating func searchRepos_invalid_whitespaceInput() async {
        viewModel.searchRepos(with: "    ")
        do {
            let _: Void = try await withCheckedThrowingContinuation { continuation in
                viewModel.$state
                    .sink { state in
                        switch state {
                        case .initial:
                            break
                        case .loaded, .loading:
                            continuation.resume(throwing: RepoSearchViewModelTests_Success.TestError.invalidState)
                        case .error(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                    .store(in: &cancellables)
            }
        } catch {
            switch error {
            case RepoSearchViewModelError.invalidSearchText:
                break
            default:
                Issue.record(error)
            }
        }
    }
    
    @Test
    mutating func searchRepos() async {
        viewModel.searchRepos(with: "test")
        do {
            let result: [RepoByLetterItem] = try await withCheckedThrowingContinuation { continuation in
                viewModel.$state
                    .sink { state in
                        switch state {
                        case .initial, .loading:
                            break
                        case .loaded(let items):
                            continuation.resume(returning: items)
                        case .error(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                    .store(in: &cancellables)
            }
            #expect(result == GitHubRepoRepositoryMock.generateSearchSorted())
        } catch {
            Issue.record(error)
        }
    }
}

struct RepoSearchViewModelTests_Fail {
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: RepoSearchViewModel = {
        let viewModel = RepoSearchViewModel()
        viewModel.repo = GitHubRepoRepositoryMockFail()
        return viewModel
    }()
    
    @Test
    mutating func searchRepos_Fail() async {
        viewModel.searchRepos(with: "test")
        do {
            let _: Void = try await withCheckedThrowingContinuation { continuation in
                viewModel.$state
                    .sink { state in
                        switch state {
                        case .initial, .loading:
                            break
                        case .loaded:
                            continuation.resume(returning: ())
                        case .error(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                    .store(in: &cancellables)
            }
            Issue.record("Unexpected success")
        } catch {
            #expect(error as? GitHubRepoRepositoryMockError == GitHubRepoRepositoryMockError.fail)
        }
    }
}
