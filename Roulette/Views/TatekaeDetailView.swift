//
//  TatekaeDetailView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/05.
//

import SwiftUI

struct TatekaeDetailView: View {
    @EnvironmentObject private var mainViewModel: MainViewModel
    @Environment(\.dismiss) private var dismiss
    
    let tatekae: Tatekae
    @State private var memberName: String?
    @State private var dateString: String?
    
    var body: some View {
        NavigationStack {
            List {
                if let memberName, let dateString {
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
                        Text(memberName)
                    } header: {
                        Text("立替人")
                    }
                    Section {
                        Text(dateString)
                    } header: {
                        Text("日時")
                    }
                } else {
                    HStack {
                        Text("読み込み中...")
                        Spacer()
                        ProgressView()
                    }
                }
            }
            .task {
                let member = await mainViewModel.getMember(id: tatekae.payer)
                self.memberName = member.name
                
                let df = DateFormatter()
                df.calendar = Calendar(identifier: .gregorian)
                df.dateFormat = "yyyy年MM月dd日 HH時mm分"
                self.dateString = df.string(from: tatekae.createdTime)
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
