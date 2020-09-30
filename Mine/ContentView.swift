//
//  ContentView.swift
//  Mine
//
//  Created by kaz on 2020/09/30.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject
    private var game: Game
    
    @State
    private var showsSheet = false
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button("Restart Game") {
                    game.reset()
                }
                Button("Settings") {
                    self.showsSheet = true
                }
                Text("size: (\(game.state.size.w),\(game.state.size.h))")
                Text("mines: \(game.state.numMines)")
                Text(game.timeLabel ?? "")
            }.padding(.top, 10)
            
            Text(game.message ?? " ").padding(4).foregroundColor(.red)
            
            MineFieldView(
                field: game.state.field,
                onTap: game.open
            ).frame(maxWidth: .infinity, maxHeight: .infinity)
        }.sheet(isPresented: $showsSheet, content: {
            Settings(dismiss: {
                self.showsSheet = false
            }).environmentObject(game)
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
