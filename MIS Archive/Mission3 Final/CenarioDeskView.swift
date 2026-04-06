//
//  CenarioDeskView.swift
//  MIS Archive
//
//  Created by Isabella Brum on 26/02/26.
//

import SwiftUI
import AVKit

struct VideoPlayerLayer: UIViewRepresentable {
    let videoName: String
    
    func makeUIView(context: Context) -> VideoUIView {
        let view = VideoUIView()
        if let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
            let player = AVPlayer(url: url)
            view.playerLayer.player = player
            view.playerLayer.videoGravity = .resizeAspectFill
            player.play()
        }
        return view
    }
    
    func updateUIView(_ uiView: VideoUIView, context: Context) {}
    
    static func dismantleUIView(_ uiView: VideoUIView, coordinator: ()) {
        uiView.playerLayer.player?.pause()
    }
}

class VideoUIView: UIView {
    override class var layerClass: AnyClass { return AVPlayerLayer.self }
    var playerLayer: AVPlayerLayer { return layer as! AVPlayerLayer }
}

enum FaseMesa {
    case pedeFita, animandoFita, pedeRewind, rebobinando, pedeConversor, animandoConversor, pedePlay, digitizando, finalizado
}

// VIEW PRINCIPAL
struct CenarioDeskView: View {
    @Binding var iniciarJogo: Bool
    @ObservedObject var animador: StopMotionManager
    @State private var faseAtual: FaseMesa = .pedeFita
    @State private var instructionTarget: String = "Insert"
    @State private var frameFita = 0
    let totalFramesFita = 6
    @State private var frameConversor = 0
    @State private var mostrarRewind = false
    @State private var mostrarTaskboardFinal = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // CAMADA 1: FUNDO
            Image("CenárioBaseMesa")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: faseAtual == .finalizado ? 8 : 0)
                .animation(.easeInOut(duration: 0.5), value: faseAtual == .finalizado)
            
            GeometryReader { geo in
                
                // CAMADA 2: ASSETS VISUAIS
                Group {
                    if faseAtual == .animandoFita {
                        Image("FitaInserida_\(frameFita)").resizable().scaledToFill().ignoresSafeArea()
                    }
                    
                    if faseAtual == .animandoConversor || faseAtual == .pedePlay || faseAtual == .digitizando || faseAtual == .finalizado {
                        Image(frameConversor == 0 ? "ConversorInserido_0" : "ConversorInserido_1")
                            .resizable()
                            .scaledToFit()
                            .ignoresSafeArea()
                            .frame(width: geo.size.width * 1.18, height: geo.size.height * 1.18)
                            .position(x: geo.size.width * 0.518, y: geo.size.height * 0.52)
                    }
                    
                    if mostrarRewind {
                        Image("Rewinding").resizable().scaledToFit().ignoresSafeArea()
                            .frame(width: geo.size.width * 0.12, height: geo.size.height * 0.12)
                            .position(x: geo.size.width * 0.836, y: geo.size.height * 0.604)
                    }
                    
                    // VÍDEO NO MONITOR
                    if faseAtual == .digitizando {
                        VideoPlayerLayer(videoName: "VideoDigitalizacao")
                            .opacity(0.9)
                            .frame(width: geo.size.width * 0.245, height: geo.size.height * 0.185)
                            .offset(x: 10, y: 24)
                            .clipped()
                            .cornerRadius(5)
                            .position(x: geo.size.width * 0.445, y: geo.size.height * 0.414)
                            .transition(.opacity)
                    }
                }
                .blur(radius: faseAtual == .finalizado ? 8 : 0)
                
                // CAMADA 3: INTERAÇÃO DE ARRASTO INSTANTÂNEO
                if faseAtual != .finalizado {
                    
                    // ÁREA DE DROP DA FITA
                    GeometryReader { areaFita in
                        Color.clear
                            .onChange(of: animador.posicaoDrop) { _, novaPosicao in
                                // Verifica se tem uma nova posição de soltura E se estamos na fase da fita
                                if let posicao = novaPosicao, faseAtual == .pedeFita {
                                    // Pega o retângulo dessa área na tela toda (global)
                                    let retanguloAlvo = areaFita.frame(in: .global)
                                    // Se a posição do dedo caiu dentro do retângulo...
                                    if retanguloAlvo.contains(posicao) {
                                        iniciarAnimacaoFita()
                                        animador.posicaoDrop = nil // Reseta para o próximo arraste
                                    }
                                }
                            }
                    }
                    .frame(width: geo.size.width * 0.35, height: geo.size.height * 0.25)
                    .position(x: geo.size.width * 0.81, y: geo.size.height * 0.65)
                    
                    
                    // ÁREA DE DROP DO CONVERSOR
                    GeometryReader { areaConversor in
                        Color.clear
                            .onChange(of: animador.posicaoDrop) { _, novaPosicao in
                                if let posicao = novaPosicao, faseAtual == .pedeConversor {
                                    let retanguloAlvo = areaConversor.frame(in: .global)
                                    if retanguloAlvo.contains(posicao) {
                                        iniciarAnimacaoConversor()
                                        animador.posicaoDrop = nil
                                    }
                                }
                            }
                    }
                    .frame(width: geo.size.width * 0.6, height: geo.size.height * 0.5)
                    .position(x: geo.size.width * 0.3, y: geo.size.height * 0.55)
                    
                    
                    // BOTÕES
                    ZStack {
                        Button(action: { if faseAtual == .pedePlay { iniciarPlay() } }) {
                            Image("Start").resizable().scaledToFit()
                                .frame(width: geo.size.width * 0.02, height: geo.size.height * 0.02)
                                .padding(15).contentShape(Rectangle())
                        }
                        .position(x: geo.size.width * 0.718, y: geo.size.height * 0.61)
                        .brilhoSeAtivo(faseAtual == .pedePlay)
                        
                        Button(action: { if faseAtual == .pedeRewind { iniciarRewind() } }) {
                            Image("ReButton").resizable().scaledToFit()
                                .frame(width: geo.size.width * 0.02, height: geo.size.height * 0.02)
                                .padding(15).contentShape(Rectangle())
                        }
                        .position(x: geo.size.width * 0.675, y: geo.size.height * 0.607)
                        .brilhoSeAtivo(faseAtual == .pedeRewind)
                    }
                }
                
                // CAMADA 4: FEEDBACKS
                if !instructionTarget.isEmpty {
                    InstructionTextsView(instructionTarget: instructionTarget, geo: geo)
                }
                
                // CAMADA 5: TELA FINAL
                if faseAtual == .finalizado {
                    Color.black.opacity(mostrarTaskboardFinal ? 0.6 : 0.3)
                        .ignoresSafeArea()
                        .transition(.opacity)
                    
                    ZStack {
                        if !mostrarTaskboardFinal {
                            ZStack {
                                Image("Postit3incompleto").resizable().scaledToFit()
                                Image("Check").resizable().scaledToFit()
                                    .frame(width: geo.size.width * 0.05)
                                    .offset(x: -geo.size.width * 0.11, y: -geo.size.height * 0.14)
                            }
                            .frame(width: geo.size.width * 0.42)
                            .position(x: geo.size.width * 0.49, y: geo.size.height * 0.42)
                            
                            feedbackMissao(titulo: "Mission accomplished", frase: "You've completed all the three tasks", geo: geo)
                        } else {
                            // Imagem do Quadro (Fundo)
                            Image("TaskBoardIsolado4")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.8)
                                .position(x: geo.size.width * 0.5, y: geo.size.height * 0.42)
                            
                            // Texto de feedback
                            feedbackMissao(titulo: "Well done!", frase: "You pushed through every difficulty and helped preserve an important piece of the city’s memory", geo: geo)
                            
                            // Botão de Menu
                            Button {
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    iniciarJogo = false
                                }
                            } label: {
                                Text("Menu")
                                    .foregroundColor(Color("BrancoBase"))
                                    .underline(true, color: Color("BrancoBase"))
                                    .font(.custom("Fonteisabrumgibi-bold", size: 60))
                            }
                            .position(x: geo.size.width * 0.08, y: geo.size.height * 0.1)
                            .zIndex(100)
                        }
                    }
                }
            }
            .ignoresSafeArea()
            
            // INVENTÁRIO
            if faseAtual != .finalizado {
                InventaryView(animador: animador).zIndex(90)
            }
        }
    }
    
    // FUNÇÕES
    func iniciarPlay() {
        faseAtual = .digitizando
        instructionTarget = "Digitize"
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            withAnimation(.easeInOut(duration: 0.6)) {
                faseAtual = .finalizado
                instructionTarget = ""
            }
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            withAnimation(.easeInOut(duration: 0.6)) {
                mostrarTaskboardFinal = true
            }
        }
    }
    
    func iniciarAnimacaoFita() {
        faseAtual = .animandoFita
        instructionTarget = ""
        Task { @MainActor in
            for _ in 0..<(totalFramesFita - 1) {
                try? await Task.sleep(nanoseconds: 120_000_000); frameFita += 1
            }
            faseAtual = .pedeRewind; instructionTarget = "Rewind"
            animador.inventario.removeAll(where: { $0 == "FitaColetavel" || $0 == "Fita" })
        }
    }
    
    func iniciarRewind() {
        faseAtual = .rebobinando; instructionTarget = ""
        Task { @MainActor in
            for _ in 0..<6 { try? await Task.sleep(nanoseconds: 400_000_000); mostrarRewind.toggle() }
            mostrarRewind = false; instructionTarget = "Done"
            try? await Task.sleep(nanoseconds: 1_500_000_000); faseAtual = .pedeConversor; instructionTarget = "Converter"
        }
    }
    
    func iniciarAnimacaoConversor() {
        faseAtual = .animandoConversor
        instructionTarget = ""
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 200_000_000)
            frameConversor = 1
            withAnimation(.easeInOut) {
                faseAtual = .pedePlay
                instructionTarget = "Play"
            }
            animador.inventario.removeAll(where: { $0 == "ConversorColetavel" || $0 == "Conversor" })
        }
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


