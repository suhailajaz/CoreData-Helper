//
//  File.swift
//  Project-11-CoreData DatabaseHelper
//
//  Created by suhail on 05/10/23.
//


import CoreData
import UIKit
enum Gender{
    case male
    case female
}
final class DatabaseHelper{
    
    static let shared = DatabaseHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //CRUD METHODS
    func getAllPersons(completion: @escaping ([Person])->()){
        do{
            let people = try context.fetch(Person.fetchRequest())
            completion(people)
        }catch{
            print("Could not fetch persons!")
        }
    }
    
    func createNewPerson(personName: String,completion: (Bool)->()){
        let newPerson = Person(context: self.context)
        newPerson.name = personName
        newPerson.age = 25
        newPerson.gender = "Male"
        do{
            try self.context.save()
            completion(true)
        }catch{
            print(error.localizedDescription)
            completion(false)
        }
        
    }
    func deletePerson(person: Person,completion: @escaping (Bool)->()){
        self.context.delete(person)
        
        do{
            try self.context.save()
            completion(true)
        }catch{
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    func updatePerson(person: Person,newName: String,completion: @escaping (Bool)->Void){
        person.name = newName
        do{
            try self.context.save()
            completion(true)
        }catch{
            print(error.localizedDescription)
            completion(false)
        }
        
    }
    func filterByName(name: String, completion: @escaping ([Person])->()){
        
        do{
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            let pred = NSPredicate(format: "name CONTAINS %@", name)
            request.predicate = pred
            
            let people = try context.fetch(request)
            completion(people)
        }catch{
            print("Could not fetch specified person!")
        }
    }
    func sortByNameAscending(completion: @escaping ([Person])->()){
        do{
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            
            let people = try context.fetch(request)
            completion(people)
        }catch{
            print("Could not fetch specified person!")
        }
    }
    func sortByNameDescending(completion: @escaping ([Person])->()){
        do{
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            let sort = NSSortDescriptor(key: "name", ascending: false)
            request.sortDescriptors = [sort]
            
            let people = try context.fetch(request)
            completion(people)
        }catch{
            print("Could not fetch specified person!")
        }
    }
}
//family methods
extension DatabaseHelper{
    func createFamily(name : String,completion: @escaping ((Bool)->())){
        let family = Family(context: context)
        family.name = name
        
        let person = Person(context: context)
        person.name = "Brock"
        person.age = 45
        person.gender = "Male"
        
        person.family = family
        
        let person2 = Person(context: context)
        person2.name = "Ash"
        person2.age = 10
        person2.gender = "Male"
        
        person2.family = family
        
        let person3 = Person(context: context)
        person3.name = "Misty"
        person3.age = 12
        person3.gender = "Female"
        
        person3.family = family
        //or another way
        //family.addToMembers(person)
        do{
            try self.context.save()
            completion(true)
        }catch{
            print(error.localizedDescription)
            completion(false)
        }
    }
    func getAllFamilies(completion: @escaping ([Family])->()){
        do{
            let families = try context.fetch(Family.fetchRequest())
            completion(families)
        }catch{
            print("Could not fetch families!")
        }
    }

}
