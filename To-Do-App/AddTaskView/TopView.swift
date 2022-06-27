//
//  TopView.swift
//  To-Do-App
//
//  Created by Rza Ismayilov on 26.06.22.
//

import UIKit
import SnapKit

class TopView: UIView {
    
    private var onClose: () -> Void = {}

    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        
        let btnImage = UIImageView(image: UIImage(named: "arrow"))
        let btnLabel = UILabel()
        
        btn.addSubview(btnImage)
        btn.addSubview(btnLabel)
        
        btnImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        btnLabel.text = "Close"
        btnLabel.font = UIFont.Regular(size: 24)
        btnLabel.textColor = UIColor(hexaRGB: "#007AFF")
        btnLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(btnImage.snp.right).offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        
        btn.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onCloseTap(_:)))
        )
        
        self.addSubview(btn)        
        return btn
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Task"
        label.font = UIFont.SemiBold(size: 24)
        self.addSubview(label)
        return label
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexaRGB: "#D3D3D3")
        self.addSubview(view)
        return view
    }()
    
    public func setupView(onClose: @escaping () -> Void) {
        
        self.onClose = onClose
        
        self.closeBtn.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    @objc func onCloseTap(_ sender: UITapGestureRecognizer) {
        self.onClose()
    }

}
