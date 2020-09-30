//
//  MineFieldView.swift
//  Mine
//
//  Created by kaz on 2020/09/30.
//

import SwiftUI

struct MineFieldView: View {
    var field: [FieldLineState]
    var onTap: (_ x: Int, _ y: Int) -> Void
    
    var body: some View {
        HStack(spacing: 1) {
            ForEach(field) { line in
                VStack(spacing: 1) {
                    ForEach(line.cells) { f in
                        Cell(state: f)
                            .onTapGesture {
                                onTap(line.id, f.id)
                            }
                    }
                }
            }
        }
    }
}

struct MineFieldView_Previews: PreviewProvider {
    static let game = Game(w: 5, h: 4, n: 1)
    static var previews: some View {
        MineFieldView(field: [], onTap: { _, _ in () }).environmentObject(game)
    }
}
