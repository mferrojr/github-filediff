//
//  GitHubUser+CoreDataProperties.swift
//  filediff
//
//  Created by Michael Ferro, Jr. on 4/3/20.
//  Copyright © 2020 Michael Ferro. All rights reserved.
//
//

import Foundation
import CoreData

extension GitHubUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GitHubUser> {
        return NSFetchRequest<GitHubUser>(entityName: "GitHubUser")
    }

    @NSManaged public var avatar_url: String?
    @NSManaged public var id: Int32
    @NSManaged public var login: String?
    @NSManaged public var pullRequests: NSSet?

}

// MARK: Generated accessors for pullRequests
extension GitHubUser {

    @objc(addPullRequestsObject:)
    @NSManaged public func addToPullRequests(_ value: GitHubPR)

    @objc(removePullRequestsObject:)
    @NSManaged public func removeFromPullRequests(_ value: GitHubPR)

    @objc(addPullRequests:)
    @NSManaged public func addToPullRequests(_ values: NSSet)

    @objc(removePullRequests:)
    @NSManaged public func removeFromPullRequests(_ values: NSSet)

}
