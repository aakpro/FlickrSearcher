//
//  PhotosQueriesListViewModelTests.swift
//  FlickrSearcherTests
//
//  Created by Amir Abbas Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import XCTest
@testable import FlickerSearcher

class PhotosQueriesListViewModelTests: XCTestCase {
    
    private enum FetchRecentQueriedUseCase: Error {
        case someError
    }
    
    var photoQueries = [PhotoQuery(query: "query1"),
                        PhotoQuery(query: "query2"),
                        PhotoQuery(query: "query3"),
                        PhotoQuery(query: "query4"),
                        PhotoQuery(query: "query5")]
    
    class PhotosQueryListViewModelDelegateMock: PhotosQueryListViewModelDelegate {
        var expectation: XCTestExpectation?
        var didNotifiedWithPhotoQuery: PhotoQuery?
        func photosQueriesListDidSelect(photoQuery: PhotoQuery) {
            didNotifiedWithPhotoQuery = photoQuery
            expectation?.fulfill()
        }
    }
    
    class FetchRecentPhotoQueriesUseCaseMock: FetchRecentPhotoQueriesUseCase {
        var expectation: XCTestExpectation?
        var error: Error?
        var photoQueries: [PhotoQuery] = []
        
        func execute(requestValue: FetchRecentPhotoQueriesUseCaseRequestValue, completion: @escaping (Result<[PhotoQuery], Error>) -> Void) -> Cancellable? {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(photoQueries))
            }
            expectation?.fulfill()
            return nil
        }
    }
    
    func test_whenFetchRecentPhotoQueriesUseCaseReturnsQueries_thenShowTheseQueries() {
        // given
        let useCase = FetchRecentPhotoQueriesUseCaseMock()
        useCase.expectation = self.expectation(description: "Recent query fetched")
        useCase.photoQueries = photoQueries
        let viewModel = DefaultPhotosQueryListViewModel(numberOfQueriesToShow: 3,
                                                    fetchRecentPhotoQueriesUseCase: useCase)

        // when
        viewModel.viewWillAppear()
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.items.value.map { $0.query }, photoQueries.map { $0.query })
    }
    
    func test_whenFetchRecentPhotoQueriesUseCaseReturnsError_thenDontShowAnyQuery() {
        // given
        let useCase = FetchRecentPhotoQueriesUseCaseMock()
        useCase.expectation = self.expectation(description: "Recent query fetched")
        useCase.error = FetchRecentQueriedUseCase.someError
        let viewModel = DefaultPhotosQueryListViewModel(numberOfQueriesToShow: 3,
                                                        fetchRecentPhotoQueriesUseCase: useCase)
        
        // when
        viewModel.viewWillAppear()
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(viewModel.items.value.isEmpty)
    }
    
    func test_whenDidSelectQueryEventIsReceived_thenNotifyDelegate() {
        // given
        let selectedQueryItem = PhotoQuery(query: "query1")
        let delegate = PhotosQueryListViewModelDelegateMock()
        delegate.expectation = self.expectation(description: "Delegate notified")
        
        let viewModel = DefaultPhotosQueryListViewModel(numberOfQueriesToShow: 3,
                                                        fetchRecentPhotoQueriesUseCase: FetchRecentPhotoQueriesUseCaseMock(),
                                                        delegate: delegate)
        
        // when
        viewModel.didSelect(item: DefaultPhotosQueryListItemViewModel(query: selectedQueryItem.query))
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(delegate.didNotifiedWithPhotoQuery, selectedQueryItem)
    }
}
