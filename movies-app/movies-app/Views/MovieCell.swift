import UIKit

class MovieCell: UITableViewCell {

    var cellRow = 0
    
    private var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constants.emptyStarIcon), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var detailButtonPressed: () -> Void = {}
    
    private lazy var detailAction = UIAction { [weak self] _ in
        self?.detailButtonPressed()
    }
    
    private lazy var detailButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect, primaryAction: detailAction)
        button.setTitle("Show details", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
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
        detailButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
        overviewLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 10).isActive = true
        overviewLabel.leadingAnchor.constraint(equalTo: movieTitleLabel.leadingAnchor).isActive = true
        overviewLabel.trailingAnchor.constraint(equalTo: movieTitleLabel.trailingAnchor).isActive = true
        overviewLabel.bottomAnchor.constraint(equalTo: detailButton.topAnchor, constant: -10).isActive = true
        
        favoriteButton.trailingAnchor.constraint(equalTo: detailButton.leadingAnchor, constant: -10).isActive = true
        favoriteButton.centerYAnchor.constraint(equalTo: detailButton.centerYAnchor).isActive = true
    }
    
    func configureCell(movie: Movie?, row: Int) {
        movieTitleLabel.text = movie?.title ?? ""
        overviewLabel.text = movie?.overview ?? ""
        cellRow = row
        
        guard let _ = movie?.imgData
        else {
            movieImage.image = UIImage(named: "no_image")
            return
        }
        
        if let data = movie?.imgData {
            movieImage.image = UIImage(data: data)
        }
        
        if let fav = movie?.isFavorite {
            if fav {
                favoriteButton.setImage(UIImage(systemName: Constants.filledStarIcon), for: .normal)
            } else {
                favoriteButton.setImage(UIImage(systemName: Constants.emptyStarIcon), for: .normal)
            }
        }
        
    }
    
}
