//
//  DefaultImagesRepository.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/4/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import Foundation

/// Implementation of image downloader
final class DefaultImagesRepository {
    
    private let dataTransferService: DataTransferService
    private let imageNotFoundData: Data?
    
    init(dataTransferService: DataTransferService,
         imageNotFoundData: Data?) {
        self.dataTransferService = dataTransferService
        self.imageNotFoundData = imageNotFoundData
    }
}

extension DefaultImagesRepository: ImagesRepository {
    
    /// Download given photo data
    /// - Parameter photo: data of image
    /// - Parameter completion: results
    func image(with photo: Photo, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        
        let endpoint = APIEndpoints.photoPoster(photo)
        let networkTask = dataTransferService.request(with: endpoint) { [weak self] (response: Result<Data, Error>) in
            guard let strongSelf = self else { return }

            switch response {
            case .success(let data):
                completion(.success(data))
                return
            case .failure(let error):
                if case let DataTransferError.networkFailure(networkError) = error, networkError.isNotFoundError,
                    let imageNotFoundData = strongSelf.imageNotFoundData {
                    completion(.success(imageNotFoundData))
                    return
                }
                completion(.failure(error))
                return
            }
        }
        return RepositoryTask(networkTask: networkTask)
    }
}
