//
//  MovieDetailViewModel.swift
//  IMDBMovie
//
//  Created by Bedirhan Yeşilbaş on 9.11.2022.
//

import Foundation

class MovieDetailViewModel{
    let movieService = MovieService()
    var view: MovieDetailDelegate!
    var movieModel: MovieModel?
    var movieDetail : MovieDetailModel?
    func start(){
        view.isLoading(loading: true)
        request()
    }
    func request(){
        guard let movieModel = movieModel else {
            return
        }
        movieService.requestMovieDetails(movie: movieModel) { movieDetail in
            self.view.isLoading(loading: false)
            self.movieDetail = movieDetail
            self.view.setupInitialState()
            
        } onFailure: { [weak self] error in
            self?.view.isLoading(loading: false)
            self?.view.showError(error.message)
        }
    }
    
}
protocol MovieDetailDelegate: AnyObject {
    func setupInitialState()
    func showError(_ errorMessage: String)
    func isLoading(loading status: Bool)
}
