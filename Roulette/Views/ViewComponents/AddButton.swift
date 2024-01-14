//
//  AddButton.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/06.
//

import SwiftUI

struct AddButton: View {
    let action: () -> Void
    let diameter: CGFloat

    init(action: @escaping () -> Void, diameter: CGFloat = 60) {
        self.action = action
        self.diameter = diameter
    }

    var body: some View {
        Button(action: {}, label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: diameter, height: diameter)
                .foregroundStyle(.blue)
                .background(.white)
                .clipShape(Circle())
        })
    }
}

#Preview {
    AddButton {}
}
