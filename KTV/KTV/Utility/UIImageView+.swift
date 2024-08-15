//
//  UIImageView+.swift
//  KTV
//
//  Created by 유연수 on 2024/08/16.
//

import UIKit

extension UIImageView {
    func loadImage(url: URL) -> Task<Void, Never> {
        return .init {
            guard
                let responseData = try? await URLSession.shared.data(for: .init(url: url)).0,
                let image = UIImage(data: responseData)
            else {
                return
            }
            
            self.image = image
        }
    }
}
