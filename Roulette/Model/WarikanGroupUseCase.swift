//
//  WarikanGroupUseCase.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/11/27
//  
//

import Foundation

struct WarikanGroupUsecase {
    private var warikanGroupRepository: WarikanGroupRepositoryProtocol
    private var memberRepository: MemberRepositoryProtocol
    
    init(
        warikanGroupRepository: WarikanGroupRepositoryProtocol,
        memberRepository: MemberRepositoryProtocol
    ) {
        self.warikanGroupRepository = warikanGroupRepository
        self.memberRepository = memberRepository
    }
    
    /// 登録されている割り勘グループの配列の全体を返す。
    func findAll() -> [WarikanGroup] {
        return warikanGroupRepository.findAll()
    }
    
    /// 割り勘グループを新規作成する。
    ///
    /// 新規作成した割り勘グループは `findAll()` で得られる割り勘グループ配列の末尾に追加される。
    func create(name: String, memberNames: [String]) {
        let members = memberNames.map { name in
            let member = Member(name: name)
            memberRepository.save(member)
            return member.id
        }
        warikanGroupRepository.save(WarikanGroup(name: name, members: members))
    }
    
    /// 指定したインデックスの割り勘グループを削除する。
    ///
    /// 割り勘グループの削除に伴って、その割り勘グループに所属するメンバーの情報も削除される。
    func remove(at indices: [Int]) {
        let entirety = warikanGroupRepository.findAll()
        let warikanGroups = indices.map { entirety[$0] }
        
        warikanGroups.forEach { warikanGroup in
            warikanGroupRepository.remove(id: warikanGroup.id)
            warikanGroup.members.forEach { memberID in
                memberRepository.remove(id: memberID)
            }
        }
    }
}
