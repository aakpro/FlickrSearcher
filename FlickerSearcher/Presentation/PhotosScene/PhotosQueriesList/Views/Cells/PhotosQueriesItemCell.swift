//
//  PhotosQueriesItemCell.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import UIKit

class PhotosQueriesItemCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: PhotosQueriesItemCell.self)
    @IBOutlet private var titleLabel: UILabel!
    
    func fill(with suggestion: PhotosQueryListItemViewModel) {
        self.titleLabel.text = suggestion.query
    }

}
