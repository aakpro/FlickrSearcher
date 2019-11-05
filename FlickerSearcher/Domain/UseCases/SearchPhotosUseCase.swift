//
//  SearchPhotosUseCase.swift
//  FlickrSearcher
//
//  Created by Amir Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import UIKit

/// Main use case to search flickr photos
protocol SearchPhotosUseCase {
    func execute(requestValue: SearchPhotosUseCaseRequestValue,
                 completion: @escaping (Result<FlickrPhotosRoot, Error>) -> Void) -> Cancellable?

}


/// Default implementation of search photo use case
final class DefaultSearchPhotosUseCase: SearchPhotosUseCase {

    private let photosRepository: PhotosRepository
    private let photosQueriesRepository: PhotosQueriesRepository
    
    init(photosRepository: PhotosRepository, photosQueriesRepository: PhotosQueriesRepository) {
        self.photosRepository = photosRepository
        self.photosQueriesRepository = photosQueriesRepository
    }
    
    func execute(requestValue: SearchPhotosUseCaseRequestValue,
                 completion: @escaping (Result<FlickrPhotosRoot, Error>) -> Void) -> Cancellable? {
        return photosRepository.photosList(query: requestValue.query, page: requestValue.page) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success:
                strongSelf.photosQueriesRepository.saveRecentQuery(query: requestValue.query) { _ in }
                completion(result)
            case .failure:
                completion(result)
            }
        }
    }
}

struct SearchPhotosUseCaseRequestValue {
    let query: PhotoQuery
    let page: Int
}
