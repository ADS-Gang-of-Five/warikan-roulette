//
//  InMemoryMemberRepository.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/03
//  
//

import Foundation

/// テスト用のリポジトリ。`Member`のCRUD操作を行う。
final class InMemoryMemberRepository: MemberRepositoryProtocol {
    private var items = [EntityID<Member>: Member]()
    
    func transaction(block: () async throws -> Void) async rethrows {
        try await block()
    }
    
    func nextID() -> EntityID<Member> {
        return .init(value: UUID().uuidString)
    }
    
    func nextIDs(count: Int) -> [EntityID<Member>] {
        return (0..<count).map { _ in .init(value: UUID().uuidString) }
    }
    
    func find(id: EntityID<Member>) throws -> Member {
        guard let item = items[id] else {
            throw ValidationError.notFoundID(id)
        }
        return item
    }
    
    func find(ids: [EntityID<Member>]) throws -> [Member] {
        return try ids.map { try find(id: $0) }
    }
    
    func save(_ item: Member) {
        items[item.id] = item
    }
    
    func remove(id: EntityID<Member>) {
        items.removeValue(forKey: id)
    }
    
    func remove(ids: [EntityID<Member>]) {
        ids.forEach { remove(id: $0) }
    }
}
