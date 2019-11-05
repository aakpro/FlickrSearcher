//
//  PhotosListItemViewModel.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/4/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

// This file is related to each item in our list
import UIKit

protocol PhotosListItemViewModelInput {
    func didEndDisplaying()
    func updateImage()
}

protocol PhotosListItemViewModelOutput {
    var title: String { get }
    var image: Observable<Data?> { get }
    var photo: Photo? { get }
}

protocol PhotosListItemViewModel: PhotosListItemViewModelInput, PhotosListItemViewModelOutput { }

final class DefaultPhotosListItemViewModel: PhotosListItemViewModel {
    
    private(set) var id: photoId

    // MARK: - OUTPUT
    let image: Observable<Data?> = Observable(nil)
    var photo: Photo?
    var title: String

    private let imagesRepository: ImagesRepository
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }

    init(photo: Photo,
         imagesRepository: ImagesRepository) {
        self.id = photo.id ?? ""
        self.photo = photo
        self.title = photo.title ?? ""
        self.imagesRepository = imagesRepository
    }
}

// MARK: - INPUT. View event methods
extension DefaultPhotosListItemViewModel {
    
    func didEndDisplaying() {
        image.value = nil
    }
    
    func updateImage() {
        image.value = nil
        guard let thePhoto = self.photo else { return }
        
        imageLoadTask = imagesRepository.image(with: thePhoto) { [weak self] result in
            guard self?.photo?.id == thePhoto.id else { return }
            switch result {
            case .success(let data):
                self?.image.value = data
            case .failure: break
            }
            self?.imageLoadTask = nil
        }
    }
}

func == (lhs: DefaultPhotosListItemViewModel, rhs: DefaultPhotosListItemViewModel) -> Bool {
    return (lhs.id == rhs.id)
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
