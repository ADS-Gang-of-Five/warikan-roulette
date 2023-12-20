//
//  MemberRepositoryProtocol.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/03
//  
//

import Foundation

/// `Member`のCRUD操作のために、データベースとやり取りを行うメソッド。
protocol MemberRepositoryProtocol {
    /// データベースのトランザクションを実行する。
    func transaction(block: () async throws -> Void) async throws
    
    /// 採番処理を行い、新しいIDを生成する。
    func nextID() async throws -> EntityID<Member>
    
    /// 採番処理を行い、新しいIDを複数生成する。
    func nextIDs(count: Int) async throws -> [EntityID<Member>]
    
    /// 指定したIDのメンバーを取得する。
    func find(id: EntityID<Member>) async throws -> Member?
    
    /// 指定した複数のIDのメンバーを取得する。
    ///
    /// 存在しないIDが含まれる場合はエラーを投げる。
    func find(ids: [EntityID<Member>]) async throws -> [Member]

    /// メンバーを保存する。
    ///
    /// 既に存在するIDの場合は更新、存在しないIDの場合は新規作成する。
    func save(_ item: Member) async throws

    /// 指定したIDのメンバーを削除する。
    func remove(id: EntityID<Member>) async throws
    
    /// 指定した複数のIDのメンバーを削除する。
    func remove(ids: [EntityID<Member>]) async throws
}
