//
//  TableViewController.swift
//  Test191118
//
//  Created by Sar/Users/Sarah/Desktop/SAPDashboardApp/Test191118/SettingsTableViewController.swiftah on 20.11.18.
//  Copyright © 2018 Sarah. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController {
    
    let headlines = ["Apple Service", "Services", "Amazon Web Service"]
    
    //    let status = [["App Store", "Device Enrollment Programm", "iOS Device Activation", "Mac App Store", "macOS Software Update", "Volume Purchase Program"],
    //                  ["Asia Pacific", "Europe", "North America", "South America" ]]
    
    var allServices: String = "all services operating normally"
    var appleServices: [Service] = []
    var amazonServices: [Service] = [
        Service(name: "Test 1", status: "Available"),
        Service(name: "Test 2", status: "Unavailable"),
        Service(name: "Test 3", status: "Available")
    ]
    
    var appleServicesParser: Parser!
    //14.) Die Liste soll sich hier ändern bzw. Filtern!
    //soll ich die inactiven Server anzeigen oder nicht varible erstellt zunächst auf false
    var showInactiveOnly = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //15,) hier entsteht jetzt die funktion, und die bleibt jetzt auch in der View erhalten.
        let preferences = UserDefaults.standard
        if (preferences.object(forKey: SettingsTableViewController.PREF_INACTIVE_ONLY) != nil ) {
            showInactiveOnly = preferences.bool(forKey: SettingsTableViewController.PREF_INACTIVE_ONLY)
        }
        
        loadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return headlines.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headlines[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section == 0) {
            return appleServices.count
        } else if (section == 1) {
            return amazonServices.count
        }
        return 0

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCellApple", for: indexPath)
        
        var service: Service?
        if (indexPath.section == 0) {
            service = appleServices[indexPath.row]
        } else if (indexPath.section == 1) {
            service = amazonServices[indexPath.row]
        }
        
        cell.textLabel?.text = service!.name
        cell.detailTextLabel?.text = service!.status //Available
        
        if(cell.detailTextLabel?.text == "Available"){
            cell.imageView?.image = UIImage(named: "gruen")
        }
        else{
            cell.imageView?.image = UIImage(named: "rot")
        }

        return cell
    }
 
    func loadData() {
        appleServicesParser = Parser(url: URL(string:"https://www.apple.com/support/systemstatus/")!) {
            [weak self] services in
            
            // 16. Wenn wit filtern, dann filtert er
            if (self != nil && self!.showInactiveOnly) {
                self!.appleServices = services.filter {
                    service in
                    service.status == "Unavailable"
                }
            } else
            
            //17. ansonszen Liste komplett
            {
                self?.appleServices = services
            }
            self?.tableView.reloadData()
        }
        //allServices = awsServices + appleServices
        appleServicesParser.parse()
        
        if (showInactiveOnly) {
            amazonServices = amazonServices.filter{
                service in service.status == "Unavailable"
                
            }
        }
    }
    
}
