//
//  BookmarkViewModel.swift
//  KTV
//
//  Created by 유연수 on 2024/08/23.
//

import Foundation

@MainActor class BookmarkViewModel {
    
    private(set) var bookmarks: [Bookmark.Item]?
    var dataChanged: (() -> Void)?
    
    func requestData() {
        Task {
            do {
                let bookmark = try await DataLoader.load(url: URLDefines.bookmark, for: Bookmark.self)
                bookmarks = bookmark.channels
                dataChanged?()
            } catch {
                print("json parshing failed: \(error.localizedDescription)")
            }
        }
    }
}
