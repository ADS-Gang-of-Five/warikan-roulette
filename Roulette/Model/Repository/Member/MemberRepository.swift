//
//  MemberRepository.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/07
//  
//

import Foundation

/// UserDefaultsを用いて`Member`のCRUD操作を行うリポジトリ。
struct MemberRepository: MemberRepositoryProtocol {
    private let userDefaultsKey = "member"
    
    init() {
        if UserDefaults.standard.data(forKey: userDefaultsKey) == nil {
            commit(items: [EntityID<Member>: Member]())
        }
    }
    
    /// - NOTE: UserDefaultsにトランザクションの仕組みは存在しないため、実装していない。
    func transaction(block: () async throws -> Void) async rethrows {
        try await block()
    }
    
    private func write(block: (inout [EntityID<Member>: Member]) -> Void) {
        var items = getItems()
        block(&items)
        commit(items: items)
    }
    
    func nextID() -> EntityID<Member> {
        return .init(value: UUID().uuidString)
    }
    
    func nextIDs(count: Int) -> [EntityID<Member>] {
        return (0..<count).map { _ in nextID() }
    }
    
    private func commit(items: [EntityID<Member>: Member]) {
        let encodedData = try! JSONEncoder().encode(items)
        UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
    }
    
    private func getItems() -> [EntityID<Member>: Member] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            assertionFailure("リポジトリのデータソース userDefaultsKey=\(userDefaultsKey) が喪失しています。")
            return [:]
        }
        do {
            return try JSONDecoder().decode([EntityID<Member>: Member].self, from: data)
        } catch {
            print("デコードに失敗：\(error)")
            return [:]
        }
    }
    
    func find(id: EntityID<Member>) -> Member? {
        let items = getItems()
        return items[id]
    }
    
    func find(ids: [EntityID<Member>]) throws -> [Member] {
        return try ids.map { id in
            guard let item = find(id: id) else {
                throw ValidationError.notFoundID(id)
            }
            return item
        }
    }
    
    func save(_ item: Member) {
        write { items in
            items[item.id] = item
        }
    }
    
    func remove(id: EntityID<Member>) {
        write { items in
            items.removeValue(forKey: id)
        }
    }
    
    func remove(ids: [EntityID<Member>]) {
        ids.forEach { remove(id: $0) }
    }
}
