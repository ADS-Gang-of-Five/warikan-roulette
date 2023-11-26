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
func %%(left: Int, right: Int) -> Int {
 ((left % right) + right) % right
}
