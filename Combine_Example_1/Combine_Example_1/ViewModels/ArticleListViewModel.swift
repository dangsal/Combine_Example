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
    var cancelBag = Set<AnyCancellable>()
    
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
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=e9b514c39c5f456db8ed4ecb693b0040") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Article].self, decoder: JSONDecoder())
            .print()
            .replaceError(with: [])
            .assign(to: \.articles, on: self)
            .store(in: &self.cancelBag)
        print(articles.count)
    }
    
}
