//
//  IntroductionView.swift
//  Jogo MIS Archive
//
//  Created by Isabella Brum on 15/02/26.
//
import SwiftUI

struct IntroductionView: View {
    
    var finalizarIntro: () -> Void
    
    //Textos da intro
    let textos = [
        "The **Museum of Image and Sound (MIS)** was created in the late ‘60s to preserve the emerging media of the analog era, which were beyond the technical capacity of traditional museums.", //1
        "With the transition to the digital age, this guardian of audiovisual memory now faces a new challenge:\n\n**Digitizing** these legacy media to ensure the **information remains accessible** while **preserving** their original physical formats.", //2
        "However, **MIS** is currently facing serious difficulties due to a lack of resources, and our collection is at risk.\n\n**We need your help to digitize and preserve it!**" //3
    ]
    
    //O índice que controla qual texto está na tela
    @State private var indiceAtual = 0
    
    var body: some View {
        
        ZStack {
            
            //Escurecimento do fundo
            Color.black
                .opacity(0.4)
                .ignoresSafeArea()
            
            //PEDAÇO DE PAPEL
            //Asset pedaço de papel
            Image("PapelIntroducao")
                .resizable()
                .scaledToFit()
                .scaleEffect(0.86)
            
            //TEXTO 1 (alinhamento diferente do resto e imagem de fita)
            if indiceAtual == 0 {
                Image("DesenhoFita")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.1)
                    .offset(x:-30 ,y: -186)
                
                Text(LocalizedStringKey(textos[0]))
                    .foregroundColor(Color("CinzaTexto"))
                    .font(.custom ("fonteisabrumgibi", size: 58))
                    .rotationEffect(.degrees(-2.4))
                    .multilineTextAlignment(.leading)
                    .frame(width: 710)
                    .offset(x: 0, y: 20)
            }
            //TEXTOS SEGUINTES
            if indiceAtual != 0 {
                Text(LocalizedStringKey(textos[indiceAtual]))
                    .foregroundColor(Color("CinzaTexto"))
                    .font(.custom ("fonteisabrumgibi", size: 58))
                    .rotationEffect(.degrees(-2.4))
                    .multilineTextAlignment(.leading)
                    .frame(width: 710)
                    .offset(x: 0, y: -5)
            }
            
            // BOTÕES
            GeometryReader { geo in
                
                Button {
                    if indiceAtual < textos.count - 1 {
                        indiceAtual += 1
                    } else {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            finalizarIntro()
                        }
                    }
                } label: {
                    Image(indiceAtual < textos.count - 1 ? "BotaoSeta" : "BotaoOk")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: indiceAtual < textos.count - 1
                            ? geo.size.width * 0.065
                            : geo.size.width * 0.055
                        )
                }
                .position(
                    x: geo.size.width * 0.82,
                    y: geo.size.height * 0.69
                )
            }
            .ignoresSafeArea()
        }
    }
}
