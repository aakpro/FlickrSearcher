//
//  APIEndpoints.swift
//  FlickrSearcher
//
//  Created by Amir Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import UIKit


/// Create api end points
struct APIEndpoints {
    
    /// Create search api end point
    /// - Parameter query: search query
    /// - Parameter page: number of page
    static func photos(query: String, page: Int) -> Endpoint<FlickrPhotosRoot> {
        
        return Endpoint(path: "services/rest",
                        queryParameters: [
                            "text": query,
                            "page": "\(page)",
                            "method":"flickr.photos.search",
                            "format":"json",
                            "nojsoncallback":"1"])
    }
    
    /// Create photoUrl
    /// - Parameter photo: data of photo to download
    static func photoPoster(_ photo: Photo) -> Endpoint<Data> {
        let path = "https://farm\(photo.farm ?? 0).\(AppConfigurations().imagesBaseURL)\(photo.server ?? "")/\(photo.id ?? "")_\(photo.secret ?? "").jpg"
        let endPoint = Endpoint<Data>(path: path, isFullPath: true, method: .get, queryParameters: [String : String](), headerParamaters: [String : String](), bodyParamaters: [String : Any](), bodyEncoding: BodyEncoding.jsonSerializationData)
        
        return endPoint
    }
}
