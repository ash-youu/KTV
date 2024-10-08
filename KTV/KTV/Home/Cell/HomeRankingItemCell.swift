//
//  HomeRankingItemCell.swift
//  KTV
//
//  Created by 유연수 on 2024/08/12.
//

import UIKit

class HomeRankingItemCell: UICollectionViewCell {
    
    static let identifier: String = "\(HomeRankingItemCell.self)"
    static let size: CGSize = CGSize(width: 130, height: 239)
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    
    private var imageTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetView()
    }
    
    private func resetView() {
        imageTask?.cancel()
        imageTask = nil
        numberLabel.text = nil
        thumbnailImageView.image = nil
    }
    
    func setData(_ data: Home.Ranking, rank: Int) {
        numberLabel.text = "\(rank + 1)"
        imageTask = thumbnailImageView.loadImage(url: data.imageUrl)
    }
}
