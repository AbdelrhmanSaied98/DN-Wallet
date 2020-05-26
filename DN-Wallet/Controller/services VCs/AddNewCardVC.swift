//
//  AddNewCardVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/16/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

let lbColor = UIColor.DN.LightBlue.color()
let textColor = UIColor.DN.Black.color()


class AddNewCardVC: UIViewController {
    
    var cardName: DropDown!
    var cardNameContainer: UIView = {
        let vw = UIView()
        vw.layer.borderColor = UIColor.DN.DarkBlue.color().cgColor
        vw.layer.borderWidth = 0.5
        return vw
    }()
    var cardHolderName: UITextField = {
        let tf = UITextField()
        tf.rightPadding(text: "CARDHONER NAME")
        tf.configurePaymentTF()
        return tf
    }()
    var cardNumber: UITextField = {
        let tf = UITextField()
        tf.rightPadding(text: "CARD NUMBER")
        tf.placeholder = "xxxx - xxxx - xxxx - xxxx"
        tf.configurePaymentTF()
        tf.keyboardType = .numberPad
        return tf
    }()
    var expireDate: UITextField = {
        let tf = UITextField()
        tf.rightPadding(text: "EXPIRE DATE")
        tf.placeholder = "05  /  21"
        tf.configurePaymentTF()
        tf.keyboardType = .asciiCapableNumberPad
        return tf
    }()
    
    var cvv: UITextField = {
        let tf = UITextField()
        tf.rightPadding(text: "CVV")
        tf.placeholder = "123"
        tf.configurePaymentTF()
        tf.keyboardType = .asciiCapableNumberPad
        return tf
    }()
    var address: UITextField = {
        let tf = UITextField()
        tf.rightPadding(text: "ADDRESS")
        tf.configurePaymentTF()
        return tf
    }()
    
    var previousTextFieldContent: String = ""
    var nextTextFieldContent:String = ""
    var previousLocation: Int!
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupDropDown()
        setupLayout()
        cardNumber.delegate = self
        expireDate.delegate = self
        cardNumber.addTarget(self, action: #selector(cardNumberFormate), for: .editingChanged)
        expireDate.addTarget(self, action: #selector(expireDateFormate), for: .editingChanged)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @objc func cardNumberFormate() {
        if previousLocation == 3 || previousLocation == 10 || previousLocation == 17 {
            cardNumber.text = "\(previousTextFieldContent)\(nextTextFieldContent) - "
        }
        if previousLocation == 24 {
            expireDate.becomeFirstResponder()
        }
    }
    
    @objc func expireDateFormate() {
        if previousLocation == 1 {
            expireDate.text = "\(previousTextFieldContent)\(nextTextFieldContent)  /  "
        }
        if previousLocation == 8 {
            cvv.becomeFirstResponder()
        }
    }
    
    func setupNavBar() {
        self.configureNavigationBar(title: K.vc.addNewCardTitle)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add , target: self, action: #selector(addPaymentCardBtnPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: K.sysImage.leftArrow), style: .plain, target: self, action: #selector(dismissBtnWasPressed))
    }
    
    @objc func dismissBtnWasPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addPaymentCardBtnPressed() {
        
        //navBar.rightBtn.isEnabled = false
        let alert = UIAlertController(title: K.alert.success, message: K.vc.addNewCardAlertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: K.alert.ok, style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// setup drop down list which contain cards image
    func setupDropDown() {
        cardName = DropDown()
        cardName.borderColor = UIColor.DN.DarkBlue.color()
        cardName.optionArray = ["Visa", "Meza", "Master Card"]
        cardName.isSearchEnable = false
        cardName.optionIds = [1,23,54]
    }
    
    /// setup layout constraint navBar, stackview(cardName, cardHoner, cardNumber, expireDate, cvv, address)
    func setupLayout() {
        
        let Hstack = UIStackView(arrangedSubviews: [
            cardNameContainer,
            cardHolderName,
            cardNumber,
            expireDate,
            cvv,
            address
        ])
        Hstack.configureHstack()
        view.addSubview(Hstack)
        Hstack.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 20, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 310))
        cardNameContainer.translatesAutoresizingMaskIntoConstraints = false
        cardNameContainer.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        cardNameContainer.addSubview(cardName)
        cardName.DNLayoutConstraint(cardNameContainer.topAnchor, left: cardNameContainer.leftAnchor, right: cardNameContainer.rightAnchor, bottom: cardNameContainer.bottomAnchor, margins: UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 20))
    }
}

extension UITextField {
    func configurePaymentTF() {
        self.backgroundColor = .white
        self.font = UIFont.DN.Bold.font(size: 14)
        self.textColor = UIColor.DN.Black.color()
        self.stopSmartActions()
        self.leftPadding()
        self.setBottomBorder()
    }
}

extension AddNewCardVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        previousLocation = range.location
        previousTextFieldContent = textField.text!
        nextTextFieldContent = string
        
        return true
    }
}
