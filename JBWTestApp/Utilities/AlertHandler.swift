//
//  ErrorHandler.swift
//  JBWTestApp
//
//  Created by Andrew on 16.02.18.
//  Copyright © 2018 AR. All rights reserved.
//

import UIKit

class AlertHandler {
    static let sharedManager = AlertHandler()
    private init() {}
    
    func makeAlert(withErrors errors:[Any]) -> UIAlertController {
        let error = errors.first as? [String:Any] ?? [String:Any]()
        let status = error["status"] as? Int ?? 0
        let name = error["name"] as? String ?? "Unknown error"
        let message = error["message"] as? String ?? "Unknown error"
        
        let alert = UIAlertController(title: name, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
        let logoutAction = UIAlertAction.init(title: "Ok", style: .cancel, handler: { (action) in
            LoginManager.sharedManager.logout()
        })
        if status == 401 || status == 422 {
            alert.addAction(logoutAction)
        } else {
            alert.addAction(cancelAction)
        }
        
        return alert
    }
}
