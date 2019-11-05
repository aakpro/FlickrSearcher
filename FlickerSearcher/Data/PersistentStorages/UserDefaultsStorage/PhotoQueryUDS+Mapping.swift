//
//  PhotoQueryUDS+Mapping.swift
//  FlickrSearcher
//
//  Created by Amir Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import Foundation

/// The main entity to save data in user default setting
struct PhotoQueriesListUDS: Codable {
    var list: [PhotoQueryUDS]
}

struct PhotoQueryUDS: Codable {
    let query: String
}

extension PhotoQueryUDS {
    init(photoQuery: PhotoQuery) {
        query = photoQuery.query
    }
}

extension PhotoQuery {
    init(photoQueryUDS: PhotoQueryUDS) {
        query = photoQueryUDS.query
    }
}
