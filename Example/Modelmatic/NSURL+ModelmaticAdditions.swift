//
// Copyright (C) 2016 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

import Foundation

extension NSURL
{
    func queryParameters() -> NSDictionary?
    {
        let dict = NSMutableDictionary()
        guard let params = query?.componentsSeparatedByString("&") else { return nil }
        for currString: NSString in params {
            let s = currString.componentsSeparatedByString("=")
            dict[s[0]] = s[1]
        }
        return dict
    }
    
    func parameterValue(key: NSString) -> String? {
        guard let dict = queryParameters(), value = dict[key] else { return nil }
        return value as? String
    }
    
    class func documentDirectoryURL(forFileName fileName: String, type: String) -> NSURL? {
        let URLs = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return URLs.first?.URLByAppendingPathComponent(fileName).URLByAppendingPathExtension(type)
    }
    
    class func bundleDirectoryURL(forFileName fileName: String, type: String) -> NSURL? {
        return NSBundle(forClass: AuthorObjectStore.self).URLForResource(fileName, withExtension: type)
    }
    
    class func libraryDirectoryURL(forFileName fileName: String, type: String) -> NSURL? {
        let URLs = NSFileManager.defaultManager().URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask)
        return URLs.first?.URLByAppendingPathComponent(fileName).URLByAppendingPathExtension(type)
    }
}


extension NSHTTPURLResponse {
    var valid: Bool { return statusCode == 200 }
}

extension NSDictionary
{
    class func dictionary(contentsOfPropertyListFile fileName: String) -> NSDictionary?
    {
        if  let URL = NSURL.documentDirectoryURL(forFileName: fileName, type: "plist"),
            let dict = NSDictionary(contentsOfURL: URL) {
            return dict
        }
        
        guard let URL = NSURL.bundleDirectoryURL(forFileName: fileName, type: "plist") else { return nil }
        return NSDictionary(contentsOfURL: URL)
    }
    
    class func dictionary(contentsOfJSONFile fileName: String) -> NSDictionary?
    {
        if let url = NSURL.documentDirectoryURL(forFileName: fileName, type: "json"),
            dict = NSDictionary.dictionary(contentsOf: url) {
            return dict
        }
        
        guard let url = NSURL.bundleDirectoryURL(forFileName: fileName, type: "json") else { return nil }
        return NSDictionary.dictionary(contentsOf: url)
    }
}
