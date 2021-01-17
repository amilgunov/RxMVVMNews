//
//  NewsTableViewController.swift
//  RxMVVMNews
//
//  Created by Alexander Milgunov on 17.01.2021.
//

import UIKit
import RxSwift

class NewsTableViewController: UITableViewController {
    
    private let disposeBag = DisposeBag()
    //private let data:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        fetchNews()
    }
    
    private func fetchNews() {
        
        guard let resource = ArticlesList.all else { return }
        
        URLRequest.load(resource: resource)
            .subscribe(onNext: { data in
                if let data = data {
                    
                }
            }).disposed(by: disposeBag)
    }
    
    
}
