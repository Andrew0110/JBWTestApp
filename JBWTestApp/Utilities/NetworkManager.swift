//
//  NetworkManager.swift
//  JBWTestApp
//
//  Created by Andrew on 15.02.18.
//  Copyright © 2018 AR. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager {
    static let sharedManager = NetworkManager()
    private init() {}
    
    func getText(for locale:String, with completion:@escaping (Any?)->()) -> Void {
        let url = "\(kURLBase)\(kURLGetText)"
        let headers = ["Authorization":"Bearer \(LoginManager.sharedManager.accessToken!)"]
        let parameters = ["Locale":locale]
        
        Alamofire.request(url,
                          method: .get,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers)
            
            .responseJSON { response in
                switch (response.result) {
                case .success:
                    if let json = response.result.value as? NSDictionary {
                        completion(json)
                    }
                    
                case .failure(let error):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 422 {
                        LoginManager.sharedManager.logout()
                    }
                    let message = error.localizedDescription + "\nStatus code:\(statusCode)"
                    print(message)
                }
        }
    }
}
