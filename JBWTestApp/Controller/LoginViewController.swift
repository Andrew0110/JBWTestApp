//
//  ViewController.swift
//  JBWTestApp
//
//  Created by Andrew on 15.02.18.
//  Copyright © 2018 AR. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameUnderline: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var verticalOffset: NSLayoutConstraint!

    var isSigned = true
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: NSNotification.Name(rawValue: Constants.kNCUserLoggedOut), object: nil)
        
        if LoginManager.sharedManager.accessToken.count > 0,
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocalesViewController") as? LocalesViewController {
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkIsSigned()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - UI settings
    func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signUpLblClicked))
        signUpLabel.addGestureRecognizer(tapGesture)
        signUpLabel.isUserInteractionEnabled = true
    }
    
    func checkIsSigned() -> () {
        if isSigned {
            nameTextField.isHidden = true
            nameUnderline.isHidden = true
            signUpLabel.text = "Not a registered user?"
            loginButton.setTitle("Log In", for: .normal)
            
            verticalOffset.constant = -60
        } else {
            nameTextField.isHidden = false
            nameUnderline.isHidden = false
            signUpLabel.text = "I am registered user"
            loginButton.setTitle("Sign Up", for: .normal)
            
            verticalOffset.constant = -30
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Actions
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        let completion: (Any?)->() = { (jsonResponse) in
            guard let response = jsonResponse as? NSDictionary else {
                return
            }
            
            guard let success = response["success"] as? Bool else {
                return
            }
            
            if !success, let errors = response["errors"] as? NSArray {
                
                guard let error = errors.firstObject as? NSDictionary else { return }
                guard let name = error["name"] else { return }
                guard let message = error["message"] else {return}
                
                let alert = UIAlertController(title: name as? String, message: message as? String, preferredStyle: .alert)
                let cancelAction = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            if success, let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocalesViewController") as? LocalesViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        if isSigned {
            LoginManager.sharedManager.login(with: emailTextField.text!, passwordTextField.text!, completion)
            return
        }
        LoginManager.sharedManager.signUp(nameTextField.text!, emailTextField.text!, passwordTextField.text!, completion)
    }
    
    @objc func signUpLblClicked() -> () {
        isSigned = !isSigned
        checkIsSigned()
    }

    @objc func logout() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

