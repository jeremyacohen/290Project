//
//  submitViewController.swift
//  FirebaseTest
//
//  Created by Jeremy Cohen on 4/4/20.
//  Copyright © 2020 Jeremy Cohen. All rights reserved.
//

import UIKit
import FirebaseDatabase
class submitViewController: UIViewController {
    var ref:DatabaseReference?
    var databaseHandleAdd:DatabaseHandle?
    var groupIDs:[String] = []
    var groupID: String = ""
    @IBOutlet weak var textField: UITextField!
    @IBAction func submitButton(_ sender: Any) {
        ref = Database.database().reference()
        if textField.text != ""{
            ref!.child("\(groupID)/Songs").childByAutoId().setValue(["name": textField.text!, "vote": 0])
        }
        textField.text = ""
    }
    /*
    func getAllData() {
        ref = Database.database().reference()
        databaseHandleAdd = ref?.child(groupID).observe(.childAdded) { (snapshot) in
            let id = snapshot.key
            let dict = snapshot.value as! [String: Any]
            let s = Song(name: dict["name"] as! String, vote: dict["vote"] as! Int)
            //self.allSongs.append(s)
            self.allKeys[id] = s
            

            self.sortedKeys = self.allKeys.keys.sorted(by: { (firstKey, secondKey) -> Bool in
                return self.allKeys[firstKey]!.vote > self.allKeys[secondKey]!.vote
            })
            self.tableView.reloadData()
        }
            
    }
 */
    override func viewDidLoad() {
        super.viewDidLoad()
        //getGroups()
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
