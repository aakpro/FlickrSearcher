//
//  FlickrPhotosRoot.swift
//  FlickrSearcher
//
//  Created by Amir Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import Foundation


/// Root entity based on flickr api
struct FlickrPhotosRoot {
    let photos : PhotosPage?
    let stat : String?
}
