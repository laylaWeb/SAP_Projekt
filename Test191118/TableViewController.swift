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
    
    let headlines = ["All Services", "Amazon Web Services", "Apple Services"]
    var awsServices: [Service] = []
    var appleServices: [Service] = []
    var totalStatusService = Service(name: "TEST", stateMessage: " ", state: .Unknown )
    var totalNumberOfProblems = 0
    var dummyServices: [Service] = []
    var appleServicesParser: AppleDataService!
    var awsServicesParser: AWSDataService!
    var dummyServicesParser: DummyDataService!
    var showInactiveOnly = false
    
    func appleCompletion() -> Promise<[Service]> {
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
        Spinner.start(style: .white, backColor: UIColor.white, baseColor: UIColor.blue)

        showServices()

        _ = Timer.scheduledTimer(timeInterval: 900.0, target: self, selector: #selector(showServices), userInfo:nil, repeats: true)
        
        let statusChangedNotifCategory = UNNotificationCategory(identifier: "statusChangedNotification", actions: [], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([statusChangedNotifCategory])
        
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString(string: "refreshing")
        refresher.tintColor = UIColor.blue
        refresher.addTarget(self, action: #selector(showServices), for: .valueChanged)
        
    }
    
    func sendNotif() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            guard settings.authorizationStatus == .authorized else { return }
            
            let content = UNMutableNotificationContent()
            content.body = "Status Changed!"
            content.categoryIdentifier = "statusChangedNotification"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            let request = UNNotificationRequest(identifier: "StatusChange", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    @objc func showServices() {
        firstly {
            when(fulfilled: dummyCompletion(), awsCompletion())
            }.done { dummyServices, awsServices in
                self.dummyServices = dummyServices
                self.awsServices = awsServices
                
                var numberOfAWSProblems = 0
                var numberOfDummyProblems = 0
                
                for service in awsServices {
                    
                    if service.state == .Unavailable {
                        
                        numberOfAWSProblems += 1
                        
                    }
                }
                
                for service in dummyServices {
                    
                    if service.state == .Unavailable {
                        
                        numberOfDummyProblems += 1
                    }
                }
                
                var tempNumOfallProblems = numberOfAWSProblems + numberOfDummyProblems
                self.totalNumberOfProblems = tempNumOfallProblems
                self.filterIfNeeded()
            }.ensure {
                Spinner.stop()
                self.refresher.endRefreshing()
                self.tableView.reloadData()
                self.sendNotif()
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
            return 1
        }
        else if section == 1 {
            return awsServices.count
        } else if section == 2 {
            return dummyServices.count
        }
        return 0
    }
   // Das ist eine Methode die eine Zelle darstellt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCellApple", for: indexPath)
        
        var service: Service?
        var totalStatus = ""
        
        if (indexPath.section == 0) {
            
            if totalNumberOfProblems > 0 {
                if totalNumberOfProblems == 1 {
                    totalStatus = "ATTENTION! \(totalNumberOfProblems) detected error"
                } else {
                    totalStatus = "ATTENTION! \(totalNumberOfProblems) detected errors"
                }
            } else {
                totalStatus = "All Services operate normally"
            }
            
            totalStatusService.name = totalStatus
            service = totalStatusService
            
        }
        
        if (indexPath.section == 1) {
            service = awsServices[indexPath.row]
        } else if (indexPath.section == 2) {
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

        //super.viewDidLoad()

        return cell
    }
 
    func filterIfNeeded() {
        //show inactive only filter
       // Er guckt sich in den Einstellungen welche Eigenschaft gesetzt ist, wenn  es true ist dann
        //filtert er  nur die Inaktiven!
        let preferences = UserDefaults.standard
        if (preferences.object(forKey: SettingsTableViewController.PREF_INACTIVE_ONLY) != nil ) {
            showInactiveOnly = preferences.bool(forKey: SettingsTableViewController.PREF_INACTIVE_ONLY)
        }
        
        if (showInactiveOnly) {
            appleServices = appleServices.filter{
                service in service.state == ServiceState.Unavailable || service.state == ServiceState.Maintenance
            }
            
            awsServices = awsServices.filter {
                service in service.state == ServiceState.Unavailable || service.state == ServiceState.Maintenance
            }
            
            dummyServices = dummyServices.filter {
                service in service.state == ServiceState.Unavailable || service.state == ServiceState.Maintenance
            }
        }
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
