//
//  ShareViewController.swift
//  AddParticleExtension
//
//  Created by Artem Misesin on 6/27/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {

    @IBOutlet weak var savedView: UIView!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var savedLabel: UILabel!
    @IBOutlet weak var savedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var savedViewWidth: NSLayoutConstraint!

    private let scaleRatio: CGFloat = 0.9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchAndSetContentFromContext()
    }
    
    func setupViews() {
        savedView.layer.cornerRadius = 9
        savedLabel.sizeToFit()
        self.resultImage.tintColor = Colors.mainColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1) { [unowned self] in
            self.resultImage.transform = CGAffineTransform(scaleX: self.scaleRatio, y: self.scaleRatio)
            self.savedViewHeight.constant *= self.scaleRatio
            self.savedViewWidth.constant *= self.scaleRatio
            
            self.view.layoutIfNeeded()
        }

        animator.startAnimation()
    }

    private func fetchAndSetContentFromContext() {
        
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            return
        }
        
        for extensionItem in extensionItems {
            guard let attachments = extensionItem.attachments as? [NSItemProvider] else {
                return
            }
            
            for attachment in attachments {
                    attachment.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, error) in
                        
                        if error == nil {
                            if let shareURL = url as? URL {
                                ParticleHandler.shared.addArticle(url: shareURL.absoluteString, creationDate: Date())
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                            })
                        }
                        
                    })
            }
        }
    }
    
}
