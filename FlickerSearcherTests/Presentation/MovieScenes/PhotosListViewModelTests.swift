//
//  PhotosListViewModelTests.swift
//  FlickrSearcherTests
//
//  Created by Amir Abbas Kashani on 11/5/19.
//  Copyright © 2019 Photo. All rights reserved.
//

import XCTest
@testable import FlickerSearcher

class PhotosListViewModelTests: XCTestCase {
    
    private enum SearchPhotosUseCaseError: Error {
        case someError
    }
    
    static let photosPages: [FlickrPhotosRoot] = {
        let page1 = PhotosPage(page: 1, totalPages: 2, perpage: 1, total: "2", photos: [Photo(id: "1", owner: "1", secret: "1", server: "1", farm: 1, title: "1", ispublic: 0, isfriend: 0, isfamily: 0)])
        let page2 = PhotosPage(page: 1, totalPages: 2, perpage: 1, total: "2", photos: [Photo(id: "2", owner: "2", secret: "2", server: "2", farm: 2, title: "2", ispublic: 1, isfriend: 1, isfamily: 1)])
        
        let flickrRoot = [FlickrPhotosRoot(photos: page1, stat: nil), FlickrPhotosRoot(photos: page2, stat: nil)];
        
        return flickrRoot
    }()
    
    
    class SearchPhotosUseCaseMock: SearchPhotosUseCase {
        
        
        var expectation: XCTestExpectation?
        var error: Error?
        var page = PhotosListViewModelTests.photosPages.first!
        
        func execute(requestValue: SearchPhotosUseCaseRequestValue, completion: @escaping (Result<FlickrPhotosRoot, Error>) -> Void) -> Cancellable? {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(PhotosListViewModelTests.photosPages.first!))
            }
            expectation?.fulfill()
            return nil
        }
    }
    
    func test_whenSearchPhotosUseCaseRetrievesFirstPage_thenViewModelContainsOnlyFirstPage() {
        // given
        let searchPhotosUseCaseMock = SearchPhotosUseCaseMock()
        searchPhotosUseCaseMock.expectation = self.expectation(description: "contains only first page")
        searchPhotosUseCaseMock.page = PhotosListViewModelTests.photosPages.first!
        let imageRepository = ImagesRepositoryMock()
        let viewModel = DefaultPhotosListViewModel(searchPhotosUseCase: searchPhotosUseCaseMock, imagesRepository: imageRepository)
        // when
        viewModel.didSearch(query: "query")
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(viewModel.hasMorePages)
    }
    
    func test_whenSearchPhotosUseCaseRetrievesFirstAndSecondPage_thenViewModelContainsTwoPages() {
        // given
        let searchPhotosUseCaseMock = SearchPhotosUseCaseMock()
        searchPhotosUseCaseMock.expectation = self.expectation(description: "First page loaded")
        
        searchPhotosUseCaseMock.page = PhotosListViewModelTests.photosPages.first!
        let viewModel = DefaultPhotosListViewModel(searchPhotosUseCase: searchPhotosUseCaseMock,
                                                   imagesRepository: ImagesRepositoryMock())
        // when
        viewModel.didSearch(query: "query")
        waitForExpectations(timeout: 5, handler: nil)
        
        searchPhotosUseCaseMock.expectation = self.expectation(description: "Second page loaded")
        searchPhotosUseCaseMock.page = PhotosListViewModelTests.photosPages.last!

        viewModel.didLoadNextPage()
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(viewModel.hasMorePages)
    }
    
    func test_whenSearchPhotosUseCaseReturnsError_thenViewModelContainsError() {
        // given
        let searchPhotosUseCaseMock = SearchPhotosUseCaseMock()
        searchPhotosUseCaseMock.expectation = self.expectation(description: "contain errors")
        searchPhotosUseCaseMock.error = SearchPhotosUseCaseError.someError
        let viewModel = DefaultPhotosListViewModel(searchPhotosUseCase: searchPhotosUseCaseMock,
                                                   imagesRepository: ImagesRepositoryMock())
        // when
        viewModel.didSearch(query: "query")
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(viewModel.error)
    }
    
    func test_whenLastPage_thenHasNoPageIsTrue() {
        // given
        let searchPhotosUseCaseMock = SearchPhotosUseCaseMock()
        searchPhotosUseCaseMock.expectation = self.expectation(description: "First page loaded")
        searchPhotosUseCaseMock.page = PhotosListViewModelTests.photosPages.first!
        let viewModel = DefaultPhotosListViewModel(searchPhotosUseCase: searchPhotosUseCaseMock,
                                                   imagesRepository: ImagesRepositoryMock())
        // when
        viewModel.didSearch(query: "query")
        waitForExpectations(timeout: 5, handler: nil)
        
        searchPhotosUseCaseMock.expectation = self.expectation(description: "Second page loaded")
        searchPhotosUseCaseMock.page = PhotosListViewModelTests.photosPages.last!

        viewModel.didLoadNextPage()
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(viewModel.hasMorePages)
    }
    
}
