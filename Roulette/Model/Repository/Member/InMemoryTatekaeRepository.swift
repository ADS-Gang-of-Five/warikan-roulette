//
//  InMemoryTatekaeRepository.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/03
//  
//

import Foundation

/// テスト用のリポジトリ。`Tatekae`のCRUD操作を行う。
class InMemoryTatekaeRepository: TatekaeRepositoryProtocol {
    private var items = [EntityID<Tatekae>: Tatekae]()
    
    func transaction(block: () async throws -> ()) async rethrows {
        try await block()
    }
    
    func nextID() -> EntityID<Tatekae> {
        return .init(value: UUID().uuidString)
    }
    
    func nextIDs(count: Int) -> [EntityID<Tatekae>] {
        return (0..<count).map { _ in .init(value: UUID().uuidString) }
    }
    
    func find(id: EntityID<Tatekae>) -> Tatekae? {
        return items[id]
    }
    
    func find(ids: [EntityID<Tatekae>]) throws -> [Tatekae] {
        return try ids.map { id in
            guard let item = find(id: id) else {
                throw ValidationError.notFoundID(id)
            }
            return item
        }
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
