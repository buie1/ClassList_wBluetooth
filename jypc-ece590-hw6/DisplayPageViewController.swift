//
//  DisplayViewController.swift
//  jab165-ece590-hw4
//
//  Created by Jonathan Buie on 9/25/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import UIKit

protocol DisplayPageViewControllerDelegate{
    func editMemberArray(_ mem:Students, _ ix:(Int,Int))
}

class DisplayPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, AddMemberViewControllerDelegate{
    
    
    // MARK: Variables
    
    var pageViewController: UIPageViewController!
    var member: Students!
    let pages = ["DisplayDetailController","AnimationView"]
    
    var memIndex: (Int,Int)!
    var currentIndex: Int!
    fileprivate var pendingIndex: Int!
    
    var editArrayDelegate: DisplayPageViewControllerDelegate!
    
    // MARK: Delegate Functions
    func addMember(_ mem: Students){
        // Do nothing we aren't adding members in this view controller 
    }
    
    func editMember(_ mem:Students, _ ix:(Int,Int)){
        self.member = mem
        self.memIndex = ix
        
        self.loadView()
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsPageViewController"){
            self.addChildViewController(vc)
            self.view.addSubview(vc.view)
            
            self.navigationItem.setHidesBackButton(false, animated: false)
            
            
            pageViewController = vc as! UIPageViewController
            pageViewController.dataSource = self
            pageViewController.delegate = self
            
            pageViewController.setViewControllers([viewControllerAtIndex(0)!], direction: .forward, animated: true, completion: nil)
            pageViewController.didMove(toParentViewController: self)
            
        }
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0

        
        
        editArrayDelegate.editMemberArray(mem, ix)
    }
    
    //MARK: IBOutlets
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK: IBActions
    @IBAction func editButtonPressed(_ sender: AnyObject) {
    }
    
    
    
    
    
    // MARK: Page View Controller Datasource
    //http://samwize.com/2016/03/08/using-uipageviewcontroller-with-custom-uipagecontrol/
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore
        viewController: UIViewController) -> UIViewController? {
        
        
        currentIndex = pages.index(of: viewController.restorationIdentifier!)
        if currentIndex == 0{
            return nil
        }
        //let previousIndex = abs((currentIndex - 1) % pages.count)
        let previousIndex = (currentIndex - 1 ) % pages.count
        return viewControllerAtIndex(previousIndex)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter
        viewController: UIViewController) -> UIViewController? {
        currentIndex = pages.index(of: viewController.restorationIdentifier!)
        if currentIndex == pages.count - 1 {
            return nil
        }
        //let nextIndex = abs((currentIndex+1) % pages.count)
        let nextIndex = (currentIndex+1) % pages.count
        return viewControllerAtIndex(nextIndex)
        
    }
    
    func viewControllerAtIndex(_ index: Int)-> UIViewController? {
        let vc = storyboard?.instantiateViewController(withIdentifier: pages[index])
        
        if vc?.restorationIdentifier == "DisplayDetailController"{
            //(vc as! DisplayTextViewController).descriptionString = member.describeMe()
            if self.member != nil {
                //(vc as! DetailViewController).detailItem = self.member.describeMe() as String!
                (vc as! DetailViewController).studentsItem = self.member as Students!
            }else{
                // ignore for now... 
                // jab165 10/26
                vc as! DetailViewController
            }
        }else if vc?.restorationIdentifier == "AnimationView"{
            (vc as! AnimateViewController).member = self.member
        }
        return vc
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = pages.index(of: (pendingViewControllers.last?.restorationIdentifier)!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControl.currentPage = index
            }
        }
    }
    
    
    //MARK: Segue functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditMemberSegue"{
            let destVC = segue.destination as! AddMemberViewController
            destVC.memberIX = memIndex
            destVC.memDelegate = self
            destVC.currMember = self.member
            destVC.toEdit = true
        }
    }
    
    
    // MARK: View Lifecycle Funcitons
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        /*if let vc = storyboard?.instantiateViewControllerWithIdentifier("DetailsPageViewController"){
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
        pageControl.currentPage = 0*/
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsPageViewController"){
            self.addChildViewController(vc)
            self.view.addSubview(vc.view)
            
            self.navigationItem.setHidesBackButton(false, animated: false)

            
            pageViewController = vc as! UIPageViewController
            pageViewController.dataSource = self
            pageViewController.delegate = self
            
            pageViewController.setViewControllers([viewControllerAtIndex(0)!], direction: .forward, animated: true, completion: nil)
            pageViewController.didMove(toParentViewController: self)
            
        }
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Stop the Music Player if it is playing when the page view controller is dismissed
    override func viewWillDisappear(_ animated: Bool) {
        MusicPlayer.sharedHelper.stop()
    }
}
