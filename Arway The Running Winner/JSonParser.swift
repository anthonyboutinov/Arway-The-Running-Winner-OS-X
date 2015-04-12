//
//  JSonParser.swift
//  Arway The Running Winner
//
//  Created by Anthony Boutinov on 4/12/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

//import Foundation
//
//class JSONParser: NSObject {
//    
//    private class func getJSON(urlToRequest: String) -> NSData{
//        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
//    }
//    
//    private class func parseJSON(inputData: NSData) -> NSDictionary{
//        var error: NSError?
//        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
//        
//        return boardsDictionary
//    }
//
//    class func getData(urlToRequest: String) -> NSDictionary {
//        return parseJSON(getJSON(urlToRequest))
//    }
//   
//    
//}