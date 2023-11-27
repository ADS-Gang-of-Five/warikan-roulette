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
    
    init(userDefaultsKey: String) {
        self.userDefaultsKey = userDefaultsKey
    }
    
    private func write(block: (inout [WarikanGroup]) -> ()) {
        var items = findAll()
        block(&items)
        guard let encodedData = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
    }
    
    func findAll() -> [WarikanGroup] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let items = try? JSONDecoder().decode([WarikanGroup].self, from: data) // FIXME: try?
        else {
            return []
        }
        return items
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
