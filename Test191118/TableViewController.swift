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
    var dummyServices: [Service] = []
    var appleServicesParser: Parser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        appleServicesParser = Parser(url: URL(string:"https://www.apple.com/support/systemstatus/")!) { [weak self] services in
//            self?.appleServices = services
//
//        }
//        appleServicesParser.parse()

        let awsData = AWSDataService()
        awsData.getServices(callbackHandler: { [weak self] services in
            self?.awsServices = services
            self?.tableView.reloadData()
        })

        let dummyData = DummyDataService()
        dummyData.getServices(callbackHandler: { [weak self] services in
            self?.dummyServices = services
            self?.tableView.reloadData()
        })
        
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headlines[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.headlines.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.awsServices.count + self.dummyServices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("bla")
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCellApple", for: indexPath)
        if indexPath.section == 0 {
            let awsservice = awsServices.popLast()
            cell.textLabel?.text = awsservice?.name
            cell.detailTextLabel?.text = awsservice?.status
        }
        else if indexPath.section == 1 {
            let dummyService = dummyServices.popLast()
            cell.textLabel?.text = dummyService?.name
            cell.detailTextLabel?.text = dummyService?.status
        }
        return cell
    }
    
}
