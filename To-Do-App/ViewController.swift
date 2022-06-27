//
//  ViewController.swift
//  To-Do-App
//
//  Created by Rza Ismayilov on 26.06.22.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

class ViewController: UIViewController {
    
    private lazy var bag = DisposeBag()
    private var themeCtrl = ThemeController.instance
    
    private lazy var addTaskBtn: UIButton = {
        let btn = UIButton()
        
        let img = UIImage(systemName: "plus.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        btn.setImage(img, for: .normal)
        btn.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onAdd(_:)))
        )
        
        self.view.addSubview(btn)
        return btn
    }()
    
    private lazy var switchThemeBtn: UIButton = {
        let btn = UIButton()
        
        btn.setTitle("Switch theme", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onSwitchTheme(_:)))
        )
        btn.titleLabel?.font = UIFont.SemiBold(size: 20)
        
        self.view.addSubview(btn)
        return btn
    }()
    
    private lazy var todoTable: ToDoTable = {
        let table = ToDoTable()
        table.setupView()
        self.view.addSubview(table)
        return table
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.switchThemeBtn.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-16)
        }
        
        self.todoTable.snp.makeConstraints { make in
            make.top.equalTo(switchThemeBtn.snp.bottom)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(addTaskBtn.snp.top).offset(-4)
        }
        
        self.addTaskBtn.snp.makeConstraints { make in
            make.right.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-4)
        }
 
        self.addTaskBtn.imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(52)
        }

        themeCtrl.themeRelay
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] theme in
                switch theme.event {
                case .next(let theme):
                    self?.switchTheme(newTheme: theme)
                default:
                    break
                }
            }.disposed(by: bag)
        
        themeCtrl.loadTheme()
    }
    
    public func switchTheme(newTheme: Theme) {
        switch newTheme {
        case .dark:
            self.view.backgroundColor = .black
            self.switchThemeBtn.setTitleColor(.white, for: .normal)
            let img = UIImage(systemName: "plus.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            self.addTaskBtn.setImage(img, for: .normal)
        case .light:
            self.view.backgroundColor = .white
            self.switchThemeBtn.setTitleColor(.black, for: .normal)
            let img = UIImage(systemName: "plus.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            self.addTaskBtn.setImage(img, for: .normal)
        }
    }
    
    @objc func onAdd(_ sender: UITapGestureRecognizer) {
        let vc = AddTaskVC(nibName: nil, bundle: nil)
        vc.setupView { [weak self] in
            self?.todoTable.reloadData()
        }
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
    }
    
    @objc func onSwitchTheme(_ sender: UITapGestureRecognizer) {
        themeCtrl.switchTheme()
    }


}
