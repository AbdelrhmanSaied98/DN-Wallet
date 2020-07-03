//
//  DNError.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/23/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

enum DNError: String, Error {
    case unableToComplete   = "Unable to compelete your request, please check your internet connection."
    case invalidResponse    = "Invalid response from a server. please try again."
    case invalidData        = "The data received from the server was invalid, please try again."
    case invalidCode        = "Invalid Code, please try again."
    case invalidPhoneNumber = "Invalid Phone number, please enter a vaild phone number."
    case invalidToSendCode  = "Failure to send confirmation Code, please try again."
}

struct ErrorMessage {
    static let unableToComplete = "Unable to compelete your request, please check your internet connection."
    static let invalidResponse    = "Invalid response from a server. please try again."
    static let invalidData        = "The data received from the server was invalid, please try again."
    static let invalidCode        = "Invalid Code, please try again."
    static let invalidPhoneNumber = "Invalid Phone number, please enter a vaild phone number."
    static let invalidToSendCode  = "Failure to send confirmation Code, please try again."
    static let invalidBiometrics    = "Please enable your Face/Touch ID on your device"
    static let invalidAccessBiometrics = "Can not access to your Face/Touch ID Biometrics, please try again later."
}
