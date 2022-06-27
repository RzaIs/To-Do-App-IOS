//
//  TaskModel.swift
//  To-Do-App
//
//  Created by Rza Ismayilov on 27.06.22.
//

import Foundation


struct TaskModel {
    var id: UUID?
    var name: String
    var hour: Date
    var done: Bool
    var today: Bool
}
