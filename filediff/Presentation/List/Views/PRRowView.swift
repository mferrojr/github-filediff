//
//  PRRowView.swift
//  PR Diff Tool
//
//  Created by Michael Ferro.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import SwiftUI

struct PRRowView: View {
    var model: PRRowViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.title ?? "")
                .bold()
                .font(.system(size:17))
            Text(model.subTitle)
                .font(.system(size:12))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PRRowView_Previews: PreviewProvider {
    static var previews: some View {
        PRRowView(model: PRRowViewModel(entity:
            .init(id: 3,
            body: nil,
            created_at: nil,
            diff_url: "diff_url",
            number: 6,
            state: nil,
            title: "title",
            user: .init(id: 5, login: "login", avatarUrl: URL(string: "http://avatar.url")!)
            )
        ))
    }
}
