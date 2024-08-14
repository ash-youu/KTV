//
//  HomeRecentWatchContainerCell.swift
//  KTV
//
//  Created by 유연수 on 2024/08/12.
//

import UIKit

protocol HomeRecentWatchContainerCellDelegate: AnyObject {
    func homeRecentWatchContainerCell(_ cell: HomeRecentWatchContainerCell, didSelectItemAt index: Int)
}

class HomeRecentWatchContainerCell: UITableViewCell {

    static let identifier: String = "\(HomeRecentWatchContainerCell.self)"
    static let height: CGFloat = 209
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: HomeRecentWatchContainerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.layer.cornerRadius = 10
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
        
        collectionView.register(
            UINib(nibName: HomeRecentWatchItemCell.identifier, bundle: .main),
            forCellWithReuseIdentifier: HomeRecentWatchItemCell.identifier
        )
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension HomeRecentWatchContainerCell: UICollectionViewDelegate {
    
}

extension HomeRecentWatchContainerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(HomeRecentWatchItemCell.identifier)",
            for: indexPath
        ) as? HomeRecentWatchItemCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.homeRecentWatchContainerCell(self, didSelectItemAt: indexPath.item)
    }
}
