//  AirConditionerButton.swift
//  MIS Archive
//
//  Created by Isabella Brum on 23/02/26.
//

import SwiftUI

struct AirConditionerButton: View {
    
    
    @Binding var isOn: Bool
    @Binding var imageName: String
    var action: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            
            Button(action: action) {
                if isOn {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .brilhoExterno()
                } else {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: geo.size.width * 0.232,
                   height:geo.size.height * 0.232)
            .position(
                x: geo.size.width * 0.266,
                y: geo.size.height * 0.185
            )
        }
    }
}


