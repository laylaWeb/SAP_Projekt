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
        
        if service?.state == ServiceState.Maintenance {
            detailsLabel?.text = "ksjhdfkshefiuwehfoisdf"
        }
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

