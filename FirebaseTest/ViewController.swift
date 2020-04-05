//
//  ViewController.swift
//  FirebaseTest
//
//  Created by Jeremy Cohen on 4/3/20.
//  Copyright © 2020 Jeremy Cohen. All rights reserved.
//

import UIKit
import FirebaseDatabase
class ViewController: UIViewController {
    var id:String = "0"
    var joinGroup:Bool = false
    @IBAction func joinButton(_ sender: Any) {
        joinGroup = true
    }
    @IBOutlet weak var joinButtton: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! myTableViewController
        if joinGroup {
            id = textField.text!
        }
        else{
            id = "1"
        }
        destVC.groupID = id
    }


}

