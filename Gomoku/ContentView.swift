//
//  ContentView.swift
//  Gomoku
//
//  Created by Deev Ilyas on 25.10.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var gameViewModel = GomokuViewModel(Int.random(in: 0..<2))
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    @State private var offset = CGSize.zero
    @State private var prevGestOffset = CGSize.zero

    var body: some View {
        GeometryReader{ geometry in
            VStack{
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .background(.white)
                        .frame(width: geometry.size.width,
                               height: (geometry.size.height - geometry.size.width) / 2)
                        .shadow(color: .black, radius: 1, x: 0, y: 2)
                    Text("Turn \(gameViewModel.roundNumber)")
                                    .font(.title)
                }
                    
                LazyVGrid(columns: gameViewModel.columns, spacing: 0){
                    ForEach(0..<225, id: \.self){i in
                        ZStack{
                            GameCircleView(proxy: geometry)
                            PlayerMakerView(playerMarker: gameViewModel.playZone[(i - i % 15)/15][i % 15], proxy: geometry)
                        }
                        .onTapGesture {
                            gameViewModel.makeMove(row: (i - i % 15)/15, col: i % 15)
                        }
                    }
                }
                .scaleEffect(currentZoom + totalZoom)
                .offset(x: offset.width, y: offset.height)
                .gesture(
                    MagnificationGesture()
                        .onChanged{value in
                            currentZoom = value - 1
                        }
                        .onEnded { value in
                            totalZoom += currentZoom
                            if (totalZoom < 1.0){
                                totalZoom = 1.0
                            }
                            currentZoom = 0
                        }
                )
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { gesture in
                            var translation = prevGestOffset
                            translation.width += gesture.translation.width
                            translation.height += gesture.translation.height
                            offset = translation
                        }
                        .onEnded { gesture in
                            prevGestOffset = offset
                        }
                )
                .padding(.horizontal)
                .zIndex(-1)
                    
                ZStack(alignment: .center) {
                    Rectangle()
                        .foregroundColor(.white)
                        .background(.white)
                        .frame(width: geometry.size.width,
                               height: (geometry.size.height - geometry.size.width) / 2)
                        .shadow(color: .black, radius: 1, x: 0, y: -2)
                        
                    Button {
                        gameViewModel.resetGame(Int.random(in: 0..<2))
                    } label: {
                        Text("Reset")
                            .padding()
                            .foregroundStyle(.white)
                            .background(.gray)
                    }
                }
            }
            .alert(item: $gameViewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action:{gameViewModel.resetGame(Int.random(in: 0..<2))}))
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct GameCircleView: View {
    
    var proxy: GeometryProxy
    
    var body: some View {
        Rectangle()
            .foregroundColor(.brown)
            .frame(width: proxy.size.width/15,
                   height: proxy.size.width/15)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}

func getMarker(_ val: Int) -> String {
    
    switch val {
    case 1:
        return "circle"
    case -1:
        return "xmark"
    default:
        return ""
    }
}

struct PlayerMakerView: View {
    
    var playerMarker: Int
    
    var proxy: GeometryProxy
    
    var body: some View {
        if(playerMarker != 0){
            Image(systemName: getMarker(playerMarker))
                .resizable()
                .scaledToFit()
                .frame(width: proxy.size.width/19,
                       height: proxy.size.width/19)
                .foregroundColor(.white)
        }
    }
}
