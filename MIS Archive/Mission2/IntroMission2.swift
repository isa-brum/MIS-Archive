//
//  IntroMission2.swift
//  MIS Archive
//
//  Created by Isabella Brum on 25/02/26.
//
import SwiftUI

struct IntroMission2View: View {
    
    var finalizarIntro: () -> Void
    
    //Textos da intro
    let textos = [
        "A **rare and important VHS tape** containing footage of the **city in the 1950s** became **moldy** while the air conditioner was broken...", //1
        "**VHS tapes** store information in an **analog** format using magnetic tape. This type of storage is **very limited** and can **easily degrade**...", //2
        "For this reason, **you need to digitize** it to **preserve this memory** for future generations!" //3
    ]
    
    //O índice que controla qual texto está na tela
    @State private var indiceAtual = 0
    
    var body: some View {
        
        
        ZStack {
            
            
            
            GeometryReader { geo in
                
                //Escurecimento do fundo
                Color.black
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                //PEDAÇO DE PAPEL
                //Asset pedaço de papel
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
                
                //Passagem dos textos pelo índice
                Text(LocalizedStringKey(textos[indiceAtual]))
                    .comentaryFormat()
                    .position(
                        x: geo.size.width * 0.76,
                        y: geo.size.height * 0.76
                    )
                
                
                // BOTÕES
                Button {
                    if indiceAtual < textos.count - 1 {
                        indiceAtual += 1
                    } else {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            finalizarIntro()
                        }
                    }
                } label: {
                    Image(indiceAtual < textos.count - 1 ? "BotaoSeta" : "BotaoOk")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: indiceAtual < textos.count - 1
                            ? geo.size.width * 0.038
                            : geo.size.width * 0.034
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



