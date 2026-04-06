//
//  Cenario3View.swift
//  MIS Archive
//
//  Created by Isabella Brum on 26/02/26.
//

import SwiftUI

enum EstadoMissao3 {
    case introMissao3
    case esperandoTaskBoard
    case taskBoard3
    case avisoDesk
    case exploracaoLivre
}

struct Cenario3View: View {
    @Binding var iniciarJogo: Bool
    @StateObject private var animador = StopMotionManager()
    @State private var estadoMissao: EstadoMissao3 = .introMissao3
    @State private var taskBoardJaFoiLido = false
    
    // Variável que controla a ida para a mesa ampliada
    @State private var irParaMesaAmpliada = false
    
    // Controle do fade específico do texto de instrução
    @State private var mostrarTextoGoDesk = false
    
    var body: some View {
        ZStack {
            if irParaMesaAmpliada {
                
                if irParaMesaAmpliada {
                    CenarioDeskView(iniciarJogo: $iniciarJogo, animador: animador)
                    }
                
            } else {
                // CENÁRIO 3 NORMAL
                ZStack {
                    Color.black.opacity(1).ignoresSafeArea()
                    
                    Group {
                        Image("CenarioBase")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                        
                        GeometryReader { geo in
                            
                            // ASSETS ESTÁTICOS
                            
                            // Lixo
                            Image("LixoCheio")
                                .resizable()
                                .scaledToFit()
                            
                            // Ar Condicionado
                            Image("ArConsertadoCenario")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.232, height: geo.size.height * 0.232)
                                .position(x: geo.size.width * 0.266, y: geo.size.height * 0.185)
                            
                            // Gavetas
                            ZStack {
                                Image("GavetaA")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width * 0.148, height: geo.size.height * 0.148)
                                    .position(x: geo.size.width * 0.193, y: geo.size.height * 0.416)
                                
                                Image("GavetaB")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width * 0.147, height: geo.size.height * 0.147)
                                    .position(x: geo.size.width * 0.191, y: geo.size.height * 0.566)
                                
                                Image("GavetaC")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width * 0.159, height: geo.size.height * 0.159)
                                    .position(x: geo.size.width * 0.196, y: geo.size.height * 0.712)
                            }
                            .shadow(color: Color("SombraGaveta"), radius: 0.5, x: 4, y: 6)
                            
                            // TASKBOARD 3
                            Button(action: {
                                withAnimation { estadoMissao = .taskBoard3 }
                            }) {
                                Image("TaskBoardCenario3")
                                    .resizable()
                                    .scaledToFit()
                            }
                            .frame(width: geo.size.width * 0.244, height: geo.size.height * 0.244)
                            .position(x: geo.size.width * 0.748, y: geo.size.height * 0.24)
                            .disabled(estadoMissao != .esperandoTaskBoard && estadoMissao != .exploracaoLivre)
                            .brilhoSeAtivo(estadoMissao == .esperandoTaskBoard && !taskBoardJaFoiLido)
                            
                            // BOTÃO DA MESA (DESK)
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    irParaMesaAmpliada = true
                                }
                            }) {
                                Color.clear
                            }
                            .frame(width: geo.size.width * 0.510, height: geo.size.height * 0.28)
                            .position(x: geo.size.width * 0.71, y: geo.size.height * 0.49)
                            .rotationEffect(Angle(degrees: 10))
                            .disabled(estadoMissao != .avisoDesk && estadoMissao != .exploracaoLivre)
                            .brilhoSeAtivo(estadoMissao == .avisoDesk || estadoMissao == .exploracaoLivre)
                            
                            // INSTRUÇÃO COM FADE CONTROLADO
                            if mostrarTextoGoDesk {
                                InstructionTextsView(instructionTarget: "GoDesk", geo: geo)
                                    .transition(.opacity)
                            }
                        }
                    }
                    // O blur só acontece para o TaskBoard
                    .blur(radius: (estadoMissao == .taskBoard3) ? 5 : 0)
                    .animation(.easeInOut(duration: 0.3), value: estadoMissao)
                    
                    // OVERLAYS DA MISSÃO 3
                    
                    if estadoMissao == .introMissao3 {
                        IntroMission3View {
                            withAnimation { estadoMissao = .esperandoTaskBoard }
                        }
                        .zIndex(100)
                        .transition(.opacity)
                    }
                    
                    if estadoMissao == .taskBoard3 {
                        TaskBoard3View(fechar: Binding(
                            get: { estadoMissao != .taskBoard3 },
                            set: { _ in
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    taskBoardJaFoiLido = true
                                    estadoMissao = .avisoDesk
                                }
                            }
                        ))
                        .zIndex(100)
                        .transition(.opacity)
                    }
                    
                    // INVENTÁRIO
                    InventaryView(animador: animador)
                        .zIndex(90)
                }
                .transition(.opacity)
                // Gerenciador do Fade In / Out do texto "Go to the desk"
                .onChange(of: estadoMissao) { oldState, newState in
                    if newState == .avisoDesk {
                        // Delay de 0.3s para o TaskBoard sumir antes do texto aparecer
                        withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                            mostrarTextoGoDesk = true
                        }
                        
                        // Agenda o sumiço do texto e libera a exploração
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                            withAnimation {
                                mostrarTextoGoDesk = false
                                estadoMissao = .exploracaoLivre
                            }
                        }
                    }
                }
                .onAppear {
                    animador.inventario = ["FitaColetavel", "ConversorColetavel"]
                }
            }
        }
    }
}

