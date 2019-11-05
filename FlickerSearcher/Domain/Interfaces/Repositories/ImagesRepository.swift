//
//  ImagesRepository.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/4/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import Foundation

/// Image repository protocol to abstract image downloading from implmentation
protocol ImagesRepository {
    func image(with image: Photo, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable?
}
