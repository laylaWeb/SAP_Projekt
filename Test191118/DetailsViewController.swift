//
//  DetailsViewController.swift
//  Test191118
//
//  Created by Sarah on 29.01.19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var service: Service?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel?.text = service?.name
        
        
        
        if (service?.name.contains("AWS"))! {
            detailsLabel?.text = service?.stateMessage
        }
        else if (service?.name.contains("Amazon"))! {
            detailsLabel?.text = service?.stateMessage
        }
        else if (service?.name.contains("disrupted"))! {
            detailsLabel?.text = "Please check the list in the mainview for disrupted services. You can also set your filter to show only interrupted services."
        }
        else if service?.state == ServiceState.Available {
            detailsLabel?.text = "Everything is operating normally."
        }
        else if service?.state == ServiceState.Maintenance {
            detailsLabel?.text = "A maintenance window is scheduled. Service is available, but latency issues might occur."
        }
        else if service?.state == ServiceState.Unavailable {
            detailsLabel?.text = "Service is disrupted. Please check again later."
        }
    }
}

