//
//  PRListView.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr. on 6/29/23.
//  Copyright © 2023 Michael Ferro. All rights reserved.
//

import SwiftUI

struct PRListView: View {
    
    var coordinator: MainCoordinator?
    @StateObject var viewModel: PRListViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.entities) { entity in
                    PRRowView(model: PRTableViewCellModel(entity: entity))
                }
            }
            .refreshable {
                viewModel.refreshData()
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PRListView_Previews: PreviewProvider {
    static var previews: some View {
        var entities = [GitHubPREntity]()
        let entity = GitHubPREntity(body: "body", title: "title", number: 5)
        entities.append(entity)
        let vm = PRListViewModel(title: "Welcome", entities: entities)
        return PRListView(viewModel: vm)
    }
}
