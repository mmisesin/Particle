//
//  PresentationAnimator.swift
//  Particle
//
//  Created by Artem Misesin on 9/24/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class PresentationAnimator: NSObject {
    
    let isPresentation: Bool
    
    init(isPresentation: Bool) {
        self.isPresentation = isPresentation
        super.init()
    }

}

extension PresentationAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1
        let key = isPresentation ? UITransitionContextViewControllerKey.to
            : UITransitionContextViewControllerKey.from
        
        guard let transitionController = transitionContext.viewController(forKey: key) else {
            preconditionFailure("Transition controller is nil")
        }
        let controller = transitionController
        
        // 2
        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }
        
        // 3
        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        dismissedFrame.origin.y = presentedFrame.height
        
        // 4
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        // 5
        let animationDuration = transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame
        UIView.animate(withDuration: animationDuration, animations: {
            controller.view.frame = finalFrame
        }, completion: { (finished) in
            transitionContext.completeTransition(finished)
        })
    }
}
