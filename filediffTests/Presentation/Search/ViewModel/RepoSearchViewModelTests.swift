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

struct RepoSearchViewModelTests {
    
    enum TestError: Error {
        case invalidState
    }
    
    @Test
    func init_State() {
        let viewModel = RepoSearchViewModel(repo: GitHubRepoRepositoryMock())
        switch viewModel.state {
        case .loading, .error, .loaded:
            Issue.record("Invalid state: \(viewModel.state)")
        case .initial:
            #expect(viewModel.title == "GitHub Repository Diff Tool")
        }
    }
    
    @Test
    func searchRepos_invalid_emptyInput() async {
        var cancellables = Set<AnyCancellable>()
        let viewModel = RepoSearchViewModel(repo: GitHubRepoRepositoryMock())
        viewModel.searchRepos(with: "")
        do {
            let _: Void = try await withCheckedThrowingContinuation { continuation in
                viewModel.$state
                    .sink { state in
                        switch state {
                        case .initial:
                            break
                        case .loaded, .loading:
                            continuation.resume(throwing: RepoSearchViewModelTests.TestError.invalidState)
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
    func searchRepos_invalid_whitespaceInput() async {
        var cancellables = Set<AnyCancellable>()
        let viewModel = RepoSearchViewModel(repo: GitHubRepoRepositoryMock())
        viewModel.searchRepos(with: "    ")
        do {
            let _: Void = try await withCheckedThrowingContinuation { continuation in
                viewModel.$state
                    .sink { state in
                        switch state {
                        case .initial:
                            break
                        case .loaded, .loading:
                            continuation.resume(throwing: RepoSearchViewModelTests.TestError.invalidState)
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
    func searchRepos_Success() async {
        var cancellables = Set<AnyCancellable>()
        let viewModel = RepoSearchViewModel(repo: GitHubRepoRepositoryMock())
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

    @Test
    func searchRepos_Fail() async {
        var cancellables = Set<AnyCancellable>()
        let viewModel = RepoSearchViewModel(repo: GitHubRepoRepositoryMockFail())
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
