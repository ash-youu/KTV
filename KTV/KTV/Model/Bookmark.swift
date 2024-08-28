//
//  Bookmark.swift
//  KTV
//
//  Created by 유연수 on 2024/08/28.
//

import Foundation

struct Bookmark: Decodable {
    let channels: [Item]
}

extension Bookmark {
    struct Item: Decodable {
        let channel: String
        let channelId: Int
        let thumbnail: URL
    }
}
