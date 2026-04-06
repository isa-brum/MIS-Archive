//
//  ClickAroundMessage.swift
//  MIS Archive
//
//  Created by Isabella Brum on 25/02/26.
//

import SwiftUI

struct ClickAroundMessageView: View {
    
    var finalizarIntro: () -> Void
    var body: some View {
        
        
        ZStack {
            
            GeometryReader { geo in
                
                Text("click around to explore the room")
                    .frame(width: 280)
                    .feedbackFormat()
                    .position(
                        x: geo.size.width * 0.5,
                        y: geo.size.height * 0.87
                    )
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    finalizarIntro()
                }
            }
        }
    }
}


