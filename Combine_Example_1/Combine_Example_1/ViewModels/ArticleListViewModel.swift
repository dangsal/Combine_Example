//
//  ViewModel.swift
//  Combine_Example_1
//
//  Created by 이성호 on 2023/06/06.
//

import Combine
import Foundation


class ArticleListViewModel {
    
    @Published var articles: [Article] = []
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.articles.count
    }
    
    func articleAtIndex(_ index: Int) -> ArticleViewModel {
        let article = self.articles[index]
        
        return ArticleViewModel(article)
    }
    
    func requestArticles() {
        WebService().fetchArticles { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
