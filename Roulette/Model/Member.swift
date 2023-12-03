//
//  Member.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/25.
//

import Foundation

struct Member: Identifiable, Codable {
    // TODO: IDの発行はリポジトリで行う
    var id: EntityID<Self> = .init(value: UUID().uuidString)
    private(set) var name: String
}
