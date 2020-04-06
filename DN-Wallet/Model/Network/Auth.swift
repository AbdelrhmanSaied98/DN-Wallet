//
//  Auth.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/23/20.
//  Copyright © 2020 DN. All rights reserved.
//

import KeychainSwift
import LocalAuthentication

struct keys {
    static let keyPrefix = "dnwallet_"
    static let id = "user_id"
    static let password = "password"
    static let email = "email"
    static let token = "user_token"
}

/// Login, SignUp and get user's information from keychain
class Auth {
    
    static let shared = Auth()
    let keychain = KeychainSwift(keyPrefix: keys.keyPrefix)
    
    /// Login with Face ID or Touch ID
    func loginWithBiometric(viewController: UIViewController) {
        let context:LAContext = LAContext()
        var error: NSError?
        let reason = "Identify yourself"
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics , error: &error) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, error) in
                if success {
                    //guard let password = self?.keychain.get(keys.password) else { return }
                    //guard let email = self?.keychain.get(keys.email) else { return }
                    self?.authWithUserCredential(credintial: Login(email: "kkkk", password: "kkkkm")) { (success, error) in
                        if true {
                            DispatchQueue.main.async {
                                self?.pushHomeViewController(vc: viewController)
                            }
                            
                        }else {
                            // faild to login
                        }
                    }
                    
                } else {
                    // faild to identify user
                }
            }
        } else {
            // can not evaluate policy
            enableBiometricAuthAlert(viewController: viewController)
        }
    }
    
    /// Login with email and password
    /// - Parameters:
    ///   - password: user password which confirmed by API
    ///   - email: user id, it must be unique and also confirmed by API
    /// - Returns:
    ///   - Bool : return true of the process success, false otherwise.
    func authWithUserCredential(credintial: Login, completion: @escaping (Bool, Error?)->Void) {
//        Data.login(credintial: credintial) { [weak self] (response, error) in
//            guard let self = self else { return }
//            if let response = response {
//                self.keychain.set(response.token, forKey: keys.token, withAccess: .accessibleWhenUnlocked)
//                completion(true, nil)
//            }else {
//                completion(false, error)
//            }
//        }
        completion(true, nil)
    }
    
    /// create new acount with user info
    /// - Parameters:
    ///   - user: user is a structure with (email - password - username - phone - ...).
    func createAccount(user: User, completion: @escaping(Bool, Error?)-> Void) {
        let data = Register(email: user.email, password: user.password, username: user.username, phone: user.phone)
        Data.register(with: data) { [weak self] (response, error) in
            guard let self = self else { return }
            if let response = response {
                self.keychain.set(user.email, forKey: keys.email, withAccess: .accessibleWhenUnlocked)
                self.keychain.set(user.password, forKey: keys.password, withAccess: .accessibleWhenUnlocked)
                self.keychain.set(response.id, forKey: keys.id, withAccess: .accessibleWhenUnlocked)
                self.keychain.set(response.token, forKey: keys.token, withAccess: .accessibleWhenUnlocked)
                completion(true, nil)
            }else {
                completion(false, error)
            }
        }
    }
    
    /// update the user password from setting
    /// - Parameters:
    ///   - currentPassword: the current password entered to confirm the user.
    ///   - newPassword: new password.
    /// - Returns:
    ///   - Bool : return true of the process success, false otherwise.
    func updateCurrentPassword(_ currentPassword: String, newPassword: String) -> Bool {
        guard let password = keychain.get(keys.password) else { return false }
        if currentPassword ==  password{
            
            // first update the password in database (API)
            
            // if success then update password in keychain
            keychain.set(newPassword, forKey: keys.password, withAccess: .accessibleWhenUnlocked)
            
            // else faild to update password in the database, try again
            
        } else {
            // entered password not correct or faild to get the password from keychain
            return false
        }
        
        return true
    }
    
    
    /// update the user password when he forget it.
    /// - Parameters:
    ///   - newPassword: send new password to the database.
    /// - Returns:
    ///   - Bool : return true of the process success, false otherwise.
    func updateWithNewPassword(_ newPassword: String) -> Bool {
        
        // first update in database (API)
        
        // if success then update password in keychain
        keychain.set(newPassword, forKey: keys.password, withAccess: .accessibleWhenUnlocked)
        
        // else return false, faild to update the password
        return true
        // update password in both keychain & database
    }

    
    /// forget the current password and go to change it, confirm user email
    /// - Parameters:
    ///   - email: user email which the confirmation code will sent to it.
    func forgetCurrentPassword(_ email: String) {
        // sent confirmation digits to the user email
    }
    
    /// compare the two confirmation code equality.
    /// - Parameters:
    ///   - userDigits: the digits enter by user in the opt.
    ///   - sendDigits: the random digits that send by the app.
    /// - Returns:
    ///   - Bool : return true if the both are the same, false otherwise.
    func compareConfirmationDigits(_ userDigits: String, sendDigits: String) -> Bool {
        return userDigits == sendDigits
    }
    
    func generateConfirmationCode() -> String {
         var code = ""
         repeat {
             // Create a string with a random number 0...9999
             code = String(format:"%04d", arc4random_uniform(10000) )
         } while Set<Character>(code).count < 4
         return code
    }
    
    /// Alert pop up when the user do not enable his biometric authentication
    func enableBiometricAuthAlert(viewController: UIViewController) {
        let title = "Enable Biometric Auth"
        let message = "Please enable your Face/Touch ID on your device"
        buildAndPresentAlertWith(title, message: message, viewController: viewController)
    }
    
    func getUserEmail() -> String? {
        return keychain.get(keys.email)
    }
    
    
    func faildLoginAlert(viewController: UIViewController) {
        let title = "Faild Login"
        let message = "Email/Password is Invalid."
        buildAndPresentAlertWith(title, message: message, viewController: viewController)
    }
    
    func buildAndPresentAlertWith(_ title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func pushHomeViewController(vc: UIViewController) {
        let st = UIStoryboard(name: "Main", bundle: .main)
        let HomeVC = st.instantiateViewController(identifier: "startScreanID") as? SWRevealViewController
        HomeVC?.modalPresentationStyle = .fullScreen
        vc.present(HomeVC!, animated: true, completion: nil)
    }
    
}
