//
//  WarikanGroupUseCase.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/11/27
//  
//

import Foundation

struct WarikanGroupUsecase {
    private var repository: WarikanGroupRepository
    
    init(repository: WarikanGroupRepository) {
        self.repository = repository
    }
    
    func findAll() -> [WarikanGroup] {
        return repository.findAll()
    }
    
    func add(name: String, memberNames: [String]) {
        let members = memberNames.map { Member(name: $0) }
        repository.save(WarikanGroup(name: name, members: members))
    }
    
    func remove(at indices: [Int]) {
        repository.remove(at: indices)
    }
}
