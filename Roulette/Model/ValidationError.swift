//
//  ValidationError.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/03
//  
//

import Foundation

enum ValidationError<T>: Error {
    case notFoundID(EntityID<T>)
}
