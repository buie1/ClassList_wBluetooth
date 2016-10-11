//
//  TeamItem.swift
//  jab165-ece590-hw3
//
//  Created by Jonathan Buie on 9/19/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import Foundation

struct InfoKey {
    static let nameK = "name"
    static let projectK = "project"
    static let detailsK = "details"
    static let membersK = "students"
}

class TeamItem: NSObject {
    var name:String = ""
    var project: String = ""
    var details: String!
    var members = [Students]()
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("TeamInfo1")
    
    override init(){
        super.init()
    }
    
    init(name: String, project: String, details: String! = "", members: [Students] = [Students]()) {

        self.name = name
        self.project = project
        self.details = details
        self.members = members
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(name, forKey: InfoKey.nameK)
        aCoder.encodeObject(project, forKey: InfoKey.projectK)
        aCoder.encodeObject(details, forKey: InfoKey.detailsK)
        aCoder.encodeObject(members, forKey: InfoKey.membersK)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        let name = aDecoder.decodeObjectForKey(InfoKey.nameK) as! String
        let project = aDecoder.decodeObjectForKey(InfoKey.projectK) as! String
        let details = aDecoder.decodeObjectForKey(InfoKey.detailsK) as! String
        let mems = aDecoder.decodeObjectForKey(InfoKey.membersK) as! [Students]
        self.init(name: name,project: project, details: details, members: mems)
    }
    
    static func saveTeamInfo(teamList: [TeamItem]) -> Bool {
        let isSuccess = NSKeyedArchiver.archiveRootObject(teamList, toFile: TeamItem.ArchiveURL.path!)
        if !isSuccess {
            print("Failed to save info")
            return false
        }else{
            return true
        }
    }
    
    static func loadTeamInfo() -> [TeamItem]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(TeamItem.ArchiveURL.path!) as? [TeamItem]
    }
    
}