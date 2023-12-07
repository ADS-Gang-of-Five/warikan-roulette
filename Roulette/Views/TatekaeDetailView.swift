//
//  TatekaeDetailView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/05.
//

import SwiftUI

struct TatekaeDetailView: View {
    @Binding var isShowTatekaeDetailView: Bool
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("朝食")
                } header: {
                    Text("立替の名目")
                }
                Section {
                    Text("5,000円")
                } header: {
                    Text("立替の金額")
                }
                Section {
                    Text("Maki")
                } header: {
                    Text("立替人")
                }
                Section {
                    Text("2023年12月5日 10:00")
                } header: {
                    Text("日時")
                }
            }
            .navigationTitle("立替の詳細")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isShowTatekaeDetailView = false
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                }
            }
        }
    }
}


#Preview {
    TatekaeDetailView(isShowTatekaeDetailView: Binding.constant(true))
}
