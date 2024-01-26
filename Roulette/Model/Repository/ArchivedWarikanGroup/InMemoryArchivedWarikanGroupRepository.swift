//
//  InMemoryArchivedWarikanGroupRepository.swift
//  Roulette
//  
//  Created by Seigetsu on 2024/01/27
//  
//

import Foundation

/// テスト用のリポジトリ。`WarikanGroup`配列のCRUD操作を行う。
class InArchivedMemoryWarikanGroupRepository: ArchivedWarikanGroupRepositoryProtocol {
    private var items = [ArchivedWarikanGroup]()
    
    func transaction<Result>(block: () async throws -> Result) async throws -> Result {
        try await block()
    }
    
    func nextID() async throws -> EntityID<ArchivedWarikanGroup> {
        return .init(value: UUID().uuidString)
    }
    
    func findAll() -> [ArchivedWarikanGroup] {
        return items
    }
    
    func find(id: EntityID<ArchivedWarikanGroup>) -> ArchivedWarikanGroup? {
        return items.first { $0.id == id }
    }
    
    func find(indices: [Int]) -> [ArchivedWarikanGroup] {
        return indices.map { items[$0] }
    }
    
    func save(_ item: ArchivedWarikanGroup) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
    }
    
    func remove(id: EntityID<ArchivedWarikanGroup>) {
        items = items.filter { $0.id != id }
    }
}
