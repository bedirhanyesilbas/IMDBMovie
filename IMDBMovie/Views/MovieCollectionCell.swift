//
//  File.swift
//  IMDBMovie
//
//  Created by Bedirhan Yeşilbaş on 9.11.2022.
//



import UIKit
import Kingfisher

 class MovieCollectionCell: UICollectionViewCell {
     var movieImageView =  UIImageView()
    private  var movieTitleLabel =  UILabel()
   private var movieOverviewLabel = UILabel()
     let width = UIScreen.main.bounds.width
   
   
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
       movieImageView.layer.zPosition = 0
       
       movieImageView.translatesAutoresizingMaskIntoConstraints = false
       movieImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
       movieImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
       movieImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
       setupLabels(model: model)
   }
   func setupLabels(model: MovieModel){
       
       movieTitleLabel.text = model.title
       movieTitleLabel.textColor = UIColor.white
       movieTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
       movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
       movieTitleLabel.layer.zPosition = 50
       
       movieOverviewLabel.text = model.overview
       movieOverviewLabel.textColor = UIColor.white
       movieOverviewLabel.font = UIFont.systemFont(ofSize: 14)
       movieOverviewLabel.numberOfLines = 2
       movieOverviewLabel.translatesAutoresizingMaskIntoConstraints = false
       movieOverviewLabel.layer.zPosition = 50
       
       movieTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10).isActive = true
       movieTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10).isActive = true
       movieTitleLabel.bottomAnchor.constraint(equalTo: movieOverviewLabel.topAnchor,constant: -10).isActive = true
       
       
       movieOverviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10).isActive = true
       movieOverviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10).isActive = true
       movieOverviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -40).isActive = true
      
        
   }
    func addSubviews() {
       contentView.addSubview(movieTitleLabel)
       contentView.addSubview(movieOverviewLabel)
       contentView.addSubview(movieImageView)
   }
}



