import Foundation
import UIKit
import Combine

protocol ViewModelPorotocol {
    var totalRows: Int { get }
    var movies: [Movie] { get }
    var favoriteMovies: [Int: Movie] { get set }
    var favoritesIdArray: [Int] { get set }
    var publisherMovies: Published<[Movie]>.Publisher { get }
    func getMovies()
    func downloadImages()
    func showDetail(row: Int, fav: Bool) -> MovieDetailViewController
    func showDetailSearch(movie: Movie?) -> MovieDetailViewController
    func addFavorite(movie: Movie?, fav: Bool)
}

class MoviesVCViewModel: ViewModelPorotocol {
    
    let CDContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var totalRows: Int { movies.count }
    var publisherMovies: Published<[Movie]>.Publisher { $movies }
    
    private let networkManager: NetworkManager
    private var subscribers = Set<AnyCancellable>()
    @Published var movies = [Movie]()
    var favoriteMovies: [Int: Movie] = [:]
    var favoritesIdArray: [Int] = []
    
    init(networkManager: NetworkManager){
        self.networkManager = networkManager
    }
    
    func getMovies() {
        networkManager
            .getModel(MovieResponse.self, from: URLs.popularMovies)
            .sink { completion in
                switch completion {
                    
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            } receiveValue: { [weak self] response in
//                self?.movies.append(contentsOf: response.results)
                self?.movies = response.results
                self?.downloadImages()
            }
            .store(in: &subscribers)
    }
    
    func downloadImages() {
        for movie in movies {
            if let poster = movie.posterPath {
                let url = URLs.image + poster
                networkManager.getData(from: url) { data in
                    movie.imgData = data
                }
            }
        }
    }
    
    func showDetail(row: Int, fav: Bool) -> MovieDetailViewController {
        let movieDetailVC = MovieDetailViewController()
        var movie = movies[row]
        
        if fav {
            if let temp = favoriteMovies[favoritesIdArray[row]] {
                movie = temp
            }
        }
        if let data = movie.imgData {
            movieDetailVC.movieImageView.image = UIImage(data: data)
        }
        movieDetailVC.movieTitleLabel.text = movie.title
        movieDetailVC.overviewLabel.text = movie.overview
        movieDetailVC.title = movie.title
        
        return movieDetailVC
    }
    
    func showDetailSearch(movie: Movie?) -> MovieDetailViewController {
        let movieDetailVC = MovieDetailViewController()
        if let movie = movie {
            if let data = movie.imgData {
                movieDetailVC.movieImageView.image = UIImage(data: data)
            }
            movieDetailVC.movieTitleLabel.text = movie.title
            movieDetailVC.overviewLabel.text = movie.overview
            movieDetailVC.title = movie.title
        }
        return movieDetailVC
    }
    
    func addFavorite(movie: Movie?, fav: Bool) {
        if !fav {
            if let movie = movie {
                if !movie.isFavorite {
                    movie.isFavorite = !movie.isFavorite
                    favoriteMovies[Int(movie.id)] = movie
                    favoritesIdArray.append(Int(movie.id))
                } else {
                    movie.isFavorite = !movie.isFavorite
                    favoriteMovies.removeValue(forKey: Int(movie.id))
                    if let index = favoritesIdArray.firstIndex(of: Int(movie.id)) {
                        favoritesIdArray.remove(at: index)
                        print(favoritesIdArray)
                    }
                }
            }
        } else {
            if let movie = movie {
                favoriteMovies.removeValue(forKey: Int(movie.id))
                if let index = favoritesIdArray.firstIndex(of: Int(movie.id)) {
                    favoritesIdArray.remove(at: index)
                    print(favoritesIdArray)
                }
                movie.isFavorite = !movie.isFavorite
            }
        }
        
        
        
        
    }
}
