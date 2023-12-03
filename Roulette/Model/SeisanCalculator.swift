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
    /// メンバーの負債の状況を表現する。清算の計算のために使用する。
    fileprivate struct DebtState {
        enum DebtMapKey: Hashable {
            case someone(id: EntityID<Member>)
            /// 計算過程に使用する仮想のメンバー。
            case imaginary
        }
        
        /// メンバーの借金額を格納する辞書。
        private(set) var debtMap: [DebtMapKey: Int]
        
        init() {
            self.debtMap = [.imaginary: 0]
        }
        
        private init(debtMap: [DebtMapKey: Int]) {
            self.debtMap = debtMap
        }
        
        /// メンバーに対して借金を課す。
        mutating func impose(money: Int, on member: EntityID<Member>) {
            let key = DebtMapKey.someone(id: member)
            if let nowDebt = debtMap[key] {
                debtMap[key] = nowDebt + money
            } else {
                debtMap[key] = money
            }
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
            return DebtState(debtMap: newDebtMap)
        }
        
        /// メンバーの借金額を返す。
        func getDebt(of member: EntityID<Member>) -> Int? {
            debtMap[.someone(id: member)]
        }
        
        /// 借金額の多い順にメンバーを並べた配列を返す。
        func debtRanking() -> [EntityID<Member>] {
            debtMap.sorted(by: { $0.value < $1.value }).compactMap { (key, debt) in
                switch key {
                case .someone(let id):
                    return id
                case .imaginary:
                    return nil
                }
            }
        }
    }
    
    /// アンラッキーメンバーが確定しない段階での、清算手順の途中計算結果を保持する。
    struct SeisanContext {
        fileprivate let debts: DebtState
        fileprivate let zansais: DebtState
    }
    
    /// `seisan(transactionRecords:)`の応答。
    enum SeisanResponse {
        case needsUnluckyMember(SeisanContext)
        case success([Seisan])
    }
    
    /// 立て替えリストから清算手順の計算を行う。
    func seisan(tatekaes: [Tatekae]) -> SeisanResponse {
        let debts = debts(tatekaes: tatekaes)
        
        var zansais = debts
        debts.debtMap.forEach { (key, debt) in
            zansais.payMoney(debt - debt %% 10, from: key, to: .imaginary)
        }
        
        if zansais.debtMap[.imaginary] != 0 {
            let context = SeisanContext(debts: debts, zansais: zansais)
            return SeisanResponse.needsUnluckyMember(context)
        } else {
            return SeisanResponse.success(seisan(seisanPrises: debts - zansais))
        }
    }
    
    /// アンラッキーメンバーを指定して清算の計算を再開する。
    func seisan(context: SeisanContext, unluckyMember: EntityID<Member>) -> [Seisan] {
        let debts = context.debts
        var zansais = context.zansais
        zansais.payMoney(zansais.debtMap[.imaginary]!, from: .imaginary, to: .someone(id: unluckyMember))
        return seisan(seisanPrises: debts - zansais)
    }
    
    /// 清算必要額から清算手順を計算する。
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
    private func debts(tatekaes: [Tatekae]) -> DebtState {
        var debts: DebtState = DebtState()
        tatekaes.forEach { tatekae in
            debts.impose(money: -tatekae.money, on: tatekae.payer.id)
            let splitAmount = tatekae.money / tatekae.recipients.count
            tatekae.recipients.forEach { debts.impose(money: splitAmount, on: $0.id) }
        }
        return debts
    }
}
