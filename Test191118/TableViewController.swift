//
//  TableViewController.swift
//  Test191118
//
//  Created by Sarah on 20.11.18.
//  Copyright © 2018 Sarah. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController {
    
    let headlines = ["Amazon Web Services", "Apple Services"]
    var allServices: [Service] = []
    var awsServices: [Service] = []
    var appleServices: [Service] = []
    var appleServicesParser: Parser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appleServicesParser = Parser(url: URL(string:"https://www.apple.com/support/systemstatus/")!) { [weak self] services in
            self?.appleServices = services
            self?.tableView.reloadData()
        }
        //allServices = awsServices + appleServices
        appleServicesParser.parse()
        
        
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return headlines.count
    //    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headlines[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appleServices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCellApple", for: indexPath)
        let service = appleServices[indexPath.row]
        cell.textLabel?.text = service.name
        cell.detailTextLabel?.text = service.status
        return cell
        }
    
    
    
}
