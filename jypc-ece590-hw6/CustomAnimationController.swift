//
//  CustomAnimationController.swift
//  jypc-ece590-hw6
//
//  Created by Colby Stanley on 10/16/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//https://www.appcoda.com/custom-view-controller-transitions-tutorial/

import UIKit

class CustomAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2.5
    }
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
        let containerView = transitionContext.containerView()
        toViewController.view.frame = finalFrameForVC
        toViewController.view.alpha = 0.5
        containerView!.addSubview(toViewController.view)
        containerView!.sendSubviewToBack(toViewController.view)
        
        let snapshotView = fromViewController.view.snapshotViewAfterScreenUpdates(false)
        snapshotView.frame = fromViewController.view.frame
        containerView!.addSubview(snapshotView)
        
        fromViewController.view.removeFromSuperview()
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            snapshotView.frame = CGRectInset(fromViewController.view.frame, fromViewController.view.frame.size.width / 2, fromViewController.view.frame.size.height / 2)
            toViewController.view.alpha = 1.0
            }, completion: {
                finished in
                snapshotView.removeFromSuperview()
                transitionContext.completeTransition(true)
        })  
    }
}
