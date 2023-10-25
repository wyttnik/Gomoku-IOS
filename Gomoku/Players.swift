//
//  Players.swift
//  Gomoku
//
//  Created by Deev Ilyas on 25.10.2023.
//

class Person: Player {
    
    var playerStone: Int
    var winStatus: Bool = false
    
    init(playerStone: Int){
        self.playerStone = playerStone
    }
    
    func makeMove(_ board: inout [[Int]], coords: [Int]) {
        board[coords[0]][coords[1]] = playerStone
        if (checkScore(board,row:coords[0], col:coords[1],playerStone) == 6) {
            winStatus = true
        }
    }
}

class Bot: Player {
    
    var playerStone: Int
    var winStatus: Bool = false
    
    init(playerStone: Int){
        self.playerStone = playerStone
    }
    
    func findMove(_ board:[[Int]]) -> [Int] {
        var maxScore = -1
        var botRow = -1
        var botCol = -1
        for i in 0...14 {
            for j in 0...14 {
                if (board[i][j] == 0) {
                    let curScore = checkScore(board, row: i, col: j, playerStone)
                    if (curScore == 6) {
                        winStatus = true
                        return [i,j]
                    }
                    if (curScore > maxScore) {
                        maxScore = curScore
                        botRow = i
                        botCol = j
                    }
                    else if (curScore == maxScore) {
                        let playerScoreMax = checkScore(board, row: botRow, col: botCol, -playerStone)
                        let playerCurScore = checkScore(board, row: i, col: j, -playerStone)
                        if (playerCurScore > playerScoreMax){
                            maxScore = curScore
                            botRow = i
                            botCol = j
                        }
                    }
                }
            }
        }

        for i in 0...14 {
            for j in 0...14 {
                if (board[i][j] == 0){
                    if (checkScore(board, row: i, col: j, -playerStone) >= 4){
                        botRow = i
                        botCol = j
                        break
                    }
                }
            }
        }

        return [botRow,botCol]
    }
    
    func makeMove(_ board: inout [[Int]], coords: [Int]) {
        board[coords[0]][coords[1]] = playerStone
    }
}

protocol Player {
    
    var playerStone: Int {get set}
    var winStatus:Bool {get set}
    
    func makeMove(_ board: inout [[Int]], coords: [Int])
}

extension Player {
    
    func checkScore(_ board:[[Int]], row:Int, col:Int, _ stone:Int) -> Int {
        var score = [0,0,0,0]

        for i in stride(from: col-1, through: 0, by: -1) {
            if(board[row][i] == stone) {
                score[0] += 1
            }
            else {break}
        }
        if (col != 14){
            for i in col+1...14 {
                if(board[row][i] == stone) {score[0] += 1}
                else {break}
            }
        }

        for i in stride(from: row-1, through: 0, by: -1) {
            if(board[i][col] == stone) {score[1] += 1}
            else {break}
        }
        if (row != 14) {
            for i in row+1...14 {
                if(board[i][col] == stone) {score[1] += 1}
                else {break}
            }
        }

        var j = 1
        while(row - j >= 0 && col - j >= 0){
            if(board[row-j][col-j] == stone) {score[2] += 1}
            else {break}
            j += 1
        }
        
        j = 1
        while(row + j < 15 && col + j < 15){
            if(board[row+j][col+j] == stone) {score[2] += 1}
            else {break}
            j += 1
        }

        j = 1
        while(row + j < 15 && col - j >= 0){
            if(board[row+j][col-j] == stone) {score[3] += 1}
            else {break}
            j += 1
        }
        
        j = 1
        while(row - j >= 0 && col + j < 15){
            if(board[row-j][col+j] == stone) {score[3] += 1}
            else {break}
            j += 1
        }

        for i in score{
            if(i == 4) {return 6}
        }
            
        var sumScore = 0
        for i in 0...3 {
            if (i != 3){
                for k in i+1...3 {
                    if(score[i] + score[k] > sumScore) {sumScore = score[i] + score[k]}
                }
            }
        }
        
        if (sumScore >= 4) {return sumScore}
        return max(max(score[0], score[1]), max(score[2], score[3])) + 1
    }

}

