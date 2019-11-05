//
//  PhotosQueryListViewModel.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/4/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

// View model for interacting with queries 

import Foundation

protocol PhotosQueryListViewModelInput {
    func viewWillAppear()
    func didSelect(item: PhotosQueryListItemViewModel)
}

protocol PhotosQueryListViewModelOutput {
    var items: Observable<[PhotosQueryListItemViewModel]> { get }
}

protocol PhotosQueryListViewModel: PhotosQueryListViewModelInput, PhotosQueryListViewModelOutput { }

protocol PhotosQueryListViewModelDelegate: class {
    func photosQueriesListDidSelect(photoQuery: PhotoQuery)
}


class DefaultPhotosQueryListViewModel: PhotosQueryListViewModel {

    private let numberOfQueriesToShow: Int
    private let fetchRecentPhotoQueriesUseCase: FetchRecentPhotoQueriesUseCase
    private weak var delegate: PhotosQueryListViewModelDelegate?
    
    // MARK: - OUTPUT
    let items: Observable<[PhotosQueryListItemViewModel]> = Observable([PhotosQueryListItemViewModel]())
    
    init(numberOfQueriesToShow: Int,
         fetchRecentPhotoQueriesUseCase: FetchRecentPhotoQueriesUseCase,
         delegate: PhotosQueryListViewModelDelegate? = nil) {
        self.numberOfQueriesToShow = numberOfQueriesToShow
        self.fetchRecentPhotoQueriesUseCase = fetchRecentPhotoQueriesUseCase
        self.delegate = delegate
    }
    
    private func updatePhotosQueries() {
        let request = FetchRecentPhotoQueriesUseCaseRequestValue(number: numberOfQueriesToShow)
        _ = fetchRecentPhotoQueriesUseCase.execute(requestValue: request) { [weak self] result in
            switch result {
            case .success(let items):
                self?.items.value = items.map { $0.query }.map ( DefaultPhotosQueryListItemViewModel.init )
            case .failure: break
            }
        }
    }
}

// MARK: - INPUT. View event methods
extension DefaultPhotosQueryListViewModel {
        
    func viewWillAppear() {
        updatePhotosQueries()
    }
    
    func didSelect(item: PhotosQueryListItemViewModel) {
        delegate?.photosQueriesListDidSelect(photoQuery: PhotoQuery(query: item.query))
    }
}
