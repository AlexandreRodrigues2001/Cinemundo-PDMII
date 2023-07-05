import Foundation

struct Filme: Decodable, Identifiable {
    let id: Int // Identificador único do filme
    let category: String // Categoria do filme
    let title: String // Título do filme
    let resume: String // Resumo do filme
    let imageName: String // Nome da imagem do filme

    enum CodingKeys: String, CodingKey {
        case id = "id_film" // key de decodificação para a propriedade "id"
        case category // key de decodificação para a propriedade "category"
        case title // key de decodificação para a propriedade "title"
        case resume // key de decodificação para a propriedade "resume"
        case imageName // key de decodificação para a propriedade "imageName"
    }
}
