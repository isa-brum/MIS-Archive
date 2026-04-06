//  Cenario2View.swift
//  MIS Archive
//
//  Created by Isabella Brum on 24/02/26.
//

import SwiftUI

struct Cenario2View: View {
    @Binding var iniciarJogo: Bool
    @StateObject private var animador = StopMotionManager()
    @State private var animacaoAtiva = "GavetaAabrindo"
    @State private var estadoMissao: OverlayAtivo = .introPapel
    @State private var taskBoardJaFoiLido = false
    @State private var irParaMissao3 = false
    @State private var mostrarAvisoNewTask = false
    
    var body: some View {
        
        ZStack {
            if irParaMissao3 {
                Cenario3View(iniciarJogo: $iniciarJogo)
                    .transition(.opacity)
            } else {
                let todosItensColetados = animador.inventario.contains("FitaColetavel") && animador.inventario.contains("ConversorColetavel")
                
                ZStack {
                    // Fundo preto para corrigir bordas do blur
                    Color.black.opacity(1)
                        .ignoresSafeArea()
                    
                    Group { // esse group é pra aplicar o blur no fundo ao abrir a view do taskboard
                        Image("CenarioBase")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                        
                        GeometryReader { geo in
                            // CENARIO 2 - ASSETS
                            Image("LixoCheio")
                                .resizable()
                                .scaledToFit()
                                .opacity(animador.isPlaying && animacaoAtiva == "LixoEsvaziando" ? 0 : 1)
                            
                            // Ar consertado cenario
                            Button(action: {
                                Task { await animador.mostrarFeedbackEstatico(nome: "Ar") }
                            }) {
                                Image("ArConsertadoCenario")
                                    .resizable()
                                    .scaledToFit()
                            }
                            .brilhoSeAtivo(!((estadoMissao != .exploracaoLivre && estadoMissao != .avisoExplorar) || animador.isPlaying || todosItensColetados))
                            .frame(width: geo.size.width * 0.232, height: geo.size.height * 0.232)
                            .position(x: geo.size.width * 0.266, y: geo.size.height * 0.185)
                            .disabled((estadoMissao != .exploracaoLivre && estadoMissao != .avisoExplorar) || animador.isPlaying || todosItensColetados)
                            
                            // Taskboard 2 cenário
                            Button(action: {
                                withAnimation {
                                    estadoMissao = .taskBoard2
                                }
                            }) {
                                Image("TaskBoardCenario2")
                                    .resizable()
                                    .scaledToFit()
                            }
                            .frame(width: geo.size.width * 0.244, height: geo.size.height * 0.244)
                            .position(x: geo.size.width * 0.748, y: geo.size.height * 0.24)
                            .disabled(estadoMissao != .esperandoTaskBoard && estadoMissao != .exploracaoLivre && estadoMissao != .avisoExplorar)
                            .brilhoSeAtivo(mostrarAvisoNewTask || estadoMissao == .esperandoTaskBoard)
                            
                            // GAVETAS
                            ZStack {
                                // Gaveta A
                                Button {
                                    animacaoAtiva = "GavetaAabrindo"
                                    Task { await animador.animarGavetaA() }
                                } label: {
                                    Image("GavetaA")
                                        .resizable()
                                        .scaledToFit()
                                }
                                .frame(width: geo.size.width * 0.148, height: geo.size.height * 0.148)
                                .position(x: geo.size.width * 0.193, y: geo.size.height * 0.416)
                                .opacity(animador.isPlaying && animacaoAtiva == "GavetaAabrindo" ? 0 : 1)
                                .disabled((estadoMissao != .exploracaoLivre && estadoMissao != .avisoExplorar) || animador.isPlaying || todosItensColetados)
                                .brilhoSeAtivo(!((estadoMissao != .exploracaoLivre && estadoMissao != .avisoExplorar) || animador.isPlaying || todosItensColetados))
                                
                                // Gaveta B
                                Button {
                                    animacaoAtiva = "GavetaBabrindo"
                                    Task { await animador.abrirGavetaComItem(nomeDaAnimacao: "GavetaBabrindo") }
                                } label: {
                                    Image("GavetaB")
                                        .resizable()
                                        .scaledToFit()
                                }
                                .frame(width: geo.size.width * 0.147, height: geo.size.height * 0.147)
                                .position(x: geo.size.width * 0.191, y: geo.size.height * 0.566)
                                .opacity(animador.isPlaying && (animacaoAtiva == "GavetaBabrindo" || animacaoAtiva == "GavetaBfechando") ? 0 : 1)
                                .disabled((estadoMissao != .exploracaoLivre && estadoMissao != .avisoExplorar) || animador.isPlaying || animador.inventario.contains("FitaColetavel"))
                                .brilhoSeAtivo(!((estadoMissao != .exploracaoLivre && estadoMissao != .avisoExplorar) || animador.isPlaying || animador.inventario.contains("FitaColetavel")))
                                
                                // Gaveta C
                                Button {
                                    animacaoAtiva = "GavetaCabrindo"
                                    Task { await animador.abrirGavetaComItem(nomeDaAnimacao: "GavetaCabrindo") }
                                } label: {
                                    Image("GavetaC")
                                        .resizable()
                                        .scaledToFit()
                                }
                                .frame(width: geo.size.width * 0.159, height: geo.size.height * 0.159)
                                .position(x: geo.size.width * 0.196, y: geo.size.height * 0.712)
                                .opacity(animador.isPlaying && (animacaoAtiva == "GavetaCabrindo" || animacaoAtiva == "GavetaCfechando") ? 0 : 1)
                                .disabled((estadoMissao != .exploracaoLivre && estadoMissao != .avisoExplorar) || animador.isPlaying || animador.inventario.contains("ConversorColetavel"))
                                .brilhoSeAtivo(!((estadoMissao != .exploracaoLivre && estadoMissao != .avisoExplorar) || animador.isPlaying || animador.inventario.contains("ConversorColetavel")))
                            }
                            .shadow(color: Color("SombraGaveta"), radius: 0.5, x: 4, y: 6)
                            
                            // FITA
                            if animador.isItemVisible && animador.currentCollectibleTarget == "GavetaBabrindo" {
                                Button(action: {
                                    animacaoAtiva = "GavetaBfechando"
                                    Task { await animador.coletarItemEFecharGaveta(nomeDoItem: "FitaColetavel") }
                                }) {
                                    Image("FitaColetavel")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geo.size.width * 0.144, height: geo.size.width * 0.144)
                                }
                                .position(x: geo.size.width * 0.244, y: geo.size.height * 0.495)
                            }
                            
                            // CAMADA DA ANIMAÇÃO
                            if animador.isPlaying {
                                Image("\(animacaoAtiva)_\(animador.currentFrame)")
                                    .resizable()
                                    .scaledToFit()
                                    .ignoresSafeArea()
                                    .allowsHitTesting(false)
                            }
                            
                            // Desk (botão invisível)
                            Button(action: { Task { await animador.mostrarFeedbackEstatico(nome: "Desk") }
                            }) {
                                Color.clear
                            }.frame(width: geo.size.width * 0.510, height: geo.size.height * 0.28)
                                .position(x: geo.size.width * 0.71, y: geo.size.height * 0.49)
                                .rotationEffect(Angle(degrees: 10))
                                .disabled((estadoMissao != .exploracaoLivre && estadoMissao != .avisoExplorar) || animador.isPlaying || todosItensColetados)
                            
                            // Lixo Botão
                            Button(action: {
                                animacaoAtiva = "LixoEsvaziando"
                                Task { await animador.animarLixo() }
                            }) {
                                Image("LixoCheioClicavel")
                                    .resizable()
                                    .scaledToFit()
                            }
                            .brilhoSeAtivo(!((estadoMissao != .exploracaoLivre && estadoMissao != .avisoExplorar) || animador.isPlaying || todosItensColetados))
                            .frame(width: geo.size.width * 0.174, height: geo.size.height * 0.174)
                            .position(x: geo.size.width * 0.377, y: geo.size.height * 0.702)
                            .disabled((estadoMissao != .exploracaoLivre && estadoMissao != .avisoExplorar) || animador.isPlaying || todosItensColetados)
                            .opacity(animador.isPlaying && animacaoAtiva == "LixoEsvaziando" ? 0 : 1)
                            
                            // CONVERSOR
                            if animador.isItemVisible && animador.currentCollectibleTarget == "GavetaCabrindo" {
                                Button(action: {
                                    animacaoAtiva = "GavetaCfechando"
                                    Task { await animador.coletarItemEFecharGaveta(nomeDoItem: "ConversorColetavel") }
                                }) {
                                    Image("ConversorColetavel")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geo.size.width * 0.154, height: geo.size.width * 0.154)
                                        .shadow(color: Color("SombraGaveta"), radius: 0.5, x: 4, y: 2)
                                }
                                .position(x: geo.size.width * 0.226, y: geo.size.height * 0.686)
                            }
                            
                            if mostrarAvisoNewTask {
                                Text("new task available")
                                    .frame(width: 200)
                                    .feedbackFormat()
                                    .position(x: geo.size.width * 0.53, y: geo.size.height * 0.24)
                                    .allowsHitTesting(false)
                                    .zIndex(200)
                                    .transition(.opacity)
                            }
                            
                            // CAMADA DOS FEEDBACKS DE TEXTO
                            ZStack {
                                if let feedback = animador.activeFeedback {
                                    FeedbackOverlayView(feedbackTarget: feedback, geo: geo)
                                        .transition(.opacity.animation(.easeInOut(duration: 0.8)))
                                }
                            }
                        }
                    }
                    .blur(radius: estadoMissao.blurRadius)
                    .animation(.easeInOut(duration: 0.3), value: estadoMissao)
                    
                    // INVENTÁRIO
                    if estadoMissao == .exploracaoLivre || estadoMissao == .taskBoard2 || estadoMissao == .avisoExplorar {
                        InventaryView(animador: animador)
                            .zIndex(90)
                    }
                    
                    // SEQUÊNCIA DE TELAS
                    if estadoMissao == .introPapel {
                        IntroMission2View {
                            
                            withAnimation {
                                estadoMissao = .esperandoTaskBoard
                                mostrarAvisoNewTask = true
                            }
                            // O texto some sozinho depois de 2 segundos
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation { mostrarAvisoNewTask = false }
                            }
                        }
                        .zIndex(100)
                        .transition(.opacity)
                    }
                    
                    if estadoMissao == .taskBoard2 {
                        TaskBoard2View(fechar: Binding(
                            get: { estadoMissao != .taskBoard2 },
                            set: { _ in
                                withAnimation {
                                    if !taskBoardJaFoiLido {
                                        taskBoardJaFoiLido = true
                                        estadoMissao = .avisoExplorar
                                    } else {
                                        estadoMissao = .exploracaoLivre
                                    }
                                }
                            }
                        ))
                        .zIndex(100)
                        .transition(.opacity)
                    }
                    
                    if estadoMissao == .avisoExplorar {
                        ClickAroundMessageView {
                            estadoMissao = .exploracaoLivre
                        }
                        .zIndex(100)
                        .allowsHitTesting(false)
                        .transition(.opacity)
                    }
                    
                    if estadoMissao == .tarefaConcluida {
                        CompletedTaskView(onClose: {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                irParaMissao3 = true
                            }
                        })
                        .zIndex(100)
                        .transition(.opacity)
                    }
                    
                }.onChange(of: todosItensColetados) { oldValue, newValue in
                    if newValue {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            withAnimation { estadoMissao = .tarefaConcluida }
                        }
                    }
                }
            }
        }
    }
}
