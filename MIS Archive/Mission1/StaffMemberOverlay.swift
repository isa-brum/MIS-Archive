import SwiftUI

struct StaffMemberView: View {
    
    var onClose: () -> Void
    
    var autoDismissAfter: TimeInterval = 5.5
    
    var body: some View {
        ZStack {
            // Escurecimento do fundo
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()
            
            // PEDAÇO DE PAPEL
            // Asset pedaço de papel
            Image("PapelStaff")
                .resizable()
                .scaledToFit()
                .scaleEffect(0.9)
            
            // TEXTO
            Text("\(Text(" You are now a MIS staff member\n ").font(.custom("IsaBrumManuscrita-Regular", size: 73))) \(Text("welcome to archive! Complete the missions and help preserving the museum collection").font(.custom("fonteisabrumgibi", size: 47)))")
                .foregroundColor(Color("CinzaTitulo"))
                .multilineTextAlignment(.center)
                .frame(width: 850)
            
            // CAMADA INVISÍVEL PRA PASSAR DE TELA AO CLICAR EM QUALQUER CANTO
            Color.white.opacity(0.001)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.6)) {
                        onClose()
                    }
                }
        }
    }
}

