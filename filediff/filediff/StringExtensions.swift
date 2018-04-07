//
//  StringExtensions.swift
//  filediff
//
//  Created by bn-user on 7/13/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation

extension String {
    
    //https://stackoverflow.com/questions/42476395/how-to-split-string-using-regex-expressions
    func getMatches(pattern : String) -> [String]{
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        // NSRegularExpression works with objective-c NSString, which are utf16 encoded
        let matches = regex.matches(in: self, range: NSMakeRange(0, self.utf16.count))
        
        // the combination of zip, dropFirst and map to optional here is a trick
        // to be able to map on [(result1, result2), (result2, result3), (result3, nil)]
        let results = zip(matches, matches.dropFirst().map { Optional.some($0) } + [nil]).map { current, next -> String in
            let range = current.range(at: 0)
            let start = String.UTF16Index(encodedOffset: range.lowerBound)
            // if there's a next, use it's starting location as the ending of our match
            // otherwise, go to the end of the searched string
            let end = next.map { $0.range(at: 0) }.map { _ in String.UTF16Index(encodedOffset: range.lowerBound) } ?? String.UTF16Index(encodedOffset: self.count)

            return String(self.utf16[start..<end])!
        }
        
        return results
    }
}
