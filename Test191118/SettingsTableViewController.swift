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
    @IBOutlet weak var switchDetailedStatusReport: UISwitch!
    // TODO 1: Erstelle ein Outlet fuer switchGetNotification
    
    @IBOutlet weak var settingTableView: UITableView!
    @IBAction func inactiveServer(_ sender: Any) {
        
//        if(service!.state !== ServiceState.Available){
//            showServices()
       // }
    }
    
    static let PREF_INACTIVE_ONLY = "inactiveOnly"
    static let PREF_DETAILED_STATUS_REPORT = "detailedStatusReport"
    // TODO 2: define a static const value for the getNotification key
    
    
    let headlines2 = ["Add & Manage Webservers", "Apply Filter"]
    let status2 = [[""], [""]]

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
        var detailedStatusReport = false
        //var getNotification = false
        
       //5.) ist den dieser Schlüssel überhaupt definiert, (nil== does not exist)
        if (preferences.object(forKey: SettingsTableViewController.PREF_INACTIVE_ONLY) == nil) {
         //6,) dann komme ich hier rein, wenn es nicht existiert dann setz man ein Standardwert mit dieser Eigenschaft setzen wir ihn in die Liste inactiveOnly = true!
            inactiveOnly = true
            preferences.set(inactiveOnly, forKey: SettingsTableViewController.PREF_INACTIVE_ONLY)
            //hier legt er es im Speicher , er synchronisiert,sobald wir die App schliessen ist es immer da!
            preferences.synchronize()
        } else {
            inactiveOnly = preferences.bool(forKey: SettingsTableViewController.PREF_INACTIVE_ONLY)
        }
    //7.)am Ende ist der Schlüseel definiert jetzt steht er auf der Liste dieser Schlüssel
        
        
        
        
        
        // 2.)Wie kann ich das animieren das Switchelement das es angeht je nach dem true oder false, im mainstoryboard sage ich das das aus ist, sobald ich es mit dieser Methode starte ist auf dem Simulator angeschalten (sobald die View geladen soll sie anspringen
        
        switchInactiveOnly.setOn(inactiveOnly, animated: true)
        
        //9.)Da sagt man diese Klasse soll darauf lauschen self ist der Controller, und der selektor dafür ist gleich der Funktion onSwitchChanged, da sagen wir welche Methode soll drauf geklickt werden, nämlich onSwitchChanged
        switchInactiveOnly.addTarget(self, action: #selector(onSwitchChanged), for: UIControl.Event.valueChanged)
        
        if (preferences.object(forKey: SettingsTableViewController.PREF_DETAILED_STATUS_REPORT) == nil) {
            detailedStatusReport = true
            preferences.set(detailedStatusReport, forKey: SettingsTableViewController.PREF_DETAILED_STATUS_REPORT)
            preferences.synchronize()
        } else {
            detailedStatusReport = preferences.bool(forKey: SettingsTableViewController.PREF_DETAILED_STATUS_REPORT)
        }
        
        // TODO 3: same as above for switchGetNotification
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    //8.)hier definiere ich eine Funktion es soll jetzt schliesslich funktionieren, die soll aufgerufen werden wenn jemand diesen Switch berührt!
  
    @objc func onSwitchChanged(mySwitch: UISwitch) {
        
        
        //10.) hier geben wir auf der konsole den isOn Status ausgeben
        
        //11.) gehe mainStoryboard dann brauchen wir ein Identifier,damit man die 3 Switche von einander unterscheiden kann nenn ich den "switchInactiveOnly"
        
        let value = mySwitch.isOn
        let preferences = UserDefaults.standard
        
        //12.) hier definieren  wier die Identifier, wenn es dieser ist dann nehmen wir unsere Preferences und setzen den Status "let value = mySwitch.isOn" auf den neuen Wert!
        
     
        switch mySwitch.accessibilityIdentifier {
        case "switchInactiveOnly":
            preferences.set(value, forKey: SettingsTableViewController.PREF_INACTIVE_ONLY)
            //
            //
            //hier kommt der Code rein?
            //preferences.set(value, forKey: SettingsTableViewController.inactiveServer(<#T##SettingsTableViewController#>))
            //
            //
            
            preferences.synchronize()
        // TODO 4: same as above for switchGetNotification, dont forget to set the identifier on main.storyboard
            
        default:
            print("Identifiert not found")
        }
    }
    //13.)Dann sieht man in der App  das  Switch behält seine possition,das heisst es ist abegespeichert!
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return status2.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headlines2[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return status2[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebserverLabelCell", for: indexPath)
        
        cell.textLabel?.text = status2[indexPath.section][indexPath.row]
        
        return cell
    }
    
    //override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    //{
        //return 40.0;//Choose your custom row height
    //    if indexPath.section == StatusReportLabelCell {
    //        return 60
    //    } else {
    //        return UITableView.automaticDimension
    //    }
    //}
    
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
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
