//
//  PRDetailsView.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import SwiftUI

struct PRDetailsView: View {
    weak var coordinator: MainCoordinator?
    @State var viewModel: PRDetailsViewModel
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .bold()
                    .font(.system(size:17))
                    .padding(.bottom, 10)
                Text(viewModel.body)
                    .font(.system(size: 15))
                Button(viewModel.btnTitle) {
                    coordinator?.navigate(to: .pullRequestDiff(entity: self.viewModel.entity))
                }
                .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .padding(20)
        }
    }
}

struct PRDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let entity = GitHubPullRequest(
            id: 0,
            body: "body",
            created_at: "created_at",
            diff_url: "diff_url",
            number: 3,
            state: "state",
            title: "title",
            user: nil)
        let model = PRDetailsViewModel(entity: entity)
        PRDetailsView(viewModel: model)
    }
}
