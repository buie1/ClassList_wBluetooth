//
//  MasterViewController.swift
//  jypc-ece590-hw6
//
//  Created by Jonathan Buie on 10/10/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchResultsUpdating, AddTeamViewControllerDelegate, AddMemberViewControllerDelegate {

    
    // MARK:  Variables
    var array = [TeamItem]()
    var currTeam: TeamItem!
    var members = [Students]()
    var student: Students!
    var sectionIndx: Int!
    var filteredMembers = [Students]()
    var deleteMemberIndexPath: NSIndexPath? = nil
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    // MARK:  Delegate Methods
        //Search Delegate Functions
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func addNew(team: TeamItem) {
        array.append(team)
        // tell table view to refresh
        
        //TeamItem.saveTeamInfo(array)
        self.tableView.reloadData()
    }
    
    func addMember(mem: Students) {
        currTeam.members.append(mem)
        TeamItem.saveTeamInfo(array)
        self.tableView.reloadData()
    }
    
    func editMember(mem: Students, _ ix: (Int, Int)) {
        array[ix.0].members.removeAtIndex(ix.1)
        array[ix.0].members.insert(mem,atIndex: ix.1)
        TeamItem.saveTeamInfo(array)
        self.tableView.reloadData()
    }
    
    
    
    // MARK: - View Lifecycle functions
    
    var detailViewController: DisplayPageViewController? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
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
    }
    

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewTeam(sender: AnyObject) {
        array.insert(TeamItem(name: "Temp", project: "Test"), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if self.tableView.indexPathForSelectedRow != nil {
                
                var memIdx = tableView.indexPathForSelectedRow?.row
                var teamix = tableView.indexPathForSelectedRow?.section
                if searchController.active && searchController.searchBar.text != "" {
                    // Find where current memeber is in the REAL array
                    (teamix,memIdx) = getArrayIndexes(tableView.cellForRowAtIndexPath((tableView.indexPathForSelectedRow)!)!)
                }else{
                    memIdx = tableView.indexPathForSelectedRow?.row
                    teamix = tableView.indexPathForSelectedRow?.section
                }
                
                if memIdx == nil {
                    memIdx = sender?.row
                }
                if teamix == nil {
                    teamix = sender?.section
                }
                // Just print the persons name for now
                // We will need to change this later
                
                let object = array[teamix!].members[memIdx!]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DisplayPageViewController
                controller.member = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }else if segue.identifier == "AddTeamSegue" {
            //let destVC = (segue.destinationViewController as! UINavigationController).topViewController as! AddTeamViewController
            let destVC = segue.destinationViewController as! AddTeamViewController
            destVC.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            destVC.navigationItem.leftItemsSupplementBackButton = true
            destVC.delegate = self
        }else if segue.identifier == "AddMemberSegue" {
            let ix = sender?.tag
            let destVC = segue.destinationViewController as! AddMemberViewController
            self.currTeam = array[ix!]
            destVC.memDelegate = self
            destVC.toEdit = false
        }
    }

    // MARK: - Search Functions
    
    func filterContentForSearchText(searchText: String, scope: String = "All"){
        for i in array{
            filteredMembers = i.members.filter{member in
                return member.getName().lowercaseString.containsString(searchText.lowercaseString)
            }
        }
        tableView.reloadData()
    }
    
    func getArrayIndexes(cell:UITableViewCell) -> (Int?,Int?){
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return array.count
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //let team_cell = tableView.dequeueReusableCellWithIdentifier("team_cell")! as! TeamTableCell
        let team_cell = tableView.dequeueReusableCellWithIdentifier("team_cell") as!TeamTableCell
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
        let color = UIColor(red: 0x76/255, green: 0x32/255, blue: 0x3F/255, alpha: 1.0)
        team_cell.backgroundColor = color
        team_cell.teamName.textColor = UIColor.whiteColor()
        team_cell.projectName.textColor = UIColor.whiteColor()
        team_cell.btn_AddMember.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        return team_cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array[section].members.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let theTeam = array[indexPath.section]
        let member_cell = tableView.dequeueReusableCellWithIdentifier("member_cell")! as UITableViewCell
        let theMember: Students
        if searchController.active && searchController.searchBar.text != "" {
            theMember = filteredMembers[indexPath.row]
        }else{
            theMember = theTeam.members[indexPath.row]
        }
        member_cell.textLabel?.text = theMember.getName()
        member_cell.detailTextLabel?.text = theMember.getProgram()
        member_cell.imageView?.image = theMember.getImage()?.circle
        
        //background color #565656
        let color = UIColor(red: 0x56/255, green: 0x56/255, blue: 0x56/255, alpha: 1.0)
        member_cell.backgroundColor = color
        member_cell.textLabel?.textColor = UIColor.whiteColor()
        member_cell.detailTextLabel?.textColor = UIColor.whiteColor()
        return member_cell
        
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            array[indexPath.section].members.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
            self.tableView.reloadData()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        footerView.backgroundColor = UIColor.blackColor()
        
        return footerView
    }
    /*override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 116
    }*/
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2.0
    }
    
    
    
    // MARK: Load initial Data
    // Edit here
    func loadInitialData() {
        /*************
        // Uncomment when we want to persist data.
        **************/
        //let tempTeams = TeamItem.loadTeamInfo()
        let tempTeams:[TeamItem]? = [TeamItem]()
        if tempTeams?.count > 0{
            array = tempTeams!
        }else{
            let t0 = TeamItem(name:"JYP-C++", project:"Curfew Monitor")
            let courseList0: [Double:String] = [
                590.05:"Mobile Application Development", 590.04:"Team Design Challenge",571:"Machine Learning"
            ]
            let me = Students("Jonathan","Buie",nil, "O'Fallon, IL", mycourses:courseList0,
                              "Electrical Engineering","Masters student", true)
            me.addHobbies("Sports","Listening to Kanye", "Salsa Dancing")
            me.setAnimate(true)
            me.setImage(UIImage(named:"buie")!)
            me.setLanguages(["C","C++","Java","Swift","MATLAB"])
            let pete = Students("Peter","Murphy, IV", nil,"Redding,CA", mycourses: courseList0,
                                "Electrical Engineering","Masters student", true)
            pete.setImage(UIImage(named:"peter")!)
            pete.setAnimate(false)
            pete.addHobbies("Snowboarding", "Bae-cations","Overwatch")
            pete.setLanguages(["C","C++","Java","Swift","VHDL","Verilog"])
            let colby = Students("Colby","Stanley",nil,"Bridgeport,WV", mycourses: courseList0,
                                 "Computer Engineering","Masters student", true)
            colby.setImage(UIImage(named:"colby")!)
            colby.setAnimate(false)
            colby.addHobbies("Biking","Playing Music","Halo")
            colby.setLanguages(["C","C++","Java","Swift","VHDL"])
            let yhk = Students("Young-Hoon","Kim",nil,"Raleigh, NC", mycourses: courseList0,
                               "Computer Engineering","Masters student", true)
            yhk.setImage(UIImage(named:"young")!)
            yhk.setAnimate(true)
            yhk.addHobbies("Working Out","Talking to Cuties", "General Winning")
            yhk.setLanguages(["C","C++","Java","Swift","VHDL","Sarcasm"])
            t0.members.append(me)
            t0.members.append(pete)
            t0.members.append(yhk)
            t0.members.append(colby)
            
            array.append(t0);
        }
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
        imageView.contentMode = .ScaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

