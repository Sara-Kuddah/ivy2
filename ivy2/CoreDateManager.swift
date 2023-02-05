//
//  CoreDateManager.swift
//  ivy2
//
//  Created by Sara Khalid BIN kuddah on 13/07/1444 AH.
//

import Foundation
import CoreData
import SwiftUI

class CoreDateManager{
    
    let persistentContainer: NSPersistentContainer
    
    public init() {
        persistentContainer = NSPersistentContainer(name: "IvyCoreDataModel")
        persistentContainer.loadPersistentStores{ (description, error)in
            if let error = error {
                fatalError("Core Date Store failed \(error.localizedDescription)")
            }
        }
    }
    func isItOnCoredata(name: String) -> Bool{
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = Habit.fetchRequest()
        // Configure a fetch request to fetch at most 1 result
       // let fetchRequest: NSFetchRequest<Habit>
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(
            format: "name LIKE %@", name
        )

        // Get a reference to a NSManagedObjectContext
        let context = persistentContainer.viewContext
        // Perform the fetch request to get the objects
        // matching the predicate
        let objects =   try! context.fetch(fetchRequest).first
        print("objects : \( String(describing: objects))")
        return (objects != nil)
//        let nilHabit = Habit(context: persistentContainer.viewContext)
//        nilHabit.name = "no"
//        nilHabit.points = 0
//        if ((objects) != nil){
//            return objects as! Habit
//        }else{
//            return nilHabit
//        }
        
    }
    func fitchByName(name: String) -> Habit{
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = Habit.fetchRequest()
        // Configure a fetch request to fetch at most 1 result
       // let fetchRequest: NSFetchRequest<Habit>
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(
            format: "name LIKE %@", name
        )

        // Get a reference to a NSManagedObjectContext
        let context = persistentContainer.viewContext
        // Perform the fetch request to get the objects
        // matching the predicate
        let objects =   try! context.fetch(fetchRequest).first
        print("objects : \( String(describing: objects))")
        return objects! as! Habit
//        let nilHabit = Habit(context: persistentContainer.viewContext)
//        nilHabit.name = "no"
//        nilHabit.points = 0
//        if ((objects) != nil){
//            return objects as! Habit
//        }else{
//            return nilHabit
//        }
        
    }
    func updateHabit(){
 
        do{
            try persistentContainer.viewContext.save()
           
        }catch{
            persistentContainer.viewContext.rollback()
        }
    }
    func getAllHabits() ->[Habit]{
        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        do{
            return try persistentContainer.viewContext.fetch(fetchRequest)
        }catch{
            return []
        }

    }
    func saveHabit(name: String, points: Int16){
        let habit = Habit(context: persistentContainer.viewContext)
        habit.name = name
        habit.points = points
        do{
            try persistentContainer.viewContext.save()
        }catch{
            print("Failed to save habit \(error)")
        }
    }
}
