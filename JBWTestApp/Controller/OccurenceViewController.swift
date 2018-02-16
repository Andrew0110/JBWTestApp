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
        guard let currentLocale = locale else { return }
        
        NetworkManager.sharedManager.getText(for: currentLocale) { [weak self] (jsonResponse) in
            guard let strongSelf = self else { return }
            
            guard let response = jsonResponse as? NSDictionary, let str = response["data"] as? String else {
                guard let response = jsonResponse as? NSDictionary, let errors = response["errors"] as? [Any] else {
                    return
                }
                
                let alert = AlertHandler.sharedManager.makeAlert(withErrors: errors)
                strongSelf.present(alert, animated: true, completion: nil)
                return
            }
            print(str)
            strongSelf.charactersDict = strongSelf.stringToDict(str)
            strongSelf.characters = Array(strongSelf.charactersDict.keys).sorted()
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
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
        let letters = Array(str.uppercased())
        var dict = [Character:Int]()
        letters.forEach({ (letter) in
                if let numberOfChars = dict[letter]  {
                    dict[letter] = numberOfChars + 1
                } else {
                    dict[letter] = 1
                }
        })
        return dict
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension OccurenceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OccuranceCell", for: indexPath) as? OccuranceCell else {
            return UITableViewCell()
        }
        
        let char = characters[indexPath.row]
        let number : Int = charactersDict[char] ?? 0
        cell.configure("\"\(char)\" - \(number) times")
        return cell
    }
    
    
}
