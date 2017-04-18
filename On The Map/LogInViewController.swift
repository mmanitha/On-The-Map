//
//  LogInViewController.swift
//  On The Map
//
//  Created by Michael Manisa on 4/17/17.
//  Copyright © 2017 Michael Manisa. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var LogInButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var session: URLSession!

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugTextLabel.text = ""
    }
    

    
    // MARK: Actions
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        UdacityClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.completeLogin()
                } else {
                    self.displayError(errorString)
                }
            }
        }
    }
    
    // MARK: Login
    
    private func completeLogin() {
        debugTextLabel.text = ""
        let controller = storyboard!.instantiateViewController(withIdentifier: "MapViewController") 
        present(controller, animated: true, completion: nil)
    }


}


private extension LogInViewController {
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }
    
}
