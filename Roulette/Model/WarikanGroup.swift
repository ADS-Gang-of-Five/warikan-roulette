//
//  WarikanGroup.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/25.
//

import Foundation

struct WarikanGroup: Identifiable, Codable {
    var id: EntityID<Self>
    private(set) var name: String
    var members: [EntityID<Member>]
    var tatekaeList: [EntityID<Tatekae>]
}
