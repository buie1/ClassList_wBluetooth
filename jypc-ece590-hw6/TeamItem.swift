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
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("TeamInfo1")
    
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
    
    func encodeWithCoder(_ aCoder: NSCoder){
        aCoder.encode(name, forKey: InfoKey.nameK)
        aCoder.encode(project, forKey: InfoKey.projectK)
        aCoder.encode(details, forKey: InfoKey.detailsK)
        aCoder.encode(members, forKey: InfoKey.membersK)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        let name = aDecoder.decodeObject(forKey: InfoKey.nameK) as! String
        let project = aDecoder.decodeObject(forKey: InfoKey.projectK) as! String
        let details = aDecoder.decodeObject(forKey: InfoKey.detailsK) as! String
        let mems = aDecoder.decodeObject(forKey: InfoKey.membersK) as! [Students]
        self.init(name: name,project: project, details: details, members: mems)
    }
    
    static func saveTeamInfo(_ teamList: [TeamItem]) ->() {
        let isSuccess = NSKeyedArchiver.archiveRootObject(teamList, toFile: TeamItem.ArchiveURL.path)
        if !isSuccess {
            print("Failed to save info")
        }else{
            print("Save info successful!")
        }
    }
    
    static func loadTeamInfo() -> [TeamItem]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: TeamItem.ArchiveURL.path) as? [TeamItem]
    }
    
}
