//
//  TatekaeListViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
final class TatekaeListViewModel: ObservableObject {
    @Published var tatekaes: [Tatekae] = []
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

    func getTatakaeList(id: EntityID<WarikanGroup>) async {
        print("called getTatakaeList")
        do {
            tatekaes = try await warikanGroupUseCase.getTatekaeList(id: id)
            print("tatekaes:", tatekaes)
        } catch {
            print("error:", error)
            print(#file, #line)
        }
    }
}
