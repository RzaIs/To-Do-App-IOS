//
//  AddTaskVC.swift
//  To-Do-App
//
//  Created by Rza Ismayilov on 26.06.22.
//

import UIKit
import SnapKit

class AddTaskVC: UIViewController {
    
    private let tc = TaskController.instance
    
    private var reload: () -> Void = {}
    
    private lazy var topView: TopView = {
        let view = TopView()
       
        view.setupView { [weak self] in
            self?.dismiss(animated: true)
        }
        self.view.addSubview(view)
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add a task"
        label.font = UIFont.Bold(size: 36)
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.SemiBold(size: 26)
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var nameField: UITextField = {
        let field = UITextField()
        field.placeholder = "name of your task"
        self.view.addSubview(field)
        return field
    }()

    private lazy var hourLable: UILabel = {
        let label = UILabel()
        label.text = "Hour"
        label.font = UIFont.SemiBold(size: 26)
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var hourPickerView: UIDatePicker = {
        let dp = UIDatePicker()
        
        dp.datePickerMode = .time
        dp.preferredDatePickerStyle = .compact
        
        self.view.addSubview(dp)
        return dp
    }()
    
    private lazy var todayLabel: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.font = UIFont.SemiBold(size: 26)
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var todaySwitch: UISwitch = {
        let uis = UISwitch()
        uis.isOn = true
        self.view.addSubview(uis)
        return uis
    }()
    
    private lazy var doneBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Done", for: .normal)
        btn.titleLabel?.font = UIFont.SemiBold(size: 20)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 12
        btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDone(_:))))
        self.view.addSubview(btn)
        return btn
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "If you disable today, the task will be considered as tomorrow"
        label.font = UIFont.Regular(size: 15)
        label.textColor = UIColor(hexaRGBA: "#3C3C4399")
        label.numberOfLines = 0
        self.view.addSubview(label)
        return label
    }()
    
    public func setupView(reload: @escaping () -> Void) {
        self.reload = reload
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.topView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(14)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(32)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(32)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-32)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(42)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(32)
        }
        
        self.nameField.snp.makeConstraints { make in
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-32)
            make.left.equalTo(nameLabel.snp.right).offset(16)
            make.centerY.equalTo(nameLabel)
        }
        
        self.hourLable.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(32)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(32)
        }
        
        self.hourPickerView.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(16)
            make.centerY.equalTo(hourLable)
        }
        
        self.todayLabel.snp.makeConstraints { make in
            make.top.equalTo(hourLable.snp.bottom).offset(42)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(32)
        }
        
        self.todaySwitch.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-32)
            make.centerY.equalTo(todayLabel)
        }
        
        self.doneBtn.snp.makeConstraints { make in
            make.top.equalTo(todayLabel.snp.bottom).offset(56)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(32)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-32)
            make.height.equalTo(48)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(doneBtn.snp.bottom).offset(12)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(32)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-32)
        }
        
    }
    
    @objc func onDone(_ sender: UITapGestureRecognizer) {

        guard let nameFieldText = nameField.text else {
            let failAlert = UIAlertController(title: "Empty Task Name", message: "Name of the task cannot be empty", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            failAlert.addAction(ok)
            self.present(failAlert, animated: true)
            return
        }
        
        guard nameFieldText.count != 0 else {
            let failAlert = UIAlertController(title: "Empty Task Name", message: "Name of the task cannot be empty", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            failAlert.addAction(ok)
            self.present(failAlert, animated: true)
            return
        }
    
        tc.saveTask(name: nameFieldText, hour: hourPickerView.date, today: todaySwitch.isOn)
        
        self.dismiss(animated: true)
        self.reload()
    }
}
