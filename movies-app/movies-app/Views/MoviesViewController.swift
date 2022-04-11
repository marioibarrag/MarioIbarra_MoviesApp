//
//  MoviesViewController.swift
//  movies-app
//
//  Created by Consultant on 4/5/22.
//

import UIKit

class MoviesViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    private lazy var deleteNameButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete name", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(deleteName), for: .touchUpInside)
        return button
    }()
    
    private var editNameButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
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
    
    private var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Movies List", "Favorites"])
        // Make first segment selected
        segmentControl.selectedSegmentIndex = 0
        
        // Add function to handle Value Changed events
//        segmentControl.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        return segmentControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 200
        tableView.register(MovieCell.self, forCellReuseIdentifier: Constants.movieCellIdentifier)
        return tableView
    }()
    
    private var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        
        setUpUI()
        // Do any additional setup after loading the view.
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
    
    @objc private func deleteName() {
        defaults.removeObject(forKey: Constants.defaultNameKey)
        print("Default name deleted")
    }
    
    @objc private func editDefaultName() {
        print("Edit default name button pressed.")
        present(EditNameViewController(), animated: true)
    }

}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.movieCellIdentifier, for: indexPath) as! MovieCell
        cell.configureCell(image: UIImage(named: "hp1")!, title: "Harry Potter", overview: Constants.lorem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailVC = MovieDetailViewController()
        navigationController?.isNavigationBarHidden = false
        movieDetailVC.movieImageView.image = UIImage(named: "hp1")!
        movieDetailVC.movieTitleLabel.text = "Harry Potter"
        movieDetailVC.overviewLabel.text = Constants.lorem
        movieDetailVC.title = "Harry Potter"
        
        
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}
