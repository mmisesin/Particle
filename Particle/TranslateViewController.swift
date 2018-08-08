//
//  TranslateViewController.swift
//  Particle
//
//  Created by Artem Misesin on 9/10/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {
    
    let cellId = "translationCell"
    
    var definition: Definition?
    
    var interactor: Interactor?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var pronunciationLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let percentThreshold: CGFloat = 0.3
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
    
    @IBAction func soundButtonTapped() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 1
        self.view.backgroundColor = .white
        setupViews()
        self.navigationController?.navigationBar.tintColor = Colors.mainColor
        self.tableView.estimatedRowHeight = 96
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func setupViews() {
        guard let definition = definition else {
            return
        }
        
        categoryLabel.text = definition.partOfSpeech ?? "Unknown"
        pronunciationLabel.text = definition.transcription ?? ""
        wordLabel.text = definition.text ?? "Unknown"
        tableView.reloadData()
    }

}

extension TranslateViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TranslateTableViewCell,
            let translation = definition?.translations[indexPath.row]
        else {
            preconditionFailure("No cell for \(cellId)")
        }
        cell.setupForTranslation(translation, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return definition?.translations.count ?? 1
    }
    
}
