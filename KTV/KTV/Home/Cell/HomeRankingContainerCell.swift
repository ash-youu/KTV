//
//  HomeRankingContainerCell.swift
//  KTV
//
//  Created by 유연수 on 2024/08/12.
//

import UIKit

protocol HomeRankingContainerCellDelegate: AnyObject {
    func homeRankingContainerCell(_ cell: HomeRankingContainerCell, didSelectItemAt index: Int)
}

class HomeRankingContainerCell: UITableViewCell {

    static let identifier: String = "\(HomeRankingContainerCell.self)"
    static let height: CGFloat = 349
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: HomeRankingContainerCellDelegate?
    
    private var rankings: [Home.Ranking]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCollectionView()
    }
    
    private func setCollectionView() {
        collectionView.register(
            UINib(nibName: HomeRankingItemCell.identifier, bundle: nil)
            , forCellWithReuseIdentifier: HomeRankingItemCell.identifier
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setData(_ data: [Home.Ranking]) {
        rankings = data
        collectionView.reloadData()
    }
}

extension HomeRankingContainerCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.homeRankingContainerCell(self, didSelectItemAt: indexPath.item)
    }
}

extension HomeRankingContainerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rankings?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeRankingItemCell.identifier,
            for: indexPath
        ) as? HomeRankingItemCell else {
            return UICollectionViewCell()
        }
        
        guard let data = rankings?[indexPath.item] else {
            return cell
        }
        
        cell.setData(data, rank: indexPath.item)
        return cell
    }
}
