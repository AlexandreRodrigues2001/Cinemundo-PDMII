import SwiftUI

struct FilmesListView: View {
    @ObservedObject var filmDataFetch: FilmDataFetch
    
    var body: some View {
        NavigationView {
            VStack {
                // Bloco principal da visualização
                GeometryReader { geometry in
                    ScrollView {
                        LazyVStack {
                            // Loop de repetição para cada filme
                            ForEach(filmDataFetch.films, id: \.id) { film in
                                VStack(alignment: .leading, spacing: 8) {
                                    // Exibição da imagem do filme
                                    Image(film.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geometry.size.width - 32, height: (geometry.size.width - 32) * 0.5625) // Mantém a resolução de 16:9 para a imagem
                                        .cornerRadius(8)
                                    
                                    // Exibição da categoria do filme
                                    Text(film.category)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    // Exibição do título do filme
                                    Text(film.title)
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(.white)
                                    
                                    // Exibição do resumo do filme
                                    Text(film.resume)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 16)
                                .background(Color.init(white: 0.2)) // Define a cor de fundo do conteúdo do filme
                                .cornerRadius(8)
                                .listRowInsets(EdgeInsets()) // Remove o espaçamento entre as linhas da lista
                            }
                        }
                        .padding(.vertical, 16)
                    }
                }
                Spacer()
            }
            .background(Color.init(white: 0.2)) // Define a cor de fundo da tela
        }
        .onAppear {
            filmDataFetch.fetchFilms() // Quando o display aparecer, chama o método fetchFilms() do objeto filmDataFetch para buscar os filmes
        }
    }
}

struct FilmesListView_Previews: PreviewProvider {
    static var previews: some View {
        FilmesListView(filmDataFetch: FilmDataFetch()) 
    }
}
