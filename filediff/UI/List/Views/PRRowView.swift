//
//  PRRowView.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr. on 6/26/23.
//  Copyright © 2023 Michael Ferro. All rights reserved.
//

import SwiftUI

struct PRRowView: View {
    var model: PRTableViewCellModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.title ?? "")
                .bold()
                .font(.system(size:17))
            Text(model.subTitle)
                .font(.system(size:12))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
    }
}

struct PRRowView_Previews: PreviewProvider {
    static var previews: some View {
        PRRowView(model: PRTableViewCellModel(title: "title", subTitle: "subTitle"))
    }
}
