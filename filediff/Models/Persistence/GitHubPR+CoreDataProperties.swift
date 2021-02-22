//
//  GitHubPR+CoreDataProperties.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/3/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//
//

import Foundation
import CoreData

extension GitHubPR {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GitHubPR> {
        return NSFetchRequest<GitHubPR>(entityName: "GitHubPR")
    }

    @NSManaged public var body: String?
    @NSManaged public var created_at: String?
    @NSManaged public var diff_url: String?
    @NSManaged public var id: Int32
    @NSManaged public var number: Int32
    @NSManaged public var state: String?
    @NSManaged public var title: String?
    @NSManaged public var user: GitHubUser?

}
