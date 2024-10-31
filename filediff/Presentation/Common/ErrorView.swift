//
//  ErrorView.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation
import SwiftUI

struct ErrorView: View {
    let text: String
    let imageSystemName: String
    
    var body: some View {
        VStack {
            Label {
                Text(text)
            } icon: {
                Image(systemName: imageSystemName)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color.red)
            }
            .padding(8)
            Spacer()
        }
    }
}
