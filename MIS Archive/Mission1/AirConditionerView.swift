//
//  AirConditionerView.swift
//  MIS Archive
//
//  Created by Isabella Brum on 24/02/26.
//

import SwiftUI

enum EstadoAr {
    case quebradoTotal
    case parcial1
    case parcial2
    case consertado
}

enum FaseAr {
    case consertando
    case ajustandoTemperatura
    case concluido
}

struct AirConditionerView: View {
    
    private let tempoFade: Double = 0.8
    
    struct BrilhoCondicional: ViewModifier {
        var ativo: Bool
        
        func body(content: Content) -> some View {
            if ativo {
                content.brilhoExterno()
            } else {
                content
            }
        }
    }
    
    @State private var estado: EstadoAr = .quebradoTotal
    @State private var fase: FaseAr = .consertando
    @State private var nivelTemperatura: Int = 0
    @State private var mostrarOverlay = false
    @State private var animarCheck = false
    
    var onClose: () -> Void
    
    var faseAtiva: Bool {
        fase == .ajustandoTemperatura
    }
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                
                // Pra evitar bordas deixadas pelo blur
                Color.black.opacity(0.9)
                    .ignoresSafeArea()
                
                // blur cenario final
                ZStack {
                    conteudoPrincipal(geo: geo)
                }
                .blur(radius: mostrarOverlay ? 10 : 0)
                .animation(.easeInOut(duration: 0.4), value: mostrarOverlay)
                
                // overlay do final sem blur
                if mostrarOverlay {
                    overlayFinal(geo: geo)
                }
            }
            .ignoresSafeArea()
            
        }
    }
}

// conteudo principal
extension AirConditionerView {
    
    func conteudoPrincipal(geo: GeometryProxy) -> some View {
        ZStack {
            
            // Imagem base
            if estado == .consertado {
                Image("ArConsertado")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1.201)
                    .shadow(color: .black, radius: 0.7, x: 10, y: 12)
                
                
            } else {
                Image(nomeImagem)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1.2)
                    .shadow(color: .black, radius: 0.5, x: 10, y: 12)
            }
            
            // Ajustar temperatura
            if estado == .consertado {
                
                // fundo escurecido da fase 2
                Color.black
                    .opacity(faseAtiva ? 0.2 : 0)
                    .animation(.easeInOut(duration: tempoFade), value: faseAtiva)
                
                // Papel e texto de comentário
                if !mostrarOverlay {
                    ZStack {
                        Image("PapelComentarios")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.5)
                        
                        Text(LocalizedStringKey("The collection **must** be kept at a temperature **between 18°C and 22°C** to prevent the proliferation of fungi and insects that can cause deterioration!"))
                            .comentaryFormat()
                        
                    }
                    .position(x: geo.size.width * 0.28, y: geo.size.height * 0.26)
                    .opacity(faseAtiva ? 1 : 0)
                    .animation(.easeInOut(duration: tempoFade), value: faseAtiva)
                }
                // Sombra do botão: sempre aparece
                Image("BotaoAr")
                    .resizable()
                    .scaledToFit()
                    .colorMultiply(.black)
                    .offset(x: 14, y: -2)
                    .opacity(0.85)
                    .allowsHitTesting(false)
                    .frame(width: geo.size.width * 0.24, height: geo.size.height * 0.16)
                    .position(x: geo.size.width * 0.762, y: geo.size.height * 0.805)
                
                // Display digital na frente da sombra, atrás do botão
                if !mostrarOverlay {
                    Image("DisplayAr")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.2)
                        .shadow(color: Color.black, radius: 0.1, x: 1, y: 1)
                        .opacity(0.8)
                        .position(x: geo.size.width * 0.765, y: geo.size.height * 0.735)
                        .opacity(faseAtiva ? 1 : 0)
                        .animation(.easeInOut(duration: tempoFade), value: faseAtiva)
                }
                
                // Botão giratório
                Button {
                    if fase == .ajustandoTemperatura {
                        girarBotao()
                    }
                } label: {
                    Image("BotaoAr")
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(.degrees(anguloSeletor))
                        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: nivelTemperatura)
                }
                .disabled(fase == .concluido)
                .frame(width: geo.size.width * 0.156, height: geo.size.height * 0.156)
                .position(x: geo.size.width * 0.762, y: geo.size.height * 0.807)
                
            }
            
            // Fase 1 - conserto
            if estado == .quebradoTotal {
                botaoAleta(geo: geo, x: 0.696, y: 0.4) { estado = .parcial2 }
                botaoAleta(geo: geo, x: 0.696, y: 0.6) { estado = .parcial1 }
            }
            
            if estado == .parcial1 {
                botaoAleta(geo: geo, x: 0.696, y: 0.4) { finalizarConserto() }
            }
            
            if estado == .parcial2 {
                botaoAleta(geo: geo, x: 0.696, y: 0.6) { finalizarConserto() }
            }
        }
    }
}

// OVERLAY FINAL
extension AirConditionerView {
    
    func overlayFinal(geo: GeometryProxy) -> some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            ZStack {
                Image("Postit1incompleto")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width * 0.42)
                    .shadow(color: .black.opacity(0.8), radius: 0.7, x: 12, y: 16)
                    .position(x: geo.size.width * 0.5, y: geo.size.height * 0.42)
                
                Image("Check")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width * 0.05)
                    .scaleEffect(animarCheck ? 1 : 0.2)
                    .position(x: geo.size.width * 0.404, y: geo.size.height * 0.256)
                    .opacity(animarCheck ? 1 : 0)
                    .animation(.easeInOut(duration: 0.35), value: animarCheck)
                
                Color.white.opacity(0.0001)
                    .ignoresSafeArea()
            }
            .onTapGesture {
                onClose()
            }
            feedbackMissao(
                frase: "Fixing the air conditioner wasn’t exactly part of your job but someone had to do it...",
                geo: geo)
        }
    }
}


//FUNCOES AUXILIARES
extension AirConditionerView {
    
    var nomeImagem: String {
        switch estado {
        case .quebradoTotal: return "ArTodoQuebrado"
        case .parcial1: return "ArQuebrado1"
        case .parcial2: return "ArQuebrado2"
        case .consertado: return "ArConsertado"
        }
    }
    
    var anguloSeletor: Double {
        switch nivelTemperatura {
        case 0: return 0
        case 1: return -70
        case 2: return -140
        default: return 0
        }
    }
    
    func finalizarConserto() {
        estado = .consertado
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            fase = .ajustandoTemperatura
        }
    }
    
    func girarBotao() {
        if nivelTemperatura < 2 {
            nivelTemperatura += 1
        }
        
        if nivelTemperatura == 2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                fase = .concluido
                withAnimation(.easeInOut(duration: 0.4)) {
                    mostrarOverlay = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    animarCheck = true
                }
            }
        }
    }
    
    func botaoAleta(geo: GeometryProxy, x: CGFloat, y: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Color.clear
        }
        .frame(width: geo.size.width * 0.24, height: geo.size.height * 0.16)
        .position(x: geo.size.width * x, y: geo.size.height * y)
    }
}

