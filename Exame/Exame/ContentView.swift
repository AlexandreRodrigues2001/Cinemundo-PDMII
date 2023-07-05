import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                // logotipo do site
                Image("cinemundoLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()

                HStack(spacing: 16) {
                    // Navegação para o LoginView
                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    
                    // Navegação para o RegisterView
                    NavigationLink(destination: RegisterView()) {
                        Text("Register")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                Spacer()
            }
            .background(Color.init(white: 0.2)) // definir a cor de fundo como cinza escuro 
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
