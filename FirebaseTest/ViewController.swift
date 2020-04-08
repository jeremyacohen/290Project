//
//  ViewController.swift
//  FirebaseTest
//
//  Created by Jeremy Cohen on 4/3/20.
//  Copyright © 2020 Jeremy Cohen. All rights reserved.
//

import UIKit
import FirebaseDatabase
extension UIView {
    func fadeIn(_ duration: TimeInterval? = 0.2, onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 1 },
                       completion: { (value: Bool) in
                          if let complete = onCompletion { complete() }
                       }
        )
    }

    func fadeOut(_ duration: TimeInterval? = 0.2, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 0 },
                       completion: { (value: Bool) in
                           self.isHidden = true
                           if let complete = onCompletion { complete() }
                       }
        )
    }

}
class ViewController: UIViewController {
    var id:String = "0"
    var joinGroup:Bool = false
    var createGroup:Bool = false
    var ref:DatabaseReference?


    @IBOutlet weak var serviceSlider: UISegmentedControl!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var groupTextValue: UITextField!
    @IBOutlet weak var newView: UIView!
    @IBAction func createButton(_ sender: Any) {
        createGroup = true
        var type = ""
        if serviceSlider.selectedSegmentIndex == 0{
            type = "Spotify"
        }
        else if serviceSlider.selectedSegmentIndex == 1{
            type = "Apple"
        }
        ref = Database.database().reference()
        ref?.child("Groups/\(groupTextValue.text!)").setValue(["admin": usernameText.text!, "type": type])
        
        
        
    }
    @IBAction func newGroupButton(_ sender: Any) {
        newView.fadeIn()
        validLabel.isHidden = true
    }
    @IBAction func cancelButton(_ sender: Any) {
        newView.fadeOut()
        validLabel.isHidden = true
    }
    @IBAction func joinButton(_ sender: Any) {
        joinGroup = true
    }
    
    var completionHandler:DatabaseHandle?
    

    func fetchUserName(completionHandler: @escaping (Set<String>) -> Void) {
        self.ref = Database.database().reference()
        self.ref?.child("Groups").observeSingleEvent(of: .value, with: {( snapshot) in
            var groupSet = Set<String>()
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                groupSet.insert(snap.key)
            }
            completionHandler(groupSet)
          })
    }
    @IBAction func validateButton(_ sender: Any) {
        self.fetchUserName { fetchedUserName in
            if fetchedUserName.contains(self.groupTextValue.text!){
                self.validLabel.isHidden = false
                self.validLabel.text = "Name Taken"
                self.validLabel.textColor = .red
            }
            else{
                self.validLabel.isHidden = false
                self.validLabel.text = "Valid!"
                self.validLabel.textColor = .green
            }
            
        }
        //let t = groupTextValue.text!
        /*
        ref = Database.database().reference()
        ref?.child("Groups").observeSingleEvent(of: .value, with: { (snapshot) in
          
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                self.groupSet.insert(snap.key)
            }
          }) { (error) in
            print(error.localizedDescription)
        }
        */
        /*
        print (t)
        if (t != ""){
            groupSet = getGroups(group: t)
            print (groupSet)
            if (!groupSet.contains(t)){
               
           }
           else{
               
           }
       }
 */
    }
    @IBOutlet weak var validLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        newView.isHidden = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if joinGroup {
            id = textField.text!
            let destVC = segue.destination as! myTableViewController
            destVC.groupID = id
        }
        if createGroup {
            let destVC = segue.destination as! myTableViewController
            destVC.groupID = groupTextValue.text!
            destVC.adminBool = true
        }
        
    }


}

