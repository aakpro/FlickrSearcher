//
//  PhotoDetailViewController.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import UIKit

/// Photo detail view
/// Completly designed and implemented in code
class PhotoDetailViewController: UIViewController {
    
    final class func create(with viewModel: PhotoDetailsViewModel) -> PhotoDetailViewController {
        let view = PhotoDetailViewController()
        view.viewModel = viewModel
        return view
    }
    
    var viewModel:PhotoDetailsViewModel!
    
    var scrollView: UIScrollView = {
        let sView = UIScrollView()
        sView.translatesAutoresizingMaskIntoConstraints = false
        return sView
    }()
    
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(data: viewModel.image)
        return imgView
    }()
    
    
    func setupImageView() {
        self.scrollView.addSubview(imageView)
        [imageView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 0),
         imageView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: 0),
         imageView.heightAnchor.constraint(equalToConstant: 500),
         imageView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
         imageView.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor)].forEach { $0.isActive = true }
    }
    
    func setupScrollView() {
        self.view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 2
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.contentInsetAdjustmentBehavior = .never
        [scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
         scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
         scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
         scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)].forEach { $0.isActive = true }
    }
    
    @objc
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupScrollView()
        setupImageView()
        title = viewModel.title
    }
}


extension PhotoDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false
    }
}


