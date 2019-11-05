//
//  PhotosQueriesTableViewController.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

// Presents a list of previous queries

import UIKit

final class PhotosQueriesTableViewController: UITableViewController, StoryboardInstantiable {
    
    private var viewModel: PhotosQueryListViewModel!
    
    final class func create(with viewModel: PhotosQueryListViewModel) -> PhotosQueriesTableViewController {
        let view = PhotosQueriesTableViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        
        bind(to: viewModel)
    }
    
    func bind(to viewModel: PhotosQueryListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PhotosQueriesTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotosQueriesItemCell.reuseIdentifier, for: indexPath) as? PhotosQueriesItemCell else {
            fatalError("Cannot dequeue reusable cell \(PhotosQueriesItemCell.self) with reuseIdentifier: \(PhotosQueriesItemCell.reuseIdentifier)")
        }
        cell.fill(with: viewModel.items.value[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.didSelect(item: viewModel.items.value[indexPath.row])
    }
}
