//
//  Article.swift
//  RxMVVMNews
//
//  Created by Alexander Milgunov on 17.01.2021.
//

import Foundation

struct ArticlesList: Decodable {
    let articles: [Article]
}

extension ArticlesList {
    
    static var all: Resource<ArticlesList>? = {
        
        guard let url = URL(string: "http://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=27951c65db6a4dd0bb7d3d7e7f1c1fdd") else { return nil }
        
        return Resource(url: url)
    }()
    
}

struct Article: Decodable {
    let title: String
    let description: String?
}
