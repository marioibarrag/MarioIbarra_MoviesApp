//
//  MovieCellTableViewCell.swift
//  movies-app
//
//  Created by Consultant on 4/5/22.
//

import UIKit

class MovieCell: UITableViewCell {

    private var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
//        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .justified
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constants.emptyStarIcon), for: .normal)
        button.addTarget(nil, action: #selector(setFavoriteMovie), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var detailButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show details", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var isFavorite = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        contentView.addSubview(movieImage)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(detailButton)
        
        movieImage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        movieImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        movieImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        movieImage.heightAnchor.constraint(equalToConstant: 180).isActive = true
        movieImage.widthAnchor.constraint(equalTo: movieImage.heightAnchor, multiplier: 2/3).isActive = true
        
        movieTitleLabel.topAnchor.constraint(equalTo: movieImage.topAnchor).isActive = true
        movieTitleLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 10).isActive = true
        movieTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        detailButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        detailButton.trailingAnchor.constraint(equalTo: movieTitleLabel.trailingAnchor).isActive = true
        
        overviewLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 10).isActive = true
        overviewLabel.leadingAnchor.constraint(equalTo: movieTitleLabel.leadingAnchor).isActive = true
        overviewLabel.trailingAnchor.constraint(equalTo: movieTitleLabel.trailingAnchor).isActive = true
        overviewLabel.bottomAnchor.constraint(equalTo: detailButton.topAnchor, constant: -10).isActive = true
        
        favoriteButton.trailingAnchor.constraint(equalTo: detailButton.leadingAnchor, constant: -10).isActive = true
        favoriteButton.centerYAnchor.constraint(equalTo: detailButton.centerYAnchor).isActive = true
    }
    
    func configureCell(image: UIImage, title: String, overview: String) {
        movieImage.image = image
        movieTitleLabel.text = title
        overviewLabel.text = overview
    }
    
    @objc func setFavoriteMovie() {
        print("Favorite button pressed")
        
        if !isFavorite {
            favoriteButton.setImage(UIImage(systemName: Constants.filledStarIcon), for: .normal)
            isFavorite = true
        } else {
            favoriteButton.setImage(UIImage(systemName: Constants.emptyStarIcon), for: .normal)
            isFavorite = false
        }
    }
    
}
