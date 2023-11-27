//
//  InMemoryWarikanGroupRepository.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/11/28
//  
//

import Foundation

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
