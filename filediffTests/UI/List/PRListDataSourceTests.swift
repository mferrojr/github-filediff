//
//  PRListDataSourceTests.swift
//  filediffTests
//
//  Created by Michael Ferro, Jr. on 5/2/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//

import XCTest
@testable import filediff

class PRListDataSourceTests: XCTestCase {

    func testRefresh() throws {
        let dataSource = PRListDataSource(prService: MockGitHubPREntityServicable())
        dataSource.refresh()
        
        XCTAssertEqual(dataSource.datas.count,2)
    }

}
