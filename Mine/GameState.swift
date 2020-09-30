//
//  GameState.swift
//  Mine
//
//  Created by kaz on 2020/09/30.
//

import Foundation

struct FieldSize {
    var w: Int
    var h: Int
}

struct CellState: Equatable, Identifiable {
    var id: Int
    var mined: Bool = false
    var opened: Bool = false
    var numMinesAround: Int = 0
}

struct FieldLineState: Equatable, Identifiable {
    var id: Int
    var cells: [CellState]
    
    subscript(index: Int) -> CellState {
        get {
            cells[index]
        }
        set {
            cells[index] = newValue
        }
    }
}

struct GameState {
    enum Result {
        case won, lost, playing
    }
    let size: FieldSize
    var field: [FieldLineState]
    let numMines: Int
    var startedAt: Date?
    var finishedAt: Date?
    
    init(_ fieldSize: FieldSize, numMines: Int) {
        field = []
        self.size = fieldSize
        self.numMines = numMines
        initializeField()
    }
    
    func isOpened() -> Bool {
        for line in field {
            for s in line.cells {
                if s.opened {
                    return true
                }
            }
        }
        return false
    }
    
    func result() -> Result {
        var playing = false
        for line in field {
            for s in line.cells {
                if s.opened && s.mined {
                    return .lost
                }
                if !s.opened && !s.mined {
                    playing = true
                }
            }
        }
        return playing ? .playing : .won
    }
    
    func numMinesAround(x: Int, y: Int) -> Int {
        let xrange = (x-1...x+1).clamped(to: 0...size.w-1)
        let yrange = (y-1...y+1).clamped(to: 0...size.h-1)
        var n = 0
        for xi in xrange {
            for yi in yrange {
                if field[xi][yi].mined {
                    n += 1
                }
            }
        }
        return n
    }
    
    mutating func initializeField() {
        field = Array(repeating: FieldLineState(id: 0, cells: Array(repeating: CellState(id: 0), count: size.h)), count: size.w)
        for x in 0..<size.w {
            field[x].id = x
            for y in 0..<size.h {
                field[x][y].id = y
            }
        }
        
        var n = numMines
        while n > 0 {
            let x = Int.random(in: 0..<size.w)
            let y = Int.random(in: 0..<size.h)
            if !field[x][y].mined {
                field[x][y].mined = true
                n -= 1
            }
        }
        for x in 0..<size.w {
            for y in 0..<size.h {
                field[x][y].numMinesAround = numMinesAround(x: x, y: y)
            }
        }
        startedAt = nil
        finishedAt = nil
    }
    
    mutating func open(x: Int, y: Int) {
        if !isOpened() {
            while field[x][y].mined {
                initializeField()
            }
            startedAt = Date()
        }
        
        openRecursively(x: x, y: y)
        
        if finishedAt == nil && result() != .playing {
            finishedAt = Date()
        }
    }
    
    private mutating func openRecursively(x: Int, y: Int) {
        if field[x][y].opened {
            return
        }
        field[x][y].opened = true
        if field[x][y].mined {
            return
        }
        if field[x][y].numMinesAround > 0 {
            return
        }
        for xi in x-1...x+1 {
            if xi < 0 || size.w <= xi {
                continue
            }
            for yi in y-1...y+1 {
                if yi < 0 || size.h <= yi {
                    continue
                }
                openRecursively(x: xi, y: yi)
            }
        }
    }
}
