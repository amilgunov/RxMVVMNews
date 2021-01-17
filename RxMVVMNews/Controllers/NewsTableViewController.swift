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
    private var articleListVM: ArticleListViewModel!
    
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
                    let articles = data.articles
                    self.articleListVM = ArticleListViewModel(articles)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleListVM == nil ? 0 : articleListVM.articlesVM.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Article", for: indexPath) as? ArticleTableViewCell else { fatalError() }
        
        let articleVM = self.articleListVM.articleAt(indexPath.row)
        
        articleVM.title.asDriver(onErrorJustReturn: "")
            .drive(cell.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        articleVM.description.asDriver(onErrorJustReturn: "")
            .drive(cell.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        return cell
    }
    
}
