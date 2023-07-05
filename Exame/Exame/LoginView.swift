import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var loginSuccess: Bool = false
    @State private var navigateToFilmesMain: Bool = false

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    //logotipo do site
                    Image("cinemundoLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    Spacer()
                    //texto Log In
                    Text("Log in")
                        .padding()
                        .foregroundColor(.red)
                        .font(.largeTitle)
                        .bold()
                    
                    // espaço para a colocação do username
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // espaço para a colocação da password
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // botão de log in
                    Button(action: {
                        isValidLogin { success in
                            DispatchQueue.main.async {
                                loginSuccess = success
                                isShowingAlert = true
                                if success {
                                    navigateToFilmesMain = true
                                }
                            }
                        }
                    }) {
                        Text("Log in")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.init(white: 0.2))
            }
            
            // alerta quando se carrega no butão de Log In
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text(loginSuccess ? "Success" : "Error"),
                    message: Text(loginSuccess ? "Login successful" : "Invalid username or password"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        
        // direciona para a pagina principal dos filmes
        .background(
            NavigationLink(destination: FilmesMainView(), isActive: $navigateToFilmesMain) {
                EmptyView()
            }
        )
    }
    
    func isValidLogin(completion: @escaping (Bool) -> Void) {
        let baseURL = "http://localhost/API/login.php"

        guard let url = URL(string: baseURL) else {
            print("Invalid URL")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = "username=\(username)&password=\(password)"
        request.httpBody = body.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("URL Session Error: \(error)")
                completion(false)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(false)
                return
            }


            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let success = json?["success"] as? Bool {
                    completion(success)
                } else {
                    print("Invalid JSON response")
                    completion(false)
                }
            } catch {
                print("JSON parsing error: \(error)")
                completion(false)
            }
        }.resume()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
