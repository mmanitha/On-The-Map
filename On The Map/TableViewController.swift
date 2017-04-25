//
//  TableViewController.swift
//  On The Map
//
//  Created by Michael Manisa on 4/16/17.
//  Copyright © 2017 Michael Manisa. All rights reserved.
//

import Foundation
import UIKit

// MARK: - TableViewController: UIViewController

class TableViewController: UIViewController {
    
    // MARK: Properties
    var studentLocations = [[String:AnyObject]]()
    
    // MARK: Outlets
    @IBOutlet weak var locationsTableView: UITableView!
    
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load student data
        ParseClient.sharedInstance().getStudents { (result, error) in
            if result != nil {
                performUIUpdatesOnMain {
                    self.studentLocations = result!
                    self.locationsTableView.reloadData()
                }
            } else {
                print(error!)
            }
        }
    }
}


// MARK: - TableViewController: UITableViewDelegate, UITableViewDataSource

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        let student = studentLocations[indexPath.row]
        let firstName = student["firstName"] as? String ?? ""
        let lastName = student["lastName"] as? String ?? ""
        cell?.textLabel?.text = firstName + " " + lastName
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = studentLocations[indexPath.row]
        let studentURL = student["mediaURL"] as? String
        if studentURL != nil {
            UIApplication.shared.open(URL(string: studentURL!)!, options: [:], completionHandler: nil)
        } else {
            // if student doesnt have a mediaURL, send alert
            let alert = UIAlertController(title: "Oops", message: "Student does not have a mediaURL", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            print("no URL")
        }
    }
    
}
