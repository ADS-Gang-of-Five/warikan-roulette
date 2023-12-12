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
    
    private init(debtMap: [DebtMapKey: Int]) {
        self.debtMap = debtMap
    }
    
    /// メンバーとDouble型の借金額の辞書型を受け取って `DebtMap` を作成する。
    ///
    /// 借金額は四捨五入され、整数に変換される。
    static func create(from originalDebtMap: [EntityID<Member>: Double]) -> Self {
        let debtMap = Dictionary(uniqueKeysWithValues: originalDebtMap.map({ (member: EntityID<Member>, debt: Double) in
            (DebtMapKey.someone(id: member), Int(debt.rounded()))
        }))
        return .init(debtMap: debtMap)
    }
    
    /// 送金する。送金元の借金額を減らし、送金先の借金額を増やす。
    mutating func payMoney(_ money: Int, from fromKey: DebtMapKey, to toKey: DebtMapKey) {
        debtMap[fromKey] = (debtMap[fromKey] ?? 0) - money
        debtMap[toKey] = (debtMap[toKey] ?? 0) + money
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
