//
//  DefaultPhotosQueriesRepository.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/4/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import Foundation

/// Keep data of Implementation of PhotosQueriesRepository
final class DefaultPhotosQueriesRepository {
    
    private let dataTransferService: DataTransferService
    private var photosQueriesPersistentStorage: PhotosQueriesStorage
    
    init(dataTransferService: DataTransferService,
         photosQueriesPersistentStorage: PhotosQueriesStorage) {
        self.dataTransferService = dataTransferService
        self.photosQueriesPersistentStorage = photosQueriesPersistentStorage
    }
}

extension DefaultPhotosQueriesRepository: PhotosQueriesRepository {
    
    func recentsQueries(number: Int, completion: @escaping (Result<[PhotoQuery], Error>) -> Void) {
        return photosQueriesPersistentStorage.recentsQueries(number: number, completion: completion)
    }
    
    func saveRecentQuery(query: PhotoQuery, completion: @escaping (Result<PhotoQuery, Error>) -> Void) {
        photosQueriesPersistentStorage.saveRecentQuery(query: query, completion: completion)
    }
}
