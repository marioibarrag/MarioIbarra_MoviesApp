import Foundation

enum NetworkError: Error {
    case badURL
    case other(Error)
}
