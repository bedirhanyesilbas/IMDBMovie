import Foundation
import UIKit
import Alamofire

class MovieViewModel{
    var view: MovieDelagete!
    var cellViewModels: [MovieModel] = [MovieModel]()
    var currentPage: Int = 1
    var totalPages: Int = 1
    var itemsBeforeRequest: Int = 0
    var loadingNewMovies: Bool = false
    var path:String
    var navigateController: UINavigationController?
    let movieServiceAPI = MovieService()
    init(path: String) {
        self.path = path
    }
    func viewIsReady() {
        view.setupInitialState()
        view.isLoadingMovies(loading: true)
        loadingNewMovies = true
        requestMoviesList(for: currentPage)
    }
    func getNumberOfItemsBeforeRequest() -> Int {
        return self.itemsBeforeRequest
    }
    
    func isLoadingNewMovies() -> Bool {
        return loadingNewMovies
    }
    
    func getNextMovies() {
        if currentPage < totalPages {
            loadingNewMovies = true
            currentPage += 1
            itemsBeforeRequest = cellViewModels.count
            requestMoviesList(for: currentPage)
        }
    }
    
    func numberOfCells() -> Int {
        return cellViewModels.count
    }
    
    func cellViewModel(index indexPath: IndexPath) -> MovieModel {
        return cellViewModels[indexPath.row]
    }
    
    func resetMovies() {
        cellViewModels.removeAll()
        currentPage = 1
        view.updateMoviesList()
        view.isLoadingMovies(loading: true)
        loadingNewMovies = true
        requestMoviesList(for: currentPage)
    }
    
    func openMovieDetails(index indexPath: IndexPath) {
        guard let navigateController = navigateController else {
            return
        }
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.movieModel = cellViewModels[indexPath.item]
        navigateController.pushViewController(movieDetailVC, animated: true)
    }
    func didRetrieveMovieDetails(_ currentPage: Int, totalPages: Int) {
        self.currentPage = currentPage
        self.totalPages = totalPages
    }
    
    func didRetrieveMovies(_ movies: [MovieModel]) {
        view.isLoadingMovies(loading: false)
        cellViewModels += movies
        view.updateMoviesList()
        self.loadingNewMovies = false
    }
    
    func onError(_ error: ErrorType) {
        loadingNewMovies = false
        view.isLoadingMovies(loading: false)
        view.showError(error.message)
    }
    func requestMoviesList(for page: Int?) {
        movieServiceAPI.requestMovies(page: page,path: self.path, onSuccess: { [self] movies in
            
            self.view.isLoadingMovies(loading: false)
            self.loadingNewMovies = false
            self.totalPages = movies.totalPages
            self.currentPage = movies.page
            self.cellViewModels.append(contentsOf: movies.results)
            self.view.updateMoviesList()
            
        }, onFailure: { [weak self] error in
            self?.view.showError(error.message)
            self?.view.isLoadingMovies(loading: false)
            self?.loadingNewMovies = false
        })
    }
}


protocol MovieDelagete: AnyObject {
    func setupInitialState()
    func updateMoviesList()
    func showError(_ errorMessage: String)
    func isLoadingMovies(loading status: Bool)
}
