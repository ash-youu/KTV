//
//  BookmarkViewController.swift
//  KTV
//
//  Created by 유연수 on 2024/08/23.
//

import UIKit

class BookmarkViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    let bookmarkViewModel = BookmarkViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        bookmarkViewModel.requestData()
        bindViewModel()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            UINib(nibName: BookmarkCell.identifier, bundle: nil),
            forCellReuseIdentifier: BookmarkCell.identifier
        )
    }
    
    private func bindViewModel() {
        bookmarkViewModel.dataChanged = { [weak self] in
            self?.tableView.isHidden = false
            self?.tableView.reloadData()
        }
    }
}

extension BookmarkViewController: UITableViewDelegate {}

extension BookmarkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkViewModel.bookmarks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookmarkCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BookmarkCell.identifier,
            for: indexPath
        ) as? BookmarkCell else {
            return UITableViewCell()
        }
        
        if let data = bookmarkViewModel.bookmarks?[indexPath.row] {
            cell.setData(data)
        }
        
        return cell
    }
}
