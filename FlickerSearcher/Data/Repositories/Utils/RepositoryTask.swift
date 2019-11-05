//
//  RepositoryTask.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/4/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import Foundation

struct RepositoryTask: Cancellable {
    let networkTask: NetworkCancellable?
    func cancel() {
        networkTask?.cancel()
    }
}
