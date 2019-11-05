//
//  AppConfigurations.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import UIKit

/// Get basic configuration which are embeded in project settings
final class AppConfigurations: NSObject
{
    lazy var apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String else {
            fatalError("ApiKey must not be empty in plist")
        }
        return apiKey
    }()
    
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    lazy var imagesBaseURL: String = {
        guard let imagesBaseURL = Bundle.main.object(forInfoDictionaryKey: "imagesBaseURL") as? String else {
            fatalError("imagesBaseURL must not be empty in plist")
        }
        return imagesBaseURL

    }()
}
