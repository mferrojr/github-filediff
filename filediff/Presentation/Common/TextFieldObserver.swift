//
//  TextFieldObserver.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr. on 10/29/24.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Combine
import SwiftUI

/// [Reference](https://stackoverflow.com/a/66165075)
class TextFieldObserver : ObservableObject {
    @Published var debouncedText = ""
    @Published var searchText = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] t in
                self?.debouncedText = t
            } )
            .store(in: &subscriptions)
    }
}
