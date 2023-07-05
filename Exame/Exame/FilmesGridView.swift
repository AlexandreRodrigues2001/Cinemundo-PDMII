import SwiftUI

struct FilmesGridView: View {
    let gridLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    @ObservedObject var filmDataFetch: FilmDataFetch
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.init(white: 0.2)
                    .edgesIgnoringSafeArea(.vertical) // Ignora a área segura verticalmente
                
                ScrollView {
                    VStack {
                        Section {
                            // Grade de filmes
                            LazyVGrid(columns: gridLayout, spacing: 16) {
                                ForEach(filmDataFetch.films, id: \.id) { film in
                                    VStack(alignment: .leading, spacing: 8) {
                                        // Exibição da imagem do filme
                                        Image(film.imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 150, height: 150)
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
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
            }
        }
        .onAppear {
            filmDataFetch.fetchFilms() // Quando o display aparecer, chama o método fetchFilms() do objeto filmDataFetch para buscar os filmes
        }
    }
}


struct FilmesGridView_Previews: PreviewProvider {
    static var previews: some View {
        FilmesGridView(filmDataFetch: FilmDataFetch())
    }
}
