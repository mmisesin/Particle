//
//  SavedTableViewController.swift
//  Particle
//
//  Created by Artem Misesin on 6/25/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

enum TransitionMethod {
    case segue(value: UIStoryboardSegue)
    case forceTouch(at: CGPoint)
}

enum SearchStatus {
    case nonActive
    case active(resultRange: NSRange)
}

final class SavedTableViewController: UITableViewController {
    
    private var selectedArticle: Int?
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchString: String?
    private var readerViewController: ReaderViewController?
    
    var removedArticlesRows = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchAndRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let splitVC = splitViewController else {
            preconditionFailure("Unexpectedly found nil")
        }
        clearsSelectionOnViewWillAppear = splitVC.isCollapsed
        self.tabBarController?.tabBar.isHidden = false
        self.tableView.backgroundColor = .white
        setupNavigationAndTable()
        loadArticles()
        updateTableIfNeeded()
    }

    private func loadArticles() {
        var loadedArticlesCount = 0
        DispatchQueue.global(qos: .background).async {
            for article in ParticleHandler.shared.articlesData() where !article.loaded {
                loadedArticlesCount += 1
                guard let articleURL = article.url else {
                    ParticleHandler.shared.deleteArticle(with: article.id) { _ in
                    }
                    continue
                }
                guard let url = URL(string: articleURL) else { continue }
                do {
                    let html = try String(contentsOf: url)
                    DispatchQueue.main.async {
                        self.tableView.beginUpdates()
                        article.parse(html: html)
                        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                        self.tableView.endUpdates()
                    }
                    ParticleHandler.shared.downloadThumbnail(from: html) { (data, error)  in
                        if let data = data, error == nil {
                            DispatchQueue.main.async {
                                self.tableView.beginUpdates()
                                article.saveImage(from: data)
                                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                                self.tableView.endUpdates()
                            }
                        }
                    }
                } catch {
                    continue
                }
            }
        }
        
        if ParticleHandler.shared.articlesData().isEmpty {
            self.setEmptyState()
        } else {
            self.setRegularState()
        }
        if loadedArticlesCount == 0 {
            self.refreshControl?.endRefreshing()
        }
    }
    
    private func updateTableIfNeeded() {
        var indexPaths = [IndexPath]()
        for rowIndex in removedArticlesRows {
            indexPaths.append(IndexPath(row: rowIndex, section: 0))
        }
        self.tableView.deleteRows(at: indexPaths, with: .left)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openArticle" {
            _ = prepareReaderViewController(from: .segue(value: segue))
        }
    }
    
    @objc private func refresh() {
        loadArticles()
    }
    
}

// MARK: - UITableView data source and delegate

extension SavedTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return ParticleHandler.shared.filteredArticlesData(with: self.searchString ?? "").count
        } else {
            return ParticleHandler.shared.loadedArticlesData().count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as? ArticleCellTableViewCell {
            if traitCollection.forceTouchCapability == .available {
                self.registerForPreviewing(with: self, sourceView: tableView)
            }
            let article = getArticleForCell(at: indexPath)
            if isFiltering {
                let range = getSearchRange(at: indexPath)
                cell.configure(with: article, at: indexPath.row, searchStatus: .active(resultRange: range))
            } else {
                cell.configure(with: article, at: indexPath.row, searchStatus: .nonActive)
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedArticle = indexPath.row
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.swipeDeleteAction(at: indexPath)
        let actionsConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return actionsConfig
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let resetAction = self.swipeResetAction(at: indexPath)
        let actionsConfig = UISwipeActionsConfiguration(actions: [resetAction])
        return actionsConfig
    }
    
    func swipeDeleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let article = getArticleForCell(at: indexPath)
        let action = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler: @escaping (Bool) -> Void) in
            ParticleHandler.shared.deleteArticle(with: article.id) { success in
                if success != nil {
                    self.tableView.deleteRows(at: [indexPath], with: .left)
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        }
        return action
    }
    
    func swipeResetAction(at indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler: @escaping (Bool) -> Void) in
            for article in ParticleHandler.shared.loadedArticlesData() {
                ParticleHandler.shared.deleteArticle(with: article.id) { success in
                    if let isSuccessful = success, isSuccessful {
                        self.tableView.deleteRows(at: [indexPath], with: .left)
                    }
                }
            }
            completionHandler(true)
        }
        return action
    }

    private func prepareReaderViewController(from transitionMethod: TransitionMethod) -> ReaderViewController? {
        if let finalIndexPath = getTransitionIndexPath(from: transitionMethod) {
            let object = getArticleForCell(at: finalIndexPath)
            let parseTextStart = CACurrentMediaTime()
            guard var article = ArticleParser.parseText(of: object) else {
                return nil
            }
            let parseTextEnd = CACurrentMediaTime()
            print("parseText")
            print(parseTextEnd - parseTextStart)
            article.title = object.title
            if article.contentString.isEmpty {
                readerViewController?.isEmpty = true
            } else {
                if let title = object.title {
                    article.contentString.insert(title, at: 0)
                    article.tags.insert(.h1, at: 0)
                }
            }
            readerViewController?.detailItem = article
            guard let selArticle = selectedArticle else { return nil }
            readerViewController?.parentTableRow = selArticle
            readerViewController?.mainViewController = self
            return readerViewController
        }
        return nil
    }
    
    private func getArticleForCell(at indexPath: IndexPath) -> ParticleReading {
        var indexRow = 0
        var object = ParticleReading()
        if isFiltering {
            indexRow = ParticleHandler.shared.filteredArticlesData(with: self.searchString ?? "").count - indexPath.row - 1
            object = ParticleHandler.shared.filteredArticlesData(with: self.searchString ?? "")[indexRow]
        } else {
            indexRow = ParticleHandler.shared.loadedArticlesData().count - indexPath.row - 1
            object = ParticleHandler.shared.loadedArticlesData()[indexRow]
        }
        return object
    }
    
    private func getSearchRange(at indexPath: IndexPath) -> NSRange {
        let indexRow = ParticleHandler.shared.filteredRanges.count - indexPath.row - 1
        return ParticleHandler.shared.filteredRanges[indexRow]
    }
    
    private func getTransitionIndexPath(from transition: TransitionMethod) -> IndexPath? {
        var indexPath: IndexPath?
        switch transition {
        case .segue(let value):
            guard let vc = value.destination as? ReaderViewController else { return nil }
            readerViewController = vc
            guard let iP = tableView.indexPathForSelectedRow else {
                return nil
            }
            indexPath = iP
        case .forceTouch(let location):
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "readerVC") as? ReaderViewController else { return nil }
            readerViewController = vc
            guard let iP = tableView.indexPathForRow(at: location) else {
                return nil
            }
            print(location.y)
            print(iP.row)
            indexPath = iP
        }
        return indexPath
    }
    
}

// MARK: UI Setup

extension SavedTableViewController {
    
    private func setEmptyState() {
        tableView.separatorStyle = .none
    }
    
    private func setRegularState() {
        tableView.separatorStyle = .singleLine
    }
    
    private func setupSearchAndRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search for articles"
        searchController.searchBar.tintColor = Colors.mainColor
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupNavigationAndTable() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        }
        tableView.tableFooterView = UIView()
        tableView.separatorColor = Colors.separatorColor
    }
    
}

// MARK: Search

extension SavedTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }

    var searchBarIsEmpty: Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        searchString = searchText
        tableView.reloadData()
    }

    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
}

// MARK: 3D-touch

extension SavedTableViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRow(at: location) {
            if let cell = tableView.cellForRow(at: indexPath) {
                previewingContext.sourceRect = cell.frame
            }
        }
        return prepareReaderViewController(from: .forceTouch(at: location))
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        guard let rVC = readerViewController else { return }
        tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(rVC, animated: false)
    }
}
