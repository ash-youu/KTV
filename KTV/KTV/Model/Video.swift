//
//  Video.swift
//  KTV
//
//  Created by 유연수 on 2024/08/28.
//

import Foundation

struct Video: Decodable {
    let videoURL: URL
    let channelImageUrl: URL
    let uploadTimestamp: Double
    let channel: String
    let channelId: Int
    let title: String
    let videoId: Int
    let playCount: Int
    let recommends: [VideoListItem]
    let favoriteCount: Int
}
