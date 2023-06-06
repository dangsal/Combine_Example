//
//  ViewController.swift
//  Combine_Example_1
//
//  Created by 이성호 on 2023/06/06.
//

import Combine
import UIKit

final class NewsViewController: UIViewController {
    
    // MARK: - ui components
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    // MARK: - property
    
    private var articleListViewModel: ArticleListViewModel? = ArticleListViewModel()
    private var cancelBag = Set<AnyCancellable>()

    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.setupDelegation()
        self.setupNavigationBar()
        self.setBinding()
        self.fetchArticles()
        
    }

    // MARK: - func
    
    private func setupLayout() {
        self.view.addSubview(self.tableView)
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.heightAnchor.constraint(equalToConstant: 500).isActive = true
    }
    
    private func setupDelegation() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "News"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func fetchArticles() {
        articleListViewModel?.requestArticles()
    }
    
    private func setBinding() {
        self.articleListViewModel?.$articles
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &self.cancelBag)
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let articleListViewModel = self.articleListViewModel else { return 0 }
        return articleListViewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleTableViewCell
        
        guard let articleListViewModel = self.articleListViewModel else { return UITableViewCell() }
        let articleViewModel = articleListViewModel.articleAtIndex(indexPath.row)
        cell.configurelable(article: articleViewModel)
        return cell
    }
}

extension NewsViewController: UITableViewDelegate { }

