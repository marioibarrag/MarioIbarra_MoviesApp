import Foundation

struct MovieResponse: Decodable {
    let page: Int
    let results: [Movie]
}
