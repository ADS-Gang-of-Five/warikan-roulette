//
//  ValidationError.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/03
//  
//

import Foundation

/// 妥当性確認に関するエラー。UseCaseおよびRepositoryが投げる。
enum ValidationError<T>: Error {
    /// 存在しないIDが指定された際のエラー。
    case notFoundID(EntityID<T>)
}
