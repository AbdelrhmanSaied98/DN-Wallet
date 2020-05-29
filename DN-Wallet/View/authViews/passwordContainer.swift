//
//  passwordContainer.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/12/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class passwordContainer: UIView {

    private var showPasswordBtn = UIButton(type: .system)
    
    private var eyeImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "eye")
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.tintColor = .black
        return img
    }()
    
    private var toggleShow: Bool = true
    
    var textField : UITextField = {
        let txt = UITextField()
        txt.placeholder = "New Password"
        txt.textColor = .DnColor
        txt.font = UIFont.DN.Regular.font(size: 14)
        txt.stopSmartActions()
        txt.isSecureTextEntry = true
        return txt
    }()
    
    fileprivate func setupLayout() {
        addSubview(textField)
        addSubview(showPasswordBtn)
        addSubview(eyeImage)
        
        eyeImage.DNLayoutConstraint(topAnchor, left: nil, right: rightAnchor, bottom: bottomAnchor, margins: .zero, size: CGSize(width: 30, height: 0))
        showPasswordBtn.DNLayoutConstraint(eyeImage.topAnchor, left: eyeImage.leftAnchor, right: eyeImage.rightAnchor, bottom: eyeImage.bottomAnchor)
        textField.DNLayoutConstraint(topAnchor, left: leftAnchor, right: showPasswordBtn.leftAnchor, bottom: bottomAnchor, margins: .zero, size: .zero)
    }
    
    fileprivate func commonInit() {
        setupLayout()
        showPasswordBtn.addTarget(self, action: #selector(toggleImage), for: .touchUpInside)
    }
    
    @objc func toggleImage() {
        
        if toggleShow {
            eyeImage.image = UIImage(systemName: "eye.slash")
            textField.isSecureTextEntry = false
            toggleShow = false
        }else {
            eyeImage.image = UIImage(systemName: "eye")
            textField.isSecureTextEntry = true
            toggleShow = true
            print("it is secure password")
        }
    }
    
    func configureTxtFeild(placeholder: String){
        textField.placeholder = placeholder
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
