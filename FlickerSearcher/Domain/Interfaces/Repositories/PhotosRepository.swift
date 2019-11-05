//
//  PhotosRepository.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/4/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import UIKit

/// Image repository protocol to abstract searching photos from implmentation
protocol PhotosRepository {
    @discardableResult
    func photosList(query: PhotoQuery, page: Int, completion: @escaping (Result<FlickrPhotosRoot, Error>) -> Void) -> Cancellable?

}
