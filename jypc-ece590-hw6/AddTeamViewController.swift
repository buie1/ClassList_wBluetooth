//
//  AddTeamViewController.swift
//  jab165-ece590-hw3
//
//  Created by Jonathan Buie on 9/19/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import UIKit

protocol AddTeamViewControllerDelegate{
    func addNew(team: TeamItem)
}

class AddTeamViewController: UIViewController {


    var delegate: AddTeamViewControllerDelegate!
    
    // MARK: IBOutlets
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var projectText: UITextField!
    
    //MARK: IBActions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        if nameText.text! == ""{
            nameText.placeholder = "Insert a team name!"
        }else{
            let team = TeamItem(name: nameText.text!, project: projectText.text!)
            delegate.addNew(team)
            // create segue programatically
            //navigationController?.popViewControllerAnimated(true)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    // MARK: View Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
