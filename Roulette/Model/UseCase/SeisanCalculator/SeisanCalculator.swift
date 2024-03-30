//
//  SeisanCalculator.swift
//  Roulette
//
//  Created by Seigetsu on 2023/11/26
//
//

import Foundation

/// 清算の計算を行う。
struct SeisanCalculator {
    /// アンラッキーメンバーが確定しない段階での、途中計算結果を保持する。
    struct SeisanContext {
        fileprivate let debts: DebtState
        fileprivate let zansais: DebtState
        let unluckyMemberCandidates: [EntityID<Member>]
    }
    
    /// `seisan(tatekaeList:)`の応答。
    enum SeisanResponse {
        case needsUnluckyMember(SeisanContext)
        case success([SeisanData])
    }

    private var memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    /// 立て替えリストを受け取り、清算リストを計算する。
    func seisan(tatekaeList: [TatekaeData]) async throws -> SeisanResponse {
        let debts = debts(tatekaeList: tatekaeList)
        
        var zansais = debts
        debts.debtMap.forEach { key, debt in
            zansais.payMoney(debt - debt %% 10, from: key, to: .imaginary)
        }
        
        if zansais.debtMap[.imaginary] != 0 {
            let context = SeisanContext(debts: debts, zansais: zansais, unluckyMemberCandidates: debts.getMembers())
            return SeisanResponse.needsUnluckyMember(context)
        } else {
            let seisanList = seisan(seisanPrises: debts - zansais)
            return try await SeisanResponse.success(seisanList.mapToData(withMemberRepository: memberRepository))
        }
    }
    
    /// アンラッキーメンバーを指定して清算の計算を再開する。
    func seisan(context: SeisanContext, unluckyMember: EntityID<Member>) async throws -> [SeisanData] {
        let debts = context.debts
        var zansais = context.zansais
        zansais.payMoney(zansais.debtMap[.imaginary]!, from: .imaginary, to: .someone(id: unluckyMember))
        let seisanList = seisan(seisanPrises: debts - zansais)
        return try await seisanList.mapToData(withMemberRepository: memberRepository)
    }
    
    /// 清算必要額を受け取り、清算リストを計算する。
    private func seisan(seisanPrises: DebtState) -> [Seisan] {
        var seisanState = seisanPrises  // 清算状況
        let sortedSeisanPriceMap = seisanPrises.debtRanking()
        var result = [Seisan]()
        var left = 0
        var right = sortedSeisanPriceMap.count - 1
        while left < right {
            let lender = sortedSeisanPriceMap[right]
            let borrower = sortedSeisanPriceMap[left]
            let lendingMoney = seisanState.getDebt(of: lender)!
            let borrowingMoney = (-1) * seisanState.getDebt(of: borrower)!
            guard lendingMoney > 0 && borrowingMoney > 0 else { break }
            
            let repaymentAmount = min(lendingMoney, borrowingMoney)
            result.append(Seisan(debtor: lender, creditor: borrower, money: repaymentAmount))
            seisanState.payMoney(repaymentAmount, from: .someone(id: lender), to: .someone(id: borrower))
            
            if seisanState.getDebt(of: lender)! == 0 { right -= 1 }
            if seisanState.getDebt(of: borrower)! == 0 { left += 1 }
        }
        return result
    }
    
    /// 各メンバーの借金額を計算する。
    private func debts(tatekaeList: [TatekaeData]) -> DebtState {
        var debtMap = [EntityID<Member>: Double]()
        tatekaeList.forEach { tatekae in
            let splitAmount = Double(tatekae.money) / Double(tatekae.recipients.count)
            debtMap[tatekae.payer.id] = (debtMap[tatekae.payer.id] ?? 0.0) - Double(tatekae.money)
            tatekae.recipients.forEach { debtMap[$0.id] = (debtMap[$0.id] ?? 0.0) + splitAmount }
        }
        return DebtState.create(from: debtMap)
    }
}
