//
//  User.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/23/20.
//  Copyright © 2020 DN. All rights reserved.
//

struct Register: Codable {
    let name: String
    let email: String
    let password: String
    let confirm_password : String
    // optional
    // let phone: String
    // let country: String
    // let gender: String
    // let job: String
    // let photo: String
}

struct RegisterResponder: Codable {
    let token: String
    let id: String
}
