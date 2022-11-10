//
//  ViewController.swift
//  IMDBMovie
//
//  Created by Bedirhan Yeşilbaş on 9.11.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    let nowPlayingVC = NowPlayingViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        nowPlayingVC.navigateController = navigationController
        view.addSubview(nowPlayingVC.view)
        
    }
}

