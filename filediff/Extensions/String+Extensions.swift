//
//  StringExtensions.swift
//  filediff
//
//  Created by bn-user on 7/13/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation

extension String {
    
    enum LocalKey: String {
        case pullRequests = "PULL REQUESTS"
        case pullToRefresh = "PULL TO REFRESH"
        case viewDiff = "VIEW DIFF"
    }

    static func localize(_ localKey: LocalKey, with comment: String = "") -> String {
        return NSLocalizedString(localKey.rawValue, comment: comment)
    }
    
    //https://stackoverflow.com/questions/42476395/how-to-split-string-using-regex-expressions
    func getMatches(pattern : String) -> [String]{
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        // NSRegularExpression works with objective-c NSString, which are utf16 encoded
        let matches = regex.matches(in: self, range: NSMakeRange(0, self.utf16.count))
        
        // the combination of zip, dropFirst and map to optional here is a trick
        // to be able to map on [(result1, result2), (result2, result3), (result3, nil)]
        let results = zip(matches, matches.dropFirst().map { Optional.some($0) } + [nil]).map { current, next -> String in
            let range = current.range(at: 0)
            
            let start = String.Index(utf16Offset: range.lowerBound, in: self)
            
            // if there's a next, use it's starting location as the ending of our match
            // otherwise, go to the end of the searched string
            let end = next.map { $0.range(at: 0) }.map { _ in String.Index(utf16Offset: range.lowerBound, in: self) } ?? String.Index(utf16Offset: self.count, in: self)

            return String(self.utf16[start..<end])!
        }
        
        return results
    }
}
