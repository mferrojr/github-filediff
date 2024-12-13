//
//  PRListViewModelTests.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Testing
import Combine
@testable import PR_Diff_Tool

struct PRListViewModelTests_Success {
    private var viewModel: PRListViewModel = {
        let viewModel = PRListViewModel(repo: .init(id: 0, name: "name", fullName: "fullName"))
        viewModel.prRepo = GitHubPRRepositoryMock()
        return viewModel
    }()
    
    @Test
    func init_state() {
        switch viewModel.state {
        case .loading, .error, .loaded:
            Issue.record("Unexpected state")
        case .initial:
            #expect(viewModel.navTitle == "name \(String.localize(.openPullRequest))")
        }
    }
    
    @Test
    func refreshData_Loading() {
        viewModel.refreshData()
        switch viewModel.state {
        case .initial, .error, .loaded:
            Issue.record("Unexpected state")
        case .loading:
            break
        }
    }
    
    @Test
    func searchData_Load() async {
        var cancellables = Set<AnyCancellable>()
        
        viewModel.refreshData()
        do {
            let result: [GitHubPullRequest] = try await withCheckedThrowingContinuation { continuation in
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
            #expect(result == [GitHubPRRepositoryMock.generatePR()])
        } catch {
            Issue.record(error)
        }
    }
}

struct PRListViewModelTests_Fail {
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: PRListViewModel = {
        let viewModel = PRListViewModel(repo: .init(id: 0, name: "name", fullName: "fullName"))
        viewModel.prRepo = GitHubPRRepositoryMockFail()
        return viewModel
    }()
    
    @Test
    mutating func init_Refresh_Fail() async {
        viewModel.refreshData()
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
            #expect(error as? GitHubPRRepositoryMockError == GitHubPRRepositoryMockError.fail)
        }
    }
}
