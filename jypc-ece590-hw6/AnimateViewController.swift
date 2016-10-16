//
//  AnimateViewController.swift
//  jab165-ece590-hw4
//
//  Created by Jonathan Buie on 9/26/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import UIKit

class AnimateViewController: UIViewController {

    var member: Students!
    var animateImage: Bool!
    var object: UIImageView!
    var location = CGPoint(x: 0, y: 0)
    
    @IBOutlet weak var animateText: UITextView!
    let pics = ["bulls","bears","kanye","lego","netflix","sox","taco","archer","shield","salsa","bball"]
    
    
    // MARK: Code for animations
    // ref: http://mathewsanders.com/animations-in-swift-part-two/
    override func viewWillAppear(animated: Bool) {
        if animateImage == nil || !animateImage {
        animateText.hidden = false
        UIView.animateWithDuration(1.0, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.animateText.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)
        }else{
            animateText.hidden = true
            
            
            switch member.getName() {
            case "Jonathan Buie":
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
                break
            case "Colby Stanley":
                animateGuitarandNote()
                drawRectangle()
                MusicPlayer.sharedHelper.playBackgroundMusic()
                break
            case "Young-Hoon Kim":
                drawSun()
                drawCloud()
                drawCoaster()
                break
            default:
                animateText.hidden = false
                UIView.animateWithDuration(1.0, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.animateText.center.x += self.view.bounds.width
                    self.view.layoutIfNeeded()
                    }, completion: nil)
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
    
    
    
    // MARK: Code for YH's Animations
    func drawSun() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 50,y: 100), radius: CGFloat(10), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.yellowColor().CGColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.blackColor().CGColor
        //you can change the line width
        shapeLayer.lineWidth = 3.0
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func drawCloud() {
        // first set up an object to animate
        
        for _ in 0...8{
            let cloud = UIImageView()
            cloud.frame = CGRect(x: 55, y: 50, width: 70, height: 30)
            cloud.image = UIImage(named: "simple_cloud")
            
            // add the square to the screen
            self.view.addSubview(cloud)
            
            // randomly create a value between 0.0 and 100.0
            let randomYOffset = CGFloat( arc4random_uniform(100))
            
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: 0 ,y: 100 + randomYOffset))
            path.addLineToPoint(CGPoint(x: 350, y: 100 + randomYOffset))
            
            
            
            // create a new CAKeyframeAnimation that animates the objects position
            let anim = CAKeyframeAnimation(keyPath: "position")
            
            // set the animations path to our bezier curve
            anim.path = path.CGPath
            
            // set some more parameters for the animation
            // this rotation mode means that our object will rotate so that it's parallel to whatever point it is currently on the curve
            anim.rotationMode = kCAAnimationRotateAuto
            anim.repeatCount = Float.infinity
            anim.duration = Double(arc4random_uniform(40)+50) / 10
            
            // stagger each animation by a random value
            anim.timeOffset = Double(arc4random_uniform(300))
            
            // we add the animation to the squares 'layer' property
            cloud.layer.addAnimation(anim, forKey: "animate position along path")
        }
    }
    
    func drawCoaster() {
        // first set up an object to animate
        // we'll use a familiar red square
        let track = UIImageView()
        track.frame = CGRect(x: 0, y: 250, width: 350, height: 100)
        track.image = UIImage(named: "rollerCoasterTrack")
        self.view.addSubview(track)
        
        let square = UIImageView()
        square.frame = CGRect(x: 55, y: 300, width: 20, height: 20)
        square.image = UIImage(named: "cart")
        
        // add the square to the screen
        self.view.addSubview(square)
        
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 30,y: 320))
        path.addQuadCurveToPoint(CGPoint(x: 110, y:320), controlPoint: CGPoint(x: 68, y: 185))
        path.moveToPoint(CGPoint(x: 111, y: 320))
        path.addQuadCurveToPoint(CGPoint(x: 180, y: 320), controlPoint: CGPoint(x: 145, y: 300))
        path.moveToPoint(CGPoint(x: 180, y: 320))
        path.addQuadCurveToPoint(CGPoint(x: 210, y: 280), controlPoint: CGPoint(x: 220, y: 310))
        path.moveToPoint(CGPoint(x: 210, y: 280))
        path.addQuadCurveToPoint(CGPoint(x: 245, y: 320), controlPoint: CGPoint(x: 210, y: 330))
        path.moveToPoint(CGPoint(x: 245, y: 320))
        path.addQuadCurveToPoint(CGPoint(x: 330, y: 320), controlPoint: CGPoint(x: 260, y: 190))
        
        
        
        // create a new CAKeyframeAnimation that animates the objects position
        let anim = CAKeyframeAnimation(keyPath: "position")
        
        // set the animations path to our bezier curve
        anim.path = path.CGPath
        
        // set some more parameters for the animation
        // this rotation mode means that our object will rotate so that it's parallel to whatever point it is currently on the curve
        anim.rotationMode = kCAAnimationRotateAuto
        anim.repeatCount = Float.infinity
        anim.duration = 5.0
        
        // we add the animation to the squares 'layer' property
        square.layer.addAnimation(anim, forKey: "animate position along path")

    }
    //Mark: Code for CS's animations
    func animateGuitarandNote(){
        
        //Add a guitar image and a rotation animation
        //A full rotation in rads
        let fullRotation = CGFloat(M_PI * 2)
        let guitar = UIImageView()
        //Set the size of the guitar
        guitar.frame = CGRect(x: 40, y:157, width: 240, height: 232)
        guitar.image = UIImage(named: "guitar")
        
        //Add the guitar image view as a sub view of the animate view controller's view
        self.view.addSubview(guitar)
        
        //Create the guitar animation
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform.rotation.z"
        animation.duration = 2.44897959184
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.repeatCount = Float.infinity
        animation.values = [0, fullRotation/4, fullRotation/2, fullRotation*3/4, fullRotation,]
        
        //Add the animation to the guitar image view layer
        guitar.layer.addAnimation(animation, forKey: "rotate")
        
        
        //Add a note image and a translation animation
        let note = UIImageView()
        note.frame = CGRect(x: 6, y: 412, width: 77, height: 55)
        note.image = UIImage(named: "musicnote")
        
        //Add the music note image view as a sub view of the animate view controller's view
        self.view.addSubview(note)
        let noteAnimation = CAKeyframeAnimation()
        noteAnimation.keyPath = "position.x"
        noteAnimation.values = [0, 25, 75, 150, 300, 150, 75, 25, 0]
        noteAnimation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
        noteAnimation.duration = 2.44897959184
        noteAnimation.repeatCount = Float.infinity
        noteAnimation.additive = true
        
        //Add the animation to the music note image view layer
        note.layer.addAnimation(noteAnimation, forKey: "shake")
    }
    
    func drawRectangle(){
        //Draw a red rectangle
        //Create an image view that will contain the rectange
        let image = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y:0), size: CGSize(width: 325, height: 100)))
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 325, height: 150), opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 150)
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextMoveToPoint(context, 0, 100)
        CGContextAddLineToPoint(context, 325, 100)
        CGContextStrokePath(context)
        let rectangle = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //set the image view image to the drawn rectangle
        image.image = rectangle
        self.view.addSubview(image)
    }
    
}