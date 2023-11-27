//
//  WarikanGroupUseCase.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/11/27
//  
//

import Foundation

struct WarikanGroupUsecase {
    private var repository: UserDefaultsRepository<WarikanGroup>
    
    init(repository: UserDefaultsRepository<WarikanGroup>) {
        self.repository = repository
    }
    
    func getAll() -> [WarikanGroup] {
        return repository.getItems()
    }
    
    func add(name: String, memberNames: [String]) {
        let members = memberNames.map { Member(name: $0) }
        repository.addItem(WarikanGroup(name: name, members: members))
    }
    
    func remove(at indices: [Int]) {
        repository.removeItem(at: indices)
    }
}
