//
//  WarikanGroupRepository.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/11/27
//  
//

import Foundation

/// UserDefaultsを用いて`WarikanGroup`配列のCRUD操作を行うリポジトリ。
struct WarikanGroupRepository: WarikanGroupRepositoryProtocol {
    
    private var userDefaultsKey: String
    
    init(userDefaultsKey: String) {
        self.userDefaultsKey = userDefaultsKey
        if UserDefaults.standard.data(forKey: userDefaultsKey) == nil {
            commit(items: [])
        }
    }
    
    /// - NOTE: UserDefaultsにトランザクションの仕組みは存在しないため、実装していない。
    func transaction(block: () async throws -> ()) async rethrows {
        try await block()
    }
    
    func nextID() async throws -> EntityID<WarikanGroup> {
        return .init(value: UUID().uuidString)
    }
    
    private func write(block: (inout [WarikanGroup]) -> ()) {
        var items = findAll()
        block(&items)
        commit(items: items)
    }
    
    private func commit(items: [WarikanGroup]) {
        let encodedData = try! JSONEncoder().encode(items)
        UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
    }
    
    func findAll() -> [WarikanGroup] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            assertionFailure("リポジトリのデータソース userDefaultsKey=\(userDefaultsKey) が喪失しています。")
            return []
        }
        do {
            return try JSONDecoder().decode([WarikanGroup].self, from: data)
        } catch {
            print("デコードに失敗：\(error)")
            return []
        }
    }
    
    func find(id: EntityID<WarikanGroup>) -> WarikanGroup? {
        let items = findAll()
        return items.first { $0.id == id }
    }
    
    func find(indices: [Int]) -> [WarikanGroup] {
        let entirety = findAll()
        return indices.map { entirety[$0] }
    }
    
    func save(_ item: WarikanGroup) {
        write { items in
            if let index = items.firstIndex(where: { $0.id == item.id }) {
                items[index] = item
            } else {
                items.append(item)
            }
        }
    }
    
    func remove(id: EntityID<WarikanGroup>) {
        write { items in
            items = items.filter { $0.id != id }
        }
    }
}
