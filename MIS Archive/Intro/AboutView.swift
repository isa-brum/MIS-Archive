//
//  AboutView.swift
//  Jogo MIS Archive
//
//  Created by Isabella Brum on 16/02/26.
//

import SwiftUI

// Estrutura dos slides
struct AboutSlide {
    var texto: LocalizedStringKey?
    var nomeImagem: String?
    var legenda: String
}

struct AboutView: View {
    
    // Conexão com a MenuView para permitir o retorno
    @Binding var mostrarAbout: Bool
    
    @State private var slideAtual = 0
    @State private var piscarTela = false
    
    let slides: [AboutSlide] = [
        AboutSlide(
            texto: "**Hi, I’m Isa brum!** A Visual Arts student from Brazil. Inspired by the time I volunteered at the **Museu da Imagem e do Som de Campinas**, this educational stop-motion game explores the preservation of audiovisual memory and the real challenges of underfunded cultural institutions. Every environment was physically built using **cardboard and 3D-printed materials** to emphasize human presence and materiality in an age of automation. More than a game, it is an **artistic investigation** into memory and the dialogue between art and technology.\n*(Historical video and images provided and authorized by MIS Campinas).* \n\n**I hope you enjoy the experience!**",
            nomeImagem: nil, legenda: ""
        ),
        
        AboutSlide(texto: nil, nomeImagem: "AboutPicture1", legenda: "The stop-motion set assembled in the studio"),
        AboutSlide(texto: nil, nomeImagem: "AboutPicture2", legenda: "Showing the improvised setup created to animate the elements coming out of the drawers, using clay for support"),
        AboutSlide(texto: nil, nomeImagem: "AboutPicture3", legenda: "The MIS Campinas archive, the original space that inspired the game (Image provided and authorized by MIS Campinas)"),
        AboutSlide(texto: nil, nomeImagem: "AboutPicture4", legenda: "The original digitization room, at MIS Campinas (Image provided and authorized by MIS Campinas)"),
        AboutSlide(texto: nil, nomeImagem: "AboutPicture5", legenda: "My first sketched prototype of the game’s set design"),
        AboutSlide(texto: nil, nomeImagem: "AboutPicture6", legenda: "The first physical prototype of the stop-motion set miniatures"),
        AboutSlide(texto: nil, nomeImagem: "AboutPicture7", legenda: "The template files and set pieces before assembly"),
        AboutSlide(texto: nil, nomeImagem: "AboutPicture8", legenda: "The set pieces being cut with the laser machine"),
        AboutSlide(texto: nil, nomeImagem: "AboutPicture9", legenda: "The game cassette modeled in Blender and 3D printed"),
        AboutSlide(texto: nil, nomeImagem: "AboutPicture10", legenda: "The trash element from the set being 3D printed"),
        AboutSlide(texto: nil, nomeImagem: "AboutPicture11", legenda: "Assembling the air conditioner using pins to allow movement"),
        AboutSlide(texto: nil, nomeImagem: "AboutPicture12", legenda: "Preparing the miniature Post-its that appear on the task board"),
        AboutSlide(texto: nil, nomeImagem: "AboutPicture13", legenda: "The set in the process of being assembled")
    ]
    
    var body: some View {
        ZStack {
            Image("FundoAbout")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            GeometryReader { geo in
                Button {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        mostrarAbout = false
                    }
                } label: {
                    Text("Menu")
                        .foregroundColor(Color("BrancoBase"))
                        .underline(true, color: Color("BrancoBase"))
                        .font(.custom("Fonteisabrumgibi-bold", size: 60))
                }
                .position(x: geo.size.width * 0.08, y: geo.size.height * 0.1)
                
                ZStack {
                    if let texto = slides[slideAtual].texto {
                        Text(texto)
                            .font(.custom("fonteisabrumgibi", size: 43))
                            .minimumScaleFactor(0.3)
                            .foregroundColor(Color("BrancoBase"))
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 20)
                            .frame(width: geo.size.width * 0.48, height: geo.size.height * 0.3)
                            .id("texto_\(slideAtual)")
                    }
                    
                    if let imagem = slides[slideAtual].nomeImagem {
                        Image(imagem)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.47, height: geo.size.height * 0.4)
                            .opacity(0.75)
                            .id("imagem_\(slideAtual)")
                    }
                }
                .position(x: geo.size.width * 0.505, y: geo.size.height * 0.342)
                .opacity(piscarTela ? 0.3 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: slideAtual)
                
                if !slides[slideAtual].legenda.isEmpty {
                    Text(slides[slideAtual].legenda)
                        .feedbackFormat()
                        .frame(maxWidth: geo.size.width * 0.8)
                        .position(x: geo.size.width * 0.5, y: geo.size.height * 0.7)
                        .id("legenda_\(slideAtual)")
                        .animation(.easeInOut(duration: 0.3), value: slideAtual)
                }
                
                ZStack {
                    Button(action: {
                        if slideAtual > 0 {
                            withAnimation(.easeInOut(duration: 0.3)) { slideAtual -= 1 }
                        } else {
                            acionarPiscada()
                        }
                    }) {
                        Image("SetaAbout_E")
                            .resizable()
                            .scaledToFit()
                    }
                    .position(x: geo.size.width * 0.19)
                    
                    Button(action: {
                        if slideAtual < slides.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) { slideAtual += 1 }
                        } else {
                            acionarPiscada()
                        }
                    }) {
                        Image("SetaAbout_D")
                            .resizable()
                            .scaledToFit()
                    }
                    .position(x: geo.size.width * 0.92)
                }
                .frame(width: geo.size.width * 0.1, height: geo.size.height * 0.1)
                .position(y: geo.size.height * 0.41)
                .opacity(0.85)
            }
        } 
    }
    
    func acionarPiscada() {
        withAnimation(.easeInOut(duration: 0.15)) {
            piscarTela = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeInOut(duration: 0.15)) {
                piscarTela = false
            }
        }
    }
}

