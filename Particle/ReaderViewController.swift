//
//  ReaderViewController.swift
//  Particle
//
//  Created by Artem Misesin on 6/25/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

protocol TranslateWordDelegate: class {
    func didTapOn(definition: Definition)
}

final class ReaderViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var emptyStateButton: UIButton!
    
    var mainViewController = SavedTableViewController()
    
    var interactor = Interactor()
    
    var isEmpty = false
    var parentTableRow = Int()
    
    lazy var slideInPresentationManager = SlideInPresentationManager()
    var selectedParagraph: ArticleContentTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEmpty {
            emptySetup()
        } else {
            basicSetup()
        }
        setupNavigation()
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    var detailItem: ArticleContent?
    
    override func viewWillDisappear(_ animated: Bool) {
        selectedParagraph?.removeSelection()
    }

    override var previewActionItems: [UIPreviewActionItem] {
        let shareAction = UIPreviewAction(title: "Share", style: .default) { (_, _) -> Void in
            print("You liked the photo")
        }
        
        let deleteAction = UIPreviewAction(title: "Delete", style: .destructive) { (_, _) -> Void in
            print("You deleted the photo")
        }
        
        return [shareAction, deleteAction]
    }
    
    private func basicSetup() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isScrollEnabled = true
        self.tabBarController?.tabBar.isHidden = true
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    private func emptySetup() {
        self.tabBarController?.tabBar.isHidden = true
        self.tableView.isScrollEnabled = false
        emptyStateLabel.text = Constants.emptyStateReader
        emptyStateLabel.textColor = Colors.headerColor
        emptyStateLabel.numberOfLines = 0
        emptyStateButton.setTitle(Constants.emptyStateReaderButton, for: .normal)
        emptyStateButton.setTitleColor(Colors.mainColor, for: .normal)
        tableView.backgroundView = emptyStateView
    }
    
    private func setupNavigation() {
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        backButton.frame = CGRect(x: 0, y: 0, width: 35, height: 44)
        let barButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = ""//self.detailItem?.title ?? ""
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func removeRecord() {
        guard let id = detailItem?.id else {
            return
        }
        mainViewController.removedArticlesRows.append(self.parentTableRow)
        ParticleHandler.shared.deleteArticle(with: id) { success in
            if let success = success {
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

extension ReaderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let detail = detailItem else {
            return 1
        }
        return detail.contentString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "paragraphCell", for: indexPath) as? ArticleContentTableViewCell,
            let item = detailItem
        else {
            preconditionFailure("Unexpectedly found nil.")
        }
        let articleParagraph = ArticleParagraph(content: item.contentString[indexPath.row], styleTag: item.tags[indexPath.row])
        cell.configure(with: articleParagraph)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.title = ""
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }, completion: nil)
            
        } else {
            if scrollView.contentOffset.y < 200 {
                self.title = ""
            } else {
                self.title = detailItem?.title ?? ""
            }
            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }, completion: nil)
        }
    }

}

extension ReaderViewController: TranslateWordDelegate {
    func didTapOn(definition: Definition) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard
            let translateVC = storyboard.instantiateViewController(withIdentifier: "translateVC") as? TranslateViewController
            else {
                preconditionFailure("Unexpectedly found nil")
        }
        translateVC.definition = definition
        translateVC.modalPresentationStyle = .overCurrentContext
        translateVC.interactor = interactor
        present(translateVC, animated: true)
    }
}

extension ReaderViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) ->
        UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
}
