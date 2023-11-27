//
//  UserDefaultsRepository.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/25.
//

import Foundation

struct UserDefaultsRepository<T: Identifiable & Codable> {
    private var userDefaultsKey: String
    
    init(userDefaultsKey: String) {
        self.userDefaultsKey = userDefaultsKey
    }
    
    private func write(block: (inout [T]) -> ()) {
        var items = findAll()
        block(&items)
        guard let encodedData = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
    }
    
    func findAll() -> [T] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let items = try? JSONDecoder().decode([T].self, from: data) // FIXME: try?
        else {
            return []
        }
        return items
    }
    
    func save(_ item: T) {
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
