//
//  SlideInPresentationManager.swift
//  Particle
//
//  Created by Artem Misesin on 9/24/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class SlideInPresentationManager: NSObject {
    
}

extension SlideInPresentationManager: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        let presentationController = TranslatePresentationController(presentedViewController: presented,
                                                                  presenting: presenting)
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentationAnimator(isPresentation: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return PresentationAnimator(isPresentation: false)
    }
}
