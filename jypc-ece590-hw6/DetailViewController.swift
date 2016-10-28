//
//  DetailViewController.swift
//  jypc-ece590-hw6
//
//  Created by Jonathan Buie on 10/10/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var descriptionText: UITextView!

    @IBOutlet weak var uIImage: UIImageView!

//    var detailItem: AnyObject? {
    var studentsItem: Students? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.studentsItem {
            if let descField = self.descriptionText {
                descField.text = detail.describeMe()
                self.uIImage.image = studentsItem?.getImage()
            }
            
        }
        // Update Picture
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //self.configureView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        isPortrait()
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isPortrait() {
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
        {
            print("landscape")
            var newFrame = self.view.frame
            newFrame.size.width = self.view.frame.width * 0.5
            newFrame.size.height = self.view.frame.height
            self.view.frame = newFrame
            //self.view
            //return false
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation))
        {
            print("Portrait")
            
        }
        //return true
        
    }

}

