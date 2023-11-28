//
//  MemberRepositoryProtocol.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/11/28
//  
//

import Foundation

/// `Member`のCRUD操作のために、データベースとやり取りを行うメソッド。
protocol MemberRepositoryProtocol {
    func transaction(block: () async throws -> ()) async throws
    
    /// 指定したIDのメンバーを取得する。
    func find(id: UUID) async throws -> Member?
    
    /// メンバーを保存する。
    ///
    /// 既に存在するIDの場合は更新、存在しないIDの場合は末尾に新規作成する。
    func save(_ member: Member) async throws
    
    /// 指定したIDのメンバーを削除する。
    func remove(id: UUID) async throws
}
