//
//  AlertManager.swift
//  LocationDemo
//
//  Created by Tong Yi on 7/1/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class AlertManager {
    static let shared = AlertManager()
    
    private init() {}
    
    func alert(title: String, message: String, controller: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        controller.present(alertController, animated: true, completion: nil)
        
        alertController.addAction(okButton)
    }
}
