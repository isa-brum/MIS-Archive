//
//  IntroMission3.swift
//  MIS Archive
//
//  Created by Isabella Brum on 25/02/26.
//
import SwiftUI

struct IntroMission3View: View {
    
    var finalizarIntro: () -> Void
    
    var body: some View {
        
        ZStack {
            
            GeometryReader { geo in
                
                // Escurecimento do fundo
                Color.black
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                // PEDAÇO DE PAPEL
                // Asset pedaço de papel
                Image("PapelComentarios")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: geo.size.width * 0.5,
                        height: geo.size.height * 0.5
                    )
                    .position(
                        x: geo.size.width * 0.76,
                        y: geo.size.height * 0.77
                    )
                
                // Passagem dos textos pelo índice
                Text("Now that you've found everything you need, you can finally complete the last task")
                    .comentaryFormat()
                    .position(
                        x: geo.size.width * 0.76,
                        y: geo.size.height * 0.76
                    )
                
                // BOTÕES
                Button {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        finalizarIntro()
                    }
                } label: {
                    Image("BotaoOk")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: geo.size.width * 0.034
                        )
                }
                .position(
                    x: geo.size.width * 0.93,
                    y: geo.size.height * 0.85
                )
            }
            .ignoresSafeArea()
        }
    }
}

#Preview(traits: .landscapeLeft){
    IntroMission3View {
        print("Intro finalizada")
    }
}
