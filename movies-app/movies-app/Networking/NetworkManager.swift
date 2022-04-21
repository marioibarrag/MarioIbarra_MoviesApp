import Foundation
import Combine
import UIKit

protocol NetworkManager {
    func getModel<Model: Decodable>(_ model: Model.Type, from url: String) -> AnyPublisher<Model, NetworkError>
    func getData(from url: String, completionHandler: @escaping (Data?) -> Void)
}

class MainNetworkManager: NetworkManager {
    
    func getModel<Model: Decodable>(_ model: Model.Type, from url: String) -> AnyPublisher<Model, NetworkError> {
        
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        guard let url = URL(string: url)
        else {
            print("BAD URL")
            return Fail<Model, NetworkError>(error: .badURL).eraseToAnyPublisher()
        }
        
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map { result -> Data in
                return result.data
            }
            .decode(type: model, decoder: decoder)
            .mapError { error -> NetworkError in
                print("ERROR: \(error)")
                return .other(error)
            }
            .eraseToAnyPublisher()
    }
    
    
    func getStories(from url: String) -> AnyPublisher<Movie, NetworkError> {
            
            guard let url = URL(string: url)
            else { return Fail<Movie, NetworkError>(error: .badURL).eraseToAnyPublisher() }
            
            return URLSession
                .shared
                .dataTaskPublisher(for: url)
                .map { result -> Data in
                    return result.data
                }
                .decode(type: Movie.self, decoder: JSONDecoder())
                .mapError { error -> NetworkError in
                    return .other(error)
                }
                .eraseToAnyPublisher()
        }
    
    
    
    func getData(from url: String, completionHandler: @escaping (Data?) -> Void) {
        
        guard let url = URL(string: url) else {
            completionHandler(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            completionHandler(data)
        }
        .resume()
    }
}
