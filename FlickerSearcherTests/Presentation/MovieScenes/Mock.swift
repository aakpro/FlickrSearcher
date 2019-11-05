//
//  Mock.swift
//  FlickrSearcherTests
//
//  Created by Amir Abbas Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import Foundation
import XCTest
@testable import FlickerSearcher

class ImagesRepositoryMock: ImagesRepository {
    
    var expectation: XCTestExpectation?
    var error: Error?
    var imageData = Data()
    
    func image(with image: Photo, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(imageData))
        }
        expectation?.fulfill()
        return nil
    }
}
