//
//  GitHubRepoRepositoryImplTests.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Combine
import Foundation
import XCTest
@testable import PR_Diff_Tool

final class GitHubRepoRepositoryImplTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func test_searchRepo_success() {
        let repo = GitHubRepoRepositoryImpl(GitHubDataSourceMock())
        let expect = expectation(description: "success state")
        repo.searchRepo(by: "test")
        .sink(
            receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail()
                } else {
                    expect.fulfill()
                }
            },
            receiveValue: { val in
                XCTAssertEqual(val, GitHubDataSourceMock.generateSearch().toModel())
            }
        )
        .store(in: &cancellables)
        wait(for: [expect], timeout: 3)
    }
    
    func test_searchRepo_fail() {
        let repo = GitHubRepoRepositoryImpl(GitHubDataSourceMockFail())
        let expect = expectation(description: "error state")
        repo.searchRepo(by: "test")
        .sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTAssertEqual(error as? GitHubDataSourceMockError, GitHubDataSourceMockError.fail)
                    expect.fulfill()
                } else {
                    XCTFail()
                }
            },
            receiveValue: { _ in
            }
        )
        .store(in: &cancellables)
        wait(for: [expect], timeout: 3)
    }
}
