//
//  TableViewController.swift
//  Test191118
//
//  Created by Sar/Users/Sarah/Desktop/SAPDashboardApp/Test191118/SettingsTableViewController.swiftah on 20.11.18.
//  Copyright © 2018 Sarah. All rights reserved.
//

import UIKit
import PromiseKit
import UserNotifications

enum AWSError : Error {
    case NameIsEmpty
}

class TableViewController: UITableViewController {
    
    var refresher: UIRefreshControl!
    
    let headlines = ["Amazon Web Services", "Apple Services"]
    var awsServices: [Service] = []
    var appleServices: [Service] = []
    var dummyServices: [Service] = []
    var appleServicesParser: AppleDataService!
    var awsServicesParser: AWSDataService!
    var dummyServicesParser: DummyDataService!
    var showInactiveOnly = false
    
    func appleCompletion() -> Promise<[Service]> { //code für switches nicht in die promises
        return Promise { seal in
            
            appleServicesParser = AppleDataService(callbackHandler: { services in
                seal.resolve(services, nil)
            })
            
            appleServicesParser.getServices()
            
        }
    }
    
    func awsCompletion() -> Promise<[Service]> {
        return Promise { seal in
            
            awsServicesParser = AWSDataService(callbackHandler: { services in
                seal.resolve(services, nil)
            })
            
            awsServicesParser.getServices()
            
        }
    }
    
    func dummyCompletion() -> Promise<[Service]> {
        return Promise { seal in
            
            dummyServicesParser = DummyDataService(callbackHandler: { services in
                seal.resolve(services, nil)
            })
            
            dummyServicesParser.getServices()
            
        }
    }
    
    
    override func viewDidLoad() {

//               //Mirvete und ich 1
//                let preferences = UserDefaults.standard
//                if (preferences.object(forKey: SettingsTableViewController.PREF_INACTIVE_ONLY) != nil ) {
//                    showInactiveOnly = preferences.bool(forKey: SettingsTableViewController.PREF_INACTIVE_ONLY)
//
//               appleServicesParser = AppleDataService(url:
//               (string:"https://www.apple.com/support/systemstatus/")){
//               [weak self] services in
//
//                        if (self != nil && self!.showInactiveOnly) {
//                            self!.appleServices = services.filter {
//                                service in
//                                service.status !== "Available"
//                            }
//                        } else
//
//                            //17. ansonsten Liste komplett
//                        {
//                            self?.appleServices = services
//                        }
//                        self?.tableView.reloadData()
//                    }
//
//        }
//
//                super.viewDidLoad()
//     //-1
        Spinner.start(style: .white, backColor: UIColor.white, baseColor: UIColor.blue)
        
        showServices()
    
        _ = Timer.scheduledTimer(timeInterval: 900.0, target: self, selector: #selector(showServices), userInfo:nil, repeats: true)
        
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.tintColor = UIColor.blue
        refresher.addTarget(self, action: #selector(showServices), for: .valueChanged)
        
    }
    
    
    @objc func showServices() {
//        // Create the request object.
//        let content = UNMutableNotificationContent()
//        content.body = "Status Changed!"
//        //let trigger = MyTrigger(coder: NSCoder)
//        //let request = UNNotificationRequest(identifier: "StatusChange", content: content, trigger: trigger)
//
//        // Schedule the request.
//       // let center = UNUserNotificationCenter.current()
//        center.add(request) { (error : Error?) in
//            if let theError = error {
//                print(theError.localizedDescription)
//            }
//        }
        firstly { //code für switches auch nicht hier rein
            when(fulfilled: dummyCompletion(), awsCompletion())
            }.done { dummyServices, awsServices in
                self.dummyServices = dummyServices
                self.awsServices = awsServices
            }.ensure {
                Spinner.stop()
                self.refresher.endRefreshing()
                self.tableView.reloadData()
                
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headlines[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.headlines.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        if section == 0 {
            return awsServices.count
        } else if section == 1 {
            return dummyServices.count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCellApple", for: indexPath)
        
        var service: Service?
        if (indexPath.section == 0) {
            service = awsServices[indexPath.row]
        } else if (indexPath.section == 1) {
            service = dummyServices[indexPath.row]
        }
        
        cell.textLabel?.text = service!.name
        cell.detailTextLabel?.text = service!.stateMessage //Available
        
        if(service!.state == ServiceState.Available){
            cell.imageView?.image = UIImage(named: "gruen2")
        }
        else if(service!.state == ServiceState.Unavailable) {
            cell.imageView?.image = UIImage(named: "rot2")
        }
        else if(service!.state == ServiceState.Maintenance) {
            cell.imageView?.image = UIImage(named: "blau2")
        }

        
        //show inactive only filter 
        let preferences = UserDefaults.standard
        if (preferences.object(forKey: SettingsTableViewController.PREF_INACTIVE_ONLY) != nil ) {
            showInactiveOnly = preferences.bool(forKey: SettingsTableViewController.PREF_INACTIVE_ONLY)
            
            if(service!.state == ServiceState.Unavailable || service!.state == ServiceState.Maintenance){
                //print("hello")
                showServices()
                //self?.tableView.reloadData()
            }
        }
        //super.viewDidLoad()


        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = tableView.indexPathForSelectedRow
        if segue.identifier == "MySegueDetails" {
            if (indexPath?.section == 0) {
                var service = self.awsServices[(indexPath?.item)!]
                
                let detailsViewController = segue.destination as! DetailsViewController
                detailsViewController.service = service
                
            } else if (indexPath?.section == 1) {
                var service = self.dummyServices[(indexPath?.item)!]
                let detailsViewController = segue.destination as! DetailsViewController
                detailsViewController.service = service
            }
        }
        
    

        
    
}

}
