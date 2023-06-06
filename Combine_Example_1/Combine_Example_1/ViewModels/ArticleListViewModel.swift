//
//  ViewModel.swift
//  Combine_Example_1
//
//  Created by 이성호 on 2023/06/06.
//

import Foundation

struct ArticleListViewModel {
    
    let articles: [Article]
    
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
}
