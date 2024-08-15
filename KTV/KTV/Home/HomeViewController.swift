//
//  HomeViewController.swift
//  KTV
//
//  Created by 유연수 on 2024/08/08.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let homeViewModel = HomeViewModel()
    
    // 상태바 색상 변경
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        //json data 연동
        bindViewModel()
        
        homeViewModel.requestData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            UINib(nibName: HomeHeaderCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeHeaderCell.identifier
        )
        
        tableView.register(
            UINib(nibName: HomeVideoCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeVideoCell.identifier
        )
        
        tableView.register(
            UINib(nibName: HomeRecommendContainerCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeRecommendContainerCell.identifier
        )
        
        tableView.register(
            UINib(nibName: HomeFooterCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeFooterCell.identifier
        )
        
        tableView.register(
            UINib(nibName: HomeRankingContainerCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeRankingContainerCell.identifier)
        
        tableView.register(
            UINib(nibName: HomeRecentWatchContainerCell.identifier, bundle: nil)
            , forCellReuseIdentifier: HomeRecentWatchContainerCell.identifier)
    }
    
    private func bindViewModel() {
        homeViewModel.dataChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
            }

        }
    }
}

extension HomeViewController: UITableViewDelegate { }

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        HomeSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = HomeSection(rawValue: section) else { return 0 }
        
        switch section {
        case .header:
            return 1
        case .video:
            return homeViewModel.home?.videos.count ?? 0
        case .ranking:
            return 1
        case .recentWatch:
            return 1
        case .recommend:
            return 1
        case .footer:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = HomeSection(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .header:
            return HomeHeaderCell.height
        case .video:
            return HomeVideoCell.height
        case .ranking:
            return HomeRankingContainerCell.height
        case .recentWatch:
            return HomeRecentWatchContainerCell.height
        case .recommend:
            return HomeRecommendContainerCell.height
        case .footer:
            return HomeFooterCell.height
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = HomeSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .header:
            return tableView.dequeueReusableCell(withIdentifier: HomeHeaderCell.identifier, for: indexPath)
        case .video:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeVideoCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeVideoCell,
               let data = self.homeViewModel.home?.videos[indexPath.row] {
                cell.setData(data)
            }
            
            return cell
        case .ranking:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeRankingContainerCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeRankingContainerCell,
               let datas = homeViewModel.home?.rankings {
                cell.setData(datas)
            }
            
            return cell
        case .recentWatch:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecentWatchContainerCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeRecentWatchContainerCell,
               let datas = homeViewModel.home?.recents {
                cell.setData(datas)
            }
            
            return cell
        case .recommend:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecommendContainerCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeRecommendContainerCell,
               let datas = homeViewModel.home?.recommends {
                cell.setData(datas)
            }
            
            return cell
        case .footer:
            return tableView.dequeueReusableCell(withIdentifier: HomeFooterCell.identifier, for: indexPath)
        }
    }
}
