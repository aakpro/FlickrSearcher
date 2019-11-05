//
//  FetchRecentPhotoQueriesUseCase.swift
//  FlickrSearcher
//
//  Created by Amir Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import UIKit

/// Main use case of program to save search queries and retrive them
protocol FetchRecentPhotoQueriesUseCase {
    func execute(requestValue: FetchRecentPhotoQueriesUseCaseRequestValue,
                 completion: @escaping (Result<[PhotoQuery], Error>) -> Void) -> Cancellable?
}

/// Default implementation FetchRecentPhotoQueriesUseCase
final class DefaultFetchRecentPhotoQueriesUseCase: FetchRecentPhotoQueriesUseCase {
    
    private let photosQueriesRepository: PhotosQueriesRepository
    
    init(photosQueriesRepository: PhotosQueriesRepository) {
        self.photosQueriesRepository = photosQueriesRepository
    }
    
    func execute(requestValue: FetchRecentPhotoQueriesUseCaseRequestValue,
                 completion: @escaping (Result<[PhotoQuery], Error>) -> Void) -> Cancellable? {
        photosQueriesRepository.recentsQueries(number: requestValue.number, completion: completion)
        return nil
    }
}


struct FetchRecentPhotoQueriesUseCaseRequestValue {
    let number: Int
}
