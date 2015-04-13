//
//  Tweets.swift
//  Arway The Running Winner
//
//  Created by Anthony Boutinov on 4/12/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

class Tweets {
    
    static var tweets: [TweetStruct] = [TweetStruct]()
    static private var index = 0
    
    class func getNext() -> TweetStruct {
        let result = tweets[index++]
        
        if index == tweets.count {
            index = 0
        }
        
        return result
    }
    
    class func getData() -> Bool {
        
        let endpoint = NSURL(string: "http://82.146.43.238")!
        
        // несколько попыток
        for try in 0...6 {
            if let data = NSData(contentsOfURL: endpoint) {
                
                if let json: NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSArray {
                    for item in json {
                        if let dictionary = item as? NSDictionary {
                            
                            println(dictionary)
                            
                            if let author = dictionary["AUTHOR"] as? String {
                                if let text = dictionary["CONTENT"] as? String {
                                    tweets.append((author: "@" + author, text: text))
                                }
                            }
                        }
                    }
                    return true
                }
            }
        }
        return false
    }
    
}