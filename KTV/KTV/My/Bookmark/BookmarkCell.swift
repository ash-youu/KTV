//
//  BookmarkCell.swift
//  KTV
//
//  Created by 유연수 on 2024/08/23.
//

import UIKit

class BookmarkCell: UITableViewCell {

    static let identifier: String = "\(BookmarkCell.self)"
    static let height: CGFloat = 58
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var channelTitle: UILabel!
    
    private var profileImageTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    override func prepareForReuse() {
        resetView()
    }
    
    private func configureView() {
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 10
    }
    
    private func resetView() {
        profileImageTask?.cancel()
        profileImageTask = nil
        
        profileImageView.image = nil
        channelTitle.text = nil
    }
    
    func setData(_ data: Bookmark.Item) {
        profileImageTask = profileImageView.loadImage(url: data.thumbnail)
        channelTitle.text = data.channel
    }
}
