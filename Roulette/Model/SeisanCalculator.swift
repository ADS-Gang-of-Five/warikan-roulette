//
//  SeisanCalculator.swift
//  Roulette
//
//  Created by Seigetsu on 2023/11/26
//
//

import Foundation

/// 清算の一手順。
struct Seisan {
    /// 債務者。清算で支払いをする人。
    let debtor: Member
    /// 債権者。清算で受け取る側の人。
    let creditor: Member
    /// 支払い金額。
    let money: Int
}

/// 清算の計算を行う。
struct SeisanCalculator {
    /// メンバーの負債の状況を表現する。清算の計算のために使用する。
    private struct DebtState {
        enum DebtMapKey: Hashable {
            case someone(id: UUID)
            /// 計算過程に使用する仮想のメンバー。
            case imaginary
        }
        
        /// メンバーの借金額を格納する辞書。
        private(set) var debtMap: [DebtMapKey: Int]
        /// `DebtMapKey`に現れるUUIDとMemberオブジェクトとの対応付けを行う辞書。
        private var memberMap: [UUID: Member]
        
        init() {
            self.debtMap = [.imaginary: 0]
            self.memberMap = [:]
        }
        
        private init(debtMap: [DebtMapKey: Int], memberMap: [UUID: Member]) {
            self.debtMap = debtMap
            self.memberMap = memberMap
        }
        
        /// メンバーに対して借金を課す。
        ///
        /// 登録したメンバーのIDは`memberMap`に登録される。
        mutating func impose(money: Int, on member: Member) {
            let key = DebtMapKey.someone(id: member.id)
            if let nowDebt = debtMap[key] {
                debtMap[key] = nowDebt + money
            } else {
                debtMap[key] = money
            }
            
            // IDとメンバーの対応付けを登録
            memberMap[member.id] = member
        }
        
        /// 送金する。送金元の借金額を減らし、送金先の借金額を増やす。
        mutating func payMoney(_ money: Int, from fromKey: DebtMapKey, to toKey: DebtMapKey) {
            guard let fromDebt = debtMap[fromKey] else {
                print("[WARNING] 存在しない送金元ID:", fromKey)
                return
            }
            guard let toDebt = debtMap[toKey] else {
                print("[WARNING] 存在しない送金先ID:", toKey)
                return
            }
            debtMap[fromKey] = fromDebt - money
            debtMap[toKey] = toDebt + money
        }
        
        /// 2つの`DebtState`が保持する借金の差額を取る。
        ///
        /// `left`に登場するが`right`に登場しないメンバーは無視される。
        static func -(left: DebtState, right: DebtState) -> DebtState {
            let leftDebtMap = left.debtMap
            let rightDebtMap = right.debtMap
            let newDebtMap: [DebtMapKey: Int] = Dictionary(
                uniqueKeysWithValues: leftDebtMap.map { (key, leftDebt) in
                    (key, leftDebt - (rightDebtMap[key] ?? 0))
                }
            )
            return DebtState(debtMap: newDebtMap, memberMap: left.memberMap)
        }
        
        /// メンバーの借金額を返す。
        func getDebt(of member: Member) -> Int? {
            debtMap[.someone(id: member.id)]
        }
        
        /// 借金額の多い順にメンバーを並べた配列を返す。
        func debtRanking() -> [Member] {
            debtMap.sorted(by: { $0.value < $1.value }).flatMap { (key, debt) in
                switch key {
                case .someone(let id):
                    return memberMap[id].map { [$0] } ?? []
                case .imaginary:
                    return []
                }
            }
        }
    }
    
    /// 清算手順を計算し、手順のシーケンスを返す。
    ///
    /// - parameter transactionRecords: 立て替えリスト。
    /// - parameter unluckyMember: 選ばれたアンラッキーメンバー。
    func seisan(tatekaes: [Tatekae], unluckyMember: Member) -> [Seisan] {
        let debts = debts(tatekaes: tatekaes)
        let zansais = zansais(debts: debts, unluckyMember: unluckyMember)
        let seisanPrises = debts - zansais
        return seisan(seisanPrises: seisanPrises)
    }
    
    /// 清算必要額から清算手順を計算する。
    private func seisan(seisanPrises: DebtState) -> [Seisan] {
        var seisanState = seisanPrises  // 清算状況
        let sortedSeisanPriceMap: [Member] = seisanPrises.debtRanking()
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
            seisanState.payMoney(repaymentAmount, from: .someone(id: lender.id), to: .someone(id: borrower.id))
            
            if seisanState.getDebt(of: lender)! == 0 { right -= 1 }
            if seisanState.getDebt(of: borrower)! == 0 { left += 1 }
        }
        return result
    }
    
    /// 各メンバーの借金額を計算する。
    private func debts(tatekaes: [Tatekae]) -> DebtState {
        var debts: DebtState = DebtState()
        tatekaes.forEach { tatekae in
            debts.impose(money: -tatekae.money, on: tatekae.payer)
            let splitAmount = tatekae.money / tatekae.recipients.count
            tatekae.recipients.forEach { debts.impose(money: splitAmount, on: $0) }
        }
        return debts
    }
    
    /// 各メンバーの清算後の残債を計算する。
    private func zansais(debts: DebtState, unluckyMember: Member) -> DebtState {
        var zansais = debts
        debts.debtMap.forEach { (key, debt) in
            zansais.payMoney(debt - debt %% 10, from: key, to: .imaginary)
        }
        zansais.payMoney(zansais.debtMap[.imaginary]!, from: .imaginary, to: .someone(id: unluckyMember.id))
        return zansais
    }
}
