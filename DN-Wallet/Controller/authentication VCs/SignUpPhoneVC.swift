//
//  SignUpPhoneVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/6/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

protocol UpdatePhoneDelegate: class {
    func newPhoneAndCountryInfo(phone: String, country: String)
}


class SignUpPhoneVC: UIViewController {
    
    //MARK:- Properities
    var user:User?
    var updateState: Bool = false
    weak var updatePhoneDelegate : UpdatePhoneDelegate?
    //MARK:- Outlets
    
    @IBOutlet weak var vcTitle: UILabel!
    @IBOutlet weak var dropDownCountry: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var confirmCodeInfoMessage: UITextView!
    @IBOutlet weak var opt: OPT!
    @IBOutlet weak var sendConfirmatioCodeOutlet: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorContainer: UIView!
    @IBOutlet weak var steppedProgressBar: SteppedProgressBar!
    
    // MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDownCountry.delegate = self
        
        // specify opt delegation to this vc and hide this part for latter
        opt.delegate = self
        opt.isHidden = true
        confirmCodeInfoMessage.isHidden = true
        activityIndicatorContainer.isHidden = true
        
        
        // pop keyboard down when user tapped any place except the phone textField
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resetKeyboardState))
        self.view.addGestureRecognizer(tapGesture)
        
        // setup stepProgressBar
        if !updateState {
            steppedProgressBar.titles = ["", "", ""]
            steppedProgressBar.currentTab = 2
        } else {
            vcTitle.text = "Update Phone"
            steppedProgressBar.isHidden = true
        }
        //setUserPreferance()

    }
    
    @objc func resetKeyboardState() {
        phoneNumber.resignFirstResponder()
    }
    
    private func setUserPreferance() {
        if let country = UserPreference.getStringValue(withKey: UserPreference.country) {
            dropDownCountry.text = country
        }
        if !updateState {
            if let phone = UserPreference.getStringValue(withKey: UserPreference.phone) {
                phoneNumber.text = phone
            }
        }
        
    }
    
    private func presentSignUpConfirmEmailVC() {
        let st = UIStoryboard(name: "Authentication", bundle: .main)
        let vc = st.instantiateViewController(identifier: "signUpConfirmEmailVCID") as? SignUpConfirmEmailVC
        vc?.modalPresentationStyle = .fullScreen
        self.user?.country = self.dropDownCountry.text!
        self.user?.phone = self.phoneNumber.text!
        vc?.registerData = self.user
        self.present(vc!, animated: true)
    }
    private func backToEditAccountVC(with phone: String, country: String) {
        UserPreference.setValue(phone, withKey: UserPreference.phone)
        UserPreference.setValue(country, withKey: UserPreference.country)
        updatePhoneDelegate?.newPhoneAndCountryInfo(phone: phone, country: country)
        dismiss(animated: true, completion: nil)
        
    }
    
    func showIndicator(_ hidden: Bool) {
        if dropDownCountry.text != "" && phoneNumber.text != "" {
            activityIndicatorContainer.isHidden = !hidden
            hidden ? activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            self.opt.isHidden = hidden
            self.confirmCodeInfoMessage.isHidden = hidden
        } else {
            Alert.syncActionOkWith(nil, msg: "you must choose your country and enter your phone number", viewController: self)
        }
        
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    /// user ask api to send him confirmation code on his phone number
    @IBAction func sendConfirmationCodeBtnPressed(_ sender: UIButton) {
        showIndicator(true)
        sendConfirmatioCodeOutlet.setTitle("resend confirmation message", for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showIndicator(false)
        }
        
        
    }
    
}

extension SignUpPhoneVC: UITextFieldDelegate, PopUpMenuDelegate {
    func selectedItem(title: String, code: String?) {
        dropDownCountry.text = "(\(code ?? " "))\t" + title
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let vc = PopUpMenu()
        vc.menuDelegate = self
        vc.dataSource = .country
        self.present(vc, animated: true, completion: nil)
        textField.endEditing(true)
    }
}

extension SignUpPhoneVC: GetOPTValuesProtocol {
    /// this function called after user enter the opt code
    func getOpt(with value: String) {
        showIndicator(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showIndicator(false)
            if value == "1122" {
                self.opt.hideErrorMessgae()
                if self.updateState {
                    self.backToEditAccountVC(with: self.phoneNumber.text!, country: self.dropDownCountry.text!)
                } else {
                    self.presentSignUpConfirmEmailVC()
                }
            }else {
                self.opt.reset()
                self.opt.showErrorMessgae()
            }
        }
    }
}
