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
    var getNotification = false
    
    
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
        
        refresh()
    }
    
    @objc func showServices() {
        firstly {
            when(fulfilled: dummyCompletion(), awsCompletion())
            }.done { dummyServices, awsServices in
                self.dummyServices = dummyServices
                self.awsServices = awsServices
                
                let numberOfAWSProblems = awsServices.filter { (service) in service.state == .Unavailable }.count
                let numberOfDummyProblems = dummyServices.filter { (service) in service.state == .Unavailable }.count
                
                self.totalNumberOfProblems = numberOfAWSProblems + numberOfDummyProblems
                
                self.filterIfNeeded()
                self.notifIfNeeded()
            }.ensure {
                Spinner.stop()
                self.refresher.endRefreshing()
                self.tableView.reloadData()
        }
    }
    
    func refresh() {
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
            content.body = "Service Status Changed!"
            content.categoryIdentifier = "statusChangedNotification"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            let request = UNNotificationRequest(identifier: "StatusChange", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
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
        }else if section == 2 {
            return dummyServices.count
        }
        return 0
    }
   // Das ist eine Methode die eine Zelle darstellt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCellApple", for: indexPath)
        
        var service: Service?
        var totalStatus = ""
        var state = service?.state
        
        if (indexPath.section == 0) {
            if totalNumberOfProblems > 0 {
                if totalNumberOfProblems == 1 {
                    totalStatus = "\(totalNumberOfProblems) service is disrupted"
                    state = ServiceState.Unavailable
                } else {
                    totalStatus = "\(totalNumberOfProblems) services are disrupted"
                    state = ServiceState.Unavailable
                }
            } else {
                totalStatus = "all services operate normally"
                state = ServiceState.Available
            }
            totalStatusService.name = totalStatus
            totalStatusService.state = state!
            totalStatusService.stateMessage = "check the list for more information"
            service = totalStatusService
        } else if (indexPath.section == 1) {
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
    
    
    func notifIfNeeded(){
        let preferences = UserDefaults.standard
        if (preferences.object(forKey: SettingsTableViewController.PREF_GET_NOTIFICATION) != nil ) {
            getNotification = preferences.bool(forKey: SettingsTableViewController.PREF_GET_NOTIFICATION)
            if(preferences.bool(forKey: SettingsTableViewController.PREF_GET_NOTIFICATION)==true){
                sendNotif()
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = tableView.indexPathForSelectedRow
        if segue.identifier == "MySegueDetails" {
            if (indexPath?.section == 0) {
                let service = self.totalStatusService
                let detailsViewController = segue.destination as! DetailsViewController
                detailsViewController.service = service
            } else if (indexPath?.section == 1) {
                let service = self.awsServices[(indexPath?.item)!]
                let detailsViewController = segue.destination as! DetailsViewController
                detailsViewController.service = service
            } else if (indexPath?.section == 2) {
                let service = self.dummyServices[(indexPath?.item)!]
                let detailsViewController = segue.destination as! DetailsViewController
                detailsViewController.service = service
            }
        }
    }
}
