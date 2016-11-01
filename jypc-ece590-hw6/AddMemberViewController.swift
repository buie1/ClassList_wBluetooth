//
//  AddMemberViewController.swift
//  jab165-ece590-hw3
//
//  Created by Jonathan Buie on 9/19/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreBluetooth

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

class AddMemberViewController: UIViewController, UITextFieldDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    /****
     jab165 (10.29.2016)
     
     The AddMemberViewController will act as the "CENTRAL" entity.  It will use the transmitted data for the task off adding new
     members to the tableview
     
     ****/
    
    
    // MARK: Variables
    var toEdit:Bool!
    var currMember:Students!
    var memberIX: (Int,Int)!
    var memDelegate: AddMemberViewControllerDelegate!
    var imagePicker: UIImagePickerController!
    var activeTextField: UITextField!
    
    
    
    // MARK: Bluetooth Managers
    var centralManager:CBCentralManager!
    var connectingPeripheral:CBPeripheral!
    var data:String = ""
    
    
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
    
    @IBAction func receiveBluetoothButtonPressed(_
        sender: Any) {
        print("Initializing central manager")
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Where is the data!?
        
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        if self.centralManager != nil{
            self.centralManager.stopScan()
        }
        print("scanning stopped")
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
            let temp = Students(fname!, teamN!, htown!, gen ,deg!, nil,lang!,hob!)
            temp.setLanguages(lang!)
            return temp
        }
    }
    
    
    // MARK: View LifecycleFunctions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // MARK: Scroll View if Keyboard Use
        /*
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddMemberViewController.keyboardUP(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddMemberViewController.keyboardDown(_:)), name: UIKeyboardWillHideNotification, object: nil)
        */
        
        //Make UIImage clickable like a button
        let imView = userImageView!
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action:#selector(AddMemberViewController.imageTapped(_:)))
        imView.isUserInteractionEnabled = true
        imView.addGestureRecognizer(tapGestureRecognizer)
        
        if toEdit!{
            titleNavBar.title = "Edit Member"
            //saveEditButton.title = "Done"

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
            
            setDegreeSegment(deg: (currMember?.getDegree())!)
            
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
    
    func setDegreeSegment(deg: String){
        if deg == "Undergraduate student"{
            programSeg.selectedSegmentIndex = 0
        }else if  deg == "Masters student"{
            programSeg.selectedSegmentIndex = 1
        }else if deg == "PhD student"{
            programSeg.selectedSegmentIndex = 2
        }else if deg == "Alumni"{
            programSeg.selectedSegmentIndex = 3
        }else if deg == "Honorary graduate"{
            programSeg.selectedSegmentIndex = 4
        }else{
            programSeg.selectedSegmentIndex = 1
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
            //self.bottomConstraint.constant -= 65
            nameText.isHidden = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == hobbyText || textField == languageText){
            self.topConstraint.constant += 65
            //self.bottomConstraint.constant += 65
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
    
    
    // MARK: Populate Fields with Bluetooth Data
    func populateWithBlueToothData() -> Bool {
        let btData = data.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        do{
            let json = try JSONSerialization.jsonObject(with: btData, options: []) as! [String:AnyObject]
            if let name = json["name"] as? String {
                nameText?.text = name
            }
            if let team = json["team"] as? String {
                teamText?.text = team
            }
            if let from = json["from"] as? String {
                hTownText?.text = from
            }
            if let sex = json["sex"] as? Bool {
                if sex {
                    genderSeg.selectedSegmentIndex = 0
                }else{
                    genderSeg.selectedSegmentIndex = 1
                }
            }
            if let deg = json["degree"] as? String {
                setDegreeSegment(deg: deg)
            }
            if let hob = json["hobbies"] as? [String] {
                hobbyText?.text = hob.joined(separator: ", ")
            }
            if let lang = json["languages"] as? [String] {
                languageText?.text = lang.joined(separator: ", ")
            }
            if let pic = json["pic"] as? String! {
                //print(pic)
                if pic == nil{
                    // We didnt send/receive an images. Do nothing
                    print("pic value was nil")
                }else{
                    let imHandle = ImageHandler()
                    userImageView.image = imHandle.decodeImage(compressedData: pic)
                }
            }
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            endIndicator()
            return false
        }
        endIndicator()
        return true
    }
    
    
    
    
    
    // MARK:  Central Manager Delegate methods
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("checking state")
        switch(central.state) {
        case .poweredOff:
            print("CB BLE hw is powered off")
            
        case .poweredOn:
            print("CB BLE hw is powered on")
            self.scan()
            
        default:
            return
        }
    }
    
    func scan() {
        self.centralManager.scanForPeripherals(withServices: serviceUUIDs,options: nil)
        print("scanning started\n\n\n")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if RSSI.intValue > -15 {
            return
        }
        startIndicator()
        print("discovered \(peripheral.name) at \(RSSI)")
        if connectingPeripheral != peripheral {
            connectingPeripheral = peripheral
            connectingPeripheral.delegate = self
            print("connecting to peripheral \(peripheral)")
            centralManager.connect(connectingPeripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        endIndicator()
        print("failed to connect to \(peripheral) due to error \(error)")
        self.cleanup()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("\n\nperipheral connected\n\n")
        centralManager.stopScan()
        peripheral.delegate = self as CBPeripheralDelegate
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            endIndicator()
            print("error discovering services \(error)")
            self.cleanup()
        }
        else {
            for service in peripheral.services! as [CBService] {
                print("service UUID  \(service.uuid)\n")
                if (service.uuid == serviceUUID) {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            endIndicator()
            print("error - \(error)")
            
            //MARK: -             print(error!)?
            print(error ?? "There was an error")
            self.cleanup()
        }
        else {
            for characteristic in service.characteristics! as [CBCharacteristic] {
                print("characteristic is \(characteristic)\n")
                if (characteristic.uuid == characteristicUUID) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            endIndicator()
            print("error")
        }
        else {
            let dataString = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)
            
            if dataString == "EOM" {
                print(self.data)
                //nameText.text = self.data
                
                //Method to populate text fields with BT data
                if(populateWithBlueToothData()){
                    print("Successfully copied data fields from Bluetooth")
                }else{
                    print("error populating fields")
                }
                
                
                peripheral.setNotifyValue(false, for: characteristic)
                centralManager.cancelPeripheralConnection(peripheral)
            }
            else {
                let strng:String = dataString as! String
                self.data += strng
                print("received \(dataString)")
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            endIndicator()
            print("error changing notification state \(error)")
        }
        if (characteristic.uuid != serviceUUID) {
            return
        }
        if (characteristic.isNotifying) {
            print("notification began on \(characteristic)")
        }
        else {
            print("notification stopped on \(characteristic). Disconnecting")
            endIndicator()
            self.centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        endIndicator()
        // Can we do this?
        
        data = ""
        
        print("didDisconnect error is \(error)")
    }
    
    func cleanup() {
        
        switch connectingPeripheral.state {
        case .disconnected:
            print("cleanup called, .Disconnected")
            return
        case .connected:
            if (connectingPeripheral.services != nil) {
                print("found")
                //add any additional cleanup code here
            }
        default:
            return
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





