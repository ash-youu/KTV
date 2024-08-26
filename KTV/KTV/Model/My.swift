//
//  My.swift
//  KTV
//
//  Created by 유연수 on 2024/08/23.
//

import Foundation

struct Bookmark: Decodable {
    let channels: [Item]
    
    struct Item: Decodable {
        let channel: String
        let channelId: Int
        let thumbnail: URL
    }
}

struct Favorite: Decodable {
    let list: [Home.VideoListItem]
}
