//
//  GitHubPRRepositoryImplTests.swift
//  PR Diff ToolTests
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Combine
import Testing
@testable import PR_Diff_Tool

struct GitHubPRRepositoryImplTests {
    
    @Test
    func pullRequests_success() async {
        var cancellables = Set<AnyCancellable>()
        let repo = GitHubPRRepositoryImpl(GitHubDataSourceMock())
        let gitHubRepo = GitHubRepo(id: 0, name: "name", fullName: "fullName")
        do {
            let result = try await withCheckedThrowingContinuation { continuation in
                repo.pullRequests(for: gitHubRepo)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { val in
                        continuation.resume(returning: val)
                    }
                )
                .store(in: &cancellables)
            }
            #expect(result == [GitHubDataSourceMock.generatePR().toModel()])
        } catch {
            Issue.record(error)
        }
    }
    
    @Test
    func pullRequests_fail() async {
        var cancellables = Set<AnyCancellable>()
        let repo = GitHubPRRepositoryImpl(GitHubDataSourceMockFail())
        do {
            let _: Void = try await withCheckedThrowingContinuation { continuation in
                repo.pullRequests(for: .init(id: 0, name: "name", fullName: "fullName"))
                    .sink(
                        receiveCompletion: { completion in
                            if case let .failure(error) = completion {
                                continuation.resume(throwing: error)
                            } else {
                                continuation.resume(returning: ())
                            }
                        },
                        receiveValue: { _ in
                            continuation.resume(returning: ())
                        }
                    )
                    .store(in: &cancellables)
            }
            Issue.record("Unexpected success")
        } catch {
            #expect(error as? GitHubDataSourceMockError == GitHubDataSourceMockError.fail)
        }
    }
    
    @Test
    func pullRequestBy_success() async {
        var cancellables = Set<AnyCancellable>()
        let repo = GitHubPRRepositoryImpl(GitHubDataSourceMock())
        do {
            let result: String = try await withCheckedThrowingContinuation { continuation in
                repo.pullRequestBy(diffUrl: .init(string: "diff_url")!)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { val in
                        continuation.resume(returning: val)
                    }
                )
                .store(in: &cancellables)
            }
            #expect(result == GitHubDataSourceMock.generateDiff())
        } catch {
            Issue.record(error)
        }
    }
    
    @Test
    func pullRequestBy_fail() async{
        var cancellables = Set<AnyCancellable>()
        let repo = GitHubPRRepositoryImpl(GitHubDataSourceMockFail())
        
        do {
            let _: Void = try await withCheckedThrowingContinuation { continuation in
                repo.pullRequestBy(diffUrl: .init(string: "diff_url")!)
                .sink(
                    receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            continuation.resume(throwing: error)
                        } else {
                            continuation.resume(returning: ())
                        }
                    },
                    receiveValue: { _ in
                        continuation.resume(returning: ())
                    }
                )
                .store(in: &cancellables)
            }
            Issue.record("Unexpected success")
        } catch {
            #expect(error as? GitHubDataSourceMockError == GitHubDataSourceMockError.fail)
        }
    }
}
