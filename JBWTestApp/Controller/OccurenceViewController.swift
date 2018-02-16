//
//  OccurenceViewController.swift
//  JBWTestApp
//
//  Created by Andrew on 15.02.18.
//  Copyright © 2018 AR. All rights reserved.
//

import UIKit

class OccurenceViewController: UIViewController {

    //MARK: - Properties
    private var locale:String?
    var charactersDict = [Character:Int]()
    var characters = [Character]()
    
    @IBOutlet weak var tableView : UITableView!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView()
    }
    
    //MARK: - Networking
    func loadText() {
        guard let currentLocale = self.locale else { return }
        
        NetworkManager.sharedManager.getText(for: currentLocale) { (jsonResponse) in
            guard let response = jsonResponse as? NSDictionary, let str = response["data"] as? String else {
                guard let response = jsonResponse as? NSDictionary, let errors = response["errors"] as? NSArray else {
                    return
                }
                
                guard let error = errors.firstObject as? NSDictionary else { return }
                guard let status = error["status"] as? Int else { return }
                guard let name = error["name"] as? String else { return }
                guard let message = error["message"] as? String else {return}
                
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
                self.present(alert, animated: true, completion: nil)
                return
            }
            print(str)
            self.charactersDict = self.stringToDict(str)
            self.characters = Array(self.charactersDict.keys).sorted()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    //MARK: - Actions
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func setLocale(_ locale:String) {
        self.locale = locale
        self.loadText()
    }
    
    func logout() {
        LoginManager.sharedManager.logout()
    }
    
    //MARK: - Helpers methods
    func stringToDict(_ str:String) -> [Character:Int] {
        let letters = Array(str)
        var dict = [Character:Int]()
        for letter in letters {
            if let numberOfChars = dict[letter]  {
                dict[letter] = numberOfChars + 1
            } else {
                dict[letter] = 1
            }
        }
        return dict
    }
}

extension OccurenceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OccuranceCell", for: indexPath) as? OccuranceCell else {
            return UITableViewCell()
        }
        
        let char = characters[indexPath.row]
        let number : Int = charactersDict[char] ?? 0
        cell.characterLabel?.text = "\"\(char)\" - \(number) times"
        return cell
    }
    
    
}
