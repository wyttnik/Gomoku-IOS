//
//  Alerts.swift
//  Gomoku
//
//  Created by Deev Ilyas on 25.10.2023.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title:Text
    var message:Text
    var buttonTitle:Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"), message: Text("Incredible moves"), buttonTitle: Text("Confirm"))
    static let computerWin = AlertItem(title: Text("You Lost!"), message: Text("Better luck next time"), buttonTitle: Text("Try again"))
    static let draw = AlertItem(title: Text("Draw!"), message: Text("Unbeliveable"), buttonTitle: Text("Another one?"))
}
