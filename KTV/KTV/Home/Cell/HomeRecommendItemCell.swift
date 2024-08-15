//
//  HomeRecommendItemCell.swift
//  KTV
//
//  Created by 유연수 on 2024/08/10.
//

import UIKit

class HomeRecommendItemCell: UITableViewCell {
    
    static let height: CGFloat = 71
    static let identifier: String = "\(HomeRecommendItemCell.self)"
    
    @IBOutlet weak var thumbnailContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var playTimeBGView: UIView!
    @IBOutlet weak var playTimeLabel: UILabel!
    private var imageTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetView()
    }
    
    private func configureView() {
        thumbnailContainerView.layer.cornerRadius = 5
        rankLabel.layer.cornerRadius = 5
        rankLabel.clipsToBounds = true
        playTimeBGView.layer.cornerRadius = 3
    }
    
    private func resetView() {
        imageTask?.cancel()
        imageTask = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        rankLabel.text = nil
        thumbnailImageView.image = nil
        playTimeLabel.text = nil
    }
    
    func setData(_ data: Home.Recommend, rank: Int?) {
        imageTask = thumbnailImageView.loadImage(url: data.imageUrl)
        titleLabel.text = data.title
        descriptionLabel.text = data.channel
        
        if let rank {
            rankLabel.text = "\(rank + 1)"
        }
        
        let timeFormatter = DateComponentsFormatter().convertTimeStyle()
        playTimeLabel.text = timeFormatter.string(from: data.playtime)
    }
}
