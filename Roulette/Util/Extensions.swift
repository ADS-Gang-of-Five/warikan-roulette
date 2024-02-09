// swiftlint:disable:this file_name
//
//  Extensions.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/11/26
//  
//

import Foundation

/// 剰余演算。
///
/// 標準の`%`が符号を被除数`left`と一致させるのに対し、`%%`は除数`right`と一致させる。
/// ```
/// 12 %% 10 == 2
/// -12 %% 10 == 8
/// 12 %% -10 == -8
/// -12 %% -10 == -2
/// ```
infix operator %%: MultiplicationPrecedence
func %% (left: Int, right: Int) -> Int {
    ((left % right) + right) % right
}

/// 一時的な拡張
/// OneView-OneViewModelに変更後削除
/// Issue #139
extension Date {
    static let dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        return dateFormatter
    }()

    var string: String {
        return Self.dateFormatter.string(from: self)
    }
}
