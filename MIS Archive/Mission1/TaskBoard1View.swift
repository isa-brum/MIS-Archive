//
//  4.TaskBoard_1View.swift
//  Jogo MIS Archive
//
//  Created by Isabella Brum on 17/02/26.
//
import SwiftUI

struct TaskBoard_1View: View {

    var onClose: () -> Void
    
    var body: some View {
        ZStack {
            //Escurecimento do fundo
            Color.black
                .opacity(0.4)
                .ignoresSafeArea()
            
            //Imagem Task Board 1
            Image("TaskBoardIsolado1")
                .resizable()
                .scaledToFit()
                .scaleEffect(0.9)
            
            //CAMADA INVISÍVEL PRA FECHAR TELA AO CLICAR EM QUALQUER CANTO
            Color.white.opacity(0.001)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                        onClose()
                    }
                }
        }
    }
}
