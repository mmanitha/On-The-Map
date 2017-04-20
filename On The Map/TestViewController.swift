//
//  TestViewController.swift
//  On The Map
//
//  Created by Michael Manisa on 4/18/17.
//  Copyright © 2017 Michael Manisa. All rights reserved.
//

import UIKit

// MARK: - TEST VIEW CONTROLLER (Used to test networking code.)

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func getStudents(_ sender: Any) {
        
        ParseClient.sharedInstance().getStudents { (result, error) in
            
            if error == nil {
                
                //print(result!)
                
                
                // get the results dictionary
                //let dictionary = result?["results"]
                
                
                //let fistName = dictionary["firstName"]
                //print(dictionary!)
                
            } else {
                
                
                print(error!)
            }
            
        }
    }

    @IBAction func getStudent(_ sender: Any) {
        
        ParseClient.sharedInstance().getStudent(with: "5023103162") { (result, error) in
            
            if error == nil {
                
                print(result!)
                
            } else {
                
                print(error!)
            }
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
