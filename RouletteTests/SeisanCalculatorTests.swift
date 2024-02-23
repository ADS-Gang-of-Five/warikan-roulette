//
//  SeisanCalculatorTests.swift
//  RouletteTests
//  
//  Created by Seigetsu on 2023/12/10
//  
//

import XCTest
@testable import Roulette

fileprivate extension [SeisanData] {
    func descript(with members: [Member]) -> String {
        let names = Dictionary(uniqueKeysWithValues: members.map { ($0.id, $0.name) })
        return self.map { seisan in
            let a = names[seisan.debtor.id]!
            let b = names[seisan.creditor.id]!
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
        return Tatekae(id: id, name: name, payer: payer, recipients: recipients, money: money, createdTime: Date())
    }
    
    func test_case01_success() async throws {
        let members = [
            createMember(name: "さこ"),
            createMember(name: "霽月"),
            createMember(name: "まき")
        ]
        let sako = members[0].id
        let seig = members[1].id
        let maki = members[2].id
        let memberRepository = InMemoryMemberRepository()
        members.forEach { memberRepository.save($0) }
        let calculator = SeisanCalculator(memberRepository: memberRepository)
        
        let tatekaeList = [
            createTatekae(name: "昼飯代", payer: sako, recipients: [sako, seig, maki], money: 1200),
            createTatekae(name: "タクシー代", payer: seig, recipients: [sako, seig, maki], money: 900),
            createTatekae(name: "宿代", payer: maki, recipients: [sako, seig, maki], money: 1080)
        ]
        
        // 計算実行
        let response = try await calculator.seisan(tatekaeList: tatekaeList)
        
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
    
    func test_case02_needsUnluckyMember() async throws {
        let members = [
            createMember(name: "さこ"),
            createMember(name: "霽月"),
            createMember(name: "まき")
        ]
        let sako = members[0].id
        let seig = members[1].id
        let maki = members[2].id
        let memberRepository = InMemoryMemberRepository()
        members.forEach { memberRepository.save($0) }
        let calculator = SeisanCalculator(memberRepository: memberRepository)
        
        let tatekaeList = [
            createTatekae(name: "昼飯代", payer: sako, recipients: [sako, seig, maki], money: 1200),
            createTatekae(name: "タクシー代", payer: seig, recipients: [sako, seig, maki], money: 900),
            createTatekae(name: "宿代", payer: maki, recipients: [sako, seig, maki], money: 1100)
        ]
        
        // 計算実行
        let response = try await calculator.seisan(tatekaeList: tatekaeList)
        
        switch response {
        case .needsUnluckyMember(let context):
            XCTAssertEqual(Set(context.unluckyMemberCandidates), Set([sako, seig, maki]))
            
            // アンラッキーメンバーを指定して計算続行
            let seisanList = try await calculator.seisan(context: context, unluckyMember: seig)
            
            let result = seisanList.descript(with: members)
            XCTAssertEqual(result, """
            霽月 -> さこ: 140円
            霽月 -> まき: 40円
            """)
            
        default:
            XCTFail()
        }
    }
    
    func test_case03_アンラッキーメンバー候補() async throws {
        let members = [
            createMember(name: "さこ"),
            createMember(name: "霽月"),
            createMember(name: "まき")
        ]
        let sako = members[0].id
        let seig = members[1].id
        let memberRepository = InMemoryMemberRepository()
        members.forEach { memberRepository.save($0) }
        let calculator = SeisanCalculator(memberRepository: memberRepository)
        
        let tatekaeList = [
            createTatekae(name: "昼飯代", payer: seig, recipients: [sako, seig], money: 1234)
        ]
        
        // 計算実行
        let response = try await calculator.seisan(tatekaeList: tatekaeList)
        
        switch response {
        case .needsUnluckyMember(let context):
            XCTAssertEqual(Set(context.unluckyMemberCandidates), Set([sako, seig]))
            
            // アンラッキーメンバーを指定して計算続行
            let seisanList = try await calculator.seisan(context: context, unluckyMember: sako)
            
            let result = seisanList.descript(with: members)
            XCTAssertEqual(result, """
            さこ -> 霽月: 620円
            """)
            
        default:
            XCTFail()
        }
    }
    
    func test_case04_清算が不要の場合は空配列を返す() async throws {
        let members = [
            createMember(name: "さこ"),
            createMember(name: "霽月"),
            createMember(name: "まき")
        ]
        let sako = members[0].id
        let seig = members[1].id
        let maki = members[2].id
        let memberRepository = InMemoryMemberRepository()
        members.forEach { memberRepository.save($0) }
        let calculator = SeisanCalculator(memberRepository: memberRepository)
        
        let tatekaeList = [
            createTatekae(name: "昼飯代", payer: sako, recipients: [sako, seig, maki], money: 1000),
            createTatekae(name: "タクシー代", payer: seig, recipients: [sako, seig], money: 667),
            createTatekae(name: "宿代", payer: maki, recipients: [sako, maki], money: 667)
        ]
        
        // 計算実行
        let response = try await calculator.seisan(tatekaeList: tatekaeList)
        
        switch response {
        case .success(let seisanList):
            XCTAssertTrue(seisanList.isEmpty)
            
        default:
            XCTFail()
        }
    }

}
