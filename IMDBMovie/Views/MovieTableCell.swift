//
//  MovieTableCell.swift
//  IMDBMovie
//
//  Created by Bedirhan Yeşilbaş on 9.11.2022.
//

import Foundation
import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell{
    
      var movieImageView =  UIImageView()
     private  var movieTitleLabel =  UILabel()
     private  var movieYearLabel =  UILabel()
    private var movieOverviewLabel = UILabel()
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        UIView.animate(withDuration: 0.2) {
            if highlighted {
                self.movieTitleLabel.textColor = UIColor.red
            } else {
                if #available(iOS 13, *) {
                    self.movieTitleLabel.textColor = UIColor.label
                } else {
                    self.movieTitleLabel.textColor = UIColor.black
                }
            }
        }
    }
    
    func setupCell(withModel model: MovieModel) {
        addSubviews()
       setupImageView(model: model)
    }
    
    private func loadPosterImage(posterPath: String) {
        let url = URL(string: posterPath)
        movieImageView.kf.indicatorType = .activity
        movieImageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "photo.fill"),
            options: [
                .transition(.fade(0.5)),
                .cacheOriginalImage
            ]
        )
    }
    func setupImageView(model: MovieModel){
        guard let posterPath = model.posterPath else { return }
        
        loadPosterImage(posterPath: "https://image.tmdb.org/t/p/w500/\(posterPath)")
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.layer.cornerRadius = 8
        movieImageView.layer.masksToBounds = true
        
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        movieImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        movieImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20).isActive  = true
        movieImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        setupLabels(model: model)
    }
    func setupLabels(model: MovieModel){
        movieYearLabel.text = model.releaseDate
        movieYearLabel.textColor = UIColor.gray.withAlphaComponent(0.8)
        movieYearLabel.font = UIFont.systemFont(ofSize: 14)
        movieYearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        movieTitleLabel.text = model.title
        movieTitleLabel.textColor = UIColor.black
        movieTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        movieOverviewLabel.text = model.overview
        movieOverviewLabel.textColor = UIColor.gray.withAlphaComponent(0.8)
        movieOverviewLabel.font = UIFont.systemFont(ofSize: 14)
        movieOverviewLabel.numberOfLines = 2
        movieOverviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        movieTitleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor,constant: 10).isActive = true
        movieTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -40).isActive = true
        movieTitleLabel.topAnchor.constraint(equalTo: movieImageView.topAnchor,constant: 10).isActive = true
        
        
        movieOverviewLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor,constant: 10).isActive = true
        movieOverviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -40).isActive = true
        movieOverviewLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor,constant: 10).isActive = true
       
        movieYearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -40).isActive = true
        movieYearLabel.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor).isActive = true
         
    }
     func addSubviews() {
        contentView.addSubview(movieYearLabel)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(movieOverviewLabel)
        contentView.addSubview(movieImageView)
    }
}
