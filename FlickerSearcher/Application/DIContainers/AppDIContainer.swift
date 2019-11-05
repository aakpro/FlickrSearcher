//
//  AppDIContainer.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/4/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import Foundation
import  UIKit

final class AppDIContainer {
    
    lazy var appConfigurations = AppConfigurations()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfigurations.apiBaseURL)!,
                                          queryParameters: ["api_key": appConfigurations.apiKey])

        let apiDataNetwork = DefaultNetworkService(session: URLSession.shared,
                                                   config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    lazy var imageDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfigurations.imagesBaseURL)!)
        let carrierLogosDataNetwork = DefaultNetworkService(session: URLSession.shared,
                                                            config: config)
        return DefaultDataTransferService(with: carrierLogosDataNetwork)
    }()
    
    // DIContainers of scenes
    func makePhotosSceneDIContainer() -> PhotosSceneDIContainer {
        let dependencies = PhotosSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService, imageDataTransferService: imageDataTransferService)
        return PhotosSceneDIContainer(dependencies: dependencies)
    }
}
