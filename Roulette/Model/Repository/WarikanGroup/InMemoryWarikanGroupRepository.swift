//
//  InMemoryWarikanGroupRepository.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/11/28
//  
//

import Foundation

/// テスト用のリポジトリ。`WarikanGroup`配列のCRUD操作を行う。
final class InMemoryWarikanGroupRepository: WarikanGroupRepositoryProtocol {
    private var items = [WarikanGroup]()
    
    func transaction<Result>(block: () async throws -> Result) async throws -> Result {
        try await block()
    }
    
    func nextID() async throws -> EntityID<WarikanGroup> {
        return .init(value: UUID().uuidString)
    }
    
    func findAll() -> [WarikanGroup] {
        return items
    }
    
    func find(id: EntityID<WarikanGroup>) -> WarikanGroup? {
        return items.first { $0.id == id }
    }
    
    func find(indices: [Int]) -> [WarikanGroup] {
        return indices.map { items[$0] }
    }
    
    func save(_ item: WarikanGroup) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
    }
    
    func remove(id: EntityID<WarikanGroup>) {
        items = items.filter { $0.id != id }
    }
}
