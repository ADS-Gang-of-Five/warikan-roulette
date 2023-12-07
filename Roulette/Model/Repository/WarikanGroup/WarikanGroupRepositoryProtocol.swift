//
//  WarikanGroupRepositoryProtocol.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/11/28
//  
//

import Foundation

/// `WarikanGroup`配列のCRUD操作のために、データベースとやり取りを行うメソッド。
protocol WarikanGroupRepositoryProtocol {
    /// データベースのトランザクションを実行する。
    func transaction(block: () async throws -> ()) async throws
    
    /// 採番処理を行い、新しいIDを生成する。
    func nextID() async throws -> EntityID<WarikanGroup>
    
    /// 割り勘グループを全件取得する。
    func findAll() async throws -> [WarikanGroup]
    
    /// 指定したIDの割り勘グループを全件取得する。
    func find(id: EntityID<WarikanGroup>) async throws -> WarikanGroup?
    
    /// 割り勘グループを保存する。
    ///
    /// 既に存在するIDの場合は更新、存在しないIDの場合は末尾に新規作成する。
    func save(_ item: WarikanGroup) async throws
    
    /// 指定したインデックスの割り勘グループを削除する。
    func remove(id: EntityID<WarikanGroup>) async throws
}
