//
//  PhotosSceneDIContainer.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/4/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import UIKit

final class PhotosSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies

    // MARK: - Persistent Storage
    lazy var photosQueriesStorage: PhotosQueriesStorage = UserDefaultsStorage(maxStorageLimit: 20)
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeSearchPhotosUseCase() -> SearchPhotosUseCase {
        return DefaultSearchPhotosUseCase(photosRepository: makePhotosRepository(),
                                          photosQueriesRepository: makePhotosQueriesRepository())
    }
    
    func makeFetchRecentPhotoQueriesUseCase() -> FetchRecentPhotoQueriesUseCase {
        return DefaultFetchRecentPhotoQueriesUseCase(photosQueriesRepository: makePhotosQueriesRepository())
    }
    
    // MARK: - Repositories
    func makePhotosRepository() -> PhotosRepository {
        return DefaultPhotosRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    func makePhotosQueriesRepository() -> PhotosQueriesRepository {
        return DefaultPhotosQueriesRepository(dataTransferService: dependencies.apiDataTransferService,
                                              photosQueriesPersistentStorage: photosQueriesStorage)
    }
    func makeImagesRepository() -> ImagesRepository {
        return DefaultImagesRepository(dataTransferService: dependencies.imageDataTransferService,
                                             imageNotFoundData: UIImage(named: "image_not_found")?.pngData())
    }
    
    // MARK: - Photos List
    func makePhotosListViewController() -> UIViewController {
        return PhotosListViewController.create(with: makePhotosListViewModel(), photosListViewControllersFactory: self)
    }
    
    func makePhotosListViewModel() -> PhotosListViewModel {
        return DefaultPhotosListViewModel(searchPhotosUseCase: makeSearchPhotosUseCase(),
                                          imagesRepository: makeImagesRepository())
    }
    
    // MARK: - Photo Details
    func makePhotosDetailsViewController(title: String, image: Data) -> UIViewController {
            return PhotoDetailViewController.create(with: makePhotosDetailsViewModel(title: title, image: image))
    }
    
    func makePhotosDetailsViewModel(title: String,
                                    image: Data) -> PhotoDetailsViewModel {
        return DefaultPhotoDetailsViewModel(title: title, image: image)
    }
    // MARK: - Photos Queries Suggestions List
    func makePhotosQueriesSuggestionsListViewController(delegate: PhotosQueryListViewModelDelegate) -> UIViewController {
        return PhotosQueriesTableViewController.create(with: makePhotosQueryListViewModel(delegate: delegate))
        
    }
    
    func makePhotosQueryListViewModel(delegate: PhotosQueryListViewModelDelegate) -> PhotosQueryListViewModel {
                return DefaultPhotosQueryListViewModel(numberOfQueriesToShow: 10,
                                               fetchRecentPhotoQueriesUseCase: makeFetchRecentPhotoQueriesUseCase(),
                                               delegate: delegate)
    }
    
}

extension PhotosSceneDIContainer: PhotosListViewControllersFactory {
}
