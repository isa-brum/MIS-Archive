//
//  FeedbackTexts.swift
//  MIS Archive
//
//  Created by Isabella Brum on 25/02/26.
//

import SwiftUI

struct FeedbackOverlayView: View {
    let feedbackTarget: String
    let geo: GeometryProxy
    
    var body: some View {
        Group {
            switch feedbackTarget {

            case "GavetaA":
                Text("wow, that's a lot of work...")
                    .frame(width: 280)
                    .feedbackFormat()
                    .position(x: geo.size.width * 0.3, y: geo.size.height * 0.32)
                
            case "GavetaBabrindo":
                Text("great! you found the vhs tape!\nclick to collect")
                    .frame(width: 490)
                    .feedbackFormat()
                    .position(x: geo.size.width * 0.24, y: geo.size.height * 0.85)
                
            case "GavetaCabrindo":
                Text("nice, you found the converter!\nclick to collect")
                    .frame(width: 450)
                    .feedbackFormat()
                    .position(x: geo.size.width * 0.24, y: geo.size.height * 0.88)
                
            case "Desk":
                Text("Before going there, you need to find the items!")
                    .frame(width: 355)
                    .feedbackFormat()
                    .position(x: geo.size.width * 0.7, y: geo.size.height * 0.7)
                
            case "Ar":
                Text("Old, but it works!\nBetter than nothing...")
                    .frame(width: 340)
                    .feedbackFormat()
                    .position(x: geo.size.width * 0.48, y: geo.size.height * 0.21)
                
            case "Lixo":
                Text("Irrecoverable items are discarded to prevent further loss to the collection")
                    .frame(width: 460)
                    .feedbackFormat()
                    .position(x: geo.size.width * 0.38, y: geo.size.height * 0.86)
                
            default:
                EmptyView()
            }
        }
        .allowsHitTesting(false) // Garante que os textos não bloqueiem os cliques
    }
}
