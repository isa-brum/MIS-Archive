//
//  FeedbackTexts.swift
//  MIS Archive
//
//  Created by Isabella Brum on 22/02/26.
//
import SwiftUI
extension View {
    
    // formatacao dos feedbacks do jogo
    func feedbackFormat() -> some View {
        self
            .foregroundColor(Color("TextoFeedback"))
            .font(.custom("fonteisabrumgibi", size: 45))
            .multilineTextAlignment(.center)
            .shadow(color: Color("BrilhoExterno").opacity(0.7), radius: 10)
            .shadow(color: Color("BrilhoExterno").opacity(0.2), radius: 1)
    }
    
    
    
    // Brilho ao redor de objetos clicáveis
    func brilhoExterno() -> some View {
        self
            .shadow(color: Color("BrilhoExterno").opacity(0.8), radius: 6)
    }
    
    // Aplica a sua função de brilho apenas se o botão estiver ativado para clique
    @ViewBuilder
    func brilhoSeAtivo(_ isAtivo: Bool) -> some View {
        if isAtivo {
            self.brilhoExterno()
        } else {
            self 
        }
    }
    
    
    // Formatacao do texto p/ comentarios
    func comentaryFormat() -> some View {
        self
            .foregroundColor(Color("CinzaTexto"))
            .font(.custom("fonteisabrumgibi", size: 42))
            .rotationEffect(.degrees(-2.4))
            .multilineTextAlignment(.leading)
            .frame(width: 400, height: 200)
    }
    
    func feedbackMissao(titulo: String = "Mission accomplished", frase: String, geo: GeometryProxy) -> some View {
        VStack(spacing: 10) {
            Text(titulo)
                .foregroundColor(Color("BrancoBase"))
                .font(.custom("fonteisabrumgibi-bold", size: 68))
                .opacity(0.8)
                .multilineTextAlignment(.center)
                .frame(maxWidth: geo.size.width * 0.86)
            
            Text(LocalizedStringKey(frase))
                .foregroundColor(Color("BrancoBase"))
                .font(.custom("fonteisabrumgibi", size: 50))
                .opacity(0.8)
                .multilineTextAlignment(.center)
                .frame(maxWidth: geo.size.width * 0.8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, geo.size.height * 0.08)
    }
}

