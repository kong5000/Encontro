//
//  PickerItem.swift
//  Encontro
//
//  Created by k on 2024-03-01.
//

import SwiftUI

struct PickerItem: View {
    var body: some View {
        HStack{
            Rectangle()
                .fill(.red)
                .frame(width: 20, height: 20)
                .cornerRadius(5)
        }
    }
}

#Preview {
    PickerItem()
}
