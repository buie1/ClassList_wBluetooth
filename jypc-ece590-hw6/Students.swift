//
//  Students.swift
//  jab165-ece590-hw3
//
//  Created by Jonathan Buie on 9/19/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import Foundation
import UIKit
/*fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
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

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}*/


class Students: Human {
    
    struct Keys {
        static let Courses = "courses"
        //static let Major = "major"
        static let Program = "program"
        //static let Animate = "animate"
        static let Languages = "languages"
    }
    
    //fileprivate var courses: [Double:String]! // This is dictionary of a students current classes
    //private var transcript: [Double:Grade] //This is a dictionary of a students classes & Grades
    //lazy var gpa : Double? = 4.0 // Here we are using a lazy variable unlike the other variable this is able to refer to the instance
    
    
    //fileprivate var major: String!
    fileprivate var program: String!
    fileprivate var languages = [String]()
    
    override init(){
        super.init()
    }
    
    /*******
    // Clean up initializers :'(
     jab165 10/25/16
    init(_ fName: String, _ lName: String, _ mName: String?, _ hTown: String, mycourses courses:[Double:String],_ major:String, _ program: String, _ sex:Bool = false, _ live: Bool=true) {
        self.courses = courses
        self.major = major
        self.program = program
        super.init(fName, lName, mName, hTown, live, sex)
    }
    init(_ fName: String, _ lName: String, _ mName: String?, _ hTown: String, mycourses courses:[Double:String],_ major:String, _ program: String, _ hob: [String],
           _ sex:Bool = false, _ live: Bool=true) {
        self.courses = courses
        self.major = major
        self.program = program
        super.init(fName, lName, mName, hTown, hob, live, sex)
    }
    init(_ fName: String, _ lName: String, _ mName: String?, _ hTown: String, _ courses:[Double:String],_ major:String, _ program: String, _ hob: [String],
           _ sex:Bool = false, _ lang: [String], _ im:UIImage?, _ animate:Bool = false, _ live: Bool=true) {
        self.courses = courses
        self.major = major
        self.program = program
        self.languages = lang
        self.animate = animate
        super.init(fName, lName, mName, hTown, hob, sex, live, im!)
    }
    */
    init(_ fName:String, _ teamN:String, _ homeT:String, _ hob:[String], _ gend:Bool = true, _ prog:[String], _ lang:[String],
         _ im:UIImage?){
        program = program
        languages = lang
        super.init(fName, teamN, homeT, hob, gen, im)
        
    }
    override func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(major, forKey: Keys.Major) // Do we still need major?
        aCoder.encode(program, forKey: Keys.Program)
        aCoder.encode(languages, forKey: Keys.Languages)
        super.encodeWithCoder(aCoder)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: Keys.Name) as! String
        let team = aDecoder.decodeObject(forKey: Keys.Team) as! String
        let home = aDecoder.decodeObject(forKey: Keys.Home) as! String
        let gender = aDecoder.decodeObject(forKey: Keys.Gender) as! Bool
        let hobbies = aDecoder.decodeObject(forKey: Keys.Hobbies) as! [String]
        let profilePic = aDecoder.decodeObject(forKey: Keys.Image) as? UIImage
        let program = aDecoder.decodeObject(forKey: Keys.Program) as! String
        let languages = aDecoder.decodeObject(forKey: Keys.Languages) as! [String]
        //self.init(firstName,lastName,middleName,homeTown, courses, major, program, hobbies, sex, languages, profilePic, animate, living)
        self.init(name,team,home,hobbies,gender, program,languages,profilePic)
    }

    override func describeMe() -> String {
        var myDescription: String = ""
        //1. Start with the name
        myDescription += firstName
        if(middleName != nil){
            myDescription += " \(middleName!)" // Here we have to use the forced unwrapper for the optional(String)
        }
        myDescription += " \(lastName)"
        //2. Where are you from?
        myDescription += " is \(printBasedOnGPA()) student from \(homeTown)."
        //3. Major & Program
        myDescription += "\n"
        myDescription += " \(printBasedOnGender()) a \(program) in \(major) at Duke University. "
        
        //4. Hobbies
        if hobbies.count == 1{
            myDescription += "\(firstName)'s only hobby is \(hobbies[0])"
        }else if hobbies.count > 1 {
            var counter = 0
            myDescription += "\(firstName)'s hobbies include:"
            while counter < hobbies.count{
                if (counter ==  (hobbies.count - 1)){
                    myDescription += " and \(hobbies[counter]).\n "
                }else{
                    myDescription += " \(hobbies[counter]),"
                }
                counter += 1
            }
        }else{
            myDescription += " \(printBasedOnGender()) a robot and has NO Hobbies.\n "
        }

         //5. Current Languages
         if(languages.count != 0){
            myDescription += "In addition \(firstName)'s proficient Language(s) include:\n"
            for l in languages{
                myDescription += "\(l)\n"
            }
         }else{
            myDescription += "Unfortunately \(firstName) is not proficient in any languages."
         }
        return myDescription
    }

    func getProgram() -> Program {
        if program == "Undergraduate student"{
            return .UG
        }else if  program == "Masters student"{
            return .MS
        }else if program == "PhD student"{
            return .PHD
        }else if program == "Alumni"{
            return .Alum
        }else if program == "Honorary graduate"{
            return .honorary
        }else{
            return .MS
        }
    }
    
    func getProgram() -> String {
        return program
    }

    func getCourses() -> [Double:String]{
        return courses
    }
    
    func getLanguages()->[String]{
        return languages
    }
    func setLanguages(_ str:[String]){
        self.languages = str
    }
}

enum Grade: String {
    case A
    case B
    case C
    case D
    case F
    func gradeValue() -> Double {
        switch self {
        case .A:
            return 4
        case .B:
            return 3
        case .C:
            return 2
        case .D:
            return 1
        case .F:
            return 0
            /*default:
             print("Invalid grade inserted"); return 0*/
        }
    }
}

enum Program :String {
    case UG = "Undergraduate student"
    case MS = "Masters student"
    case PHD = "PhD student"
    case Alum = "Alumni"
    case honorary = "Honorary graduate"
}//Without using switch/case statement provide the strings corresponding to the Enum case


// MARK: HUMAN class

class Human: NSObject {
    
    struct Keys {
        static let Name = "name"
        static let Home = "home"
        static let Team = "team"
        static let Gender = "gender"
        static let Hobbies = "hobbies"
        static let Image = "profilePic"
    }

    fileprivate var name: String!
    fileprivate var team: String!
    fileprivate var home: String!
    fileprivate var gender : Bool!
    fileprivate var hobbies = [String]()
    fileprivate var profilePic: UIImage?
    
    override init(){
        super.init()
    }
    /*********
     old initializers will probably delete soon
     Jab165 10/25/16
     
     
    init(_ fName: String, _ lName:String, _ mName:String?, _ hTown:String, _ live:Bool = true, _ gender:Bool = false ){
        firstName = fName
        lastName = lName
        middleName = mName
        homeTown = hTown
        living = live
        fullName = fName + " " + lName
        gender = gender
        
        super.init()
    }
    init(_ fName: String, _ lName:String, _ mName:String?, _ hTown:String, _ hob:[String],
           _ live:Bool = true, _ gender:Bool = false ){
        firstName = fName
        lastName = lName
        middleName = mName
        homeTown = hTown
        hobbies = hob
        living = live
        gender = gender
        
        super.init()

    }
    init(_ fName: String, _ lName:String, _ mName:String?, _ hTown:String, _ hob:[String],
           _ live:Bool = true, _ gender:Bool = false, _ im:UIImage ){
        firstName = fName
        lastName = lName
        middleName = mName
        homeTown = hTown
        hobbies = hob
        living = live
        gender = gender
        profilePic = im
        
        super.init()

    }*/
    
    
    init(_ name:String, _ t:String, _ home:String, _ hob:[String], _ gender:Bool = true, _ im:UIImage){
        self.name = name
        self.team = t
        self.home = home
        self.hobbies = hob
        self.gender = gender
        self.im = im
        
        super.init()
    }
    
    func describeMe() -> String {
        return "I am a human named \(name)"
    }
    func getName() -> String{
        return name;
    }
    
    func addHobbies(_ hobby:String ...) -> (){  //Use of variadic parameters
        for h in hobby {
            if !self.hobbies.contains(h){  // Use of a Logical (NOT) operator as well as includes an if control statement
                self.hobbies.append(h)
            }
        }
    }
    func printBasedOnGender() -> String{
        switch gender {
        case true:
            return "He is"
        case false:
            return "She is"
        default:
            return "He is"
        }
    }
    
    func getName()->String{
        return name
    }
    func getTeam()->String{
        return team
    }
    func getHome()->String{
        return home
    }
    func getGender() -> Bool {
        return gender
    }
    func getHobbies() -> [String] {
        return hobbies
    }
    func setImage(_ im: UIImage) {
        profilePic = im
    }
    func getImage()-> UIImage? {
        return profilePic
    }
    // MARK: Persist Data
    func encodeWithCoder(_ aCoder: NSCoder) {
        //aCoder.encode(firstName, forKey: Keys.FName)
        //aCoder.encode(middleName, forKey: Keys.MName)
        //aCoder.encode(lastName, forKey: Keys.LName)
        aCoder.encode(name,forKey: Keys.Name)
        aCoder.encode(home, forKey: Keys.Home)
        aCoder.encode(team, forKey: Keys.Team)
        aCoder.encode(gender, forKey: Keys.Gender)
        aCoder.encode(hobbies, forKey: Keys.Hobbies)
        aCoder.encode(profilePic, forKey: Keys.Image)
    }
    
    
    required convenience init(coder aDecoder: NSCoder){
        let name = aDecoder.decodeObject(forKey: Keys.Name) as String
        let team = aDecoder.decodeObject(forKey: Keys.Team) as String
        let home = aDecoder.decodeObject(forKey: Keys.Home) as! String
        let gender = aDecoder.decodeObject(forKey: Keys.Gender) as! Bool
        let hobbies = aDecoder.decodeObject(forKey: Keys.Hobbies) as! [String]
        let profilePic = aDecoder.decodeObject(forKey: Keys.Image) as? UIImage
        self.init(name, team, home, hobbies, gender, profilePic!)
        
    }
    
}


enum Gender: Int{
    case male
    case female
    case na
} //Here the values are implicit so now male = 0, female= 1, na = 2 by default

