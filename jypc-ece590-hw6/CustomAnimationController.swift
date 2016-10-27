//
//  CustomAnimationController.swift
//  jypc-ece590-hw6
//
//  Created by Colby Stanley on 10/16/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//https://www.appcoda.com/custom-view-controller-transitions-tutorial/

import UIKit

class CustomAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.5
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView
        toViewController.view.frame = finalFrameForVC
        toViewController.view.alpha = 0.5
        containerView.addSubview(toViewController.view)
        containerView.sendSubview(toBack: toViewController.view)
        
        let snapshotView = fromViewController.view.snapshotView(afterScreenUpdates: false)
        snapshotView!.frame = fromViewController.view.frame
        containerView.addSubview(snapshotView!)
        
        fromViewController.view.removeFromSuperview()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            snapshotView!.frame = fromViewController.view.frame.insetBy(dx: fromViewController.view.frame.size.width / 2, dy: fromViewController.view.frame.size.height / 2)
            toViewController.view.alpha = 1.0
            }, completion: {
                finished in
                snapshotView!.removeFromSuperview()
                transitionContext.completeTransition(true)
        })  
    }
}
