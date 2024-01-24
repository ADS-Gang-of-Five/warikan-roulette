//
//  RouletteView.swift
//  Roulette
//
//  Created by sako0602 on 2023/12/05.
//

import SwiftUI
import Charts

struct RouletteView: View {
    @EnvironmentObject private var mainViewModel: MainViewModel
    @State private var angle = Angle(degrees: 0.0)
    @State private var isRouletteBottanTap = false
    
    var body: some View {
        if let members = mainViewModel.selectedGroupMembers {
            VStack {
                Image(systemName: "triangleshape.fill")
                    .rotationEffect(Angle(degrees: 180.0))
                    .foregroundStyle(.red)
                    .scaleEffect(1.3)
                Chart {
                    ForEach(members, id: \.id) { member in
                        SectorMark(
                            angle: .value("", 360.0),
                            innerRadius: MarkDimension.ratio(0.5),
                            angularInset: 1
                        )
                        .cornerRadius(1)
                        .foregroundStyle(by: .value("", member.name))
                        .annotation(position: .overlay) {
                            Text(member.name)
                                .font(.headline)
                                .foregroundStyle(.white)
                                .rotationEffect(-angle)
                        }
                    }
                }
                .chartLegend(.hidden)
                .navigationBarBackButtonHidden(isRouletteBottanTap)
                .rotationEffect(angle)
                .frame(width: 300, height: 300)
                .padding(.top, 3)
                if !isRouletteBottanTap {
                    Button {
                        isRouletteBottanTap = true
                        let unluckyMember = members.randomElement()!
                        stopAtMember(id: unluckyMember.id)
                        mainViewModel.unluckyMember = unluckyMember.id
                    } label: {
                        Text("Start")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(isRouletteBottanTap ? .gray : .blue)
                    .padding(.top)
                } else {
                    NavigationLink("Next", value: Path.rouletteResultView)
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                        .padding(.top)
                }
            }
        } else {
            Text("メンバーが登録されていません。")
        }
    }
    
    private func stopAtMember(id: EntityID<Member>) {
        guard let members = mainViewModel.selectedGroupMembers else { return }
        guard let selectedMemberIndex = members.firstIndex(where: { $0.id == id }) else { return }
        let degreesPerMember = 360.0 / Double(members.count)
        let halfSector = degreesPerMember / 2.0
        let targetDegrees = degreesPerMember * Double(selectedMemberIndex) + halfSector
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
