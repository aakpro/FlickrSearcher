//
//  PhotosListViewController.swift
//  FlickrSearcher
//
//  Created by Amir Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//
// Container view for photo list and search text field

import UIKit

final class PhotosListViewController: UIViewController, StoryboardInstantiable, Alertable
{
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var photosListContainer: UIView!
    @IBOutlet private var suggestionsListContainer: UIView!
    @IBOutlet private var searchBarContainer: UIView!
    @IBOutlet private var loadingView: UIActivityIndicatorView!
    @IBOutlet private var emptyDataLabel: UILabel!
    
    private(set) var viewModel: PhotosListViewModel!
    private var photosListViewControllersFactory: PhotosListViewControllersFactory!
    
    private var photosQueriesSuggestionsView: UIViewController?
    private var photosListCollectionViewController: PhotosListCollectionViewController?
    private var searchController = UISearchController(searchResultsController: nil)
    
    final class func create(with viewModel: PhotosListViewModel,
                            photosListViewControllersFactory: PhotosListViewControllersFactory) -> PhotosListViewController {
        let view = PhotosListViewController.instantiateViewController()
        view.viewModel = viewModel
        view.photosListViewControllersFactory = photosListViewControllersFactory
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Photos", comment: "")
        
        emptyDataLabel?.text = NSLocalizedString("Search results ", comment: "")
        setupSearchController()

        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    func bind(to viewModel: PhotosListViewModel) {
        viewModel.route.observe(on: self) { [weak self] route in
            self?.handle(route)
        }
        viewModel.items.observe(on: self) { [weak self] items in
            self?.photosListCollectionViewController?.items = items
            self?.updateViewsVisibility()
        }
        viewModel.query.observe(on: self) { [weak self] query in
            self?.updateSearchController(query: query)
        }
        viewModel.error.observe(on: self) { [weak self] error in
            self?.showError(error)
        }
        viewModel.loadingType.observe(on: self) { [weak self] _ in
            self?.updateViewsVisibility()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
    
    private func updateSearchController(query: String) {
        searchController.isActive = false
        searchController.searchBar.text = query
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: PhotosListCollectionViewController.self),
            let destinationVC = segue.destination as? PhotosListCollectionViewController {
            photosListCollectionViewController = destinationVC
            photosListCollectionViewController?.viewModel = viewModel
        }
    }
    
    func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: NSLocalizedString("Error", comment: ""), message: error)
    }
    
    private func updateViewsVisibility() {
        loadingView.isHidden = true
        emptyDataLabel.isHidden = true
        photosListContainer.isHidden = true
        suggestionsListContainer.isHidden = true
        photosListCollectionViewController?.update(isLoadingNextPage: false)
        
        if viewModel.loadingType.value == .fullScreen {
            loadingView.isHidden = false
        } else if viewModel.loadingType.value == .nextPage {
            photosListCollectionViewController?.update(isLoadingNextPage: true)
            photosListContainer.isHidden = false
        } else if viewModel.isEmpty {
            emptyDataLabel.isHidden = false
        } else {
            photosListContainer.isHidden = false
        }
        
        updateQueriesSuggestionsVisibility()
    }
    
    private func updateQueriesSuggestionsVisibility() {
        if searchController.searchBar.isFirstResponder {
            viewModel.showQueriesSuggestions()
        } else {
            viewModel.closeQueriesSuggestions()
        }
    }
}

extension PhotosListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        photosListCollectionViewController?.collectionView.setContentOffset(CGPoint.zero, animated: false)
        viewModel.didSearch(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}

extension PhotosListViewController: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestionsVisibility()
    }
    
    public func willDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestionsVisibility()
    }
    
    public func didDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestionsVisibility()
    }
}

// MARK: - Setup Search Controller

extension PhotosListViewController {
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = NSLocalizedString("Search Photos", comment: "")
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            searchController.dimsBackgroundDuringPresentation = true
        }
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchBarContainer.addSubview(searchController.searchBar)
        definesPresentationContext = true
        searchController.accessibilityLabel = NSLocalizedString("Search Photos", comment: "")
    }
}

// MARK: - Handle Routing

extension PhotosListViewController {
    func handle(_ route: PhotosListViewModelRoute) {
        switch route {
        case .initial: break
        case .showPhotoDetail(let title, let image):
            let vc = photosListViewControllersFactory.makePhotosDetailsViewController(title: title ?? "", image: image ?? Data())
            navigationController?.pushViewController(vc, animated: true)
        case .showPhotoQueriesSuggestions(let delegate):
            guard let view = view else { return }
            let vc = photosQueriesSuggestionsView ?? photosListViewControllersFactory.makePhotosQueriesSuggestionsListViewController(delegate: delegate)
            add(child: vc, container: suggestionsListContainer)
            vc.view.frame = view.bounds
            photosQueriesSuggestionsView = vc
            suggestionsListContainer.isHidden = false
        case .closePhotoQueriesSuggestions:
            guard let suggestionsListContainer = suggestionsListContainer else { return }
            photosQueriesSuggestionsView?.remove()
            photosQueriesSuggestionsView = nil
            suggestionsListContainer.isHidden = true
        }
    }
}

protocol PhotosListViewControllersFactory {
    
    func makePhotosQueriesSuggestionsListViewController(delegate: PhotosQueryListViewModelDelegate) -> UIViewController
    
    func makePhotosDetailsViewController(title: String, image: Data) -> UIViewController
}
