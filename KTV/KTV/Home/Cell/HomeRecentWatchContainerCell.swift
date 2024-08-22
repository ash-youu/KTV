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

class HomeRecentWatchContainerCell: UICollectionViewCell {
    
    static let identifier: String = "\(HomeRecentWatchContainerCell.self)"
    static let height: CGFloat = 189
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: HomeRecentWatchContainerCellDelegate?
    
    private var recents: [Home.Recent]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCollectionView()
    }
    
    private func setCollectionView() {
        collectionView.layer.cornerRadius = 10
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
        
        collectionView.register(
            UINib(nibName: HomeRecentWatchItemCell.identifier, bundle: .main),
            forCellWithReuseIdentifier: HomeRecentWatchItemCell.identifier
        )
        
        collectionView.dataSource = self
    }
    
    func setData(_ data: [Home.Recent]) {
        recents = data
        collectionView.reloadData()
    }
}

extension HomeRecentWatchContainerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recents?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(HomeRecentWatchItemCell.identifier)",
            for: indexPath
        ) as? HomeRecentWatchItemCell else {
            return UICollectionViewCell()
        }
        
        if let data = self.recents?[indexPath.item] {
            cell.setData(data)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.homeRecentWatchContainerCell(self, didSelectItemAt: indexPath.item)
    }
}
