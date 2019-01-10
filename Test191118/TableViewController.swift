//
//  TableViewController.swift
//  Test191118
//
//  Created by Sarah on 20.11.18.
//  Copyright © 2018 Sarah. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController {
    
    let headlines = ["Apple Service", "Amazon Web Service"]
    
    //    let status = [["App Store", "Device Enrollment Programm", "iOS Device Activation", "Mac App Store", "macOS Software Update", "Volume Purchase Program"],
    //                  ["Asia Pacific", "Europe", "North America", "South America" ]]
    var services: [Service] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dummyData = DummyDataService()
        services = dummyData.getServices()
        
        self.tableView.reloadData()
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
        return services.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCellApple", for: indexPath)
        let service = services[indexPath.row]
        cell.textLabel?.text = service.name
        cell.detailTextLabel?.text = service.status
        return cell
        }
    
    
    
}
