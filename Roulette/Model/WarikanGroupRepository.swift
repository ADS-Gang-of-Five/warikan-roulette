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
    
    func save(_ item: WarikanGroup) {
        write { items in
            if let index = items.firstIndex(where: { $0.id == item.id }) {
                items[index] = item
            } else {
                items.append(item)
            }
        }
    }
    
    func remove(id: UUID) {
        write { items in
            items = items.filter { $0.id != id }
        }
    }
}
