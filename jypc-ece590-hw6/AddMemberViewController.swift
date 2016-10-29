//
//  AddMemberViewController.swift
//  jab165-ece590-hw3
//
//  Created by Jonathan Buie on 9/19/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import UIKit
import MobileCoreServices

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



protocol AddMemberViewControllerDelegate{
    func addMember(_ mem: Students)
    func editMember(_ mem:Students, _ ix:(Int,Int))
}

class AddMemberViewController: UIViewController, UITextFieldDelegate {
    
    var toEdit:Bool!
    var currMember:Students!
    var memberIX: (Int,Int)!
    
    var memDelegate: AddMemberViewControllerDelegate!
    
    var imagePicker: UIImagePickerController!
    var activeTextField: UITextField!
    
    // MARK: IBOutlets
    @IBOutlet weak var titleNavBar: UINavigationItem!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var hTownText: UITextField!
    @IBOutlet weak var teamText: UITextField!
    @IBOutlet weak var hobbyText: UITextField!
    @IBOutlet weak var languageText: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var genderSeg: UISegmentedControl!
    @IBOutlet weak var programSeg: UISegmentedControl!
    @IBOutlet weak var displayTextView: UITextView!
    @IBOutlet weak var receiveBluetoothButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //@IBOutlet weak var saveEditButton: UIBarButtonItem!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: IBActions
    
    @IBAction func receiveBluetoothButtonPressed(_ sender: Any) {
        print("Receiving Bluetooth Info")
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func refreshButtonPressed(_ sender: AnyObject) {
        let mem = getCurrentFieldData()
        if mem != nil && (currMember != nil) && (currMember.describeMe() != mem?.describeMe()){
            displayTextView?.textColor = UIColor.black
            displayTextView?.text = "Preview: " + mem!.describeMe()
        }else if currMember == nil && mem != nil {
            // We're adding a new member want to preview the data
            displayTextView?.textColor = UIColor.black
            displayTextView?.text = "Preview: " + mem!.describeMe()
        }
        
    }
    /*@IBAction func displayButtonPressed(sender: AnyObject) {
        delegate.sendString(currMember!.describeMe())
        performSegueWithIdentifier("DisplayInfoSegue", sender: sender)
    }*/

    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if(nameText?.text == "" || hTownText?.text == "" || teamText?.text == ""){
            displayTextView?.text = "Please fill in all fields"
            displayTextView?.textColor = UIColor.red
        }else{
            let fname = nameText?.text
            let htown = hTownText?.text
            let teamN = teamText?.text
            let im = userImageView?.image
            var hob = hobbyText?.text?.components(separatedBy: ", ")
            if hob![0] == ""{
                hob = [String]()
            }
            var lang = languageText?.text?.components(separatedBy: ",")
            if lang![0] == ""{
                lang = [String]()
            }
        
            var gen:Bool
            switch genderSeg.selectedSegmentIndex {
            case 0:
                gen = true
            case 1:
                gen = false
            default:
                gen = false
            }
        
            var deg:String?
            switch programSeg.selectedSegmentIndex {
            case 0:
                deg = "Undergraduate student"
            case 1:
                deg = "Masters student"
            case 2:
                deg = "PhD student"
            case 3:
                deg = "Alumni"
            case 4:
                deg = "Honorary graduate"
            default:
                deg = "Masters student"
            }
            
            
            // MARK: Edit to use the new initilizer
            // jab165 10/26/2016
            
            
            
            let mem = Students(fname!, teamN!, htown!, gen ,deg!, nil,lang!,hob!)
            
            if im!.isSameImage(UIImage(named:"add_picture")!){
                mem.setImage(UIImage(named:"baby")!)
            }else{
                mem.setImage(im!)
            }
            //mem.setLanguages(lang!)
            if toEdit!{
                memDelegate.editMember(mem, memberIX)
            }else{
                memDelegate.addMember(mem)
            }
            //navigationController?.popViewControllerAnimated(true)
            self.dismiss(animated: true, completion: nil)

        }
    }
    
    func getCurrentFieldData() -> Students? {
        if(nameText?.text == "" || hTownText?.text == "" || teamText?.text == ""){
            displayTextView?.text = "Please fill in all fields"
            displayTextView?.textColor = UIColor.red
            return nil
        }else{
            let fname = nameText?.text
            let htown = hTownText?.text
            let teamN = teamText?.text
            var hob = hobbyText?.text?.components(separatedBy: ", ")
            if hob![0] == ""{
                hob = [String]()
            }
            var lang = languageText?.text?.components(separatedBy: ",")
            if lang![0] == ""{
                lang = [String]()
            }
            
            var gen:Bool
            switch genderSeg.selectedSegmentIndex {
            case 0:
                gen = true
            case 1:
                gen = false
            default:
                gen = false
            }
            
            var deg:String?
            switch programSeg.selectedSegmentIndex {
            case 0:
                deg = "Undergraduate student"
            case 1:
                deg = "Masters student"
            case 2:
                deg = "PhD student"
            case 3:
                deg = "Alumni"
            case 4:
                deg = "Honorary graduate"
            default:
                deg = "Masters student"
            }
            
            // MARK: change to use the new initializer 
            // jab165 10/26/2016
            
            let temp = Students(fname!, teamN!, htown!, gen ,deg!, nil,lang!,hob!)
            temp.setLanguages(lang!)
            return temp
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // MARK: Scroll View if Keyboard Use
        /*
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddMemberViewController.keyboardUP(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddMemberViewController.keyboardDown(_:)), name: UIKeyboardWillHideNotification, object: nil)
        */
        
        // MARK: Make UIImage clickable like a button
        let imView = userImageView!
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action:#selector(AddMemberViewController.imageTapped(_:)))
        imView.isUserInteractionEnabled = true
        imView.addGestureRecognizer(tapGestureRecognizer)
        
        if toEdit!{
            titleNavBar.title = "Edit Member"
            //saveEditButton.title = "Done"
            
            
            //MARK: WE do names differently now!
            
            /*
            fNameText?.text = currMember?.getFirstName()
            if (currMember.getMiddleName() != nil){
                mNameText?.text = currMember?.getMiddleName()
            }
            lNameText?.text = currMember?.getLastName()
            hTownText?.text = currMember?.getHometown()
            if currMember?.getSex() == true{
                genderSeg.selectedSegmentIndex = 0
            }else if currMember?.getSex() == false{
                genderSeg.selectedSegmentIndex = 1
            }else{
                genderSeg.selectedSegmentIndex = 1
            }
            */
            
            
            //MARK: Rename these fields program-> degree
            
            
            /*
             
            if currMember?.getProgram() == "Undergraduate student"{
                programSeg.selectedSegmentIndex = 0
            }else if currMember?.getProgram() == "Masters student"{
                programSeg.selectedSegmentIndex = 1
            }else if currMember?.getProgram() == "PhD student"{
                programSeg.selectedSegmentIndex = 2
            }else if currMember?.getProgram() == "Alumni"{
                programSeg.selectedSegmentIndex = 3
            }else{
                programSeg.selectedSegmentIndex = 4
            }
            */
            setDegreeSegment(student: currMember)
            nameText?.text = currMember.getName()
            teamText?.text = currMember.getTeam()
            hTownText?.text = currMember?.getFrom()
            if currMember?.getSex() == true{
                genderSeg.selectedSegmentIndex = 0
            }else if currMember?.getSex() == false{
                genderSeg.selectedSegmentIndex = 1
            }else{
                genderSeg.selectedSegmentIndex = 1
            }
            if currMember?.getHobbies().count > 0 {
                hobbyText?.text = currMember?.getHobbies().joined(separator: ", ")
            }
            if currMember?.getLanguages().count > 0 {
                languageText?.text = currMember?.getLanguages().joined(separator: ", ")
            }
            
            //Select the correct segments and Image
            if (currMember?.getImage() != nil){
                imView.image = currMember?.getImage()
            }else{
                imView.image = UIImage(named:"default")
            }
            displayTextView?.text = currMember?.describeMe()
            
        }else{
            titleNavBar.title = "Add Member"
            //saveEditButton.title = "Save"
        }
        
    }
    
    func setDegreeSegment(student: Students){
        let currDegree:Degree = student.getDegree()
        if currDegree == .UG{
            programSeg.selectedSegmentIndex = 0
        }else if  currDegree == .MS{
            programSeg.selectedSegmentIndex = 1
        }else if currDegree == .PHD{
            programSeg.selectedSegmentIndex = 2
        }else if currDegree == .Alum{
            programSeg.selectedSegmentIndex = 3
        }else if currDegree == .honorary{
            programSeg.selectedSegmentIndex = 4
        }else{
            programSeg.selectedSegmentIndex = 0
        }

    }
    
        
    // Mark: Functions to Scroll View Up when keyboard is shown
    
    /*
        NOTIFICATION METHODS CAN BE USED TO OBTAIN KEYBOARD FRAME SIZE 
        HAVE NOT FIGURED OUT HOW TO PASS THIS FIELD ONTO OTHER METHODS 
        OR HOW TO DETERMINE WHICH TEXTFIELD IS ACTIVE (OUTSIDE OF USING DELEGATE FUNCTIONS)
    */
    /*
    func keyboardUP(notification: NSNotification){
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()) != nil {
            let info = notification.userInfo!
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            
            if(activeTextField == languageText || activeTextField == hobbyText){
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.topConstraint.constant -= keyboardFrame.size.height
                self.bottomConstraint.constant = keyboardFrame.size.height
            })
            }
        }
    }

    func keyboardDown(notification: NSNotification){
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()) != nil {
            let info = notification.userInfo!
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            
            if(activeTextField == languageText || activeTextField == hobbyText){
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.topConstraint.constant += keyboardFrame.size.height
                self.bottomConstraint.constant -= keyboardFrame.size.height
            })
            }
        }
    }
    */
    
    
    func startIndicator( ){
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func endIndicator(){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == hobbyText || textField == languageText){
            self.topConstraint.constant -= 65
            self.bottomConstraint.constant -= 65
            nameText.isHidden = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == hobbyText || textField == languageText){
            self.topConstraint.constant += 65
            self.bottomConstraint.constant += 65
        }
        nameText.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
 
    func imageTapped(_ img: AnyObject){
        //Do Stuff
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
        }else{
            // If camera not available use photo Library
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: imagePicker.sourceType)!
        
        self.present(imagePicker, animated:true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        currMember?.setImage((userImageView?.image)!)
    }
    
    
    // MARK: Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplaySegue" {
            let destVC  = segue.destination as! DisplayPageViewController
            destVC.member = currMember
            
        }
    }
    
}
extension AddMemberViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)
        print("User canceled the camera/ photo library")
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == (kUTTypeImage as String){
            // a photo was taken
            self.userImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            self.currMember?.setImage((info[UIImagePickerControllerOriginalImage] as? UIImage)!)
        }else{
            // a video was taken :/
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UIImage{
    func isSameImage(_ image: UIImage)-> Bool {
        let im1: Data = UIImagePNGRepresentation(self)!
        let im2: Data = UIImagePNGRepresentation(image)!
        return (im1 == im2)
    }
}


