//
//  Taskboard2View.swift
//  MIS Archive
//
//  Created by Isabella Brum on 24/02/26.
//

import SwiftUI

struct TaskBoard2View: View {
    // variável para permitir que a View aceite o fechamento
    @Binding var fechar: Bool
    
    var body: some View {
        ZStack {
            //Escurecimento do fundo
            Color.black
                .opacity(0.4)
                .ignoresSafeArea()
            
            //Imagem Task Board 1
            Image("TaskBoardIsolado2")
                .resizable()
                .scaledToFit()
                .scaleEffect(0.9)
            
            //CAMADA INVISÍVEL PRA FECHAR TELA AO CLICAR EM QUALQUER CANTO
            Color.white.opacity(0.001)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                        fechar = false
                    }
                }
        }
    }
}

#Preview(traits: .landscapeLeft){
    TaskBoard2View(fechar: .constant(false))
}
