//
//  RouletteView.swift
//  Roulette
//
//  Created by sako0602 on 2023/12/05.
//

import SwiftUI
import Charts

// TODO: ルーレットが回った後に、backできない使用に変更する。
struct RouletteView: View {
    @EnvironmentObject private var mainViewModel: MainViewModel
//    private var members = [
//        (name: "A", count: 100),
//        (name: "B", count: 100),
//        (name: "C", count: 100),
//        (name: "D", count: 100),
//        (name: "E", count: 100),
//        (name: "F", count: 100),
//        (name: "G", count: 100)
//    ]
    private var members = [
        "りんご",
        "もも",
        "みかん",
        "ぶどう",
        "メロン",
        "スイカ",
        "ブルーベリー"
    ]
    @State private var angle = Angle(degrees: 0.0)
    @State private var isRotetion = false
    
    var body: some View {
//        if let warikanGroup = mainViewModel.selectedGroup {
            VStack {
                Image(systemName: "triangleshape.fill")
                    .rotationEffect(Angle(degrees: 180.0))
                    .foregroundStyle(.red)
                    .scaleEffect(1.3)
                Chart {
                    ForEach(members, id: \.self) { member in
                        SectorMark(
                            angle: .value("", 360.0),
                            innerRadius: MarkDimension.ratio(0.5),
                            angularInset: 1
                        )
                        .cornerRadius(1)
                        .foregroundStyle(by: .value("", member))
                        .annotation(position: .overlay) {
                            Text(member)
                                .font(.headline)
                                .foregroundStyle(.white)
                                .rotationEffect(-angle)
                        }
                    }
                }
                .chartLegend(.hidden)
                .rotationEffect(angle)
                .frame(width: 300, height: 300)
                .padding(.top, 3)
                Button {
                    stopAtMember(named: "りんご")
                } label: {
                    Text("Start")
                }
                .buttonStyle(.borderedProminent)
                .tint(.gray)
                .padding(.top)
                NavigationLink("Next", value: Path.rouletteResultView)
                    .buttonStyle(.borderedProminent)
                    .padding(.top)
            }
//        } else {
//            Text("前の画面へ戻り再度試してみてください")
//        }
    }
    
    private func stopAtMember(named name: String) {
        guard let selectedMemberIndex = members.firstIndex(of: name) else { return }
        let degreesPerMember = 360.0 / Double(members.count)
        let halfSector = degreesPerMember / 2.0
        let targetDegrees = degreesPerMember * Double(selectedMemberIndex) + halfSector
        
        isRotetion = true
        angle = .zero
        withAnimation(.spring(duration: 10)) {
            let extraRotation = 360.0 * 5
            angle = .degrees(extraRotation - targetDegrees)
        }
    }
}

#Preview {
    RouletteView()
        .environmentObject(MainViewModel())
}
