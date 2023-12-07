//
//  AddButton.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/06.
//

import SwiftUI

struct AddButton: View {
    let diameter: CGFloat
    
    init(diameter: CGFloat = 60) {
        self.diameter = diameter
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .foregroundStyle(Color.blue)
                    .frame(width: diameter, height: diameter)
                    .background(.white)
                    .clipShape(Circle())
                    .padding(.trailing)
            }
        }
    }
}

#Preview {
    AddButton()
}
