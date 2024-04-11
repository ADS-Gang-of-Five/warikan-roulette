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
    @EnvironmentObject private var viewRouter: ViewRouter
    
    init(warikanGroupID: EntityID<WarikanGroup>) {
        _viewModel = StateObject(
            wrappedValue: RouletteViewModel(warikanGroupID: warikanGroupID)
        )
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                if let members = viewModel.members {
                VStack {
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
                        .frame(
                            width: geometry.size.width * 0.8,
                            height: geometry.size.height * 0.5
                        )
                        .padding(.top, 3)
                    }
                    .frame(height: geometry.size.height * 0.6)
                    VStack {
                        Spacer()
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
                                NavigationLink("Next", value: ViewRouter.Path.rouletteResultView(id))
                                    .buttonStyle(.borderedProminent)
                                    .padding(.top)
                            }
                        }
                        Spacer()
                        Button {
                            viewRouter.path.removeLast()
                        } label: {
                            Text("戻る")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                        .opacity(viewModel.isRouletteBottanTap ? 0.0 : 1.0)
                        Spacer()
                    }
                    .frame(height: geometry.size.height * 0.2)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
}
