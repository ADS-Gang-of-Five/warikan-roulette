//
//  GroupListViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
final class GroupListViewModel: ObservableObject {
    @Published var groups: [WarikanGroup] = .init()
    private let warikanGroupUseCase: WarikanGroupUsecase

    init() {
        let warikanGroupRepository = WarikanGroupRepository(userDefaultsKey: "warikanGroup")
        let memberRepository = MemberRepository(userDefaultsKey: "member")
        let tatekaeRepository = TatekaeRepository(userDefaultsKey: "tatekae")

        self.warikanGroupUseCase = WarikanGroupUsecase(
            warikanGroupRepository: warikanGroupRepository,
            memberRepository: memberRepository,
            tatekaeRepository: tatekaeRepository
        )
    }

    func fecthAllGroups() async {
        print("fetchGroupAllが呼ばれました。")
        do {
            groups = try await warikanGroupUseCase.getAll()
            print("groups", groups)
        } catch {
            print(error)
        }
    }
    
    func createWarikanGroup(name: String, memberNames: [String]) async {
        do {
            try await warikanGroupUseCase.create(name: name, memberNames: memberNames)
            await fecthAllGroups()
        } catch {
            print(#file, #line, "couldn't create")
        }
    }
}
