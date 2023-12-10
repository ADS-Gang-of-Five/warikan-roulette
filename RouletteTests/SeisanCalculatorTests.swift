//
//  SeisanCalculatorTests.swift
//  RouletteTests
//  
//  Created by Seigetsu on 2023/12/10
//  
//

import XCTest
@testable import Roulette

fileprivate extension [Seisan] {
    func descript(with members: [Member]) -> String {
        let names = Dictionary(uniqueKeysWithValues: members.map { ($0.id, $0.name) })
        return self.map { seisan in
            let a = names[seisan.debtor]!
            let b = names[seisan.creditor]!
            return "\(a) -> \(b): \(seisan.money)円"
        }.joined(separator: "\n")
    }
}

final class SeisanCalculatorTests: XCTestCase {

    private func createMember(name: String) -> Member {
        let id = EntityID<Member>(value: UUID().uuidString)
        return Member(id: id, name: name)
    }
    
    private func createTatekae(name: String, payer: EntityID<Member>, recipients: [EntityID<Member>], money: Int) -> Tatekae {
        let id = EntityID<Tatekae>(value: UUID().uuidString)
        return Tatekae(id: id, name: name, payer: payer, recipients: recipients, money: money)
    }
    
    func test_case01_success() throws {
        let members = [
            createMember(name: "さこ"),
            createMember(name: "霽月"),
            createMember(name: "まき")
        ]
        let sako = members[0].id
        let seig = members[1].id
        let maki = members[2].id
        
        let tatekaeList = [
            createTatekae(name: "昼飯代", payer: sako, recipients: [sako, seig, maki], money: 1200),
            createTatekae(name: "タクシー代", payer: seig, recipients: [sako, seig, maki], money: 900),
            createTatekae(name: "宿代", payer: maki, recipients: [sako, seig, maki], money: 1080)
        ]
        
        // 計算実行
        let calculator = SeisanCalculator()
        let response = calculator.seisan(tatekaeList: tatekaeList)
        
        switch response {
        case .success(let seisanList):
            let result = seisanList.descript(with: members)
            XCTAssertEqual(result, """
            霽月 -> さこ: 140円
            霽月 -> まき: 20円
            """)
            
        default:
            XCTFail()
        }
    }
    
    func test_case02_needsUnluckyMember() throws {
        let members = [
            createMember(name: "さこ"),
            createMember(name: "霽月"),
            createMember(name: "まき")
        ]
        let sako = members[0].id
        let seig = members[1].id
        let maki = members[2].id
        
        let tatekaeList = [
            createTatekae(name: "昼飯代", payer: sako, recipients: [sako, seig, maki], money: 1200),
            createTatekae(name: "タクシー代", payer: seig, recipients: [sako, seig, maki], money: 900),
            createTatekae(name: "宿代", payer: maki, recipients: [sako, seig, maki], money: 1100)
        ]
        
        // 計算実行
        let calculator = SeisanCalculator()
        let response = calculator.seisan(tatekaeList: tatekaeList)
        
        switch response {
        case .needsUnluckyMember(let context):
            let unluckyMember = seig
            let seisanList = calculator.seisan(context: context, unluckyMember: unluckyMember)
            let result = seisanList.descript(with: members)
            XCTAssertEqual(result, """
            霽月 -> さこ: 140円
            霽月 -> まき: 40円
            """)
            
        default:
            XCTFail()
        }
    }

}
