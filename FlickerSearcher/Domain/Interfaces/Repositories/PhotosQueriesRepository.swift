//
//  PhotosQueriesRepository.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/4/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import UIKit

/// Photo query repository protocol to abstract save and retrive queries 
protocol PhotosQueriesRepository {
    func recentsQueries(number: Int, completion: @escaping (Result<[PhotoQuery], Error>) -> Void)
    func saveRecentQuery(query: PhotoQuery, completion: @escaping (Result<PhotoQuery, Error>) -> Void)
}
