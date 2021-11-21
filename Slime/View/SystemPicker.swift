//
//  SystemPicker.swift
//  Slime
//
//  Created by Mason Sun on 2021/11/20.
//

import SwiftUI

struct SystemPicker: View {
    @Binding var selections: [SystemType]

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(SystemType.allCases) {
                makeRow(type: $0)
            }
        }
    }

    private func makeRow(type: SystemType) -> some View {
        Toggle(type.rawValue, isOn: Binding(get: {
            selections.contains(type)
        }, set: { isSelected in
            if isSelected {
                selections.append(type)
            } else {
                selections.removeAll { $0 == type }
            }
        }))
    }
}

struct DevicePicker_Previews: PreviewProvider {
    static var previews: some View {
        SystemPicker(selections: .constant([.watchOS, .iOS]))
    }
}
