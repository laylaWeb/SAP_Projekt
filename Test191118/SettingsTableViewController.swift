//
//  SettingsTableViewController.swift
//  Test191118
//
//  Created by Sarah on 26.11.18.
//  Copyright © 2018 Sarah. All rights reserved.
//

import UIKit

class SettingsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //1.)Ein outlet erstellt im  mainstoryboard zum Code, hier wird definiert und man kann drauf zugreifen
    
    @IBOutlet weak var switchInactiveOnly: UISwitch!
    
    @IBOutlet weak var switchGetNotification: UISwitch!
    
    @IBOutlet weak var settingTableView: UITableView!
    
    @IBAction func inactiveServer(_ sender: Any) {

    }
    
   
    
    
    static let PREF_INACTIVE_ONLY = "inactiveOnly"
    
    static let PREF_GET_NOTIFICATION = "getNotification"
    
    let headlines2 = ["Add & Manage Webservers"]
    let status2 = [[" "]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView.dataSource = self
        settingTableView.delegate = self
        
        //3.)Preferences sind Einstellungen, jede App hat seine Preferences,damit wir sie "Lesen" können machen wir
        //das hier, aus den Preferences "Lesen" wir den Schlüssel,siehe oben der heisst dann nicht mehr "currentLevelKey", sondern machen daraus eine Konstante, wir haben den definiert ist jetzt ein Schlüssel
           // den gucken wir uns herraus aus dem Speicher unserer Einstellungsseite herraus
        
        //4.) man holt jetzt die Preferenz Einstellung, man guckt hier für die App die Preferences und fragt dann mit der if unten
        let preferences = UserDefaults.standard
        var inactiveOnly = false
        var getNotification = false
        
       
        if (preferences.object(forKey: SettingsTableViewController.PREF_INACTIVE_ONLY) == nil) {
         
            inactiveOnly = true
            preferences.set(inactiveOnly, forKey: SettingsTableViewController.PREF_INACTIVE_ONLY)
          
            preferences.synchronize()
        } else {
            inactiveOnly = preferences.bool(forKey: SettingsTableViewController.PREF_INACTIVE_ONLY)
        }
   
        
        switchInactiveOnly.setOn(inactiveOnly, animated: true)
        
     
        switchInactiveOnly.addTarget(self, action: #selector(onSwitchChanged), for: UIControl.Event.valueChanged)
        
     
        if (preferences.object(forKey: SettingsTableViewController.PREF_GET_NOTIFICATION) == nil) {
            
            getNotification = true
            preferences.set(getNotification, forKey: SettingsTableViewController.PREF_GET_NOTIFICATION)
            
            preferences.synchronize()
        } else {
            getNotification = preferences.bool(forKey: SettingsTableViewController.PREF_GET_NOTIFICATION)
        }
        
        
        switchGetNotification.setOn(getNotification, animated: true)
        
        
        switchGetNotification.addTarget(self, action: #selector(onSwitchChanged), for: UIControl.Event.valueChanged)
        
        
    }
  
    @objc func onSwitchChanged(mySwitch: UISwitch) {
        
        let value = mySwitch.isOn
        let preferences = UserDefaults.standard
        
        switch mySwitch.accessibilityIdentifier {
        case "switchInactiveOnly":
            preferences.set(value, forKey: SettingsTableViewController.PREF_INACTIVE_ONLY)
            preferences.synchronize()
        case "switchGetNotification":
            preferences.set(value, forKey: SettingsTableViewController.PREF_GET_NOTIFICATION)
            preferences.synchronize()
        default:
            print("Identifiert not found")
        }
    }
    //13.)Dann sieht man in der App  das  Switch behält seine possition,das heisst es ist abegespeichert!
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return headlines2.count // 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headlines2[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return status2[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if (indexPath.section == 0) {
           if (indexPath.row == 0) {
                // Gib Zelle mit der url eingabe zurück
               cell = tableView.dequeueReusableCell(withIdentifier: "NewUrlCell", for: indexPath)
                
                //cell.accessibilityIdentifier("urlEditText")
    
           }
            else {
                // Gib eine Liste der URLs zurück
               cell = tableView.dequeueReusableCell(withIdentifier: "WebserverLabelCell", for: indexPath)
                cell.textLabel?.text = status2[indexPath.section][indexPath.row]
                
            }
        }
       else {
            //Gib die Liste der Apply Filter zurück
         cell = tableView.dequeueReusableCell(withIdentifier: "InactiveServersLabelCell", for: indexPath)
            
       }
    
       return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.section == 1
        {
            if indexPath.row == 1
            {
                return 30.0
            }
        }
        return 200.0
    }
}

