//
//  FPEnterEmailVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/11/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class FPEnterEmailVC: UIViewController {
    
    var forgetPasswordMsg: UILabel = {
        let lb = UILabel()
        lb.text = "Forget Your Password ?"
        lb.textAlignment = .center
        lb.textColor = UIColor.DN.DarkBlue.color()
        lb.font = UIFont.DN.Bold.font()
        return lb
    }()
    var EnterEmailMsg: UITextView = {
        let Msg = UITextView()
        Msg.textAlignment = .center
        Msg.text = "Enter your email below and we will send you reset code"
        Msg.isEditable = false
        Msg.textColor = UIColor.DN.DarkBlue.color()
        Msg.font = UIFont.DN.Regular.font(size: 16)
        return Msg
    }()
    var emailField : UITextField = {
        let txt = UITextField()
        txt.placeholder = "enter your email"
        txt.stopSmartActions()
        txt.keyboardType = .emailAddress
        txt.textColor = UIColor.DN.DarkGray.color()
        txt.font = UIFont.DN.Regular.font(size: 14)
        return txt
    }()
    
    var emailContainerView: UIView = {
        let vw = UIView()
        vw.layer.borderColor = UIColor.DN.LightGray.color().cgColor
        vw.layer.borderWidth = 1
        return vw
    }()
    
    var sendResetCodeBtn: UIButton = {
        let Btn = UIButton(type: .system)
        Btn.setTitle("send reset code", for: .normal)
        Btn.setTitleColor(.white, for: .normal)
        Btn.titleLabel?.font = UIFont.DN.SemiBlod.font(size: 18)
        Btn.backgroundColor = UIColor.DN.DarkBlue.color()
        Btn.layer.cornerRadius = 8
        return Btn
    }()
    
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        setupLayout()
        
    }
    
    fileprivate func commonInit(){
        view.backgroundColor = .white
        sendResetCodeBtn.addTarget(self, action: #selector(sendResetCodeBtnPressed), for: .touchUpInside)
    }
    
    fileprivate func setupLayout() {
        
        view.addSubview(forgetPasswordMsg)
        view.addSubview(EnterEmailMsg)
        view.addSubview(emailContainerView)
        emailContainerView.addSubview(emailField)
        view.addSubview(sendResetCodeBtn)
        let leftC:CGFloat = 40
        let rightC:CGFloat = 40
    
        forgetPasswordMsg.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, margins: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0), centerH: true)
        EnterEmailMsg.DNLayoutConstraint(forgetPasswordMsg.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 10, left: leftC, bottom: 0, right: rightC), size: CGSize(width: 0, height: 60))
        emailContainerView.DNLayoutConstraint(EnterEmailMsg.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 40, left: leftC, bottom: 0, right: rightC), size: CGSize(width: 0, height: 40))
        emailField.DNLayoutConstraint(emailContainerView.topAnchor, left: emailContainerView.leftAnchor, right: emailContainerView.rightAnchor, bottom: emailContainerView.bottomAnchor, margins: UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 4))
        sendResetCodeBtn.DNLayoutConstraint(emailField.bottomAnchor, margins: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0), size: CGSize(width: 250, height: 40), centerH: true)
        
       }
    
    @objc func sendResetCodeBtnPressed() {
        let forgetPassVC = FPResetPasswordVC()
        forgetPassVC.modalPresentationStyle = .fullScreen
        self.present(forgetPassVC, animated: true, completion: nil)
    }
    

   

}


