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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(
            UINib(nibName: HomeRankingItemCell.identifier, bundle: nil)
            , forCellWithReuseIdentifier: HomeRankingItemCell.identifier
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension HomeRankingContainerCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.homeRankingContainerCell(self, didSelectItemAt: indexPath.item)
    }
}

extension HomeRankingContainerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeRankingItemCell.identifier,
            for: indexPath
        ) as? HomeRankingItemCell else {
            return UICollectionViewCell()
        }
        
        cell.setRank(indexPath.item)
        return cell
    }
}
