//
//  InMemoryTatekaeRepository.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/03
//  
//

import Foundation

/// テスト用のリポジトリ。`Tatekae`のCRUD操作を行う。
final class InMemoryTatekaeRepository: TatekaeRepositoryProtocol {
    private var items = [EntityID<Tatekae>: Tatekae]()
    
    func transaction(block: () async throws -> Void) async rethrows {
        try await block()
    }
    
    func nextID() -> EntityID<Tatekae> {
        return .init(value: UUID().uuidString)
    }
    
    func nextIDs(count: Int) -> [EntityID<Tatekae>] {
        return (0..<count).map { _ in .init(value: UUID().uuidString) }
    }
    
    func find(id: EntityID<Tatekae>) throws -> Tatekae {
        guard let item = items[id] else {
            throw ValidationError.notFoundID(id)
        }
        return item
    }
    
    func find(ids: [EntityID<Tatekae>]) throws -> [Tatekae] {
        return try ids.map { try find(id: $0) }
    }
    
    func save(_ item: Tatekae) {
        items[item.id] = item
    }
    
    func remove(id: EntityID<Tatekae>) {
        items.removeValue(forKey: id)
    }
    
    func remove(ids: [EntityID<Tatekae>]) {
        ids.forEach { remove(id: $0) }
    }
}
