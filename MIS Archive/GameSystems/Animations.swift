//
//  Animations.swift
//  MIS Archive
//
//  Created by Isabella Brum on 24/02/26.
//
import SwiftUI

// GERENCIADOR DO STOP MOTION
@MainActor
class StopMotionManager: ObservableObject {
    @Published var posicaoDrop: CGPoint? = nil
    @Published var currentFrame: Int = 0
    @Published var isItemVisible: Bool = false
    @Published var isPlaying: Bool = false
    @Published var currentCollectibleTarget: String = ""
    @Published var activeFeedback: String? = nil
    @Published var inventario: [String] = []
    
    let frameRate: Double = 0.12
    
    private func playSequence(reverse: Bool = false, totalFrames: Int = 5) async {
        let range = reverse ? Array((0..<totalFrames).reversed()) : Array(0..<totalFrames)
        
        for i in range {
            self.currentFrame = i
            try? await Task.sleep(nanoseconds: UInt64(frameRate * 1_000_000_000))
        }
    }
    
    // LÓGICAS DOS BOTÕES
    func animarGavetaA() async {
        guard !isPlaying else { return }
        isPlaying = true
        
        await playSequence(totalFrames: 5)
        self.activeFeedback = "GavetaA"
        
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        
        self.activeFeedback = nil
        await playSequence(reverse: true, totalFrames: 5)
        
        isPlaying = false
    }
    
    // para o item não "piscar" ao aparecer
    func abrirGavetaComItem(nomeDaAnimacao: String) async {
        guard !isPlaying else { return }
        isPlaying = true
        currentCollectibleTarget = nomeDaAnimacao
        
        // Toca apenas até o penúltimo frame (0, 1, 2, 3)
        await playSequence(totalFrames: 4)
        
        // Renderiza o último frame (4) e mostra o item no mesmo instante
        self.currentFrame = 4
        self.isItemVisible = true
        self.activeFeedback = nomeDaAnimacao
        
        // Aguarda o tempo do frame para manter o ritmo do stop motion
        try? await Task.sleep(nanoseconds: UInt64(frameRate * 1_000_000_000))
    }
    
    func fecharGavetaVazia() async {
        self.activeFeedback = nil
        self.isItemVisible = false
        await playSequence(totalFrames: 4)
        isPlaying = false
    }
    
    func coletarItemEFecharGaveta(nomeDoItem: String) async {
        // Checa se o item já não está lá para não duplicar
        if !inventario.contains(nomeDoItem) {
            inventario.append(nomeDoItem)
        }
        
        // Chama a função que já existe para fechar a gaveta visualmente
        await fecharGavetaVazia()
    }
    
    func animarFita() async {
        guard !isPlaying else { return }
        isPlaying = true
        await playSequence(totalFrames: 6)
        isPlaying = false
    }
    
    func animarLixo() async {
        guard !isPlaying else { return }
        isPlaying = true
        
        self.activeFeedback = "Lixo"
        // 1. Toca a animação de ida (esvazia o lixo)
        await playSequence(totalFrames: 5)
        
        // 2. Congela no último frame por 2 segundos
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        
        self.activeFeedback = nil
        // 3. Toca a animação de volta (lixo enche novamente)
        await playSequence(reverse: true, totalFrames: 5)
        
        isPlaying = false
    }
    
    func mostrarFeedbackEstatico(nome: String) async {
        self.activeFeedback = nome
        try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
        if self.activeFeedback == nome {
            self.activeFeedback = nil
        }
    }
}
