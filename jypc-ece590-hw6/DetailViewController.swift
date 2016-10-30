//
//  DetailViewController.swift
//  jypc-ece590-hw6
//
//  Created by Jonathan Buie on 10/10/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import UIKit
import CoreBluetooth

class DetailViewController: UIViewController, CBPeripheralManagerDelegate {
    
    /****
     jab165 (10.29.2016)
     
     The DetailViewController will act as the "PERIPHERAL" entity.  It contains the data that can be shared on the button press
     to send data via Bluetooth. 
     
     1. Convert data to JSON
     2. Send packets
     
     ****/
    

    @IBOutlet weak var descriptionText: UITextView!

    @IBOutlet weak var uIImage: UIImageView!
    
    @IBOutlet weak var sendInfoButton: UIBarButtonItem!
    
    
    // Mark: Variables for sending data over Bluetooth
    
    var peripheralManager:CBPeripheralManager!
    var transferCharacteristic:CBMutableCharacteristic!
    var dataToSend:Data!
    var sentDataCount:Int = 0
    var sentEOM:Bool = false
    
    
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
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
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
    @IBAction func sendInfoButtonPressed(_ sender: Any) {
        print("sending bluetooth info")
        // We want to serialize the data and send as JSON string
        // JSON Convertion requires top level object to be an NSArray or NSDictionary
        
        let imHandle = ImageHandler()
        let properties: [String : Any] = ["name" : (studentsItem?.getName())! as String, "team" : (studentsItem?.getTeam())! as String,
                                          "from" : (studentsItem?.getFrom())! as String, "degree" : (studentsItem?.getDegree())! as String,
                                          "sex": (studentsItem?.getSex())! as Bool , "hobbies" : (studentsItem?.getHobbies())! as [String],
                                          "languages" : (studentsItem?.getLanguages())! as [String],
                                          "pic": imHandle.compressImage(pic: (studentsItem?.getImage())!) as String!]
        
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: properties, options: [])
            print(jsonData)
            if JSONSerialization.isValidJSONObject(properties) {
                print("Valid JSON")
            }else{
                print("invalid JSON object")
            }
            
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
            print(jsonString)
            dataToSend = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            
        } catch let error {
            print("error converting to json: \(error)")
        }
        
        //Start Sending Data
        let dataToBeAdvertised: [String:Any]? = [
            CBAdvertisementDataServiceUUIDsKey : serviceUUIDs]
        self.peripheralManager.startAdvertising(dataToBeAdvertised)
        
    }

    // MARK: - Peripheral Methods
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if (peripheral.state != CBManagerState.poweredOn) {
            return
        }
        else {
            print("Powered on and ready to go")
            // This is an example of a Notify Characteristic for a Readable value
            transferCharacteristic = CBMutableCharacteristic(type:
                characteristicUUID, properties: CBCharacteristicProperties.notify, value: nil, permissions: CBAttributePermissions.readable)
            // This sets up the Service we will use, loads the Characteristic and then adds the Service to the Manager so we can start advertising
            let transferService = CBMutableService(type: serviceUUID, primary: true)
            transferService.characteristics = [self.transferCharacteristic]
            self.peripheralManager.add(transferService)
            
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Data request connection coming in")
        // A subscriber was found, so send them the data
        //self.dataToSend = self.descriptionText.text.data(using: String.Encoding.utf8, allowLossyConversion: false)
            //self.dataToSend = data
            self.sentDataCount = 0
            self.sendData()
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("Unsubscribed")
    }
    
    func sendData() {
        if (sentEOM) {                // sending the end of message indicator
            let didSend:Bool = self.peripheralManager.updateValue(endOfMessage!, for: self.transferCharacteristic, onSubscribedCentrals: nil)
            
            if (didSend) {
                sentEOM = false
                print("Sent: EOM, Outer loop")
            }
            else {
                return
            }
        }
        else {                          // sending the payload
            if (self.sentDataCount >= self.dataToSend.count) {
                return
            }
            else {
                var didSend:Bool = true
                while (didSend) {
                    var amountToSend = self.dataToSend.count - self.sentDataCount
                    if (amountToSend > MTU) {
                        amountToSend = MTU
                    }
                    
                    let range = Range(uncheckedBounds: (lower: self.sentDataCount, upper: self.sentDataCount+amountToSend))
                    var buffer = [UInt8](repeating: 0, count: amountToSend)
                    
                    self.dataToSend.copyBytes(to: &buffer, from: range)
                    let sendBuffer = Data(bytes: &buffer, count: amountToSend)
                    
                    didSend = self.peripheralManager.updateValue(sendBuffer, for: self.transferCharacteristic, onSubscribedCentrals: nil)
                    if (!didSend) {
                        return
                    }
                    if let printOutput = NSString(data: sendBuffer, encoding: String.Encoding.utf8.rawValue) {
                        print("Sent: \(printOutput)")
                    }
                    self.sentDataCount += amountToSend
                    if (self.sentDataCount >= self.dataToSend.count) {
                        sentEOM = true
                        let eomSent:Bool = self.peripheralManager.updateValue(endOfMessage!, for: self.transferCharacteristic, onSubscribedCentrals: nil)
                        if (eomSent) {
                            sentEOM = false
                            print("Sent: EOM, Inner loop")
                        }
                        return
                    }
                }
            }
        }
    }
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        self.sendData()
    }
    
    
}

