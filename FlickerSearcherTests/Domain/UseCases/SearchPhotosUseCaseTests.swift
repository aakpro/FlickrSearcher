//
//  SearchPhotosUseCaseTests.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import XCTest
@testable import FlickerSearcher

class SearchPhotosUseCaseTests: XCTestCase {
    
    static let photosPages: [FlickrPhotosRoot] = {
        let page1 = PhotosPage(page: 1, totalPages: 2, perpage: 1, total: "2", photos: [Photo(id: "1", owner: "1", secret: "1", server: "1", farm: 1, title: "1", ispublic: 0, isfriend: 0, isfamily: 0)])
        let page2 = PhotosPage(page: 1, totalPages: 2, perpage: 1, total: "2", photos: [Photo(id: "2", owner: "2", secret: "2", server: "2", farm: 2, title: "2", ispublic: 1, isfriend: 1, isfamily: 1)])
        
        let flickrRoot = [FlickrPhotosRoot(photos: page1, stat: nil), FlickrPhotosRoot(photos: page2, stat: nil)];

        return flickrRoot
    }()
    
    enum PhotosRepositorySuccessTestError: Error {
        case failedFetching
    }
    
    class PhotosQueriesRepositoryMock: PhotosQueriesRepository {
        var recentQueries: [PhotoQuery] = []
        
        func recentsQueries(number: Int, completion: @escaping (Result<[PhotoQuery], Error>) -> Void) {
            completion(.success(recentQueries))
        }
        func saveRecentQuery(query: PhotoQuery, completion: @escaping (Result<PhotoQuery, Error>) -> Void) {
            recentQueries.append(query)
        }
    }
    
    class PhotosRepositorySuccessMock: PhotosRepository {
        func photosList(query: PhotoQuery, page: Int, completion: @escaping (Result<FlickrPhotosRoot, Error>) -> Void) -> Cancellable? {
            completion(.success(SearchPhotosUseCaseTests.photosPages[0]))
            return nil
        }
    }
    
    class PhotosRepositoryFailureMock: PhotosRepository {
        func photosList(query: PhotoQuery, page: Int, completion: @escaping (Result<FlickrPhotosRoot, Error>) -> Void) -> Cancellable? {
            completion(.failure(PhotosRepositorySuccessTestError.failedFetching))
            return nil
        }
    }
    
    func testSearchPhotosUseCase_whenSuccessfullyFetchesPhotosForQuery_thenQueryIsSavedInRecentQueries() {
        // given
        let expectation = self.expectation(description: "Recent query saved")
        expectation.expectedFulfillmentCount = 2
        let photosQueriesRepository = PhotosQueriesRepositoryMock()
        let useCase = DefaultSearchPhotosUseCase(photosRepository: PhotosRepositorySuccessMock(),
                                                  photosQueriesRepository: photosQueriesRepository)

        // when
        let requestValue = SearchPhotosUseCaseRequestValue(query: PhotoQuery(query: "title1"),
                                                                                     page: 0)
        _ = useCase.execute(requestValue: requestValue) { _ in
            expectation.fulfill()
        }
        // then
        var recents = [PhotoQuery]()
        photosQueriesRepository.recentsQueries(number: 1) { result in
            recents = (try? result.get()) ?? []
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(recents.contains(PhotoQuery(query: "title1")))
    }
    
    func testSearchPhotosUseCase_whenFailedFetchingPhotosForQuery_thenQueryIsNotSavedInRecentQueries() {
        // given
        let expectation = self.expectation(description: "Recent query should not be saved")
        expectation.expectedFulfillmentCount = 2
        let photosQueriesRepository = PhotosQueriesRepositoryMock()
        let useCase = DefaultSearchPhotosUseCase(photosRepository: PhotosRepositoryFailureMock(),
                                                photosQueriesRepository: photosQueriesRepository)
        
        // when
        let requestValue = SearchPhotosUseCaseRequestValue(query: PhotoQuery(query: "title1"),
                                                          page: 0)
        _ = useCase.execute(requestValue: requestValue) { _ in
            expectation.fulfill()
        }
        // then
        var recents = [PhotoQuery]()
        photosQueriesRepository.recentsQueries(number: 1) { result in
            recents = (try? result.get()) ?? []
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(recents.isEmpty)
    }
}
