//
//  WarikanGroupRepository.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/11/27
//  
//

import Foundation

struct WarikanGroupRepository {
    private var userDefaultsKey: String
    
    static func create(userDefaultsKey: String) -> Self {
        let repository = WarikanGroupRepository(userDefaultsKey: userDefaultsKey)
        if UserDefaults.standard.data(forKey: userDefaultsKey) == nil {
            repository.commit(items: [])
        }
        return repository
    }
    
    private init(userDefaultsKey: String) {
        self.userDefaultsKey = userDefaultsKey
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
            items.append(item)
        }
    }
    
    func remove(at indices: [Int]) {
        write { items in
            indices.sorted().reversed().forEach { index in
                items.remove(at: index)
            }
        }
    }
}
