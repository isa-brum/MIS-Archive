//
//  MenuView.swift
//  Jogo MIS Archive
//
//  Created by Isabella Brum on 15/02/26.
//

import SwiftUI

struct MenuView: View {
    
    @State private var iniciarJogo = false
    @State private var mostrarAbout = false
    
    var body: some View {
        
        ZStack {
            
            if iniciarJogo {
                Cenario1View(iniciarJogo: $iniciarJogo)
            }
            
            // Vai pra tela about
            else if mostrarAbout {
                AboutView(mostrarAbout: $mostrarAbout)
            }
            
            else {
                // Fica na tela menu principal
                ZStack {
                    GeometryReader { geo in
                        
                        //Imagem de fundo
                        Image("FundoMenu")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                        
                        //Escurecimento do fundo
                        Color.black
                            .opacity(0.1)
                            .ignoresSafeArea()
                        
                        // Imagem de título
                        Image("TituloMenu")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.9)
                            .position(
                                x: geo.size.width * 0.5,
                                y: geo.size.height * 0.2 )
                        
                        //Botão de play
                        Button {
                            //FadeOut da troca de tela:
                            withAnimation(.easeIn(duration: 0.6)) {
                                iniciarJogo = true
                            } }
                        label: {
                            Image("BotaoPlay")
                                .resizable()
                                .scaledToFit()
                        }.frame(width: geo.size.width * 0.3,
                                height:geo.size.height * 0.3)
                        .position(
                            x: geo.size.width * 0.85,
                            y: geo.size.height * 0.91 )
                        
                        
                        //Botão About
                        Button {
                            //FadeOut da troca de tela:
                            withAnimation(.easeInOut(duration: 0.6)) {
                                mostrarAbout = true
                            } }
                        label: {
                            Text("About")
                                .foregroundColor(Color("BrancoBase"))
                                .underline(true, color: Color("BrancoBase"))
                                .font(.custom("Fonteisabrumgibi-bold", size: 60))
                        }  .position(
                            x: geo.size.width * 0.1,
                            y: geo.size.height * 0.94 )
                        
                    }
                    
                }
            }
        } 
    }
}

#Preview {
    MenuView()
}
