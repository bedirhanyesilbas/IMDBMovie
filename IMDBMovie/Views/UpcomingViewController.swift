//
//  NowPlayingViewController.swift
//  IMDBMovie
//
//  Created by Bedirhan Yeşilbaş on 10.11.2022.
//

import Foundation
import UIKit

class UpcomingViewController: UIViewController{
    var upcomingVM = MovieViewModel(path: "movie/upcoming")
    var navigateController: UINavigationController?
    private  var moviesTableView =  UITableView()
    private  var loadingIndicator = UIActivityIndicatorView()
  
   fileprivate lazy var moviesRefreshControll: UIRefreshControl = {
       let refreshControll = UIRefreshControl()
       refreshControll.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
       
       return refreshControll
   }()
    override func viewDidLoad() {
        super.viewDidLoad()
        upcomingVM.view = self
        upcomingVM.viewIsReady()
        upcomingVM.navigateController = navigateController
        setUpView()
    }
}
extension UpcomingViewController: UITableViewDelegate,UITableViewDataSource,MovieDelagete{
   
    func setUpView(){
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        view.addSubview(moviesTableView)
        
        moviesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        moviesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        moviesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        moviesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        moviesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc func refreshMovies() {
        upcomingVM.resetMovies()
    }

    
    func setupInitialState() {
        moviesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        
        if #available(iOS 10.0, *) {
            moviesTableView.refreshControl = moviesRefreshControll
        } else {
            moviesTableView.addSubview(moviesRefreshControll)
        }
    }
    
    func updateMoviesList() {
        DispatchQueue.main.async {
            self.moviesTableView.reloadData()
        }
    }
    
    func isLoadingMovies(loading status: Bool) {
        DispatchQueue.main.async {
            if status {
                self.loadingIndicator.isHidden = false
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                if self.moviesRefreshControll.isRefreshing {
                    self.moviesRefreshControll.endRefreshing()
                    self.moviesRefreshControll.isHidden = true
                }
            }
        }
    }
    
    func showError(_ errorMessage: String) {
        DispatchQueue.main.async {
            
            let okAction = AlertAction(onSelect: {}, name: "OK", style: .default)
            let alert = UIAlertController(info: AlertInfo(title: "Error", message: errorMessage, actions: [okAction]))
            self.present(alert, animated: true)
        }
    }
    

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return upcomingVM.numberOfCells()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellModel = upcomingVM.cellViewModel(index: indexPath)
        let cell: MovieTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        
        cell.setupCell(withModel: cellModel)
        cell.accessoryType = .disclosureIndicator
        return cell
    }

   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        upcomingVM.openMovieDetails(index: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        
        if indexPath.row == upcomingVM.numberOfCells() - 1 {
            if !upcomingVM.isLoadingNewMovies() {
                self.upcomingVM.getNextMovies()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? MovieTableViewCell)!.movieImageView.kf.cancelDownloadTask()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

}
