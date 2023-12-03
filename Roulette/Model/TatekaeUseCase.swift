//
//  TatekaeUseCase.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/03
//  
//

import Foundation

struct TatekaeUsecase {
    private var tatekaeRepository: TatekaeRepositoryProtocol
    
    init(tatekaeRepository: TatekaeRepositoryProtocol) {
        self.tatekaeRepository = tatekaeRepository
    }
    
    /// 指定したIDのメンバーを返す。
    func get(id: EntityID<Tatekae>) async throws -> Tatekae? {
        return try await tatekaeRepository.find(id: id)
    }
    
    /// 指定した複数のIDのメンバーを返す。
    func get(ids: [EntityID<Tatekae>]) async throws -> [Tatekae] {
        return try await tatekaeRepository.find(ids: ids)
    }
}
