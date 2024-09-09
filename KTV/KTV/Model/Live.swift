//
//  Live.swift
//  KTV
//
//  Created by 유연수 on 2024/09/10.
//

import Foundation

struct Live: Decodable {
    let list: [Item]
}

extension Live {
    struct Item: Decodable {
        let title: String
        let channel: String
        let videoId: Int
        let thumbnailUrl: URL
    }
}
