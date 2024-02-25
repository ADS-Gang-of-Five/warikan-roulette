//
//  TatekaeRepository.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/07
//  
//

import Foundation

/// UserDefaultsを用いて`Tatekae`のCRUD操作を行うリポジトリ。
struct TatekaeRepository: TatekaeRepositoryProtocol {
    private let userDefaultsKey = "tatekae"
    
    init() {
        if UserDefaults.standard.data(forKey: userDefaultsKey) == nil {
            commit(items: [EntityID<Tatekae>: Tatekae]())
        }
    }
    
    /// - NOTE: UserDefaultsにトランザクションの仕組みは存在しないため、実装していない。
    func transaction(block: () async throws -> Void) async rethrows {
        try await block()
    }
    
    private func write(block: (inout [EntityID<Tatekae>: Tatekae]) -> Void) {
        var items = getItems()
        block(&items)
        commit(items: items)
    }
    
    func nextID() -> EntityID<Tatekae> {
        return .init(value: UUID().uuidString)
    }
    
    func nextIDs(count: Int) -> [EntityID<Tatekae>] {
        return (0..<count).map { _ in nextID() }
    }
    
    private func commit(items: [EntityID<Tatekae>: Tatekae]) {
        let encodedData = try! JSONEncoder().encode(items)
        UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
    }
    
    private func getItems() -> [EntityID<Tatekae>: Tatekae] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            assertionFailure("リポジトリのデータソース userDefaultsKey=\(userDefaultsKey) が喪失しています。")
            return [:]
        }
        do {
            return try JSONDecoder().decode([EntityID<Tatekae>: Tatekae].self, from: data)
        } catch {
            print("デコードに失敗：\(error)")
            return [:]
        }
    }
    
    func find(id: EntityID<Tatekae>) throws -> Tatekae {
        let items = getItems()
        guard let item = items[id] else {
            throw ValidationError.notFoundID(id)
        }
        return item
    }
    
    func find(ids: [EntityID<Tatekae>]) throws -> [Tatekae] {
        return try ids.map { try find(id: $0) }
    }
    
    func save(_ item: Tatekae) {
        write { items in
            items[item.id] = item
        }
    }
    
    func remove(id: EntityID<Tatekae>) {
        write { items in
            items.removeValue(forKey: id)
        }
    }
    
    func remove(ids: [EntityID<Tatekae>]) {
        ids.forEach { remove(id: $0) }
    }
}
