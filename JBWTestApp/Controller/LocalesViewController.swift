//
//  LocalesViewController.swift
//  JBWTestApp
//
//  Created by Andrew on 16.02.18.
//  Copyright © 2018 AR. All rights reserved.
//

import UIKit

class LocalesViewController: UIViewController {

    //MARK: - Properties
    var locales = [String]()
    
    @IBOutlet weak var tableView : UITableView!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locales = LocalesStore().locales
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView()
    }
    
    //MARK: - Actions

    @IBAction func logout(_ sender: Any) {
        LoginManager.sharedManager.logout()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LocalesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locales.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OccuranceCell", for: indexPath) as? OccuranceCell else {
            return UITableViewCell()
        }
        
        let locale = self.locales[indexPath.row]
        cell.configure("\(locale)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OccurenceViewController") as? OccurenceViewController {
            vc.setLocale(locales[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

