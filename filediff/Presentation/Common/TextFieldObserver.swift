//
//  TextFieldObserver.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr. on 10/29/24.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Combine
import SwiftUI

/// Adds a delay when entering text
/// [Reference](https://stackoverflow.com/a/66165075)
class TextFieldObserver : ObservableObject {
    @Published var debouncedText = ""
    @Published var searchText = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(milliseconds: Int = 500) {
        $searchText
            .debounce(for: .milliseconds(milliseconds), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] t in
                self?.debouncedText = t
            } )
            .store(in: &subscriptions)
    }
}
