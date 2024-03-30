//
//  MemberData.swift
//  Roulette
//  
//  Created by Seigetsu on 2024/03/30
//  
//

import Foundation

struct MemberData: Identifiable, Codable {
    let id: EntityID<Member>
    let name: String
    
    private init(id: EntityID<Member>, name: String) {
        self.id = id
        self.name = name
    }
    
    /// 永続化用のデータ型から変換する
    static func create(from member: Member) -> Self {
        return .init(id: member.id, name: member.name)
    }
}

// MARK: - [Member]

extension [Member] {
    func mapToData() -> [MemberData] {
        self.map { member in
            MemberData.create(from: member)
        }
    }
}
