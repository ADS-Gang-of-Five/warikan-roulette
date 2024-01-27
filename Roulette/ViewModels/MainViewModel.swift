//
//  MainViewModel.swift
//  Roulette
//
//  Created by sako0602 on 2023/12/30.
//

import Foundation

/// - Important: 何かを追加するという処理には、更新が付随することに注意。
@MainActor
final class MainViewModel: ObservableObject {
    // 端末に保存されている全ての割り勘グループ
    @Published var allGroups: [WarikanGroup] = []

    // 使用中の割り勘グループ、及びそのメンバーと立て替えの一覧
    @Published var selectedGroup: WarikanGroup?
    @Published var selectedGroupMembers: [Member]?
    @Published var selectedGroupTatekaes: [Tatekae]?
    @Published var selectedGroupSeisanResponse: SeisanCalculator.SeisanResponse?
    var unluckyMember: Member?

    // ユースケース
    private let warikanGroupUseCase: WarikanGroupUsecase
    private let memberUsecase: MemberUsecase
    private let tatekaeUsecase: TatekaeUsecase
    private let warikanGroupArchiveController: WarikanGroupArchiveController
    let seisanCalculator: SeisanCalculator

    init() {
        let warikanGroupRepository = WarikanGroupRepository(userDefaultsKey: "warikanGroup")
        let memberRepository = MemberRepository(userDefaultsKey: "member")
        let tatekaeRepository = TatekaeRepository(userDefaultsKey: "tatekae")
        let archivedWarikanGroupRepository = ArchivedWarikanGroupRepository(
            userDefaultsKey: "archivedWarikanGroup"
        )
        let warikanGroupArchiveController =  WarikanGroupArchiveController(
            warikanGroupRepository: warikanGroupRepository,
            archivedWarikanGroupRepository: archivedWarikanGroupRepository
        )
        let seisanCalculator = SeisanCalculator(memberRepository: memberRepository)

        self.warikanGroupUseCase = WarikanGroupUsecase(
            warikanGroupRepository: warikanGroupRepository,
            memberRepository: memberRepository,
            tatekaeRepository: tatekaeRepository
        )
        self.memberUsecase = MemberUsecase(memberRepository: memberRepository)
        self.tatekaeUsecase = TatekaeUsecase(tatekaeRepository: tatekaeRepository)
        self.warikanGroupArchiveController = warikanGroupArchiveController
        self.seisanCalculator = seisanCalculator
    }

    // 全ての割り勘グループを取得
    func getAllWarikanGroups() async {
        do {
            allGroups = try await warikanGroupUseCase.getAll()
        } catch {
            print(#function, error)
        }
    }
    
    // 割り勘グループを作成
    func createWarikanGroup(name: String, memberNames: [String]) async {
        do {
            try await warikanGroupUseCase.create(name: name, memberNames: memberNames)
            await getAllWarikanGroups()
        } catch {
            print(#function, error)
        }
    }
    
    // 割り勘グループIDからそのグループのメンバーリストを取得
    func getSelectedGroupMembers(ids: [EntityID<Member>]) async {
        do {
            selectedGroupMembers = try await memberUsecase.get(ids: ids)
        } catch {
            print(#function, error)
        }
    }

    // 割り勘グループIDからそのグループの立替リストを取得
    func getSelectedGroupTatakaeList(id: EntityID<WarikanGroup>) async {
        do {
            selectedGroupTatekaes = try await warikanGroupUseCase.getTatekaeList(id: id)
        } catch {
            print(#function, error)
        }
    }

    // メンバーIDから実体(Member)を取得
    func getMember(id: EntityID<Member>) async -> Member {
        do {
            let member = try await memberUsecase.get(id: id)!
            return member
        } catch {
            print(#function, error)
            fatalError()
        }
    }

    // 立替リストを取得
    func getTatekaeList(ids: [EntityID<Tatekae>]) async {
        do {
            selectedGroupTatekaes = try await tatekaeUsecase.get(ids: ids)
        } catch {
            print(#function, error)
            fatalError()
        }
    }

    // 立替を追加
    func appendTatekae(
        warikanGroupID: EntityID<WarikanGroup>,
        tatekaeName: String,
        payerID: EntityID<Member>,
        recipantIDs: [EntityID<Member>],
        money: Int
    ) async {
        do {
            try await warikanGroupUseCase.appendTatekae(
                warikanGroup: warikanGroupID,
                tatekaeName: tatekaeName,
                payer: payerID,
                recipants: recipantIDs,
                money: money
            )
            await getSelectedGroupTatakaeList(id: warikanGroupID)
        } catch {
            print(#function, error)
        }
    }
    
    // 選択したグループとそのメンバーと立て替えをMainViewModelに保持させる
    func selectWarikanGroup(warikanGroup: WarikanGroup) async {
        do {
            selectedGroup = warikanGroup
            selectedGroupMembers = try await memberUsecase.get(ids: warikanGroup.members)
            selectedGroupTatekaes = try await warikanGroupUseCase.getTatekaeList(id: warikanGroup.id)
        } catch {
            print(#function, error)
        }
    }

    // 現在のselectedGroupTatekaesを基にSeisanResponseを取得する
    func getSeisanResponse() async {
        do {
            let memberRepository = MemberRepository(userDefaultsKey: "member")
            let seisanCaluculator = SeisanCalculator(memberRepository: memberRepository)
            guard let tatekaeList = selectedGroupTatekaes else {
                print("selectedGroupTatekaesがnilです。")
                return
            }
            try await selectedGroupSeisanResponse = seisanCaluculator.seisan(tatekaeList: tatekaeList)
        } catch {
            print(#function, error)
        }
    }
    
    func archiveWarikanGroup(
        id: EntityID<WarikanGroup>,
        seisanList: [SeisanData],
        unluckyMember: EntityID<Member>?
    ) async {
        do {
            _ = try await warikanGroupArchiveController.archive(
                id: id,
                seisanList: seisanList,
                unluckyMember: unluckyMember
            )
        } catch {
            print(#function, error)
        }
    }
}
