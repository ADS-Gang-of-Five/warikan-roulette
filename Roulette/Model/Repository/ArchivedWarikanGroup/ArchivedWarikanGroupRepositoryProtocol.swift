//
//  ArchivedWarikanGroupRepositoryProtocol.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/08
//  
//

import Foundation

/// `ArchivedWarikanGroup`のCRUD操作のために、データベースとやり取りを行うメソッド。
protocol ArchivedWarikanGroupRepositoryProtocol {
    /// データベースのトランザクションを実行する。
    func transaction(block: () async throws -> ()) async throws
    
    /// 採番処理を行い、新しいIDを生成する。
    func nextID() async throws -> EntityID<ArchivedWarikanGroup>
    
    /// 清算済グループを全件取得する。
    func findAll() async throws -> [ArchivedWarikanGroup]
    
    /// 指定したIDの清算済グループを全件取得する。
    func find(id: EntityID<ArchivedWarikanGroup>) async throws -> ArchivedWarikanGroup?
    
    /// 清算済グループを保存する。
    ///
    /// 既に存在するIDの場合は更新、存在しないIDの場合は末尾に新規作成する。
    func save(_ item: ArchivedWarikanGroup) async throws
    
    /// 指定したインデックスの清算済グループを削除する。
    func remove(id: EntityID<ArchivedWarikanGroup>) async throws
}
