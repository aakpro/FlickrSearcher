//
//  PhotosQueryListItemViewModel.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//
// View model for listing search queries

import Foundation

protocol PhotosQueryListItemViewModelInput { }

protocol PhotosQueryListItemViewModelOutput {
    var query: String { get }
}

protocol PhotosQueryListItemViewModel: PhotosQueryListItemViewModelInput, PhotosQueryListItemViewModelOutput { }

final class DefaultPhotosQueryListItemViewModel: PhotosQueryListItemViewModel, Equatable {
    let query: String
    init(query: String) {
        self.query = query
    }
}

func == (lhs: DefaultPhotosQueryListItemViewModel, rhs: DefaultPhotosQueryListItemViewModel) -> Bool {
    return (lhs.query == rhs.query)
}
