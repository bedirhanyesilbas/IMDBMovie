//
//  UpcomingViewController.swift
//  IMDBMovie
//
//  Created by Bedirhan Yeşilbaş on 10.11.2022.
//

import Foundation
import UIKit


class NowPlayingViewController: UIViewController{
    var nowPlayingVM = MovieViewModel(path: "movie/now_playing")
    let upcomingVC = UpcomingViewController()
    let pageControl = UIPageControl()
    var moviesCollectionView =  UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var navigateController: UINavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        nowPlayingVM.view = self
        nowPlayingVM.viewIsReady()
        nowPlayingVM.navigateController = navigateController
        upcomingVC.navigateController  = navigateController
        setUpView()
    }
}
extension NowPlayingViewController: UICollectionViewDelegate,UICollectionViewDataSource,MovieDelagete,UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlayingVM.numberOfCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellModel = nowPlayingVM.cellViewModel(index: indexPath)
        let cell: MovieCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionCell
        
        cell.setupCell(withModel: cellModel)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        nowPlayingVM.openMovieDetails(index: indexPath)
    }
    
   
    func setUpView(){
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let collectionviewlayout = UICollectionViewFlowLayout()
        collectionviewlayout.scrollDirection = .horizontal
        collectionviewlayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 300)
        collectionviewlayout.minimumInteritemSpacing = 0
        collectionviewlayout.minimumLineSpacing = 0
        collectionviewlayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        moviesCollectionView.collectionViewLayout = collectionviewlayout
        moviesCollectionView.showsHorizontalScrollIndicator = false
        moviesCollectionView.isPagingEnabled = true
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.8)
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.layer.zPosition = 50
        pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .touchUpInside)
        view.addSubview(pageControl)
        view.addSubview(moviesCollectionView)
        view.addSubview(upcomingVC.view)
        moviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        moviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        moviesCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        moviesCollectionView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        upcomingVC.view.translatesAutoresizingMaskIntoConstraints = false
        upcomingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        upcomingVC.view.topAnchor.constraint(equalTo: view.topAnchor,constant: 300).isActive = true
        upcomingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        upcomingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        pageControl.centerXAnchor.constraint(equalTo: moviesCollectionView.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: moviesCollectionView.bottomAnchor,constant: -15).isActive = true
        
    }
    @objc func refreshMovies() {
        nowPlayingVM.resetMovies()
    }
    func setupInitialState() {
        moviesCollectionView.register(MovieCollectionCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    func updateMoviesList() {
        DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
            self.pageControl.numberOfPages = self.nowPlayingVM.numberOfCells()
        }
    }
    func showError(_ errorMessage: String) {
        DispatchQueue.main.async {
            
            let okAction = AlertAction(onSelect: {}, name: "OK", style: .default)
            let alert = UIAlertController(info: AlertInfo(title: "Error", message: errorMessage, actions: [okAction]))
            self.present(alert, animated: true)
        }
    }
    
    func isLoadingMovies(loading status: Bool) {
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize.init(width: view.frame.width, height: 300)
        }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffsetX = Int(self.moviesCollectionView.contentOffset.x)
        let wholeWidth = Int(self.moviesCollectionView.bounds.width)
        pageControl.currentPage = contentOffsetX /  wholeWidth
    }
    @objc func pageControlTapHandler(sender:UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        moviesCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}
