//
//  HomeViewController.swift
//  KTV
//
//  Created by 유연수 on 2024/08/08.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 상태바 색상 변경
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private let homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        //json data 연동
        bindViewModel()
        
        homeViewModel.requestData()
    }
    
    private func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "empty")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isHidden = true
        
        collectionView.register(
            UINib(nibName: HomeHeaderView.identifier, bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeHeaderView.identifier
        )
        
        collectionView.register(
            UINib(nibName: HomeVideoCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeVideoCell.identifier
        )
        
        collectionView.register(
            UINib(nibName: HomeRankingHeaderView.identifier, bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeRankingHeaderView.identifier
        )
        
        collectionView.register(
            UINib(nibName: HomeRankingItemCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeRankingItemCell.identifier
        )
        
        collectionView.register(
            UINib(nibName: HomeRecentWatchItemCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeRecentWatchItemCell.identifier
        )
        
        collectionView.register(
            UINib(nibName: HomeRecommendContainerCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeRecommendContainerCell.identifier
        )
        
        collectionView.register(
            UINib(nibName: HomeFooterView.identifier, bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: HomeFooterView.identifier
        )
        
        // collectionViewLayout 설정
        collectionView.collectionViewLayout =
        UICollectionViewCompositionalLayout(sectionProvider: { [weak self] section, _ in
            self?.makeSection(section)
        })
    }
    
    private func makeSection(_ section: Int) -> NSCollectionLayoutSection? {
        guard let section = HomeSection(rawValue: section) else { return nil }
        
        let itemSpace: CGFloat = 21
        let inset: NSDirectionalEdgeInsets = .init(top: 0, leading: 21, bottom: 21, trailing: 21)
        
        switch section {
        case .header:
            return makeHeaderSection()
        case .video:
            return makeVideoSection(itemSpace, inset)
        case .ranking:
            return makeRankingSection(itemSpace, inset)
        case .recentWatch:
            return makeRecentWatchSection(itemSpace, inset)
        case .recommend:
            return makeRecommendSection(inset)
        case .footer:
            return makeFooterSection()
        }
    }
    
    private func makeHeaderSection() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(HomeHeaderView.height)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: layoutSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        return section
    }
    
    private func makeVideoSection(_ itemSpace: CGFloat, _ inset: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(HomeVideoCell.height)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = inset
        section.interGroupSpacing = itemSpace
        
        return section
    }
    
    private func makeRankingSection(_ itemSpace: CGFloat, _ inset: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection {
        let headerLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(HomeRankingHeaderView.height)
        )
        
        let itemLayoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(HomeRankingItemCell.size.width),
            heightDimension: .absolute(HomeRankingItemCell.size.height)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .absolute(HomeRankingItemCell.size.width),
                heightDimension: .absolute(265)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = itemSpace
        section.contentInsets = inset
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerLayoutSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        return section
    }
    
    private func makeRecentWatchSection(_ itemSpace: CGFloat, _ inset: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(HomeRecentWatchItemCell.itemSize.width),
            heightDimension: .absolute(HomeRecentWatchItemCell.itemSize.height)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .absolute(HomeRecentWatchItemCell.itemSize.width),
                heightDimension: .absolute(189)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = itemSpace
        section.contentInsets = inset
        section.orthogonalScrollingBehavior = .continuous

        return section
    }
    
    private func makeRecommendSection(_ inset: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(
                HomeRecommendContainerCell.height(viewModel: self.homeViewModel.recommendViewModel)
            )
        )
        
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = inset
        
        return section
    }
    
    private func makeFooterSection() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(HomeHeaderView.height)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: layoutSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
        ]
        
        return section
    }
    
    private func bindViewModel() {
        homeViewModel.dataChanged = { [weak self] in
            self?.collectionView.isHidden = false
            self?.collectionView.reloadData()
        }
    }
    
    private func presentVideoViewController() {
        let vc = VideoViewController()
        present(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = HomeSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .header, .footer, .recommend:
            return
        case .video, .ranking, .recentWatch:
            presentVideoViewController()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        HomeSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = HomeSection(rawValue: section) else { return 0 }
        
        switch section {
        case .header, .footer:
            return 0
        case .video:
            return homeViewModel.home?.videos.count ?? 0
        case .ranking:
            return homeViewModel.home?.rankings.count ?? 0
        case .recentWatch:
            return homeViewModel.home?.recents.count ?? 0
        case .recommend:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = HomeSection(rawValue: indexPath.section) else {
            return .init()
        }
        
        switch section {
        case .header:
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeHeaderView.identifier,
                for: indexPath
            )
        case .ranking:
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeRankingHeaderView.identifier,
                for: indexPath
            )
        case .footer:
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeFooterView.identifier,
                for: indexPath
            )
        case .video, .recentWatch, .recommend:
            return .init()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = HomeSection(rawValue: indexPath.section) else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "empty", for: indexPath)
        }
        
        switch section {
        case .header, .footer:
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: "empty",
                for: indexPath
            )
        case .video:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeVideoCell.identifier,
                for: indexPath
            )
            
            if let cell = cell as? HomeVideoCell,
               let data = self.homeViewModel.home?.videos[indexPath.item] {
                cell.setData(data)
            }
            
            return cell
        case .ranking:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeRankingItemCell.identifier,
                for: indexPath
            )
            
            if let cell = cell as? HomeRankingItemCell,
               let data = homeViewModel.home?.rankings[indexPath.row] {
                cell.setData(data, rank: indexPath.row)
            }
            
            return cell
        case .recentWatch:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeRecentWatchItemCell.identifier,
                for: indexPath
            )
            
            if let cell = cell as? HomeRecentWatchItemCell,
               let data = homeViewModel.home?.recents[indexPath.row] {
                cell.setData(data)
            }
            
            return cell
        case .recommend:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeRecommendContainerCell.identifier,
                for: indexPath
            )
            
            if let cell = cell as? HomeRecommendContainerCell {
                cell.delegate = self
                cell.setViewModel(homeViewModel.recommendViewModel)
            }
            
            return cell
        }
    }
}

extension HomeViewController: HomeRecommendContainerCellDelegate {
    func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int) {
        presentVideoViewController()
    }
    
    func homeRecommendContainerCellFoldChanged(_ cell: HomeRecommendContainerCell) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension HomeViewController: HomeRankingContainerCellDelegate {
    func homeRankingContainerCell(_ cell: HomeRankingContainerCell, didSelectItemAt index: Int) {
        presentVideoViewController()
    }
}

extension HomeViewController: HomeRecentWatchContainerCellDelegate {
    func homeRecentWatchContainerCell(_ cell: HomeRecentWatchContainerCell, didSelectItemAt index: Int) {
        presentVideoViewController()
    }
}
