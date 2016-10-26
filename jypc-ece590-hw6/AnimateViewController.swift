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
    override func viewWillAppear(_ animated: Bool) {
        if animateImage == nil || !animateImage {
        animateText.isHidden = false
        UIView.animate(withDuration: 1.0, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.animateText.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            animateText.isHidden = true
            
            let fullName: String = member.getName()
            print("Name to search is \(fullName)")
            switch member.getName() {
            case "Peter Murphy":
                drawSnowboarder()
                break;
            case "Jonathan Buie":
                for ix in 0...(pics.count-1) {
                    //let ix = arc4random_uniform(UInt32(pics.count))
                    let im = UIImageView(image: UIImage(named: pics[ix]))
                    self.view.addSubview(im)
                    let randomYOffset = CGFloat (arc4random_uniform(200))
                    
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x:16, y:239 + randomYOffset))
                    path.addCurve(to: CGPoint(x: 301, y: 239 + randomYOffset),
                                         controlPoint1: CGPoint(x:136, y:373 + randomYOffset),
                                         controlPoint2: CGPoint(x:178, y:110 + randomYOffset))
                    
                    //create the animation
                    let anim = CAKeyframeAnimation(keyPath: "position")
                    anim.path = path.cgPath
                    anim.rotationMode = kCAAnimationRotateAuto
                    anim.repeatCount = Float.infinity
                    anim.duration = Double(arc4random_uniform(40)+30) / 10
                    anim.timeOffset = Double(arc4random_uniform(290))
                    
                    
                    im.layer.add(anim, forKey: "animate postion along path")
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
                animateText.isHidden = false
                UIView.animate(withDuration: 1.0, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.animateText.center.x += self.view.bounds.width
                    self.view.layoutIfNeeded()
                    }, completion: nil)
            }

        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first
        
        location  = touch.location(in: self.view)
        object.center = location
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first
        location  = touch.location(in: self.view)
        object.center = location
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let imageSize = CGSize(width: 40, height: 40)
        object = UIImageView(frame: CGRect(origin: CGPoint(x: 50, y:50), size: imageSize))
        object.center = CGPoint(x: 160, y: 330)
        self.view.addSubview(object)
        let image = drawCustomImage(imageSize)
        object.image = image
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawCustomImage(_ size: CGSize) -> UIImage {
        // Setup our context
        let bounds = CGRect(origin: CGPoint.zero, size: size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        
        // Setup complete, do drawing here
        context?.setStrokeColor(UIColor.blue.cgColor)
        context?.setLineWidth(2.0)
        
        context?.stroke(bounds)
        
        context?.beginPath()
        context?.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
        context?.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        context?.move(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        context?.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        context?.strokePath()
        
        // Drawing complete, retrieve the finished image and cleanup
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    
    // MARK: Code for YH's Animations
    func drawSun() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 50,y: 100), radius: CGFloat(10), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.yellow.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.black.cgColor
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
            path.move(to: CGPoint(x: 0 ,y: 100 + randomYOffset))
            path.addLine(to: CGPoint(x: 350, y: 100 + randomYOffset))
            
            
            
            // create a new CAKeyframeAnimation that animates the objects position
            let anim = CAKeyframeAnimation(keyPath: "position")
            
            // set the animations path to our bezier curve
            anim.path = path.cgPath
            
            // set some more parameters for the animation
            // this rotation mode means that our object will rotate so that it's parallel to whatever point it is currently on the curve
            anim.rotationMode = kCAAnimationRotateAuto
            anim.repeatCount = Float.infinity
            anim.duration = Double(arc4random_uniform(40)+50) / 10
            
            // stagger each animation by a random value
            anim.timeOffset = Double(arc4random_uniform(300))
            
            // we add the animation to the squares 'layer' property
            cloud.layer.add(anim, forKey: "animate position along path")
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
        path.move(to: CGPoint(x: 30,y: 320))
        path.addQuadCurve(to: CGPoint(x: 110, y:320), controlPoint: CGPoint(x: 68, y: 185))
        path.move(to: CGPoint(x: 111, y: 320))
        path.addQuadCurve(to: CGPoint(x: 180, y: 320), controlPoint: CGPoint(x: 145, y: 300))
        path.move(to: CGPoint(x: 180, y: 320))
        path.addQuadCurve(to: CGPoint(x: 210, y: 280), controlPoint: CGPoint(x: 220, y: 310))
        path.move(to: CGPoint(x: 210, y: 280))
        path.addQuadCurve(to: CGPoint(x: 245, y: 320), controlPoint: CGPoint(x: 210, y: 330))
        path.move(to: CGPoint(x: 245, y: 320))
        path.addQuadCurve(to: CGPoint(x: 330, y: 320), controlPoint: CGPoint(x: 260, y: 190))
        
        
        // create a new CAKeyframeAnimation that animates the objects position
        let anim = CAKeyframeAnimation(keyPath: "position")
        
        // set the animations path to our bezier curve
        anim.path = path.cgPath
        
        // set some more parameters for the animation
        // this rotation mode means that our object will rotate so that it's parallel to whatever point it is currently on the curve
        anim.rotationMode = kCAAnimationRotateAuto
        anim.repeatCount = Float.infinity
        anim.duration = 5.0
        
        // we add the animation to the squares 'layer' property
        square.layer.add(anim, forKey: "animate position along path")

    }
   
    //Mark: Draw Peter's stuff
    func drawSnowboarder() {
        
            self.parent?.view.backgroundColor = UIColor.blue
            let snowBall = UIView()
            let snowBall1 = UIView()
            let snowBall2 = UIView()
            let snowBall3 = UIView()
            let snowBall4 = UIView()
            let snowBall5 = UIView()
            //aboutLabel.hidden = true
            //descriptionPageText.hidden = true
            //profilePic.hidden = true
            // set background color to blue
            let delay = 0.0 // delay will be 0.0 seconds (e.g. nothing)
            let delaySnowball = 4.0
            let options = UIViewAnimationOptions() // change the timing curve to `ease-in ease-out`
            snowBall.backgroundColor = UIColor.lightGray
            snowBall1.backgroundColor = UIColor.lightGray
            snowBall2.backgroundColor = UIColor.lightGray
            snowBall3.backgroundColor = UIColor.lightGray
            snowBall4.backgroundColor = UIColor.lightGray
            snowBall5.backgroundColor = UIColor.lightGray
            let duration = 5.0
            let size:CGFloat = 100
            //the animations can be found at the following tutorial:
            //http://mathewsanders.com/prototyping-iOS-iPhone-iPad-animations-in-swift/
            // set frame (position and size) of the square
            // iOS coordinate system starts at the top left of the screen
            // so this square will be at top left of screen, 50x50pt
            // CG in CGRect stands for Core Graphics
            snowBall.frame = CGRect(x: 270, y: 300, width: 75, height: 75)
            snowBall.layer.cornerRadius = 25;
            snowBall1.frame = CGRect(x: 250, y: 300, width: 50, height: 50)
            snowBall1.layer.cornerRadius = 25;
            snowBall2.frame = CGRect(x: 260, y: 300, width: 60, height: 60)
            snowBall2.layer.cornerRadius = 25;
            snowBall3.frame = CGRect(x: 275, y: 300, width: 50, height: 50)
            snowBall3.layer.cornerRadius = 25;
            snowBall4.frame = CGRect(x: 255, y: 300, width: 55, height: 55)
            snowBall4.layer.cornerRadius = 25;
            snowBall5.frame = CGRect(x: 270, y: 300, width: 45, height: 45)
            snowBall5.layer.cornerRadius = 25;
            // finally, add the square to the screen
            
            let snowboarder = UIImageView()
            snowboarder.image = UIImage(named: "snowboardingSprite.png")
            snowboarder.frame = CGRect(x: 50, y: 120, width: size-70, height: size-70)
            self.view.addSubview(snowboarder)
            UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
                snowboarder.frame = CGRect(x: 320-50, y: 300, width: size, height: size)
                }, completion: { animationFinished in
                    // remove the fish
                    snowboarder.removeFromSuperview()
            })
            self.view.addSubview(snowBall)
            self.view.addSubview(snowBall1)
            self.view.addSubview(snowBall2)
            self.view.addSubview(snowBall3)
            self.view.addSubview(snowBall4)
            self.view.addSubview(snowBall5)
            UIView.animate(withDuration: duration-3, delay: delaySnowball, options: options, animations: {
                snowBall.frame = CGRect(x: 50, y: 120, width: 30, height: 30)
                snowBall1.frame = CGRect(x: 50, y: 140, width: 20, height: 20)
                snowBall2.frame = CGRect(x: 50, y: 170, width: 40, height: 40)
                snowBall3.frame = CGRect(x: 200, y: 200, width: 20, height: 20)
                snowBall4.frame = CGRect(x: 100, y: 220, width: 40, height: 40)
                snowBall5.frame = CGRect(x: 50, y: 120, width: 25, height: 25)
                }, completion: { animationFinished in
                    snowBall.removeFromSuperview()
                    snowBall1.removeFromSuperview()
                    snowBall2.removeFromSuperview()
                    snowBall3.removeFromSuperview()
                    snowBall4.removeFromSuperview()
                    snowBall5.removeFromSuperview()
            })
            
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
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.repeatCount = Float.infinity
        animation.values = [0, fullRotation/4, fullRotation/2, fullRotation*3/4, fullRotation,]
        
        //Add the animation to the guitar image view layer
        guitar.layer.add(animation, forKey: "rotate")
        
        
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
        noteAnimation.isAdditive = true
        
        //Add the animation to the music note image view layer
        note.layer.add(noteAnimation, forKey: "shake")
    }
    
    func drawRectangle(){
        //Draw a red rectangle
        //Create an image view that will contain the rectange
        let image = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y:0), size: CGSize(width: 325, height: 100)))
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 325, height: 150), opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(150)
        context?.setStrokeColor(UIColor.red.cgColor)
        context?.move(to: CGPoint(x: 0, y: 100))
        context?.addLine(to: CGPoint(x: 325, y: 100))
        context?.strokePath()
        let rectangle = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //set the image view image to the drawn rectangle
        image.image = rectangle
        self.view.addSubview(image)
    }
    


    

}
