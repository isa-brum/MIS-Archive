//
//  TutorialOverlay.swift
//  MIS Archive
//
//  Created by Isabella Brum on 23/02/26.
//

import SwiftUI

struct TutorialOverlay: View {
    
    var onClose: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                Image("Seta")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.05)
                    .rotationEffect(.degrees(25))
                    .position(
                        x: geo.size.width * 0.58,
                        y: geo.size.height * 0.23 )
                
                Text("Check your task board")
                    .frame(width: 200)
                    .position(
                        x: geo.size.width * 0.47,
                        y: geo.size.height * 0.25
                    )
            }.feedbackFormat()
        }
    }
}
