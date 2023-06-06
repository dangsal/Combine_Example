//
//  WebService.swift
//  Combine_Example_1
//
//  Created by 이성호 on 2023/06/06.
//
//
//import Foundation
//
//protocol WebServiceProtocol {
//    func fetchArticles(completion: @escaping(Result<[Article], Error>) -> Void)
//}
//
//final class WebService: WebServiceProtocol {
//    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
//        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=e9b514c39c5f456db8ed4ecb693b0040")
//        else {
//            completion(.failure(WebError.invaildURL))
//            return
//        }
//        
//        
//    }
//}
//
//enum WebError: Error {
//    case invaildURL
//    case networkError
//}
