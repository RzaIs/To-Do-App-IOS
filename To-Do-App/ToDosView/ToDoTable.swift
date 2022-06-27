//
//  ToDoTable.swift
//  To-Do-App
//
//  Created by Rza Ismayilov on 26.06.22.
//

import UIKit
import RxSwift

enum TaskCell {
    case todayCell(data: TaskModel), tomorrowCell(data: TaskModel), todayTitle, tomorrowTitle
}

class ToDoTable: UITableView {
    
    private let taskCtrl = TaskController.instance
    private let bag = DisposeBag()
    
    private var currentTheme = Theme.light
    
    private lazy var taskCells: [TaskCell] = []

    private let TODAY_TASK = "today task"
    private let TOMORROW_TASK = "tomorrow task"
    private let TODAY_TITLE = "today title"
    private let TOMORROW_TITLE = "tomorrow title"

    public func setupView() {
        self.backgroundColor = .none
        self.dataSource = self
        self.delegate = self
        self.register(ToDoViewCell.self, forCellReuseIdentifier: TODAY_TASK)
        self.register(ToDoViewCell.self, forCellReuseIdentifier: TOMORROW_TASK)
        self.register(ToDoTitleViewCell.self, forCellReuseIdentifier: TODAY_TITLE)
        self.register(ToDoTitleViewCell.self, forCellReuseIdentifier: TOMORROW_TITLE)
        self.separatorStyle = .none
    
        let sortedTasks = taskCtrl.getSortedTasks()
        
        taskCells.append(.todayTitle)
        sortedTasks[0].forEach { data in
            taskCells.append(.todayCell(data: data))
        }
        
        taskCells.append(.tomorrowTitle)
        sortedTasks[1].forEach { data in
            taskCells.append(.tomorrowCell(data: data))
        }
        
        ThemeController.instance.themeRelay
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                switch event {
                case .next(let theme):
                    self?.currentTheme = theme
                    self?.reloadData()
                default:
                    break
                }
            }.disposed(by: bag)
    }
    
    override func reloadData() {
        let sortedTasks = taskCtrl.getSortedTasks()
        
        taskCells = []
        
        taskCells.append(.todayTitle)
        sortedTasks[0].forEach { data in
            taskCells.append(.todayCell(data: data))
        }
        
        taskCells.append(.tomorrowTitle)
        sortedTasks[1].forEach { data in
            taskCells.append(.tomorrowCell(data: data))
        }
        super.reloadData()
    }
    
}

extension ToDoTable: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch taskCells[indexPath.row] {
        case .todayCell(let data):
            let cell = tableView.dequeueReusableCell(withIdentifier: TODAY_TASK) as! ToDoViewCell

            cell.setupView(taskData: data, theme: self.currentTheme) { [weak self] in
                self?.reloadData()
            }
            cell.selectionStyle = .none
            return  cell
        case .tomorrowCell(let data):
            let cell = tableView.dequeueReusableCell(withIdentifier: TOMORROW_TASK) as! ToDoViewCell
            
            cell.setupView(taskData: data, theme: self.currentTheme) { [weak self] in
                self?.reloadData()
            }
            cell.selectionStyle = .none
            return  cell
        case .todayTitle:
            let cell = tableView.dequeueReusableCell(withIdentifier: TODAY_TITLE) as! ToDoTitleViewCell
            cell.setupView(theme: self.currentTheme, today: true)
            cell.selectionStyle = .none
            return  cell
        case .tomorrowTitle:
            let cell = tableView.dequeueReusableCell(withIdentifier: TOMORROW_TITLE) as! ToDoTitleViewCell
            cell.setupView(theme: self.currentTheme, today: false)
            cell.selectionStyle = .none
            return  cell
        }
    }
}

enum CellType {
    case today, tomorrow, todo
}
