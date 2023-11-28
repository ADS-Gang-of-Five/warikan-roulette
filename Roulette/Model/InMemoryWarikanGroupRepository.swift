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
    
    func findAll() -> [WarikanGroup] {
        return items
    }
    
    func save(_ item: WarikanGroup) {
        items.append(item)
    }
    
    func remove(at indices: [Int]) {
        indices.sorted().reversed().forEach { index in
            items.remove(at: index)
        }
    }
}
