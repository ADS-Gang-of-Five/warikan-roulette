//
//  DebtState.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/03
//  
//

import Foundation

/// メンバーの負債の状況を表現する。清算の計算のために使用する。
/// - Important: `SeisanCalculator`以外からの使用は禁止とする。
struct DebtState {
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
    
    /// `debtMap` に登録されているメンバーの一覧を返す。
    func getMembers() -> [EntityID<Member>] {
        return debtMap.compactMap { (key: DebtMapKey, value: Int) in
            switch key {
            case .someone(let id):
                return id
            case .imaginary:
                return nil
            }
        }
    }
}
