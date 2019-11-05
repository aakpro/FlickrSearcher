//
//  DefaultPhotosRepository.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/4/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import Foundation

/// Create and return data task for downloading data based on search term
final class DefaultPhotosRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultPhotosRepository: PhotosRepository {
    
    /// Start getting data of a search term
    /// - Parameter query: search  term
    /// - Parameter page: page number
    /// - Parameter completion: results in a callback
    func photosList(query: PhotoQuery, page: Int, completion: @escaping (Result<FlickrPhotosRoot, Error>) -> Void) -> Cancellable? {
 
        let endpoint = APIEndpoints.photos(query: query.query, page: page)
        let networkTask = self.dataTransferService.request(with: endpoint, completion: completion)
        return RepositoryTask(networkTask: networkTask)
    }
}
