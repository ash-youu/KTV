//
//  DateComponentsFormatter+.swift
//  KTV
//
//  Created by 유연수 on 2024/08/15.
//

import Foundation

extension DateComponentsFormatter {
    static let playTimeFormatter: DateComponentsFormatter = {
        let timeFormatter = DateComponentsFormatter()
        timeFormatter.unitsStyle = .positional
        timeFormatter.zeroFormattingBehavior = .pad
        timeFormatter.allowedUnits = [.minute, .second]
        
        return timeFormatter
    }()
}
