//
//  InventaryView.swift
//  MIS Archive
//
//  Created by Isabella Brum on 25/02/26.
//

import SwiftUI

struct InventaryView: View {
    @ObservedObject var animador: StopMotionManager
    
    // Variáveis para rastrear o movimento instantâneo do dedo
    @State private var offsetFita: CGSize = .zero
    @State private var offsetConversor: CGSize = .zero
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                
                // Compartimento inventario
                Image("Inventario")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.8)
                    .frame(width: geo.size.width * 0.23, height: geo.size.height * 0.23)
                    .position(x: geo.size.width * 0.936, y: geo.size.height * 0.18)
                
                // FITA
                if animador.inventario.contains("FitaColetavel") {
                    Image("Fita")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.116, height: geo.size.height * 0.116)
                        .position(x: geo.size.width * 0.936, y: geo.size.height * 0.116)
                        .offset(offsetFita) // O offset é o que move a imagem na tela
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    // Move a imagem junto com o dedo instantaneamente
                                    offsetFita = value.translation
                                }
                                .onEnded { value in
                                    // Pega a posição global exata onde o dedo soltou a tela
                                    let globalDropLocation = value.location
                                    
                                    // Manda pro animador avaliar se caiu no lugar certo
                                    animador.posicaoDrop = globalDropLocation
                                    
                                    // Se a mesa checar que caiu no lugar certo e "consumir" o item,
                                    // a Fita some daqui. Se errou o buraco, ela volta pro inventário.
                                    withAnimation(.spring()) {
                                        offsetFita = .zero
                                    }
                                }
                        )
                        .transition(.scale.combined(with: .opacity))
                }
                
                // CONVERSOR
                if animador.inventario.contains("ConversorColetavel") {
                    Image("Conversor")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.106, height: geo.size.height * 0.106)
                        .rotationEffect(Angle(degrees: 12))
                        .position(x: geo.size.width * 0.936, y: geo.size.height * 0.242)
                        .offset(offsetConversor)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offsetConversor = value.translation
                                }
                                .onEnded { value in
                                    // Pega a posição global de onde soltou o Conversor
                                    animador.posicaoDrop = value.location
                                    // Reseta a posição visual. Se a mesa "aceitou" o item,
                                    withAnimation(.spring()) {
                                        offsetConversor = .zero
                                    }
                                }
                        )
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
}
