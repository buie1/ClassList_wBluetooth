//
//  Students.swift
//  jab165-ece590-hw3
//
//  Created by Jonathan Buie on 9/19/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import Foundation
import UIKit
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

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class Students: Human {
    
    struct Keys {
        static let Degree = "degree"
        static let Languages = "languages"
    }
    
    //fileprivate var courses: [Double:String]! // This is dictionary of a students current classes
    //private var transcript: [Double:Grade] //This is a dictionary of a students classes & Grades
    //lazy var gpa : Double? = 4.0 // Here we are using a lazy variable unlike the other variable this is able to refer to the instance
    
    
    //fileprivate var major: String!
    fileprivate var degree: String!
    fileprivate var languages = [String]()
    
    override init(){
        super.init()
    }

    init(_ fName:String, _ teamN:String, _ homeT:String, _ gend:Bool = true,
         _ deg:String, _ im:UIImage?, _ lang:[String] = [String](),
         _ hob:[String] = [String]()){
        degree = deg
        languages = lang
        super.init(fName, teamN, homeT, hob, gend, im)
        
    }
    override func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(degree, forKey: Keys.Degree)
        aCoder.encode(languages, forKey: Keys.Languages)
        super.encodeWithCoder(aCoder)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: Keys.Name) as! String
        let team = aDecoder.decodeObject(forKey: Keys.Team) as! String
        let from = aDecoder.decodeObject(forKey: Keys.From) as! String
        let sex = aDecoder.decodeObject(forKey: Keys.Sex) as! Bool
        let degree = aDecoder.decodeObject(forKey: Keys.Degree) as! String
        let hobbies = aDecoder.decodeObject(forKey: Keys.Hobbies) as! [String]
        let languages = aDecoder.decodeObject(forKey: Keys.Languages) as! [String]
        let pic = aDecoder.decodeObject(forKey: Keys.Pic) as? UIImage
        self.init(name,team,from,sex,degree,pic,languages,hobbies)
    }

    override func describeMe() -> String {
        var myDescription: String = ""
        //1. Start with the name
        let studentName: String = name;  //Change studentName to be first name?
        myDescription += name

        //2. Where are you from?
        //myDescription += " is \(printBasedOnGPA()) student from \(homeTown)."
        myDescription += " is a student from \(from!)."
        //3. Major & Program
        myDescription += "\n"
        myDescription += " \(printBasedOnGender()) a \(degree!) at Duke University. "
        
        //4. Hobbies
        if hobbies.count == 1{
            myDescription += "\(studentName)'s only hobby is \(hobbies[0])"
        }else if hobbies.count > 1 {
            var counter = 0
            myDescription += "\(studentName)'s hobbies include:"
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
            myDescription += "\(studentName)'s proficient Language(s) include:\n"
            for l in languages{
                myDescription += "\(l)\n"
            }
         }else{
            myDescription += "Unfortunately \(studentName) is not proficient in any languages."
         }
        return myDescription
    }

    
    func getDegree() -> Degree {
        if degree == "Undergraduate student"{
            return .UG
        }else if  degree == "Masters student"{
            return .MS
        }else if degree == "PhD student"{
            return .PHD
        }else if degree == "Alumni"{
            return .Alum
        }else if degree == "Honorary graduate"{
            return .honorary
        }else{
            return .MS
        }
    }
    
    func getDegree() -> String {
        return degree
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

enum Degree :String {
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
        static let From = "from"
        static let Team = "team"
        static let Sex = "sex"
        static let Hobbies = "hobbies"
        static let Pic = "pic"
    }

    fileprivate var name: String!
    fileprivate var team: String!
    fileprivate var from: String!
    fileprivate var sex : Bool!
    fileprivate var hobbies = [String]()
    fileprivate var pic: UIImage?
    
    override init(){
        super.init()
    }
    
    
    init(_ name:String, _ t:String, _ home:String, _ hob:[String] = [String](), _ gender:Bool = true, _ im:UIImage?){
        self.name = name
        self.team = t
        self.from = home
        self.hobbies = hob
        self.sex = gender
        self.pic = im
        
        super.init()
    }
    
    func describeMe() -> String {
        return "I am a human named \(name)"
    }
    
    func addHobbies(_ hobby:String ...) -> (){  //Use of variadic parameters
        for h in hobby {
            if !self.hobbies.contains(h){  // Use of a Logical (NOT) operator as well as includes an if control statement
                self.hobbies.append(h)
            }
        }
    }
    func printBasedOnGender() -> String{
        switch sex {
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
    func getFrom()->String{
        return from
    }
    func getSex() -> Bool {
        return sex
    }
    func getHobbies() -> [String] {
        return hobbies
    }
    func setImage(_ im: UIImage) {
        pic = im
    }
    func getImage()-> UIImage? {
        return pic
    }
    // MARK: Persist Data
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(name,forKey: Keys.Name)
        aCoder.encode(from, forKey: Keys.From)
        aCoder.encode(team, forKey: Keys.Team)
        aCoder.encode(sex, forKey: Keys.Sex)
        aCoder.encode(hobbies, forKey: Keys.Hobbies)
// Add languages and degrees
        aCoder.encode(pic, forKey: Keys.Pic)
    }
    
    
    required convenience init(coder aDecoder: NSCoder){
        let name = aDecoder.decodeObject(forKey: Keys.Name) as! String
        let team = aDecoder.decodeObject(forKey: Keys.Team) as! String
        let from = aDecoder.decodeObject(forKey: Keys.From) as! String
        let sex = aDecoder.decodeObject(forKey: Keys.Sex) as! Bool
        let hobbies = aDecoder.decodeObject(forKey: Keys.Hobbies) as! [String]
// Add languages and degrees
        let pic = aDecoder.decodeObject(forKey: Keys.Pic) as? UIImage
        self.init(name, team, from, hobbies, sex, pic!)
        
    }
}


enum Gender: Int{
    case male
    case female
    case na
} //Here the values are implicit so now male = 0, female= 1, na = 2 by default

