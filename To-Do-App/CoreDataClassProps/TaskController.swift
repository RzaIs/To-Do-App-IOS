//
//  TaskController.swift
//  To-Do-App
//
//  Created by Rza Ismayilov on 27.06.22.
//

import CoreData

class TaskController {

    public static var instance = TaskController()
    
    private init() {}
    
    private let entityName = "Task"

    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "To_Do_App")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("cannot load container")
            }
        }
        return container
    }()
    
    public func saveTask(name: String, hour: Date, today: Bool) {
        let context = self.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: self.entityName, in: context)!
        let task = Task(entity: entity, insertInto: context)
        
        task.id = UUID()
        task.name = name
        task.hour = hour
        task.done = false
        task.today = today
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    public func updateTask(id: UUID, done: Bool) {
        let context = self.container.viewContext
        let request = Task.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            let tasks = try context.fetch(request)
            if tasks.count != 0 {
                tasks.first?.done = done
            }
            try context.save()
        } catch {
            print(error)
        }
        
    }
    
    public func getSortedTasks() -> [[TaskModel]] {
        let tasks = self.getTasks()
        
        let todaysTasks = tasks?.filter { task in
            task.today
        } ?? []
        
        let tomorrowsTasks = tasks?.filter { task in
            !task.today
        } ?? []
        
        return [todaysTasks, tomorrowsTasks]
    }
    
    public func getTasks() -> [TaskModel]? {
        let context = self.container.viewContext
        let request = Task.fetchRequest()
        
        do {
            let datas =  try context.fetch(request)
            return datas.map { task in
                TaskModel(
                    id: task.id,
                    name: task.name ?? "nil",
                    hour: task.hour!,
                    done: task.done,
                    today: task.today
                )
            }
        } catch {
            return nil
        }
    }
}
