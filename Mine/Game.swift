//
//  MineField.swift
//  Mine
//
//  Created by kaz on 2020/09/30.
//

import Foundation


final class Game: ObservableObject {
    @Published private(set) var state: GameState
    @Published private(set) var timeLabel: String?
    @Published private(set) var message: String?
    
    private var timer: Timer?
    
    init(w: Int, h: Int, n: Int) {
        state = GameState(FieldSize(w: w, h: h), numMines: n)
        updateTimeLabel()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func open(x: Int, y: Int) {
        state.open(x: x, y: y)
        
        switch state.result() {
        case .won:
            message = "YOU WIN"
        case .lost:
            message = "YOU DIED"
        case .playing:
            message = nil
        }
        
        if timer == nil {
            updateTimeLabel()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.updateTimeLabel()
            }
        }
    }
    
    func reset() {
        state.initializeField()
        timer?.invalidate()
        timer = nil
        updateTimeLabel()
        message = nil
    }
    
    func updateSettings(w: Int?, h: Int?, n: Int?) -> Bool {
        guard let w = w, let h = h, let n = n else {
            return false
        }
        if w < 1 || 100 < w || h < 1 || 100 < h || n < 1 || w*h <= n {
            return false
        }
        state = GameState(FieldSize(w: w, h: h), numMines: n)
        reset()
        return true
    }
    
    private func updateTimeLabel() {
        guard let startedAt = self.state.startedAt else {
            self.timeLabel = "time: 00:00"
            return
        }
        let endAt = self.state.finishedAt ?? Date()
        let ti = Int(endAt.timeIntervalSince(startedAt))
        self.timeLabel = String(format: "time: %02d:%02d", ti / 60, ti % 60)
    }
}
