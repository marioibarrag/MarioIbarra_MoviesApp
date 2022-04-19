import Foundation

struct MovieDetail {
    let backdropPath: String
    let id: Int
    let title: String
    let overview: String
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case title
        case overview
    }
}
