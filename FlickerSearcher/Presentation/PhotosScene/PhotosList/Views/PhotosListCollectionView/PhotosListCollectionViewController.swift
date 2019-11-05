//
//  PhotosListCollectionViewController.swift
//  FlickrSearcher
//
//  Created by Amir Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//
// Presents photos
import UIKit

class PhotosListCollectionViewController: UICollectionViewController
{
    var nextPageLoadingSpinner: UIActivityIndicatorView?
    var isLoading: Bool = true
    var viewModel: PhotosListViewModel!
    var items: [PhotosListItemViewModel]! {
        didSet { reload() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 30, right: 10)
            layout.minimumLineSpacing = 12
            
            let space: CGFloat = (layout.minimumInteritemSpacing) + (layout.sectionInset.left) + (layout.sectionInset.right)
            let size:CGFloat = ((collectionView.frame.size.width - space) / 2.0)
            layout.itemSize = CGSize(width: size, height: size)
        }
    }

    func update(isLoadingNextPage: Bool) {
        isLoading = isLoadingNextPage
        reload()
    }
    func reload() {
        collectionView.reloadData()
    }
}

// MARK: - UIcollectionViewDataSource
extension PhotosListCollectionViewController {
    
    @objc override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.items.value.count ?? 0
    }
    
    
    @objc override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosListItemCollectionViewCell.reuseIdentifier, for: indexPath) as? PhotosListItemCollectionViewCell else {
            fatalError("Cannot dequeue reusable cell \(PhotosListItemCollectionViewCell.self) with reuseIdentifier: \(PhotosListItemCollectionViewCell.reuseIdentifier)")
        }
        cell.fill(with: viewModel.items.value[indexPath.row])
        
        if indexPath.row == viewModel.items.value.count - 4 {
            viewModel.didLoadNextPage()
        }
        cell.accessibilityLabel = String(format: NSLocalizedString("Result row %d", comment: ""), indexPath.row + 1)
        
        return cell
    }
    
}

// MARK: - UIcollectionViewDelegate
extension PhotosListCollectionViewController: UICollectionViewDelegateFlowLayout
{
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelect(item: items[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize(width: width / 2, height: width / 2)}
        let space: CGFloat = (layout.minimumInteritemSpacing) + (layout.sectionInset.left) + (layout.sectionInset.right)
        let size:CGFloat = ((width - space) / 2.0)
        return CGSize(width: size, height: size)
    }
}
