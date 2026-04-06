//
//  Cenario1View.swift
//  MIS Archive
//
//  Created by Isabella Brum on 23/02/26.
//
import SwiftUI
import Combine

class AirConditionerViewModel: ObservableObject {
    @Published var isAirConditionerOn: Bool = false
    @Published var airConditionerImage: String = "ArQuebradoCenario"
}

struct Cenario1View: View {
    @Binding var iniciarJogo: Bool
    @State var overlayAtivo: OverlayAtivo? = .intro
    @State private var isShowingAirConditioner: Bool = false
    @State var airConditioner: String = "ArQuebradoCenario"
    @State var isAirConditionerOn: Bool = false
    
    // Variável que controla a troca de cena
    @State private var irParaMissao2: Bool = false
    
    // Variável para controlar o brilho do Taskboard
    @State private var taskBoardJaFoiLido = false
    
    // ESTADOS DA GAVETA A
    @State private var frameGavetaA = 0
    let framesGavetaA = ["GavetaAabrindociclo2", "GavetaAabrindociclo3", "GavetaAabrindociclo4", "GavetaAabrindociclo5", "GavetaAabrindociclo6"]
    let timerGaveta = Timer.publish(every: 0.12, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
            if irParaMissao2 {
                // Se for true, o jogo carrega a Missão 2 por cima de tudo com fade
                Cenario2View(iniciarJogo: $iniciarJogo)
                    .transition(.opacity)
            } else {
                // Senão, roda a Missão 1 normalmente no NavigationStack dela
                NavigationStack {
                    ZStack {
                        // Fundo preto para corrigir bordas do blur
                        Color.black.opacity(1)
                            .ignoresSafeArea()
                        
                        // --- CAMADA DO CENÁRIO ---
                        ZStack {
                            Image("CenarioBase")
                                .resizable()
                                .scaledToFill()
                                .ignoresSafeArea()
                            
                            GeometryReader { geo in
                                // GAVETA A (Botão que ativa a animação)
                                Button {
                                    overlayAtivo = .animacoes
                                } label: {
                                    Image("GavetaA")
                                        .resizable()
                                        .scaledToFit()
                                }
                                .buttonStyle(PlainButtonStyle())
                                .frame(width: geo.size.width * 0.148, height: geo.size.height * 0.148)
                                .shadow(color: Color("SombraGaveta"), radius: 0.5, x: 4, y: 6)
                                .position(x: geo.size.width * 0.193, y: geo.size.height * 0.42)
                                
                                // GAVETA B
                                Image("GavetaB")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width * 0.147, height: geo.size.height * 0.147)
                                    .shadow(color: Color("SombraGaveta"), radius: 0.5, x: 4, y: 6)
                                    .position(x: geo.size.width * 0.191, y: geo.size.height * 0.57)
                                
                                // GAVETA C
                                Image("GavetaC")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width * 0.159, height: geo.size.height * 0.159)
                                    .shadow(color: Color("SombraGaveta"), radius: 0.5, x: 4, y: 6)
                                    .position(x: geo.size.width * 0.196, y: geo.size.height * 0.718)
                                
                                // lixo
                                Image("LixoCheio")
                                    .resizable()
                                    .scaledToFit()
                                
                                
                                // TASKBOARD
                                Button {
                                    overlayAtivo = .taskBoard1
                                    taskBoardJaFoiLido = true // Marca como lido
                                } label: {
                                    Image("TaskBoardCenario1")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geo.size.width * 0.244, height: geo.size.height * 0.244)
                                    // Usa a extensão para brilhar só se não foi lido
                                        .if(!taskBoardJaFoiLido) { $0.brilhoExterno() }
                                }
                                .position(x: geo.size.width * 0.748, y: geo.size.height * 0.24)
                            }
                            
                            AirConditionerButton(isOn: $isAirConditionerOn, imageName: $airConditioner) {
                                self.isShowingAirConditioner = true
                            }.disabled(overlayAtivo != .mostrarArQuebrado)
                        }
                        .blur(radius: overlayAtivo?.blurRadius ?? 0)
                        
                        // CAMADA DE OVERLAYS (ORDEM DE APARIÇÃO)
                        
                        if overlayAtivo == .animacoes {
                            GavetaAOverlayView(isPresented: $overlayAtivo, frames: framesGavetaA, timer: timerGaveta)
                        }
                        
                        if overlayAtivo == .intro {
                            IntroductionView { overlayAtivo = .staff }
                        }
                        
                        if overlayAtivo == .staff {
                            StaffMemberView { overlayAtivo = .tutorial }
                        }
                        
                        if overlayAtivo == .tutorial {
                            TutorialOverlay { overlayAtivo = .taskBoard1 }
                        }
                        
                        if overlayAtivo == .taskBoard1 {
                            TaskBoard_1View {
                                isAirConditionerOn = true
                                overlayAtivo = .mostrarArQuebrado
                            }
                        }
                    }
                    .navigationDestination(isPresented: $isShowingAirConditioner) {
                        AirConditionerView(onClose: {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                irParaMissao2 = true
                            }
                        })
                        .navigationBarBackButtonHidden(true)
                    }
                }
                .transition(.opacity)
            }
        } 
    }
}

// COMPONENTE AUXILIAR DA GAVETA
struct GavetaAOverlayView: View {
    @Binding var isPresented: OverlayAtivo?
    let frames: [String]
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    @State private var currentFrame = 0
    @State private var isOpening = true
    @State private var isPaused = false
    
    var body: some View {
        GeometryReader { geo in
            Image(frames[min(currentFrame, frames.count - 1)])
                .resizable()
                .scaledToFit()
                .onReceive(timer) { _ in
                    updateAnimation()
                }
        }
    }
    
    func updateAnimation() {
        if isPaused { return }
        
        if isOpening {
            if currentFrame < frames.count - 1 {
                currentFrame += 1
            } else {
                isPaused = true
                isOpening = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.isPaused = false
                }
            }
        } else {
            if currentFrame > 0 {
                currentFrame -= 1
            } else {
                isPresented = nil // Fecha e volta pro cenário base
            }
        }
    }
}

// EXTENSÕES 

private extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}



