//
//  UserDefaultsRepository.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/25.
//

import Foundation

class UserDefaultsRepository<T: Identifiable & Codable> {
    private var userDefaultsKey: String
    private var items: [T]
    
    init(userDefaultsKey: String) {
        self.userDefaultsKey = userDefaultsKey
        
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let items = try? JSONDecoder().decode([T].self, from: data) // FIXME: try?
        else {
            self.items = []; return;
        }
        
        self.items = items
    }
    
    func getItems() -> [T] {
        return items
    }
    
    func addItem(_ item: T) {
        items.append(item)
        update()
    }
    
    func removeItem(at indices: [Int]) {
        indices.sorted().reversed().forEach { index in
            items.remove(at: index)
        }
        update()
    }
    
    func removeAllOfItems() {
        items.removeAll()
        update()
    }
    
    private func update() {
        guard let encodedData = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
    }
}
