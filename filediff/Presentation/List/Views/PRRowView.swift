//
//  PRRowView.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import SwiftUI

struct PRRowView: View {
    @StateObject var model: PRRowViewModel
    private let kImageSize: CGFloat = 10
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.title)
                .bold()
                .font(.system(size:17))
            HStack {
                Text(model.prTitle)
                    .font(.system(size:12))
                if let url = model.avatarUrl {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: kImageSize, height: kImageSize)
                                .background(Color.black)
                                .clipShape(Circle())
                        default:
                            Image(systemName: "person.circle")
                                .frame(width: kImageSize, height: kImageSize)
                                .accessibilityLabel(AccessibilityElement.Images.Label.noAvatarIcon.rawValue)
                        }
                    }
                    .accessibilityLabel(AccessibilityElement.Images.Label.avatarIcon.rawValue)
                }
                Text(model.userTitle)
                    .font(.system(size:12))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PRRowView_Previews: PreviewProvider {
    static var previews: some View {
        PRRowView(model: PRRowViewModel(entity:
            .init(id: 3,
            body: nil,
            created_at: "2024-11-18T20:09:31Z",
            diff_url: "diff_url",
            number: 6,
            state: "open",
            title: "title",
            user: .init(id: 5, login: "login", avatarUrl: URL(string: "https://developer.apple.com/news/images/og/swiftui-og.png")!)
            )
        ))
    }
}
