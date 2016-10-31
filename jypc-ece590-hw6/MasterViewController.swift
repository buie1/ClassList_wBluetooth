//
//  MasterViewController.swift
//  jypc-ece590-hw6
//
//  Created by Jonathan Buie on 10/10/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import UIKit
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


class MasterViewController: UITableViewController, UISearchResultsUpdating, AddTeamViewControllerDelegate, AddMemberViewControllerDelegate, UIViewControllerTransitioningDelegate, DisplayPageViewControllerDelegate, CBPeripheralManagerDelegate{

    
    // MARK:  Variables
    var array = [TeamItem]()
    var currTeam: TeamItem!
    var members = [Students]()
    var student: Students!
    var sectionIndx: Int!
    var filteredMembers = [Students]()
    var deleteMemberIndexPath: IndexPath? = nil
    let searchController = UISearchController(searchResultsController: nil)
    
    //Bluetooth Perifphal Variables
    var peripheralManager: CBPeripheralManager!
    var transferCharacteristic:CBMutableCharacteristic!
    var sentDataCount: Int = 0
    var sentEOM:Bool = false
    var dataToSend:Data!
    
    //Custom animation for transition from MasterViewController to AddTeam/AddMember VC's
    let customPresentAnimationController = CustomAnimationController()
    
    
    // MARK:  Delegate Methods
        //Search Delegate Functions
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func addNew(_ team: TeamItem) {
        array.append(team)
        // tell table view to refresh
        
        //TeamItem.saveTeamInfo(array)
        self.tableView.reloadData()
    }
    
    func addMember(_ mem: Students) {
        currTeam.members.append(mem)
        TeamItem.saveTeamInfo(array)
        self.tableView.reloadData()
    }
    
    func editMember(_ mem: Students, _ ix: (Int, Int)) {
        array[ix.0].members.remove(at: ix.1)
        array[ix.0].members.insert(mem,at: ix.1)
        TeamItem.saveTeamInfo(array)
        self.tableView.reloadData()
    }
    
    func editMemberArray(_ mem: Students, _ ix: (Int, Int)) {
        array[ix.0].members.remove(at: ix.1)
        array[ix.0].members.insert(mem,at: ix.1)
        TeamItem.saveTeamInfo(array)
        self.tableView.reloadData()
    }

    
    // MARK: - View Lifecycle functions
    
    var detailViewController: DisplayPageViewController? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewTeam(_:)))
        //self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DisplayPageViewController
        }
                
        // Set up Search Bar & Load initial Data
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        loadInitialData()
        
        //set up peripheral functions
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewTeam(_ sender: AnyObject) {
        array.insert(TeamItem(name: "Temp", project: "Test"), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if self.tableView.indexPathForSelectedRow != nil {
                
                var memIdx = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row
                var teamix = (tableView.indexPathForSelectedRow as NSIndexPath?)?.section
                if searchController.isActive && searchController.searchBar.text != "" {
                    // Find where current memeber is in the REAL array
                    (teamix,memIdx) = getArrayIndexes(tableView.cellForRow(at: (tableView.indexPathForSelectedRow)!)!)
                }else{
                    memIdx = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row
                    teamix = (tableView.indexPathForSelectedRow as NSIndexPath?)?.section
                }
                
                if memIdx == nil {
                    memIdx = (sender as AnyObject).row
                }
                if teamix == nil {
                    teamix = (sender as AnyObject).section
                }
                // Just print the persons name for now
                // We will need to change this later
                
                let object = array[teamix!].members[memIdx!]
                let controller = (segue.destination as! UINavigationController).topViewController as! DisplayPageViewController
                controller.memIndex = (teamix!,memIdx!)
                controller.editArrayDelegate = self
                controller.member = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }else if segue.identifier == "AddTeamSegue" {
            //let destVC = (segue.destinationViewController as! UINavigationController).topViewController as! AddTeamViewController
            let destVC = segue.destination as! AddTeamViewController
            destVC.transitioningDelegate = self
            destVC.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            destVC.navigationItem.leftItemsSupplementBackButton = true
            destVC.delegate = self
        }else if segue.identifier == "AddMemberSegue" {
            //let memIdx = tableView.indexPathForSelectedRow?.row
           // let teamix = tableView.indexPathForSelectedRow?.section
            let ix = (sender as! UIButton).tag
            let destVC = segue.destination as! AddMemberViewController
            destVC.transitioningDelegate = self
            self.currTeam = array[ix]
            //destVC.memberIX = (teamix!,memIdx!)
            destVC.memDelegate = self
            destVC.toEdit = false
        }
    }

    // MARK: - Search Functions
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All"){
        for i in array{
            filteredMembers = i.members.filter{member in
                return member.getName().lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    func getArrayIndexes(_ cell:UITableViewCell) -> (Int?,Int?){
        let name = cell.textLabel?.text
        for i in 0..<(array.count){
            for j in 0..<(array[i].members.count){
                if array[i].members[j].getName() == name {
                    return (i,j)
                }
            }
        }
        print("Didn't find this name... Fix this code")
        return (0,0)
    }
    
    
    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        }else{
            return array.count
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //let team_cell = tableView.dequeueReusableCellWithIdentifier("team_cell")! as! TeamTableCell
        
        let color = UIColor(red: 0x76/255, green: 0x32/255, blue: 0x3F/255, alpha: 1.0)
        
        if searchController.isActive && searchController.searchBar.text != "" {
            let search_cell = tableView.dequeueReusableCell(withIdentifier: "team_cell") as!TeamTableCell
            search_cell.backgroundColor = color
            search_cell.teamName.textColor = UIColor.white
            search_cell.projectName.textColor = UIColor.white
            search_cell.btn_AddMember.setTitleColor(UIColor.white, for: UIControlState())
            search_cell.teamName.text = "Search Results"
            search_cell.projectName.text = "Found \(filteredMembers.count) Match(es)"
            search_cell.btn_AddMember.isHidden = true
            return search_cell;
        }

        
        let team_cell = tableView.dequeueReusableCell(withIdentifier: "team_cell") as!TeamTableCell
        let team = array[section]
        team_cell.teamName.text = team.name
        team_cell.projectName.text = team.project
        team_cell.btn_AddMember.tag = section
        
        /* COOL RANDOM BACKGROUND SELECTOR
        let n = 1.0/CGFloat(array.count)
        let hue = CGFloat(section)*n
        let color = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 0.65)
        team_cell.backgroundColor = color
        return team_cell
        */
        
        //Lavender Color = #76323F
        team_cell.contentView.backgroundColor = color
        team_cell.teamName.textColor = UIColor.white
        team_cell.projectName.textColor = UIColor.white
        team_cell.btn_AddMember.setTitleColor(UIColor.white, for: UIControlState())
        return team_cell.contentView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredMembers.count
        }else{
            return array[section].members.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let theTeam = array[(indexPath as NSIndexPath).section]
        let member_cell = tableView.dequeueReusableCell(withIdentifier: "member_cell")! as UITableViewCell
        let theMember: Students
        if searchController.isActive && searchController.searchBar.text != "" {
            theMember = filteredMembers[(indexPath as NSIndexPath).row]
        }else{
            theMember = theTeam.members[(indexPath as NSIndexPath).row]
        }
        member_cell.textLabel?.text = theMember.getName()
        member_cell.detailTextLabel?.text = theMember.getDegree()
        member_cell.imageView?.image = theMember.getImage()?.circle
        
        //background color #565656
        let color = UIColor(red: 0x56/255, green: 0x56/255, blue: 0x56/255, alpha: 1.0)
        member_cell.backgroundColor = color
        member_cell.textLabel?.textColor = UIColor.white
        member_cell.detailTextLabel?.textColor = UIColor.white
        return member_cell
        
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    //MARK: share button functionality for cell
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //Delete Button - swipe to delete
        let delete = UITableViewRowAction(style: .normal, title: "Delete"){ (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            self.array[(indexPath as IndexPath).section].members.remove(at: (indexPath as IndexPath).row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            TeamItem.saveTeamInfo(self.array)
            self.tableView.reloadData()
        }
        delete.backgroundColor = UIColor.red
        
        //Share button - swipe to share
        let share = UITableViewRowAction(style: .normal, title: "Share"){ (action: UITableViewRowAction!, IndexPath: IndexPath!) -> Void in
            //do share function
            print("Sharing via bluetooth here...")
            let memIdx = indexPath.row
            let teamix = indexPath.section
            print("sending bluetooth info")
            // We want to serialize the data and send as JSON string
            // JSON Convertion requires top level object to be an NSArray or NSDictionary
            let studentsItem: Students = self.array[teamix].members[memIdx]
            
            let imHandle = ImageHandler()
            let properties: [String : Any] = ["name" : (studentsItem.getName()) as String, "team" : (studentsItem.getTeam()) as String,
                                              "from" : (studentsItem.getFrom()) as String, "degree" : (studentsItem.getDegree()) as String,
                                              "sex": (studentsItem.getSex()) as Bool , "hobbies" : (studentsItem.getHobbies()) as [String],
                                              "languages" : (studentsItem.getLanguages()) as [String],
                                              "pic": imHandle.compressImage(pic: (studentsItem.getImage())!) as String!]
            
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
                self.dataToSend = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                
            } catch let error {
                print("error converting to json: \(error)")
            }
            
            //Start Sending Data
            let dataToBeAdvertised: [String:Any]? = [
                CBAdvertisementDataServiceUUIDsKey : serviceUUIDs]
            //self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
            self.peripheralManager.startAdvertising(dataToBeAdvertised)
            
            
            
        }
        share.backgroundColor = UIColor.gray
        return[share, delete]
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        footerView.backgroundColor = UIColor.black
        
        return footerView
    }
    /*override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 116
    }*/
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2.0
    }
    
    
    
    // MARK: Load initial Data
    // Edit here
    func loadInitialData() {
        /*************
        // Uncomment when we want to persist data.
        **************/
        let tempTeams = TeamItem.loadTeamInfo()
        //let tempTeams:[TeamItem]? = [TeamItem]()
        if tempTeams?.count > 0{
            array = tempTeams!
        }else{
            let teamName = "JYP-C++"
            let t0 = TeamItem(name: teamName, project:"Dodge the Potholes")
            let me = Students("Jonathan Buie", teamName, "O'Fallon, IL", true,
                              "Masters student",nil)
            me.addHobbies("Sports","Listening to Kanye", "Salsa Dancing")
            me.setImage(UIImage(named:"buie")!)
            me.setLanguages(["C","C++","Java","Swift","MATLAB"])
            let pete = Students("Peter Murphy",teamName, "Redding,CA", true,
                                "Masters student",nil)
            pete.setImage(UIImage(named:"peter")!)
            pete.addHobbies("Snowboarding", "Bae-cations","Overwatch")
            pete.setLanguages(["C","C++","Java","Swift","VHDL","Verilog"])
            let colby = Students("Colby Stanley", teamName, "Bridgeport,WV",true,
                                 "Masters student", nil)
            colby.setImage(UIImage(named:"colby")!)
            colby.addHobbies("Biking","Playing Music","Halo")
            colby.setLanguages(["C","C++","Java","Swift","VHDL"])
            let yhk = Students("Young-Hoon Kim",teamName, "Raleigh, NC",true,
                               "Masters student", nil)
            yhk.setImage(UIImage(named:"young")!)
            yhk.addHobbies("Working Out","Talking to Cuties", "General Winning")
            yhk.setLanguages(["C","C++","Java","Swift","VHDL","Sarcasm"])
            t0.members.append(me)
            t0.members.append(pete)
            t0.members.append(yhk)
            t0.members.append(colby)
            
            array.append(t0);
        }
    }
    
    
    //Perform animated transition to add member/team VC's
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customPresentAnimationController
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
        self.peripheralManager.stopAdvertising()
        // So data to send is not overwritten each time, need to removeALL data before we attempt to send again
        // jab165 10/30/2016
        dataToSend.removeAll()
        print("Unsubscribed")
    }
    
    func sendData() {
        if (sentEOM) {                // sending the end of message indicator
            let didSend:Bool = self.peripheralManager.updateValue(endOfMessage!, for: self.transferCharacteristic, onSubscribedCentrals: nil)
            
            if (didSend) {
                sentEOM = false
                //self.peripheralManager.stopAdvertising()
                print("Stopped Advertising")
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

// MARK: Round Images
extension UIImage{
    // http://stackoverflow.com/questions/29046571/cut-a-uiimage-into-a-circle-swiftios
    var circle: UIImage? {
        let square = CGSize(width: min(size.width/2, size.height/2),
                            height: min(size.width/2,size.height/2))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0),
            size: square))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
}



