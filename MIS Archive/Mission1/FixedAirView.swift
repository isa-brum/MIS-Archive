import SwiftUI

struct FixedAirConditionerView: View {
    var finalizarMiniGameAr: () -> Void
    
    var body: some View {
        ZStack {
            // Imagem de fundo do Ar
            Image("ArConsertado")
                .resizable()
                .scaledToFit()
                .scaleEffect(0.86)
            
            // Botão/Fita
            Image("Fita")
                .resizable()
                .scaledToFit()
                .scaleEffect(2)
            
            // Agrupando os textos
            ZStack {
                Text("25º")
                    .offset(x: 50, y: 50)
                
                ZStack {
                    Text("30º")
                        .offset(x: 60)
                    Text("20º")
                        .offset(x: 70)
                }
                .offset(y: 60)
                
                ZStack {
                    Text(".")
                        .offset(x: 40)
                    Text(".")
                        .offset(x: 40)
                }
                .offset(y: 70)
                
                ZStack {
                    Text(".")
                        .offset(x: 50)
                    Text(".")
                        .offset(x: 50)
                }
                .offset(y: 80)
            }
            .foregroundColor(Color("BrancoBase"))
            .font(.custom("fonteisabrumgibi", size: 40))
        }
        .ignoresSafeArea()
    }
}

#Preview {
    AirConditionerView(onClose: {})
}
