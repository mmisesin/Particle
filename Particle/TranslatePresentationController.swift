//
//  FilterPresentationController.swift
//  Particle
//
//  Created by Artem Misesin on 9/24/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit
// swiftlint:disable:next type_name
class TranslatePresentationController: UIPresentationController {
    
    let blurEffectView = UIView()
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    @objc func dismiss() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        blurEffectView.backgroundColor = .black
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = self.containerView else {
            preconditionFailure("Unexpectedly found nil")
        }
        let point = CGPoint(x: 0, y: container.frame.midY)
        let size = CGSize(width: container.frame.width, height: container.frame.height)
        return CGRect(origin: point, size: size)
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.blurEffectView.alpha = 0
        }, completion: { (_) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.blurEffectView.alpha = 0.5
        }, completion: { (_) in
            
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.layer.masksToBounds = true
        presentedView?.layer.cornerRadius = 25
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        self.presentedView?.frame = frameOfPresentedViewInContainerView
        if let container = containerView {
            blurEffectView.frame = container.bounds
        }
    }
    
}
