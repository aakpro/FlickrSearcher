//
//  PhotosListItemCell.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import UIKit

/// Photo cell
final class PhotosListItemCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: PhotosListItemCollectionViewCell.self)
    @IBOutlet private var imageView: UIImageView!
    
    private var viewModel: PhotosListItemViewModel! { didSet { unbind(from: oldValue) } }
    
    func fill(with viewModel: PhotosListItemViewModel) {
        self.viewModel = viewModel
        viewModel.updateImage()
        
        bind(to: viewModel)
    }
    
    func bind(to viewModel: PhotosListItemViewModel) {
        viewModel.image.observe(on: self) { [weak self] (data: Data?) in
            self?.imageView.image = data.flatMap { UIImage(data: $0) }
        }
    }
    
    private func unbind(from item: PhotosListItemViewModel?) {
        item?.image.remove(observer: self)
    }
}
