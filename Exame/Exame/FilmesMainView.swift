import SwiftUI

struct PersonalizedTextField: View {
    @Binding var text: String
    var placeholder: String
    var onSearchButtonTapped: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2)) // Preenche o fundo do retângulo com uma cor cinza transparente
            
            HStack {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white) // Define a cor do texto do TextField como branco
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white) // Define a cor da imagem do ícone como branco
            }
            .padding(.horizontal, 16) // Adiciona espaçamento horizontal para o conteúdo da HStack
        }
        .padding(.horizontal, 16) // Adiciona espaçamento horizontal para o retângulo
        .frame(height: 36) // Define a altura do retângulo
        .onChange(of: text) { _ in
            onSearchButtonTapped() // Chama a função onSearchButtonTapped quando o texto no TextField é alterado
        }
    }
}

class FilmDataFetch: ObservableObject {
    @Published var films: [Filme] = []
    var searchText = "" {
        didSet {
            fetchFilms() // Chama o método fetchFilms() sempre que o searchText é alterado
        }
    }
    
    func fetchFilms() {
        var baseURL = "http://localhost/API/fetch_films.php"
        
        if !searchText.isEmpty {
            baseURL += "?searchText=\(searchText)"
        }
        
        guard let url = URL(string: baseURL) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("URL Session Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let filmsData = try JSONDecoder().decode([Filme].self, from: data)
                DispatchQueue.main.async {
                    self.films = filmsData
                }
            } catch {
                print("JSON decoding error: \(error)")
            }
        }.resume()
    }
}

struct FilmesMainView: View {
    @StateObject private var filmDataFetch = FilmDataFetch()
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            Color.init(white: 0.2)
                .edgesIgnoringSafeArea(.vertical) // Ignora a área segura verticalmente
            
            VStack {
                Image("cinemundoLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                HStack {
                    Text("Filmes")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    PersonalizedTextField(text: $searchText, placeholder: "Pesquisar filme", onSearchButtonTapped: searchFilms)
                }
                
                TabView {
                    FilmesListView(filmDataFetch: filmDataFetch)
                        .tabItem {
                            Image(systemName: "rectangle.grid.1x2.fill")
                            Text("Lista")
                        }
                    
                    FilmesGridView(filmDataFetch: filmDataFetch)
                        .tabItem {
                            Image(systemName: "rectangle.grid.3x2.fill")
                            Text("Grid")
                        }
                }
            }
        }
        .onAppear {
            filmDataFetch.fetchFilms() // Quando o display aparecer, chama o método fetchFilms() do objeto filmDataFetch para ir buscar os filmes
        }
    }
    
    func searchFilms() {
        filmDataFetch.searchText = searchText // Atribui o valor do searchText à propriedade searchText de filmDataFetch
        filmDataFetch.fetchFilms() // Chama o método fetchFilms() para ir buscar os filmes com base no searchText atualizado
    }
}

struct FilmesMainView_Previews: PreviewProvider {
    static var previews: some View {
        FilmesMainView()
    }
}
