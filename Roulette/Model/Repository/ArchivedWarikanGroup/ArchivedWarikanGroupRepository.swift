//
//  ArchivedWarikanGroupRepository.swift
//  Roulette
//  
//  Created by Seigetsu on 2024/01/27
//  
//

import Foundation

/// UserDefaultsを用いて`ArchivedWarikanGroup`配列のCRUD操作を行うリポジトリ。
struct ArchivedWarikanGroupRepository: ArchivedWarikanGroupRepositoryProtocol {
    private var userDefaultsKey: String
    
    init(userDefaultsKey: String) {
        self.userDefaultsKey = userDefaultsKey
        if UserDefaults.standard.data(forKey: userDefaultsKey) == nil {
            commit(items: [])
        }
    }
    
    /// - NOTE: UserDefaultsにトランザクションの仕組みは存在しないため、実装していない。
    func transaction<Result>(block: () async throws -> Result) async throws -> Result {
        try await block()
    }
    
    func nextID() async throws -> EntityID<ArchivedWarikanGroup> {
        return .init(value: UUID().uuidString)
    }
    
    private func write(block: (inout [ArchivedWarikanGroup]) -> Void) {
        var items = findAll()
        block(&items)
        commit(items: items)
    }
    
    private func commit(items: [ArchivedWarikanGroup]) {
        let encodedData = try! JSONEncoder().encode(items)
        UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
    }
    
    func findAll() -> [ArchivedWarikanGroup] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            assertionFailure("リポジトリのデータソース userDefaultsKey=\(userDefaultsKey) が喪失しています。")
            return []
        }

        do {
            return try JSONDecoder().decode([ArchivedWarikanGroup].self, from: data)
        } catch {
            print("デコードに失敗：\(error)")
            return []
        }
    }
    
    func find(id: EntityID<ArchivedWarikanGroup>) -> ArchivedWarikanGroup? {
        let items = findAll()
        return items.first { $0.id == id }
    }
    
    func find(indices: [Int]) -> [ArchivedWarikanGroup] {
        let entirety = findAll()
        return indices.map { entirety[$0] }
    }
    
    func save(_ item: ArchivedWarikanGroup) {
        write { items in
            if let index = items.firstIndex(where: { $0.id == item.id }) {
                items[index] = item
            } else {
                items.append(item)
            }
        }
    }
    
    func remove(id: EntityID<ArchivedWarikanGroup>) {
        write { items in
            items = items.filter { $0.id != id }
        }
    }
}
