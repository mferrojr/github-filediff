//
//  AccessibilityElement.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

struct AccessibilityElement {
    
    struct Buttons {
        enum ID: String {
            case viewPRDiff = "View PR Diff"
        }
    }
    
    
    struct Images {
        enum Label: String {
            case pendingMerge = "Pending Merge Icon"
            case noAvatarIcon = "No Avatar Icon"
            case avatarIcon = "Avatar Icon"
            case searchIcon = "Search Icon"
        }
    }
    
    struct Lists {
        enum ID: String {
            case repository = "LIST_REPOSITORY"
            case pullRequests = "LIST_PR"
        }
    }
    
    struct Sections {
        enum ID: String {
            case repository = "SECTION_REPOSITORY"
        }
    }
    
    struct Tables {
        enum ID: String {
            case prDiff = "TABLE_PR_DIFF"
        }
    }
    
    struct TextFields {
        enum ID: String {
            case searchForRepository = "Search for repository..."
        }
    }
}
