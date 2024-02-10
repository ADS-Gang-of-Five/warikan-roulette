//
//  TatekaeDetailView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/05.
//

import SwiftUI

struct TatekaeDetailView: View {
    @StateObject private var viewModel: TatekaeDetailViewModel
    @Environment(\.dismiss) private var dismiss

    init(_ tatekaeID: EntityID<Tatekae>) {
        self._viewModel = StateObject(
            wrappedValue: TatekaeDetailViewModel(tatekaeID)
        )
    }

    var body: some View {
        NavigationStack {
            List {
                if let tatekae = viewModel.tatekaeDTO {
                    Section {
                        Text(tatekae.name)
                    } header: {
                        Text("立替の名目")
                    }
                    Section {
                        Text("\(tatekae.money)円")
                    } header: {
                        Text("立替の金額")
                    }
                    Section {
                        Text(tatekae.payer)
                    } header: {
                        Text("立替人")
                    }
                    Section {
                        Text(tatekae.createdTime)
                    } header: {
                        Text("日時")
                    }
                }
            }
            .task {
                await viewModel.makeTatekaeDTO()
            }
            .navigationTitle("立替の詳細")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                }
            }
        }
    }
}
