//
//  Task+CoreDataProperties.swift
//  To-Do-App
//
//  Created by Rza Ismayilov on 27.06.22.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var done: Bool
    @NSManaged public var hour: Date?
    @NSManaged public var name: String?
    @NSManaged public var today: Bool
    @NSManaged public var id: UUID?

}

extension Task : Identifiable {

}
