//
//  myTableViewController.swift
//  FirebaseTest
//
//  Created by Jeremy Cohen on 4/3/20.
//  Copyright © 2020 Jeremy Cohen. All rights reserved.
//

import UIKit
import FirebaseDatabase
class myTableViewCell: UITableViewCell {
    var groupID:String = ""
    var songID: String = ""
    var ref:DatabaseReference?
    var upButtonTapped:Bool = false
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    var downButtonTapped:Bool = false
    @IBAction func upButton(_ sender: Any) {
        if !upButtonTapped {
            upButtonTapped = true
            upButton.tintColor = .gray
        }
        else if upButtonTapped {
            upButtonTapped = false
            upButton.tintColor = .green
        }
        ref = Database.database().reference()
        self.ref?.child("\(groupID)/Songs/\(songID)/vote").setValue(Int(voteLabel.text!)! + 1)
    }
    
    @IBAction func downButton(_ sender: Any) {
        if !downButtonTapped {
            downButtonTapped = true
            downButton.tintColor = .gray
        }
        else if downButtonTapped {
            downButtonTapped = false
            downButton.tintColor = .red
        }
        // ref = Database.database().reference()
        self.ref?.child("\(groupID)/Songs/\(songID)/vote").setValue(Int(voteLabel.text!)! - 1)
    }
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class myTableViewController: UITableViewController {
    var groupID:String = ""
    @IBOutlet weak var groupLabel: UILabel!
    struct Song: Codable {
        var name:String
        var vote:Int
    }
    var ref:DatabaseReference?
    var databaseHandleAdd:DatabaseHandle?
    var databaseHandleUpdate:DatabaseHandle?
    
    var allKeys: [String: Song] = [:]
    var sortedKeys: [String] = []
    func getAllData() {
        ref = Database.database().reference()
        groupLabel.text = "GroupID: \(groupID)"
        databaseHandleAdd = ref?.child("\(groupID)/Songs").observe(.childAdded) { (snapshot) in
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
        
        databaseHandleUpdate = ref?.child("\(self.groupID)/Songs").observe(.value, with: { (snapshot) in
            self.allKeys = [:]
            self.sortedKeys = []
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let id = child.key
                let dict = child.value as! [String: Any]
                let s = Song(name: dict["name"] as! String, vote: dict["vote"] as! Int)
                self.allKeys[id] = s
            }
            self.sortedKeys = self.allKeys.keys.sorted(by: { (firstKey, secondKey) -> Bool in
                return self.allKeys[firstKey]!.vote > self.allKeys[secondKey]!.vote
            })
            self.tableView.reloadData()
            /*
            self.sortedKeys = self.allKeys.keys.sorted(by: { (firstKey, secondKey) -> Bool in
                return self.allKeys[firstKey]!.vote > self.allKeys[secondKey]!.vote
            })
            self.tableView.reloadData()*/
        })
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sortedKeys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! myTableViewCell
        let id = sortedKeys[indexPath.row]
        cell.songLabel.text = allKeys[id]!.name
        cell.voteLabel.text = String(allKeys[id]!.vote)
        cell.songID = id
        cell.groupID = self.groupID
        // Configure the cell...
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let submitVC = segue.destination as! submitViewController
        submitVC.groupID = self.groupID
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
