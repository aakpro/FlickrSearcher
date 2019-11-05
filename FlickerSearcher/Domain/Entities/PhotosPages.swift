//
//  PhotosPages.swift
//  FlickrSearcher
//
//  Created by Amir Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import Foundation


/// Keep the pagination data based on flickr Api
struct PhotosPage {
    let page : Int?
    let totalPages : Int?
    let perpage : Int?
    let total : String?
    let photos : [Photo]?
}
