//
//  TatekaeDetailViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
final class TatekaeDetailViewModel: ObservableObject {
    private let tatekaeID: EntityID<Tatekae>
    @Published private(set) var tatekaeDTO: TatekaeDTO?
    private let tatekaeUseCase = TatekaeUseCase(tatekaeRepository: TatekaeRepository())

    @Published var isShowAlert = false
    @Published private(set) var alertText = ""

    init(_ tatekaeID: EntityID<Tatekae>) {
        self.tatekaeID = tatekaeID
    }

    func makeTatekaeDTO() async {
        do {
            if let tatekae = try await tatekaeUseCase.get(id: tatekaeID) {
                self.tatekaeDTO = TatekaeDTO.convert(tatekae)
            } else {
                alertText = "データの読み込み中にエラーが発生しました。前の画面に戻って再度お試しください。"
                isShowAlert = true
            }
        } catch {
            print(error)
            alertText = "データの読み込み中にエラーが発生しました。前の画面に戻って再度お試しください。"
            isShowAlert = true
        }
    }
}
