//
//  FavoriteViewController.swift
//  KTV
//
//  Created by 유연수 on 2024/08/23.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    let favoriteViewModel = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        favoriteViewModel.requestData()
        bindViewModel()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            UINib(nibName: VideoListItemCell.identifier, bundle: nil),
            forCellReuseIdentifier: VideoListItemCell.identifier
        )
    }
    
    private func bindViewModel() {
        favoriteViewModel.dataChanged = { [weak self] in
            self?.tableView.isHidden = false
            self?.tableView.reloadData()
        }
    }
}

extension FavoriteViewController: UITableViewDelegate {}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteViewModel.favorites?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return VideoListItemCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: VideoListItemCell.identifier,
            for: indexPath
        ) as? VideoListItemCell else {
            return UITableViewCell()
        }
        
        if let data = favoriteViewModel.favorites?[indexPath.row] {
            cell.setData(data, rank: nil)
        }
        
        return cell
    }
}
