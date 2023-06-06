//
//  WebService.swift
//  Combine_Example_1
//
//  Created by 이성호 on 2023/06/06.
//
//
import Foundation

protocol WebSerciceProtocol {
    func fetchArticles(completion: @escaping(Result<[Article], Error>) -> Void)
}

final class WebService: WebSerciceProtocol {
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=e9b514c39c5f456db8ed4ecb693b0040") else {
            completion(.failure(WebError.invaildURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(WebError.networkError))
                return
            }
            
            do {
                let articleList = try JSONDecoder().decode(ArticleList.self, from: data)
                completion(.success(articleList.articles))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}


enum WebError: Error {
    case invaildURL
    case networkError
}

