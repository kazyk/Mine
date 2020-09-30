//
//  Settings.swift
//  Mine
//
//  Created by kaz on 2020/09/30.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject
    private var game: Game
    
    @State private var width = ""
    @State private var height = ""
    @State private var mines = ""
    
    var dismiss: () -> Void
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("Board Width:").frame(width: 90, alignment: .trailing)
                    TextField("", text: $width)
                }
                HStack {
                    Text("Board Height:").frame(width: 90, alignment: .trailing)
                    TextField("", text: $height)
                }
                HStack {
                    Text("Mines:").frame(width: 90, alignment: .trailing)
                    TextField("", text: $mines)
                }
            }
            Section {
                HStack {
                    Spacer()
                    Button("Cancel") {
                        self.dismiss()
                    }
                    Button("Done") {
                        let w = Int(self.width)
                        let h = Int(self.height)
                        let n = Int(self.mines)
                        _ = game.updateSettings(w: w, h: h, n: n)
                        self.dismiss()
                    }
                }
            }
        }.frame(width: 200, height: 120)
        .padding()
        .onAppear {
            self.width = String(game.state.size.w)
            self.height = String(game.state.size.h)
            self.mines = String(game.state.numMines)
        }
    }
}

struct Settings_Preview: PreviewProvider {
    static var previews: some View {
        Settings(dismiss: {}).environmentObject(Game(w: 10, h: 10, n: 3))
    }
}
