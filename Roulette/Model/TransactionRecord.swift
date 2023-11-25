//
//  TransactionRecord.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/25.
//

import Foundation

struct TransactionRecord: Identifiable, Codable {
    var id = UUID()
    let fromMember: Member
    let toMembers: [Member]
    let money: Int
}
