//
//  Students.swift
//  jab165-ece590-hw3
//
//  Created by Jonathan Buie on 9/19/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import Foundation
import UIKit

class Students: Human {
    
    struct Keys {
        static let Courses = "courses"
        static let GPA = "gpa"
        static let Major = "major"
        static let Program = "program"
        static let Animate = "animate"
        static let Languages = "languages"
    }
    
    private var courses: [Double:String]! // This is dictionary of a students current classes
    //private var transcript: [Double:Grade] //This is a dictionary of a students classes & Grades
    lazy var gpa : Double? = 4.0 // Here we are using a lazy variable unlike the other variable this is able to refer to the instance
    
    
    private var major: String!
    private var program: String!
    private var animate: Bool!
    private var languages = [String]()
    
    override init(){
        super.init()
    }
    // Clean up initializers :'(
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
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(courses, forKey: Keys.Courses)
        aCoder.encodeObject(gpa, forKey: Keys.GPA)
        aCoder.encodeObject(major, forKey: Keys.Major)
        aCoder.encodeObject(program, forKey: Keys.Program)
        aCoder.encodeObject(animate, forKey: Keys.Animate)
        aCoder.encodeObject(languages, forKey: Keys.Languages)
        super.encodeWithCoder(aCoder)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let firstName = aDecoder.decodeObjectForKey(Keys.FName) as! String
        let lastName = aDecoder.decodeObjectForKey(Keys.LName) as! String
        let middleName = aDecoder.decodeObjectForKey(Keys.MName) as! String?
        _ = aDecoder.decodeObjectForKey(Keys.Name) as! String
        let homeTown = aDecoder.decodeObjectForKey(Keys.HTown) as! String
        let sex = aDecoder.decodeObjectForKey(Keys.Sex) as! Bool
        let hobbies = aDecoder.decodeObjectForKey(Keys.Hobbies) as! [String]
        let living = aDecoder.decodeObjectForKey(Keys.Live) as! Bool
        let profilePic = aDecoder.decodeObjectForKey(Keys.Image) as? UIImage
        let courses = aDecoder.decodeObjectForKey(Keys.Courses) as! [Double:String]
        _ = aDecoder.decodeObjectForKey(Keys.GPA) as? Double
        let major = aDecoder.decodeObjectForKey(Keys.Major) as! String
        let program = aDecoder.decodeObjectForKey(Keys.Program) as! String
        let animate = aDecoder.decodeObjectForKey(Keys.Animate) as! Bool
        let languages = aDecoder.decodeObjectForKey(Keys.Languages) as! [String]
        self.init(firstName,lastName,middleName,homeTown, courses, major, program, hobbies, sex, languages, profilePic, animate, living)
    }
    
    /*func calculateGPA() -> Double?{
        var sum: Double = 0
        for (_, grade) in transcript{
            sum += grade.gradeValue()
        }
        return (sum/Double(transcript.count))
    }*/
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
        
         /*
        //5. Current Courses
        if(courses.count != 0){
            myDescription += "Their course list includes:\n"
            for (n,c) in courses{
                myDescription += "\(n): \(c)\n"
            }
        }else{
            myDescription += "\(printBasedOnGender()) not currently enrolled in any classes."
        }
         */
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
    
    func printBasedOnGPA() -> String{
        if gpa > 3.0{
            return "an exceptional"
        }
        else if gpa < 3.0 &&  gpa >= 2.0{
            return "an average"
        }
        else if gpa < 2.0 && gpa > 1.0{
            return "a struggling"
        }
        else{
            return "a failing"
        }
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
    func getMajor()-> String {
        return major
    }
    
    func getCourses() -> [Double:String]{
        return courses
    }
    
    func setAnimate(bool: Bool){
        self.animate = bool
    }
    func getAnimate()->Bool!{
        return self.animate
    }
    func getLanguages()->[String]{
        return languages
    }
    func setLanguages(str:[String]){
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
        static let FName = "firstName"
        static let LName = "lastName"
        static let MName = "middleName"
        static let Name = "fullName"
        static let HTown = "homeTown"
        static let Sex = "sex"
        static let Hobbies = "hobbies"
        static let Live = "living"
        static let Image = "profilePic"
    }
    
    private var firstName: String!
    private var lastName: String!
    private var middleName: String?
    private var fullName: String!
    private var homeTown: String!
    private var sex : Bool!
    private var hobbies = [String]()
    private var living: Bool!
    
    private var profilePic: UIImage?
    
    override init(){
        super.init()
    }
    
    init(_ fName: String, _ lName:String, _ mName:String?, _ hTown:String, _ live:Bool = true, _ gender:Bool = false ){
        firstName = fName
        lastName = lName
        middleName = mName
        homeTown = hTown
        living = live
        fullName = fName + " " + lName
        sex = gender
        
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
        fullName = fName + " " + lName
        sex = gender
        
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
        fullName = fName + " " + lName
        sex = gender
        profilePic = im
        
        super.init()

    }
    func describeMe() -> String {
        return "I am a human named \(fullName)"
    }
    func getName() -> String{
        return fullName;
    }
    
    func addHobbies(hobby:String ...) -> (){  //Use of variadic parameters
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
            return "She is"
        }
    }
    
    func getFirstName()->String {
        return firstName
    }
    func getMiddleName()->String? {
        return middleName
    }
    func getLastName()->String{
        return lastName
    }
    func getHometown()->String{
        return homeTown
    }
    func getSex() -> Bool {
        return sex
    }
    func getHobbies() -> [String] {
        return hobbies
    }
    
    func setImage(im: UIImage) {
        profilePic = im
    }
    func getImage()-> UIImage? {
        return profilePic
    }
    // MARK: Persist Data
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(firstName, forKey: Keys.FName)
        aCoder.encodeObject(middleName, forKey: Keys.MName)
        aCoder.encodeObject(lastName, forKey: Keys.LName)
        aCoder.encodeObject(fullName,forKey: Keys.Name)
        aCoder.encodeObject(homeTown, forKey: Keys.HTown)
        aCoder.encodeObject(sex, forKey: Keys.Sex)
        aCoder.encodeObject(hobbies, forKey: Keys.Hobbies)
        aCoder.encodeObject(living, forKey: Keys.Live)
        aCoder.encodeObject(profilePic, forKey: Keys.Image)
    }
    
    
    required convenience init(coder aDecoder: NSCoder){
        let firstName = aDecoder.decodeObjectForKey(Keys.FName) as! String
        let lastName = aDecoder.decodeObjectForKey(Keys.LName) as! String
        let middleName = aDecoder.decodeObjectForKey(Keys.MName) as! String?
        _ = aDecoder.decodeObjectForKey(Keys.Name) as! String
        let homeTown = aDecoder.decodeObjectForKey(Keys.HTown) as! String
        let sex = aDecoder.decodeObjectForKey(Keys.Sex) as! Bool
        let hobbies = aDecoder.decodeObjectForKey(Keys.Hobbies) as! [String]
        let living = aDecoder.decodeObjectForKey(Keys.Live) as! Bool
        let profilePic = aDecoder.decodeObjectForKey(Keys.Image) as? UIImage
        self.init(firstName, lastName, middleName, homeTown, hobbies, living, sex, profilePic!)
        
    }
    
}


enum Gender: Int{
    case male
    case female
    case na
} //Here the values are implicit so now male = 0, female= 1, na = 2 by default

