//
//  DisplayViewController.swift
//  jab165-ece590-hw4
//
//  Created by Jonathan Buie on 9/25/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import UIKit

class DisplayPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, AddMemberViewControllerDelegate{
    
    
    // MARK: Variables
    
    var pageViewController: UIPageViewController!
    var member: Students!
    let pages = ["DisplayDetailController","AnimationView"]
    
    var currentIndex: Int!
    private var pendingIndex: Int!
    
    
    
    // MARK: Delegate Functions
    func addMember(mem: Students){
        // Do nothing we aren't adding members in this view controller 
    }
    
    func editMember(mem:Students, _ ix:(Int,Int)){
        
    }
    
    //MARK: IBOutlets
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK: IBActions
    @IBAction func editButtonPressed(sender: AnyObject) {
    }
    
    
    
    
    
    // MARK: Page View Controller Datasource
    //http://samwize.com/2016/03/08/using-uipageviewcontroller-with-custom-uipagecontrol/
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController
        viewController: UIViewController) -> UIViewController? {
        
        
        currentIndex = pages.indexOf(viewController.restorationIdentifier!)
        if currentIndex == 0{
            return nil
        }
        //let previousIndex = abs((currentIndex - 1) % pages.count)
        let previousIndex = (currentIndex - 1 ) % pages.count
        return viewControllerAtIndex(previousIndex)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController
        viewController: UIViewController) -> UIViewController? {
        currentIndex = pages.indexOf(viewController.restorationIdentifier!)
        if currentIndex == pages.count - 1 {
            return nil
        }
        //let nextIndex = abs((currentIndex+1) % pages.count)
        let nextIndex = (currentIndex+1) % pages.count
        return viewControllerAtIndex(nextIndex)
        
    }
    
    func viewControllerAtIndex(index: Int)-> UIViewController? {
        let vc = storyboard?.instantiateViewControllerWithIdentifier(pages[index])
        
        if vc?.restorationIdentifier == "DisplayDetailController"{
            //(vc as! DisplayTextViewController).descriptionString = member.describeMe()
            if self.member != nil {
                (vc as! DetailViewController).detailItem = self.member.describeMe() as String!
            }else{
                vc as! DetailViewController
            }
        }else if vc?.restorationIdentifier == "AnimationView"{
            //(vc as! AnimateViewController).animateImage = member.getAnimate()
            (vc as! AnimateViewController).animateImage = self.member.getAnimate()
            
        }
        return vc
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        pendingIndex = pages.indexOf((pendingViewControllers.last?.restorationIdentifier)!)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControl.currentPage = index
            }
        }
    }
    
    
    //MARK: Segue functions
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditMemberSegue"{
            //let ix = sender?.tag
            let destVC = segue.destinationViewController as! AddMemberViewController
            //self.currTeam = array[ix!]
            destVC.memDelegate = self
            destVC.currMember = self.member
            destVC.toEdit = true
        }
    }
    
    
    // MARK: View Lifecycle Funcitons
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vc = storyboard?.instantiateViewControllerWithIdentifier("DetailsPageViewController"){
            self.addChildViewController(vc)
            self.view.addSubview(vc.view)
            
            self.navigationItem.setHidesBackButton(false, animated: false)

            
            pageViewController = vc as! UIPageViewController
            pageViewController.dataSource = self
            pageViewController.delegate = self
            
            pageViewController.setViewControllers([viewControllerAtIndex(0)!], direction: .Forward, animated: true, completion: nil)
            pageViewController.didMoveToParentViewController(self)
            
        }
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
