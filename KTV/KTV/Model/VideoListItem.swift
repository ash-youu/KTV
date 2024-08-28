//
//  VideoListItem.swift
//  KTV
//
//  Created by 유연수 on 2024/08/28.
//

import Foundation

struct VideoListItem: Decodable {
    let imageUrl: URL
    let title: String
    let playtime: Double
    let channel: String
    let videoId: Int
}
