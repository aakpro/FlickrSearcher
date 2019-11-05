//
//  PhotosListViewModel.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/4/19.
//  Copyright © 2019 aakpro. All rights reserved.
//
// View model for photos list
import UIKit

/// Routing
enum PhotosListViewModelRoute {
    case initial
    case showPhotoDetail(title: String?, image: Data?)
    case showPhotoQueriesSuggestions(delegate: PhotosQueryListViewModelDelegate)
    case closePhotoQueriesSuggestions
}


/// For loading
enum PhotosListViewModelLoading {
    case none
    case fullScreen
    case nextPage
}

protocol PhotosListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didSearch(query: String)
    func didCancelSearch()
    func showQueriesSuggestions()
    func closeQueriesSuggestions()
    func didSelect(item: PhotosListItemViewModel)
}

protocol PhotosListViewModelOutput {
    var route: Observable<PhotosListViewModelRoute> { get }
    var items: Observable<[PhotosListItemViewModel]> { get }
    var loadingType: Observable<PhotosListViewModelLoading> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
}

protocol PhotosListViewModel: PhotosListViewModelInput, PhotosListViewModelOutput {}

final class DefaultPhotosListViewModel: PhotosListViewModel {

    private(set) var currentPage: Int = 0
    private var totalPageCount: Int = 1

    var hasMorePages: Bool {
        return currentPage < totalPageCount
    }
    var nextPage: Int {
        guard hasMorePages else { return currentPage }
        return currentPage + 1
    }

    private let searchPhotosUseCase: SearchPhotosUseCase
    private let imagesRepository: ImagesRepository

    private var photosLoadTask: Cancellable? { willSet { photosLoadTask?.cancel() } }

    // MARK: - OUTPUT
    let route: Observable<PhotosListViewModelRoute> = Observable(.initial)
    let items: Observable<[PhotosListItemViewModel]> = Observable([PhotosListItemViewModel]())
    let loadingType: Observable<PhotosListViewModelLoading> = Observable(.none)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }

    @discardableResult
    init(searchPhotosUseCase: SearchPhotosUseCase,
         imagesRepository: ImagesRepository) {
        self.searchPhotosUseCase = searchPhotosUseCase
        self.imagesRepository = imagesRepository
    }

    private func appendPage(photosPage: PhotosPage) {
        self.currentPage = photosPage.page ?? self.currentPage
        self.totalPageCount = photosPage.totalPages ?? self.totalPageCount
        if let photos = photosPage.photos {
            self.items.value = items.value + photos.map {
                DefaultPhotosListItemViewModel(photo: $0, imagesRepository: imagesRepository)
            }
        }
    }

    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        items.value.removeAll()
    }
    
    /// Load data from server based on query
    /// - Parameter photoQuery: Search term
    /// - Parameter loadingType: type of loadin -> new, next page, ... 
    private func load(photoQuery: PhotoQuery, loadingType: PhotosListViewModelLoading) {
        self.loadingType.value = loadingType
        self.query.value = photoQuery.query

        let photosRequest = SearchPhotosUseCaseRequestValue(query: photoQuery, page: nextPage)
        photosLoadTask = searchPhotosUseCase.execute(requestValue: photosRequest) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let flickrPhotos):
                if let photosPage = flickrPhotos.photos {
                    strongSelf.appendPage(photosPage: photosPage)
                }
                break
            case .failure(let error):
                strongSelf.handle(error: error)
            }
            strongSelf.loadingType.value = .none
        }
    }

    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading photos", comment: "")
    }

    private func update(photoQuery: PhotoQuery) {
        resetPages()
        load(photoQuery: photoQuery, loadingType: .fullScreen)
    }
}

//// MARK: - INPUT. View event methods
extension DefaultPhotosListViewModel {

    func viewDidLoad() { }

    func didLoadNextPage() {
        guard hasMorePages, loadingType.value == .none else { return }
        load(photoQuery: PhotoQuery(query: query.value),
             loadingType: .nextPage)
    }

    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        update(photoQuery: PhotoQuery(query: query))
    }

    func didCancelSearch() {
        photosLoadTask?.cancel()
    }

    func showQueriesSuggestions() {
        route.value = .showPhotoQueriesSuggestions(delegate: self)
    }

    func closeQueriesSuggestions() {
        route.value = .closePhotoQueriesSuggestions
    }

    func didSelect(item: PhotosListItemViewModel) {
        route.value = .showPhotoDetail(title: item.title, image: item.image.value)
    }
}

// MARK: - Delegate method from another model views
extension DefaultPhotosListViewModel: PhotosQueryListViewModelDelegate {
    
    func photosQueriesListDidSelect(photoQuery: PhotoQuery) {
        update(photoQuery: photoQuery)
    }
}
