//
//  GameViewModel.swift
//  Gomoku
//
//  Created by Deev Ilyas on 25.10.2023.
//
import SwiftUI

class GomokuViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem](repeating: GridItem(.flexible()), count:15)
    let person: Person
    let bot: Bot
    var places: Int = 225
    
    @Published var playZone: [[Int]] = Array(repeating: Array(repeating: 0, count: 15), count: 15 )
    @Published var alertItem: AlertItem?
    @Published var roundNumber: Int
    
    init(_ choice: Int) {
        
        person = Person(playerStone: choice == 1 ? 1: -1)
        bot = Bot(playerStone: choice == 1 ? -1: 1)
        roundNumber = 1
        
        if (choice == 0) {
            playZone[7][7] = 1
            places -= 1
        }
    }
    
    func makeMove(row: Int, col: Int) {
        
        if (playZone[row][col] != 0){
            return
        }
        
        person.makeMove(&playZone, coords: [row,col])
        if (gameEnded()) {
            return
        }
        bot.makeMove(&playZone, coords: bot.findMove(playZone))
        roundNumber += 1
        places -= 2
        if (gameEnded()) {
            return
        }
    }
    
    func gameEnded() -> Bool {
        
        if (person.winStatus) {
            alertItem = AlertContext.humanWin
            return true
        }
        else if (bot.winStatus) {
            alertItem = AlertContext.computerWin
            return true
        }
        else if (places == 0) {
            alertItem = AlertContext.draw
            return true
        }
        return false
    }
    
    func resetGame(_ choice: Int) {
        
        person.playerStone = choice == 1 ? 1: -1
        bot.playerStone = choice == 1 ? -1: 1
        person.winStatus = false
        bot.winStatus = false
        playZone = Array(repeating: Array(repeating: 0, count: 15), count: 15 )
        roundNumber = 1
        places = 225
        
        if (choice == 0) {
            playZone[7][7] = 1
            places -= 1
        }
    }
}
