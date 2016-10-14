//
//  AnimateViewController.swift
//  jab165-ece590-hw4
//
//  Created by Jonathan Buie on 9/26/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import UIKit

class AnimateViewController: UIViewController {

    var animateImage: Bool!
    var object: UIImageView!
    var location = CGPoint(x: 0, y: 0)
    
    @IBOutlet weak var animateText: UITextView!
    let pics = ["bulls","bears","kanye","lego","netflix","sox","taco","archer","shield","salsa","bball"]
    
    
    // MARK: Code for animations
    // ref: http://mathewsanders.com/animations-in-swift-part-two/
    override func viewWillAppear(animated: Bool) {
        if animateImage == nil || !animateImage {
        UIView.animateWithDuration(1.0, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.animateText.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)
        }else{
            animateText.hidden = true
            
            
            
            for ix in 0...(pics.count-1) {
                //let ix = arc4random_uniform(UInt32(pics.count))
                let im = UIImageView(image: UIImage(named: pics[ix]))
                self.view.addSubview(im)
                let randomYOffset = CGFloat (arc4random_uniform(200))
                
                let path = UIBezierPath()
                path.moveToPoint(CGPoint(x:16, y:239 + randomYOffset))
                path.addCurveToPoint(CGPoint(x: 301, y: 239 + randomYOffset),
                                     controlPoint1: CGPoint(x:136, y:373 + randomYOffset),
                                     controlPoint2: CGPoint(x:178, y:110 + randomYOffset))
                
                //create the animation
                let anim = CAKeyframeAnimation(keyPath: "position")
                anim.path = path.CGPath
                anim.rotationMode = kCAAnimationRotateAuto
                anim.repeatCount = Float.infinity
                anim.duration = Double(arc4random_uniform(40)+30) / 10
                anim.timeOffset = Double(arc4random_uniform(290))
                
                
                im.layer.addAnimation(anim, forKey: "animate postion along path")
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch! = touches.first
        
        location  = touch.locationInView(self.view)
        object.center = location
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch! = touches.first
        location  = touch.locationInView(self.view)
        object.center = location
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let imageSize = CGSize(width: 40, height: 40)
        object = UIImageView(frame: CGRect(origin: CGPoint(x: 50, y:50), size: imageSize))
        object.center = CGPointMake(160, 330)
        self.view.addSubview(object)
        let image = drawCustomImage(imageSize)
        object.image = image
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawCustomImage(size: CGSize) -> UIImage {
        // Setup our context
        let bounds = CGRect(origin: CGPoint.zero, size: size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        
        // Setup complete, do drawing here
        CGContextSetStrokeColorWithColor(context, UIColor.blueColor().CGColor)
        CGContextSetLineWidth(context, 2.0)
        
        CGContextStrokeRect(context, bounds)
        
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, CGRectGetMinX(bounds), CGRectGetMinY(bounds))
        CGContextAddLineToPoint(context, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))
        CGContextMoveToPoint(context, CGRectGetMaxX(bounds), CGRectGetMinY(bounds))
        CGContextAddLineToPoint(context, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
        CGContextStrokePath(context)
        
        // Drawing complete, retrieve the finished image and cleanup
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
