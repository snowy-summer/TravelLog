//
//  CoreDataManager.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/29.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    var persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init(name: String = "MainData") {
        self.persistentContainer = {
            let container = NSPersistentContainer(name: name)
            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("persistent stores를 가지고 오는데 실패 \(error)")
                }
            }
            return container
        }()
        
    }
    
    func saveContext(backgroudContext: NSManagedObjectContext? = nil) {
        let context = backgroudContext ?? context
        guard context.hasChanges else { return }
        
        do {
            try context.save()
            
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
            
        }
    }
    
}
