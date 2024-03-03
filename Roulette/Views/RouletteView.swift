//
//  RouletteView.swift
//  Roulette
//
//  Created by sako0602 on 2023/12/05.
//

import SwiftUI
import Charts

struct RouletteView: View {
    @StateObject private var viewModel: RouletteViewModel
    @Environment(\.dismiss) private var dismiss

    init(warikanGroupID: EntityID<WarikanGroup>) {
        _viewModel = StateObject(
            wrappedValue: RouletteViewModel(warikanGroupID: warikanGroupID)
        )
    }

    var body: some View {
            VStack {
                if let members = viewModel.members {
                    Image(systemName: "triangleshape.fill")
                        .rotationEffect(Angle(degrees: 180.0))
                        .foregroundStyle(.red)
                        .scaleEffect(1.3)
                    Chart {
                        ForEach(members) { member in
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
                                    .rotationEffect(-viewModel.angle)
                            }
                        }
                    }
                    .chartLegend(.hidden)
                    .navigationBarBackButtonHidden(viewModel.isRouletteBottanTap)
                    .rotationEffect(viewModel.angle)
                    .frame(width: 300, height: 300)
                    .padding(.top, 3)
                    if !viewModel.isRouletteBottanTap {
                        Button {
                            viewModel.didStartButtonTappedAction()
                        } label: {
                            Text("Start")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(viewModel.isRouletteBottanTap ? .gray : .blue)
                        .padding(.top)
                    } else {
                        if let id = viewModel.archivedWarikanGroupID {
                            NavigationLink("Next", value: Path.rouletteResultView(id))
                                .buttonStyle(.borderedProminent)
                                .padding(.top)
                        }
                    }
                }
            }
            .task {
                await viewModel.onAppearAction()
            }
            .alert(viewModel.alertText, isPresented: $viewModel.isShowAlert) {
                Button("戻る") {
                    dismiss()
                }
            }
    }
}
