//
//  EntityID.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/03
//  
//

import Foundation

/// 永続化されるデータに対して割り当てられる識別子。
///
/// - Important: リポジトリ以外が生成してはならない。
struct EntityID<T>: Hashable, Codable {
    let value: String
}
