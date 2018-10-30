//
//  ViewController.swift
//  Coding_Part
//
//  Created by s0554822@htw-berlin.de on 16.10.18.
//  Copyright © 2018 s0554822@htw-berlin.de. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    @IBOutlet weak var button: UIButton!
    
    @IBAction func onclick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVX = storyboard.instantiateInitialViewController(withIdentifier: "Storyboard")
        navigationController?.pushViewController(secondVX, animated: true)
        
    }

    
    
    
    
    
}

