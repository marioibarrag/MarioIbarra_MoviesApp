//
//  MovieDetailViewController.swift
//  movies-app
//
//  Created by Consultant on 4/7/22.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productionCompaniesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Production Companies"
        return label
    }()
    
    lazy private var colletionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.backgroundColor = UIColor.white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: Constants.collectionViewCell)
        collectionView.backgroundColor = .lightGray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Title"
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    
    
    private func setUpUI() {
        view.addSubview(movieImageView)
        view.addSubview(movieTitleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(productionCompaniesLabel)
        view.addSubview(colletionView)
        
        view.backgroundColor = .white
        
        let safeArea = view.safeAreaLayoutGuide
        let screenWidth = UIScreen.main.bounds.width
        
        movieImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30).isActive = true
        movieImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10).isActive = true
        movieImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        movieImageView.widthAnchor.constraint(equalTo: movieImageView.heightAnchor, multiplier: 2/3).isActive = true
        
        movieTitleLabel.topAnchor.constraint(equalTo: movieImageView.topAnchor).isActive = true
        movieTitleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10).isActive = true
        movieTitleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10).isActive = true
        
        overviewLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 20).isActive = true
        overviewLabel.leadingAnchor.constraint(equalTo: movieTitleLabel.leadingAnchor).isActive = true
        overviewLabel.trailingAnchor.constraint(equalTo: movieTitleLabel.trailingAnchor).isActive = true
        overviewLabel.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor).isActive = true
        
        productionCompaniesLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 50).isActive = true
        productionCompaniesLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        
        colletionView.topAnchor.constraint(equalTo: productionCompaniesLabel.bottomAnchor, constant: 20).isActive = true
        colletionView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        colletionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        
    }
    

}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCell, for: indexPath)
        
        return cell
    }
    
    
}
