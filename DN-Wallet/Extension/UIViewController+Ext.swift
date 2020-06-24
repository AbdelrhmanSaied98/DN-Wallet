//
//  UIViewController+Ext.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/23/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func configureNavigationBar(_ titleTintColor : UIColor = .white, backgoundColor: UIColor = .DnColor, tintColor: UIColor = .white, title: String, preferredLargeTitle: Bool = false) {
    if #available(iOS 13.0, *) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: titleTintColor]
        appearance.titleTextAttributes = [.foregroundColor: titleTintColor]
        appearance.backgroundColor = backgoundColor
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationItem.leftBarButtonItem?.tintColor = tintColor
        navigationController?.navigationItem.rightBarButtonItem?.tintColor = tintColor
        navigationItem.title = title

    } else {
        // Fallback on earlier versions
        navigationController?.navigationBar.barTintColor = backgoundColor
        navigationController?.navigationBar.backgroundColor = backgoundColor
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationItem.leftBarButtonItem?.tintColor = tintColor
        navigationController?.navigationItem.rightBarButtonItem?.tintColor = tintColor
        navigationItem.title = title
    }
}}
