//
//  ArticleViewModel.swift
//  Combine_Example_1
//
//  Created by 이성호 on 2023/06/06.
//

import Foundation

struct ArticleViewModel {
    
    private let article: Article
    
    init(_ article: Article) {
        self.article = article
    }
    
    var title: String? {
        return self.article.title
    }
    
    var description: String? {
        return self.article.description
    }
}
