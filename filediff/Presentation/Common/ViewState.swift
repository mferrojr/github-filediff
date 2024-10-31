//
//  ViewState.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

enum ViewState<T> {
    case initial
    case loading
    case loaded(T)
    case error(Error)
}
