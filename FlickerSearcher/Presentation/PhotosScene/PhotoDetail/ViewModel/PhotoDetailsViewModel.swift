//
//  PhotoDetailsViewModel.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import UIKit


protocol PhotoDetailsViewModelInput { }

protocol PhotoDetailsViewModelOutput {
    var title: String { get }
    var image: Data { get }
}

protocol PhotoDetailsViewModel: PhotoDetailsViewModelInput, PhotoDetailsViewModelOutput { }

/// Photo detail view model - only shows image and a title 
final class DefaultPhotoDetailsViewModel: PhotoDetailsViewModel {
    var title: String
    var image: Data
    
    init(title: String, image: Data) {
        self.title = title
        self.image = image
    }
}
