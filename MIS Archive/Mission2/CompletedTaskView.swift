//
//  MissaoCumpridaPostit.swift
//  MIS Archive
//
//  Created by Isabella Brum on 25/02/26.
//

import SwiftUI

struct CompletedTaskView: View {
    
    var onClose: () -> Void
    
    @State private var animarCheck = false
    
    var body: some View {
        GeometryReader { geo in
            
            ZStack {
                
                // Fundo escurecido
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                
                ZStack {
                    
                    // Post-it
                    Image("Postit2incompleto")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.42)
                        .shadow(color: .black.opacity(0.8), radius: 0.7, x: 12, y: 16)
                        .position(x: geo.size.width * 0.5, y: geo.size.height * 0.42)
                    
                    // Imagem do Check
                    Image("Check")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.05)
                        .scaleEffect(animarCheck ? 1 : 0.2)
                        .position(x: geo.size.width * 0.41, y: geo.size.height * 0.268)
                        .opacity(animarCheck ? 1 : 0)
                }
                // Camada invisível para detectar o toque na tela toda
                Color.white.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        onClose()
                    }
                feedbackMissao(
                    frase: "Now comes the biggest challenge: trusting this century-old computer not to crash on us...",
                    geo: geo
                )
                
            }
            .onAppear {
                // Faz o Check aparecer com animação assim que a tela abrir
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    animarCheck = true
                }
            }
        }
    }
}

#Preview(traits: .landscapeLeft) {
    CompletedTaskView(onClose: {
        print("Botão de fechar clicado na Preview!")
    })
}
