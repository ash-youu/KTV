//
//  ChattingViewModel.swift
//  KTV
//
//  Created by 유연수 on 2024/09/12.
//

import Foundation

@MainActor class ChattingViewModel {
    private let chatSimulator = ChatSimulator()
    var chatReceived: (() -> Void)?
    private(set) var messages: [ChatMessage] = []
    
    init() {
        chatSimulator.setMessageHandler { [weak self] in
            self?.messages.append($0)
            self?.chatReceived?()
        }
    }
    
    func start() {
        chatSimulator.start()
    }
    
    func stop() {
        chatSimulator.stop()
    }
    
    func sendMessage(_ message: String) {
        chatSimulator.sendMessage(message)
    }
}
