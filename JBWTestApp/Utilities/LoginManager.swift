//
//  LoginManager.swift
//  JBWTestApp
//
//  Created by Andrew on 15.02.18.
//  Copyright © 2018 AR. All rights reserved.
//

import UIKit
import Alamofire

class LoginManager: NSObject {
    //MARK: - Properties
    var accessToken: String?
    var user: User?

    //MARK: - StaticMethods
    static let sharedManager = LoginManager()
    
    //MARK: - Methods
    private override init() {
        if let token = UserDefaults.standard.object(forKey: kUDAccessToken) as? String {
            self.accessToken = token
        } else {
            self.accessToken = ""
        }
    }
    
    func login(with email:String, _ password:String, _ completion:@escaping (Any?)->()) -> () {
        let url = "\(kURLBase)\(kURLLogin)"
        let parameters = ["email":email, "password":password]

        Alamofire.request(url,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                
                switch (response.result) {
                case .success:
                    if let json = response.result.value as? NSDictionary, let data = json["data"] as? [String:Any] {
                        self.accessToken = data["access_token"] as? String
                        UserDefaults.standard.set(self.accessToken, forKey: kUDAccessToken)
                        self.user = User(data)
                        completion(json)
                    }
                    
                case .failure(let error):
                    guard let statusCode = response.response?.statusCode else { return }
                    let message = error.localizedDescription + "\nStatus code:\(statusCode)"
                    print(message)
                }
        }
    }
    
    func signUp(_ name:String, _ email:String, _ password:String, _ completion:@escaping (Any?)->()) -> () {
        let url = "\(kURLBase)\(kURLSignUp)"
        let parameters = ["email":email, "password":password, "name":name]
        
        Alamofire.request(url,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                
                switch (response.result) {
                case .success:
                    if let json = response.result.value as? NSDictionary, let data = json["data"] as? NSDictionary {
                        self.accessToken = data["access_token"] as? String
                        UserDefaults.standard.set(self.accessToken, forKey: kUDAccessToken)
                        completion(json)
                    }

                    
                case .failure(let error):
                    guard let statusCode = response.response?.statusCode else { return }
                    let message = error.localizedDescription + "\nStatus code:\(statusCode)"
                    print(message)
                }
        }
    }

    func logout() {
        self.user = nil
        self.accessToken = ""
        UserDefaults.standard.removeObject(forKey: kUDAccessToken)
        
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: kNCUserLoggedOut)))
    }
}
