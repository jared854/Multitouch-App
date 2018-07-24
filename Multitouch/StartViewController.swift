//
//  StartViewController.swift
//  Multitouch
//
//  Created by Chris Gerencser and Jared Schwartz on 12/10/17.
//  Copyright © 2017 Joel Hollingsworth. All rights reserved.
//

import UIKit
var peopleCount = 2
var gametype = 0
class StartViewController: UIViewController {


    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var segController: UISegmentedControl!
    
    @IBAction func Stepper(_ sender: UIStepper) {
        countLabel.text = String(format: "%.0f", sender.value)
        peopleCount = Int(sender.value)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func GameType(_ sender: UISegmentedControl) {
        gametype = segController.selectedSegmentIndex
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
