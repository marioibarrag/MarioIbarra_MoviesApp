import UIKit
import Combine

class MoviesViewController: UIViewController {

    private let defaults = UserDefaults.standard
    private var viewModel: ViewModelPorotocol?
    private var subscribers = Set<AnyCancellable>()
    private var tableViewViewType = 0
    private var searchArr: [Movie] = []
    
    private lazy var deleteNameButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete name", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(deleteName), for: .touchUpInside)
        return button
    }()
    
    private var editNameButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constants.editIcon), for: .normal)
        button.addTarget(nil, action: #selector(editDefaultName), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello: \(self.defaults.string(forKey: Constants.defaultNameKey)!)"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 30.0)
        return label
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Movies List", "Favorites"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addAction(segmentControlAction, for: .valueChanged)
        // Add function to handle Value Changed events
        return segmentControl
    }()
    
    private lazy var segmentControlAction = UIAction { action in
        self.searchBar.text = ""
        self.tableViewViewType = self.segmentControl.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 200
        tableView.register(MovieCell.self, forCellReuseIdentifier: Constants.movieCellIdentifier)
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        
        setUpUI()
        
        assembleMVVM()
        setUpBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(nameLabel)
        view.addSubview(editNameButton)
        view.addSubview(segmentControl)
        view.addSubview(searchBar)
        view.addSubview(deleteNameButton)
        view.addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        deleteNameButton.translatesAutoresizingMaskIntoConstraints = false
        deleteNameButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20).isActive = true
        deleteNameButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20).isActive = true
        nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        
        editNameButton.translatesAutoresizingMaskIntoConstraints = false
        editNameButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20).isActive = true
        editNameButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        segmentControl.widthAnchor.constraint(equalTo: safeArea.widthAnchor).isActive = true
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 10).isActive = true
        searchBar.widthAnchor.constraint(equalTo: safeArea.widthAnchor).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: deleteNameButton.topAnchor).isActive = true
        
        
        
    }
    
    private func assembleMVVM() {
        let networkManager = MainNetworkManager()
        viewModel = MoviesVCViewModel(networkManager: networkManager)
    }
    
    private func setUpBinding() {
        viewModel?
            .publisherMovies
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                // Timer to give some time to finish downloading the poster images
                Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                    self?.tableView.reloadData()
                }
            })
            .store(in: &subscribers)
        
        viewModel?.getMovies()
    }
    
    @objc private func deleteName() {
        defaults.removeObject(forKey: Constants.defaultNameKey)
        print("Default name deleted")
    }
    
    @objc private func editDefaultName() {
        present(EditNameViewController(), animated: true)
    }

}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchBar.text!.isEmpty {
            return searchArr.count
        }
        if tableViewViewType == 0 {
            return viewModel?.totalRows ?? 0
        } else {
            return viewModel?.favoritesIdArray.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.movieCellIdentifier, for: indexPath) as! MovieCell
        
        if self.tableViewViewType == 0{
            if let searchText = searchBar.text {
                if searchText.count > 0 {
                    cell.detailButtonPressed = {
                        let movieDetailVC = self.viewModel?.showDetailSearch(movie: self.searchArr[indexPath.row])
                        self.navigationController?.pushViewController(movieDetailVC ?? MovieDetailViewController(), animated: true)
                    }
                    cell.configureCell(movie: searchArr[indexPath.row], row: indexPath.row)
                } else {
                    cell.detailButtonPressed = {
                        let movieDetailVC = self.viewModel?.showDetail(row: indexPath.row, fav: false)
                        self.navigationController?.pushViewController(movieDetailVC ?? MovieDetailViewController(), animated: true)
                    }
                    cell.configureCell(movie: viewModel?.movies[indexPath.row], row: indexPath.row)
                }
            }
//            cell.detailButtonPressed = {
//                let movieDetailVC = self.viewModel?.showDetail(row: indexPath.row, fav: false)
//                self.navigationController?.pushViewController(movieDetailVC ?? MovieDetailViewController(), animated: true)
//            }
//            cell.configureCell(movie: viewModel?.movies[indexPath.row], row: indexPath.row)
        } else {
            if let searchText = searchBar.text {
                if searchText.count > 0 {
                    cell.detailButtonPressed = {
                        let movieDetailVC = self.viewModel?.showDetailSearch(movie: self.searchArr[indexPath.row])
                        self.navigationController?.pushViewController(movieDetailVC ?? MovieDetailViewController(), animated: true)
                    }
                    cell.configureCell(movie: searchArr[indexPath.row], row: indexPath.row)
                } else {
                    cell.detailButtonPressed = {
                        let movieDetailVC = self.viewModel?.showDetail(row: indexPath.row, fav: true)
                        self.navigationController?.pushViewController(movieDetailVC ?? MovieDetailViewController(), animated: true)
                    }
                    if let id = viewModel?.favoritesIdArray[indexPath.row] {
                        cell.configureCell(movie: viewModel?.favoriteMovies[id], row: indexPath.row)
                    }
                }
            }
//            cell.detailButtonPressed = {
//                let movieDetailVC = self.viewModel?.showDetail(row: indexPath.row, fav: true)
//                self.navigationController?.pushViewController(movieDetailVC ?? MovieDetailViewController(), animated: true)
//            }
//            if let id = viewModel?.favoritesIdArray[indexPath.row] {
//                cell.configureCell(movie: viewModel?.favoriteMovies[id], row: indexPath.row)
//            }
                
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.tableViewViewType == 0{
            viewModel?.addFavorite(movie: self.viewModel?.movies[indexPath.row],fav: false)
            tableView.reloadData()
        } else {
            if let id = viewModel?.favoritesIdArray[indexPath.row] {
                if let movie = viewModel?.favoriteMovies[id] {
                    viewModel?.addFavorite(movie: movie, fav: true)
                    
                    tableView.reloadData()
                }
            }
            
        }
    }
}

extension MoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if tableViewViewType == 0 {
            if let movies = viewModel?.movies {
                searchArr = movies.filter({ movie in
                    let titleAndOverview = "\(movie.title) \(movie.overview)".lowercased()
                    return titleAndOverview.contains(searchText.lowercased())
                })
            }
            tableView.reloadData()
        } else {
            
            if let ids = viewModel?.favoritesIdArray {
                searchArr = ids.map({ id in
                    return (viewModel?.favoriteMovies[id])!
                }).filter({ movie in
                    let titleAndOverview = "\(movie.title) \(movie.overview)".lowercased()
                    return titleAndOverview.contains(searchText.lowercased())
                })
            }
            tableView.reloadData()
        }
    }
}
