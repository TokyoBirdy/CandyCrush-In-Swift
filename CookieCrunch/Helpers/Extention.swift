//
//  Extention.swift
//  CookieCrunch
//
//  Created by Cecilia Humlelu on 26/11/14.
//  Copyright (c) 2014 HU. All rights reserved.
//

import Foundation



extension Dictionary {
    static func loadJsonFromBundle(fileName:String)-> Dictionary<String,AnyObject>?{
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType:"json"){
            var error:NSError?
            let data:NSData? = NSData(contentsOfFile:path, options:NSDataReadingOptions(),error:&error)
            if let data = data {
                let dictionary:AnyObject? =  NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(),error:&error)
                if let dictionary = dictionary as? Dictionary<String,AnyObject>{
                    return dictionary
                } else {
                    println("Level file '\(fileName)' is not valid JSON: \(error!)")
                    return nil
                }
            }else {
                println("Could not load level file: \(fileName), error: \(error!)")
                return nil
            }
        } else {
            println("Could not find level file: \(fileName)")
            return nil
        }
    }
}