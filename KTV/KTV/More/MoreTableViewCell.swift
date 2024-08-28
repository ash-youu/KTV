//
//  MoreTableViewCell.swift
//  KTV
//
//  Created by 유연수 on 2024/08/29.
//

import UIKit

class MoreTableViewCell: UITableViewCell {

    static let identifier: String = "\(MoreTableViewCell.self)"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        descriptionLabel.text = nil
        titleLabel.text = nil
    }

    func setItem(_ item: MoreItem, separatorHidden: Bool) {
        
        titleLabel.text = item.title
        descriptionLabel.text = item.rightText
        separatorView.isHidden = separatorHidden
    }
}
