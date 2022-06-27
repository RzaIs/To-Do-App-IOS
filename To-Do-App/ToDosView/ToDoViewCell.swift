//
//  ToDoViewCell.swift
//  To-Do-App
//
//  Created by Rza Ismayilov on 27.06.22.
//

import UIKit
import SnapKit

class ToDoViewCell: UITableViewCell {
    
    private let taskCtrl = TaskController.instance
    
    private var id: UUID!
    private var done: Bool!
    private var reload: (() -> Void)!

    private lazy var checkBox: UIImageView = {
        let view = UIImageView()
        self.addSubview(view)
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexaRGB: "#737373")
        label.numberOfLines = 0
        self.addSubview(label)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexaRGB: "#A3A3A3")
        self.addSubview(label)
        return label
    }()

    public func setupView(taskData: TaskModel, theme: Theme, reload: @escaping () -> Void) {
        
        self.id = taskData.id
        self.done = taskData.done
        self.reload = reload
        
        if taskData.today {
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCheck(_:))))
        
            self.checkBox.snp.remakeConstraints { make in
                make.width.height.equalTo(24)
            }
            
            switch theme {
            case .dark:
                self.backgroundColor = .black
                
                let image = taskData.done ? UIImage(
                    systemName: "checkmark.square"
                )?.withTintColor(
                    .white,
                    renderingMode: .alwaysOriginal
                ) : UIImage(
                    systemName: "square"
                )?.withTintColor(
                    UIColor(hexaRGB: "#E8E8E8")!,
                    renderingMode: .alwaysOriginal
                )
                
                self.checkBox.image = image
                
            case .light:
                self.backgroundColor = .white
                
                let image = taskData.done ? UIImage(
                    systemName: "checkmark.square.fill"
                )?.withTintColor(
                    .black,
                    renderingMode: .alwaysOriginal
                ) : UIImage(
                    systemName: "square"
                )?.withTintColor(
                    UIColor(hexaRGB: "#A8A8A8")!,
                    renderingMode: .alwaysOriginal
                )
                
                self.checkBox.image = image
            }
        } else {
            self.checkBox.snp.remakeConstraints { make in
                make.width.height.equalTo(12)
            }
            
            switch theme {
            case .dark:
                self.backgroundColor = .black
                self.checkBox.image = UIImage(systemName: "circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            case .light:
                self.backgroundColor = .white
                self.checkBox.image = UIImage(systemName: "circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            }
        }
                
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: taskData.name)
        if taskData.done {
            attributeString.addAttribute(
                    NSAttributedString.Key.strikethroughStyle,
                    value: 2,
                    range: NSRange(
                        location: 0,
                        length: attributeString.length
                    )
                )
        }
        
        nameLabel.attributedText = attributeString
        
        dateLabel.attributedText = self.formatDate(date: taskData.hour, done: taskData.done)
                
        self.checkBox.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.left.equalTo(checkBox.snp.right).offset(12)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.right.equalToSuperview().offset(-12)
            make.left.equalTo(checkBox.snp.right).offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    private func formatDate(date: Date, done: Bool) -> NSAttributedString {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let text = formatter.string(from: date)
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        if done {
            attributeString.addAttribute(
                    NSAttributedString.Key.strikethroughStyle,
                    value: 2,
                    range: NSRange(
                        location: 0,
                        length: attributeString.length
                    )
                )
        }
        return attributeString
    }
    
    @objc func onCheck(_ sender: UITapGestureRecognizer) {
        taskCtrl.updateTask(id: self.id, done: !self.done)
        self.reload()
    }
}
