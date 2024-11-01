//
//  LoadingView.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import SwiftUI

/// Displays loading view
struct LoadingView: View {
    var body: some View {
        VStack {
            Label {
                Text("Loading...")
            } icon: {
                Image(systemName: "gear")
                    .symbolRenderingMode(.hierarchical)
            }
            .padding(8)
            Spacer()
        }
    }
}
