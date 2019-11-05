//
//  UserDefaultsStorage.swift
//  FlickrSearcher
//
//  Created by Amir Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import Foundation

/// save data to user defaults
final class UserDefaultsStorage {
    private let maxStorageLimit: Int
    private let recentsPhotosQueriesKey = "recentsPhotosQueries"
    private var userDefaults: UserDefaults { return UserDefaults.standard }
    
    private var photosQuries: [PhotoQuery] {
        get {
            if let queriesData = userDefaults.object(forKey: recentsPhotosQueriesKey) as? Data {
                let decoder = JSONDecoder()
                if let photoQueryList = try? decoder.decode(PhotoQueriesListUDS.self, from: queriesData) {
                    return photoQueryList.list.map ( PhotoQuery.init )
                }
            }
            return []
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(PhotoQueriesListUDS(list: newValue.map ( PhotoQueryUDS.init ))) {
                userDefaults.set(encoded, forKey: recentsPhotosQueriesKey)
            }
        }
    }
    
    init(maxStorageLimit: Int) {
        self.maxStorageLimit = maxStorageLimit
    }
    
    fileprivate func removeOldQueries(_ queries: [PhotoQuery]) -> [PhotoQuery] {
        return queries.count <= maxStorageLimit ? queries : Array(queries[0..<maxStorageLimit])
    }
}

extension UserDefaultsStorage: PhotosQueriesStorage {
    
    /// Get recent queries stored user default
    /// - Parameter number: number of queries
    /// - Parameter completion: result after fetching data
    func recentsQueries(number: Int, completion: @escaping (Result<[PhotoQuery], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            var queries = strongSelf.photosQuries
            queries = queries.count < strongSelf.maxStorageLimit ? queries : Array(queries[0..<number])
            completion(.success(queries))
        }
    }
    
    /// Save query to user default
    /// - Parameter query: search term
    /// - Parameter completion: result of saving
    func saveRecentQuery(query: PhotoQuery, completion: @escaping (Result<PhotoQuery, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            var queries = strongSelf.photosQuries
            queries = queries.filter { $0 != query }
            queries.insert(query, at: 0)
            strongSelf.photosQuries = strongSelf.removeOldQueries(queries)
            completion(.success(query))
        }
    }
}
