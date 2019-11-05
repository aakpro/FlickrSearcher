//
//  PhotoQuery.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/4/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import UIKit

/// Helper entity to keeyp the query
struct PhotoQuery {
    
    let query: String
}

extension PhotoQuery: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(query)
    }
}
