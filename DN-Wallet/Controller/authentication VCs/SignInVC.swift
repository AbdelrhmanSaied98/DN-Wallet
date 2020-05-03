//
//  SignInVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var emailContainerView: userInput!
    @IBOutlet weak var passwordContainerView: userInput!
    @IBOutlet weak var signInOutlet: UIButton!
    var loginWithFaceIDButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .white
        btn.setTitle("   Login With FaceID", for: .normal)
        btn.setImage(UIImage(systemName: "faceid"), for: .normal)
        btn.addTarget(self, action: #selector(loginWithFaceIDBtnPressed), for: .touchUpInside)
        btn.layer.cornerRadius = 25.0
        btn.backgroundColor = .DnDarkBlue
        return btn
    }()
    var FaceIdFounded: Bool = false
    var shouldEvaluate: Bool = true
    var LoginWithBiometric: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginWithBiometric = UserDefaults.standard.bool(forKey: Defaults.LoginWithBiometric.key)
        FaceIdFounded = UserDefaults.standard.bool(forKey: Defaults.BiometricTypeFaceID.key)
        signInOutlet.layer.cornerRadius = 20.0
        emailContainerView.configureInputField(imageName: "envelope", systemImage: true, placeholder: "Email", isSecure: false)
        passwordContainerView.configureInputField(imageName: "lock", systemImage: true, placeholder: "Password", isSecure: true)
        if  LoginWithBiometric && FaceIdFounded {
            setupLoginWithFaceIDLayout()
            shouldEvaluate = false
            print("x1")
        } else if LoginWithBiometric {
            Auth.shared.loginWithBiometric(viewController: self)
            print("x3")
        }
        
        if LoginWithBiometric && shouldEvaluate && !UserDefaults.standard.bool(forKey: Defaults.BiometricTypeTouchID.key) {
            Auth.shared.canEvaluatePolicyWithFaceID()
            print("x4")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailContainerView.textField.text = Auth.shared.getUserEmail()
        passwordContainerView.textField.text = ""
    }

    @IBAction func haveNoAccountPressed(_ sender: Any) {
        let st = UIStoryboard(name: "Authentication", bundle: .main)
        let vc = st.instantiateViewController(identifier: "signUpVCID") as? SignUpVC
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true)
    }
    
    @IBAction func forgetPasswordPressed(_ sender: Any) {
        let forgetPassVC = FPEnterEmailVC()
        //forgetPassVC.modalPresentationStyle = .fullScreen
        self.present(forgetPassVC, animated: true, completion: nil)
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
    
        if emailContainerView.textField.text != "" && passwordContainerView.textField.text != "" {
            let email = emailContainerView.textField.text!
            let password = passwordContainerView.textField.text!
            if Auth.shared.isValidEmail(email) && password.count >= 8 {
                Auth.shared.authWithUserCredential(credintial: Login(email: email, password: password)) { (success, error) in
                    if success {
                        Auth.shared.pushHomeViewController(vc: self)
                    } else {
                        Alert.asyncActionOkWith("Faild Login", msg: "email or password are incorrect, Try Again.", viewController: self)
                    }
                }
            } else {
                Alert.asyncActionOkWith("Faild Login", msg: "email or password are incorrect, Try Again.", viewController: self)
            }
            
        }

    }
    
    func setupLoginWithFaceIDLayout() {
        view.addSubview(loginWithFaceIDButton)
        loginWithFaceIDButton.DNLayoutConstraint(nil, left: view.leftAnchor, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 40, bottom: 20, right: 40), size: CGSize(width: 0, height: 50))
    }
    
    @objc func loginWithFaceIDBtnPressed() {
        Auth.shared.loginWithBiometric(viewController: self)
    }
    
}

