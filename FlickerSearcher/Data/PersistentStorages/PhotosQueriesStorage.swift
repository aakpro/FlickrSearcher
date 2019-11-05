//
//  PhotosQueriesStorage.swift
//  FlickrSearcher
//
//  Created by Amir Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import UIKit

/// A protocol to abstract Persistent Storages
protocol PhotosQueriesStorage {
    func recentsQueries(number: Int, completion: @escaping (Result<[PhotoQuery], Error>) -> Void)
    func saveRecentQuery(query: PhotoQuery, completion: @escaping (Result<PhotoQuery, Error>) -> Void)
}
