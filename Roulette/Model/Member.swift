//
//  Member.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/25.
//

import Foundation

struct Member: Identifiable, Codable {
    var id: EntityID<Self>
    private(set) var name: String
}
