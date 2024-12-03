//
//  GitHubRepoRepositoryImplTests.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Combine
import Foundation
import Testing
@testable import PR_Diff_Tool

struct GitHubRepoRepositoryImplTests {
    
    @Test
    func searchRepo_success() async {
        var cancellables = Set<AnyCancellable>()
        let repo = GitHubRepoRepositoryImpl(GitHubDataSourceMock())
        
        do {
            let result = try await withCheckedThrowingContinuation { continuation in
                repo.searchRepo(by: "test")
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
            #expect(result == GitHubDataSourceMock.generateSearch().toModel())
        } catch {
            Issue.record(error)
        }
    }
    
    @Test
    func searchRepo_fail() async {
        var cancellables = Set<AnyCancellable>()
        let repo = GitHubRepoRepositoryImpl(GitHubDataSourceMockFail())
        
        do {
            let _: Void = try await withCheckedThrowingContinuation { continuation in
                repo.searchRepo(by: "test")
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
