//
//  MovieDetailViewController.swift
//  IMDBMovie
//
//  Created by Bedirhan Yeşilbaş on 10.11.2022.
//

import Foundation
import UIKit

class MovieDetailViewController:UIViewController{
    var movieModel: MovieModel?
    let movieDetailVM = MovieDetailViewModel()
    private var uiScrollView = UIScrollView()
    private  var loadingIndicator = UIActivityIndicatorView()
    private var movieImageView =  UIImageView()
   
    let width = UIScreen.main.bounds.width
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        movieDetailVM.movieModel = movieModel
        movieDetailVM.view = self
        setupIndicator()
        isLoading(loading: true)
        movieDetailVM.start()
        }
}
extension MovieDetailViewController: MovieDetailDelegate,UIScrollViewDelegate{
    
    func setupInitialState() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.title = movieDetailVM.movieDetail?.originalTitle
        setupView()
    }
    
    func showError(_ errorMessage: String) {
        DispatchQueue.main.async {
            
            let okAction = AlertAction(onSelect: {}, name: "OK", style: .default)
            let alert = UIAlertController(info: AlertInfo(title: "Error", message: errorMessage, actions: [okAction]))
            self.present(alert, animated: true)
        }
    }
    
    func isLoading(loading status: Bool) {
        DispatchQueue.main.async {
            if status {
                self.loadingIndicator.isHidden = false
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
            }
        }
    }
    
    func setupIndicator(){
        loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: view.center.x, y: view.center.y, width: 50, height: 50))
    }
    func setupView(){
        addSubviews()
        setupScrollView()
        setupImageView()
    }
    func setupScrollView(){
        let guide = view.safeAreaLayoutGuide
        uiScrollView.translatesAutoresizingMaskIntoConstraints = false
        uiScrollView.isScrollEnabled = true
        uiScrollView.delegate = self
        uiScrollView.bounces = true

        uiScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        uiScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        uiScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        uiScrollView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
    }
    func setupImageView(){
        guard let movieDetail =  movieDetailVM.movieDetail else {return }
        guard let posterPath = movieDetail.posterPath else { return }
        
        loadPosterImage(posterPath: "https://image.tmdb.org/t/p/w500/\(posterPath)")
        movieImageView.contentMode = .scaleToFill
        
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        movieImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        movieImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        movieImageView.topAnchor.constraint(equalTo: uiScrollView.topAnchor).isActive = true
        setupLabels(model: movieDetail)
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
    func addSubviews(){
        view.addSubview(uiScrollView)
        view.addSubview(loadingIndicator)
        uiScrollView.addSubview(movieImageView)
        
    }
    func setupLabels(model: MovieDetailModel){
         let starView =  UIImageView()
         let imdbLogoView =  UIImageView()
          let movieTitleLabel =  UILabel()
          let movieYearLabel =  UILabel()
         let movieOverviewLabel = UILabel()
        let ratingLabel = UILabel()
        let yellowDot = UIImageView()
        
        uiScrollView.addSubview(starView)
        uiScrollView.addSubview(imdbLogoView)
        uiScrollView.addSubview(movieTitleLabel)
        uiScrollView.addSubview(movieYearLabel)
        uiScrollView.addSubview(movieOverviewLabel)
        uiScrollView.addSubview(ratingLabel)
        uiScrollView.addSubview(yellowDot)
        
        imdbLogoView.image = UIImage(named: "IMDB")
        imdbLogoView.contentMode = .scaleAspectFit
        imdbLogoView.translatesAutoresizingMaskIntoConstraints = false
        
        starView.image = UIImage(systemName: "star.fill")
        starView.contentMode = .scaleAspectFit
        starView.translatesAutoresizingMaskIntoConstraints = false
        starView.tintColor = UIColor.orange
        
        ratingLabel.text = "\(Int(model.voteAverage))/10"
        ratingLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 14)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        yellowDot.backgroundColor = UIColor.orange.withAlphaComponent(0.6)
        yellowDot.layer.cornerRadius = 5
        yellowDot.translatesAutoresizingMaskIntoConstraints = false
        
        
        movieYearLabel.text = model.releaseDate
        movieYearLabel.textColor = UIColor.black
        movieYearLabel.font = UIFont.systemFont(ofSize: 14)
        movieYearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        movieTitleLabel.text = model.title
        movieTitleLabel.textColor = UIColor.black
        movieTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        movieOverviewLabel.text = model.overview
        movieOverviewLabel.textColor = UIColor.black
        movieOverviewLabel.font = UIFont.systemFont(ofSize: 20)
        movieOverviewLabel.numberOfLines = 0
        movieOverviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        imdbLogoView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imdbLogoView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imdbLogoView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10).isActive = true
        imdbLogoView.topAnchor.constraint(equalTo: movieImageView.bottomAnchor,constant: 10).isActive = true
        
        starView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        starView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        starView.leadingAnchor.constraint(equalTo: imdbLogoView.trailingAnchor,constant: 10).isActive = true
        starView.centerYAnchor.constraint(equalTo: imdbLogoView.centerYAnchor).isActive = true
        
        ratingLabel.leadingAnchor.constraint(equalTo: starView.trailingAnchor,constant: 10).isActive = true
        ratingLabel.centerYAnchor.constraint(equalTo: imdbLogoView.centerYAnchor).isActive = true
        
        yellowDot.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor,constant: 10).isActive = true
        yellowDot.centerYAnchor.constraint(equalTo: imdbLogoView.centerYAnchor).isActive = true
        yellowDot.widthAnchor.constraint(equalToConstant: 10).isActive = true
        yellowDot.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        movieYearLabel.leadingAnchor.constraint(equalTo: yellowDot.trailingAnchor,constant: 10).isActive = true
        movieYearLabel.centerYAnchor.constraint(equalTo: imdbLogoView.centerYAnchor).isActive = true
        
        movieTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10).isActive = true
        movieTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10).isActive = true
        movieTitleLabel.topAnchor.constraint(equalTo: imdbLogoView.bottomAnchor,constant: 10).isActive = true
        
        
        movieOverviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10).isActive = true
        movieOverviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10).isActive = true
        movieOverviewLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor,constant: 10).isActive = true
       
         
    }
}
