//
//  PRDetailsView.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr. on 6/28/23.
//  Copyright © 2023 Michael Ferro. All rights reserved.
//

import SwiftUI

struct PRDetailsView: View {
    var model: PRDetailsViewModel
    var coordinator: MainCoordinator?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(model.entity.title ?? "")
                    .bold()
                    .font(.system(size:17))
                    .padding(.bottom, 10)
                Text(model.entity.body ?? "")
                    .font(.system(size: 15))
                Button(model.btnTitle) {
                    coordinator?.viewPullRequestDiff(entity: self.model.entity)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle(model.title)
            .navigationBarTitleDisplayMode(.inline)
            .padding(20)
        }
    }
}

struct PRDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let entity = GitHubPREntity(body: "body", title: "title", number: 5)
        let model = PRDetailsViewModel(entity: entity)
        PRDetailsView(model: model)
    }
}
