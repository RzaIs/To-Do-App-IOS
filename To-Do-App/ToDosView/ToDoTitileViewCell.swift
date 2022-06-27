//
//  ToDoTitileViewCell.swift
//  To-Do-App
//
//  Created by Rza Ismayilov on 27.06.22.
//

import UIKit
import SnapKit
import RxSwift

class ToDoTitleViewCell: UITableViewCell {
    
    private let bag = DisposeBag()
    
    public var filterAndReload: () -> Void = {}
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Bold(size: 36)
        self.addSubview(label)
        return label
    }()
    
    private lazy var hideBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Hide completed", for: .normal)
        btn.setTitleColor(UIColor(hexaRGB: "#3478F6"), for: .normal)
        btn.titleLabel?.font = UIFont.Regular(size: 18)
        btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onHide(_:))))
        self.addSubview(btn)
        return btn
    }()
    
    public func setupView(theme: Theme, today: Bool) {
        if today {
            self.titleLabel.text = "Today"
            hideBtn.snp.makeConstraints { make in
                make.right.bottom.equalToSuperview().offset(-8)
            }
        } else {
            self.titleLabel.text = "Tomorrow"
        }
        
        switch theme {
        case .dark:
            self.backgroundColor = .black
            self.titleLabel.textColor = .white
        case .light:
            self.backgroundColor = .white
            self.titleLabel.textColor = .black
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.right.bottom.equalToSuperview().offset(-16)
        }
    }
    
    @objc func onHide(_ sender: UITapGestureRecognizer) {
        print("HIDE")
    }
    
}
