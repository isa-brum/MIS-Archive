//  OverlayList.swift
//  MIS Archive
//
//  Created by Isabella Brum on 18/02/26.
//
import SwiftUI

// Listagem global de OVERLAYS e ESTADOS:
enum OverlayAtivo {
    
    // --- MISSÃO 1 ---
    case intro
    case staff
    case tutorial
    case taskBoard1
    case mostrarArQuebrado
    case arQuebrado
    case animacoes
    
    // --- MISSÃO 2 ---
    case introPapel
    case avisoNovaTarefa
    case esperandoTaskBoard
    case taskBoard2
    case avisoExplorar
    case exploracaoLivre
    case tarefaConcluida
    
    // Blur da imagem do fundo nos diferentes overlays:
    var blurRadius: CGFloat {
        switch self {
        case .intro, .taskBoard1, .taskBoard2, .tarefaConcluida:
            return 8
        case .staff:
            return 5
        default:
            return 0
        }
    }
}
