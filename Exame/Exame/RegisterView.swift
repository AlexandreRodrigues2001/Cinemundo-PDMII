import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var registrationSuccess: Bool = false
    @State private var navigateToLogin: Bool = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    // logotipo do site
                    Image("cinemundoLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    
                    Spacer()
                    // texto register
                    Text("Register")
                        .padding()
                        .foregroundColor(.red)
                        .font(.largeTitle)
                        .bold()
                    
                    // espaço para colocar o username
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle()) // Estilo de borda arredondada para o TextField
                        .padding()
                    
                    // espaço para colocar a password
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle()) // Estilo de borda arredondada para o SecureField
                        .padding()
                    
                    //butão de registar
                    Button(action: {
                        registerUser { success in
                            DispatchQueue.main.async {
                                registrationSuccess = success
                                isShowingAlert = true
                                if success {
                                    navigateToLogin = true
                                }
                            }
                        }
                    }) {
                        Text("Register")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10) // Cria os cantos arredondados para o botão
                    }
                    Spacer()
                }
                .padding()
                .background(Color.init(white: 0.2)) // Define a cor de fundo para o VStack
            }
            
            //alerta para quando o user tenta registar-se
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text(registrationSuccess ? "Success" : "Error"),
                    message: Text(registrationSuccess ? "Registration successful" : "Registration failed"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        // direciona para a pagina de Log In
        .background(
            NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                EmptyView()
            }
        )
    }
    
    //função que oernite fazer conexão com a API para que o user se possa registar
    func registerUser(completion: @escaping (Bool) -> Void) {
        let baseURL = "http://localhost/API/register.php"

        guard let url = URL(string: baseURL) else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = "username=\(username)&password=\(password)"
        request.httpBody = body.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false)
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let success = json?["success"] as? Bool {
                    completion(success)
                } else {
                    completion(false)
                }
            } catch {
                completion(false)
            }
        }.resume()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
