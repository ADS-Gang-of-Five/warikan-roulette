//
//  TatekaeRepositoryProtocol.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/03
//  
//

import Foundation

/// `Tatekae`のCRUD操作のために、データベースとやり取りを行うメソッド。
protocol TatekaeRepositoryProtocol {
    /// データベースのトランザクションを実行する。
    func transaction(block: () async throws -> ()) async throws
    
    /// 採番処理を行い、新しいIDを生成する。
    func nextID() async throws -> EntityID<Tatekae>
    
    /// 採番処理を行い、新しいIDを複数生成する。
    func nextIDs(count: Int) async throws -> [EntityID<Tatekae>]

    /// 指定したIDの立て替えを取得する。
    func find(id: EntityID<Tatekae>) async throws -> Tatekae?

    /// 立て替えを保存する。
    ///
    /// 既に存在するIDの場合は更新、存在しないIDの場合は新規作成する。
    func save(_ item: Tatekae) async throws

    /// 指定したIDの立て替えを削除する。
    func remove(id: EntityID<Tatekae>) async throws
    
    /// 指定した複数のIDの立て替えを削除する。
    func remove(ids: [EntityID<Tatekae>]) async throws
}
