//
//  WarikanGroup.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/25.
//

import Foundation

struct WarikanGroup: Identifiable, Codable {
    // TODO: IDの発行はリポジトリで行う
    var id: ID<Self> = .init(value: UUID().uuidString)
    private(set) var name: String
    var members: [Member]
    var tatekaeList: [Tatekae]
}
