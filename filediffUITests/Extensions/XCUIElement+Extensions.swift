//
//  XCUIElement+Extensions.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import XCTest

extension XCUIElement {
    
    /// Attempt to retrieve the first cell
    func firstCell() -> XCUIElement {
        self.cells.children(matching: .any).element(boundBy: 0)
    }
}
