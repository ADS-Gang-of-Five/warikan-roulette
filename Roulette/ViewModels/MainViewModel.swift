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
    @Published var unluckyMemberName: String?

    // ユースケース
    private let warikanGroupUseCase: WarikanGroupUseCase
    private let memberUseCase: MemberUseCase
    private let tatekaeUseCase: TatekaeUseCase
    private let warikanGroupArchiveController: WarikanGroupArchiveController
    let seisanCalculator: SeisanCalculator

    init() {
        self.warikanGroupUseCase = WarikanGroupUseCase(
            warikanGroupRepository: WarikanGroupRepository(),
            memberRepository: MemberRepository(),
            tatekaeRepository: TatekaeRepository()
        )
        self.memberUseCase = MemberUseCase(memberRepository: MemberRepository())
        self.tatekaeUseCase = TatekaeUseCase(tatekaeRepository: TatekaeRepository())
        self.warikanGroupArchiveController = WarikanGroupArchiveController(
            warikanGroupRepository: WarikanGroupRepository(),
            archivedWarikanGroupRepository: ArchivedWarikanGroupRepository()
        )
        self.seisanCalculator = SeisanCalculator(memberRepository: MemberRepository())
    }

    // 全ての割り勘グループを取得
    func getAllWarikanGroups() async {
        do {
            allGroups = try await warikanGroupUseCase.getAll()
        } catch {
            print(#function, error)
        }
    }
    
    // 割り勘グループIDからそのグループのメンバーリストを取得
    func getSelectedGroupMembers(ids: [EntityID<Member>]) async {
        do {
            selectedGroupMembers = try await memberUseCase.get(ids: ids)
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
            let member = try await memberUseCase.get(id: id)!
            return member
        } catch {
            print(#function, error)
            fatalError()
        }
    }

    // 立替リストを取得
    func getTatekaeList(ids: [EntityID<Tatekae>]) async {
        do {
            selectedGroupTatekaes = try await tatekaeUseCase.get(ids: ids)
        } catch {
            print(#function, error)
            fatalError()
        }
    }

    func reloadTatekaeList() {
        Task {
            await getSelectedGroupTatakaeList(id: self.selectedGroup!.id)
        }
    }

    // 選択したグループとそのメンバーと立て替えをMainViewModelに保持させる
    func selectWarikanGroup(warikanGroup: WarikanGroup) async {
        do {
            selectedGroup = warikanGroup
            selectedGroupMembers = try await memberUseCase.get(ids: warikanGroup.members)
            selectedGroupTatekaes = try await warikanGroupUseCase.getTatekaeList(id: warikanGroup.id)
        } catch {
            print(#function, error)
        }
    }

    // 現在のselectedGroupTatekaesを基にSeisanResponseを取得する
    func getSeisanResponse() async {
        do {
            guard let tatekaeList = selectedGroupTatekaes else {
                print("selectedGroupTatekaesがnilです。")
                return
            }
            try await selectedGroupSeisanResponse = seisanCalculator.seisan(tatekaeList: tatekaeList)
        } catch {
            print(#function, error)
        }
    }
    
    // 途中計算の.needsunluckymenberを.successへ変える
    func convertSeisanResponseToSuccess( _ seisanDataList: [SeisanData]) {
        selectedGroupSeisanResponse = .success(seisanDataList)
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

    func didTapBackToTopButtonAction() {
       selectedGroup = nil
       selectedGroupMembers = nil
       selectedGroupTatekaes = nil
       selectedGroupSeisanResponse = nil
       unluckyMemberName = nil
    }
}
