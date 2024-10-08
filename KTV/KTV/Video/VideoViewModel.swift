//
//  VideoViewModel.swift
//  KTV
//
//  Created by 유연수 on 2024/08/28.
//

import Foundation

@MainActor class VideoViewModel {
    private(set) var video: Video?
    var dataChangeHandler: ((Video) -> Void)?
    
    func request() {
        Task {
            do {
                let video = try await DataLoader.load(url: URLDefines.video, for: Video.self)
//                let video = try DataLoader.load(json: "video", for: Video.self) - 실기기 테스트용 코드
                self.video = video
                self.dataChangeHandler?(video)
            } catch {
                print("video load did failed \(error.localizedDescription)")
            }
        }
    }
}
