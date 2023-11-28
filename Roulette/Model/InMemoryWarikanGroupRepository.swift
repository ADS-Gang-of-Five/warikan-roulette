//
//  InMemoryWarikanGroupRepository.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/11/28
//  
//

import Foundation

/// テスト用のリポジトリ。`WarikanGroup`配列のCRUD操作を行う。
class InMemoryWarikanGroupRepository: WarikanGroupRepositoryProtocol {
    private var items = [WarikanGroup]()
    
    func transaction(block: () async throws -> ()) async throws {
        try await block()
    }
    
    func findAll() -> [WarikanGroup] {
        return items
    }
    
    func find(id: UUID) -> WarikanGroup? {
        return items.first { $0.id == id }
    }
    
    func find(indices: [Int]) -> [WarikanGroup] {
        return indices.map { items[$0] }
    }
    
    func save(_ item: WarikanGroup) {
        items.append(item)
    }
    
    func remove(id: UUID) {
        items = items.filter { $0.id != id }
    }
}
