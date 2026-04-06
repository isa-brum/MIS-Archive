//
//  InstructionTexts.swift
//  MIS Archive
//
//  Created by Isabella Brum on 25/02/26.
//

import SwiftUI

struct InstructionTextsView: View {
    let instructionTarget: String
    let geo: GeometryProxy
    
    var body: some View {
        Group {
            switch instructionTarget {
                
            case "GoDesk":
                Text("go to the desk")
                    .frame(width: 400)
                    .feedbackFormat()
                    .position(
                        x: geo.size.width * 0.5,
                        y: geo.size.height * 0.86
                    )
                
            case "Insert":
                Text(LocalizedStringKey("**drag** the tape into\nthe VHS player"))
                    .frame(width: 360)
                    .feedbackFormat()
                    .position(x: geo.size.width * 0.5, y: geo.size.height * 0.2)
                
            case "Rewind":
                Text("the tape must be rewinded to the beginning")
                    .frame(width: 390)
                    .feedbackFormat()
                    .position(x: geo.size.width * 0.81, y: geo.size.height * 0.45)
                
            case "Done":
                Text("Done!")
                    .frame(width: 450)
                    .feedbackFormat()
                    .position(x: geo.size.width * 0.85, y: geo.size.height * 0.5)
                
            case "Converter":
                Text("the computer needs the converter to read the tape")
                    .frame(width: 420)
                    .feedbackFormat()
                    .position(x: geo.size.width * 0.34, y: geo.size.height * 0.2)
                
            case "Play":
                Text("Press play")
                    .frame(width: 340)
                    .feedbackFormat()
                    .position(x: geo.size.width * 0.48, y: geo.size.height * 0.21)
                
            case "Digitize":
                Text("Digitization beginning...")
                    .frame(width: 460)
                    .feedbackFormat()
                    .position(x: geo.size.width * 0.47, y: geo.size.height * 0.25)
                
            default:
                EmptyView()
            }
        }
        .allowsHitTesting(false)
    }
}

// PREVIEWS EM LANDSCAPE PARA AJUSTE

#Preview("Ajuste Mesa (Desk)", traits: .landscapeLeft) {
    GeometryReader { geo in
        ZStack {
            // Imagem da Mesa de fundo para referência
            Image("CenárioBaseMesa")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Renderiza os textos da mesa para ajuste de posição
            Group {
                InstructionTextsView(instructionTarget: "Insert", geo: geo)
                InstructionTextsView(instructionTarget: "Rewind", geo: geo)
                InstructionTextsView(instructionTarget: "Done", geo: geo)
                InstructionTextsView(instructionTarget: "Converter", geo: geo)
                InstructionTextsView(instructionTarget: "Play", geo: geo)
                InstructionTextsView(instructionTarget: "Digitize", geo: geo)
            }
        }
    }
}

#Preview("Ajuste Quarto (GoDesk)", traits: .landscapeLeft) {
    GeometryReader { geo in
        ZStack {
            // Imagem do Cenário Base do quarto para referência
            Image("CenarioBase")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Renderiza apenas o GoDesk
            InstructionTextsView(instructionTarget: "GoDesk", geo: geo)
        }
    }
}

