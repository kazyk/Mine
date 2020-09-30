//
//  Cell.swift
//  Mine
//
//  Created by kaz on 2020/09/30.
//

import SwiftUI

struct Cell: View, Equatable {
    var state: CellState
    
    private func color() -> NSColor {
        if state.opened {
            if state.mined {
                return .red
            } else {
                return .black
            }
        } else {
            return .lightGray
        }
    }
    
    private func label() -> String {
        if state.opened && state.mined {
            return "X"
        }
        if state.opened, state.numMinesAround > 0 {
            return String(state.numMinesAround)
        }
        return ""
    }
    
    var body: some View {
        ZStack {
            Color(color())
            Text(label())
        }
        .frame(width: 18, height: 18)
    }
}

struct Cell_Previews: PreviewProvider {
    static var previews: some View {
        Cell(state: CellState(id: 0, mined: false, opened: false))
    }
}
