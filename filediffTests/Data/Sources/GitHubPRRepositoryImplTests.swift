//
//  GitHubPRRepositoryImplTests.swift
//  PR Diff ToolTests
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Combine
import XCTest
@testable import PR_Diff_Tool

final class GitHubPRRepositoryImplTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func test_pullRequests_success() {
        let repo = GitHubPRRepositoryImpl(GitHubDataSourceMock())
        let expect = expectation(description: "success state")
        let gitHubRepo = GitHubRepo(id: 0, name: "name", fullName: "fullName")
        repo.pullRequests(for: gitHubRepo)
        .sink(
            receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail()
                } else {
                    expect.fulfill()
                }
            },
            receiveValue: { val in
                XCTAssertEqual(val, [GitHubDataSourceMock.generatePR().toModel()])
            }
        )
        .store(in: &cancellables)
        wait(for: [expect], timeout: 3)
    }
    
    func test_pullRequests_fail() {
        let repo = GitHubPRRepositoryImpl(GitHubDataSourceMockFail())
        let expect = expectation(description: "error state")
        repo.pullRequests(for: .init(id: 0, name: "name", fullName: "fullName"))
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
    
    func test_pullRequestBy_success() {
        let repo = GitHubPRRepositoryImpl(GitHubDataSourceMock())
        let expect = expectation(description: "success state")
        repo.pullRequestBy(diffUrl: .init(string: "diff_url")!)
        .sink(
            receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail()
                } else {
                    expect.fulfill()
                }
            },
            receiveValue: { val in
                XCTAssertEqual(val, GitHubDataSourceMock.generateDiff())
            }
        )
        .store(in: &cancellables)
        wait(for: [expect], timeout: 3)
    }
    
    func test_pullRequestBy_fail() {
        let repo = GitHubPRRepositoryImpl(GitHubDataSourceMockFail())
        
        let expect = expectation(description: "error state")
        repo.pullRequestBy(diffUrl: .init(string: "diff_url")!)
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
