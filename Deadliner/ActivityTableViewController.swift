//
//  ActivityTableViewController.swift
//  Deadliner
//
//  Created by Muhammad Iksanul on 07/04/20.
//  Copyright © 2020 Peter Andrew. All rights reserved.
//

import UIKit

class ActivityTableViewController: UITableViewController {
    var db = DBManager()

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var activities: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.selectedSegmentIndex = 1
        
//        let newActivity = Activity(context: db.context)
//        newActivity.title = "activity 1"
//        newActivity.priority = 3
//        newActivity.isDone = false
//        newActivity.startDate = Date().addingTimeInterval(-500000000)
//        newActivity.endDate = Date().addingTimeInterval(-500)
//
//        db.save()
//

//        let newActivity2 = Activity(context: db.context)
//        newActivity2.title = "activity 2"
//        newActivity2.priority = 2
//        newActivity2.isDone = false
//        newActivity2.startDate = Date().addingTimeInterval(-500000000)
//        newActivity2.endDate = Date().addingTimeInterval(500000000000)
//
//        db.save()
        
//        activities = db.fetch()
        let predicate = NSPredicate(format: "startDate < %@ AND isDone == false", Date() as NSDate)
        activities = db.fetch(withPredicate: predicate)
        
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
        return activities.count
    }

    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let predicate = NSPredicate(format: "startDate > %@", Date() as NSDate)
            activities = db.fetch(withPredicate: predicate)
            self.tableView.reloadData()
            break
        case 1:
            let predicate = NSPredicate(format: "startDate < %@ AND isDone == false", Date() as NSDate)
            activities = db.fetch(withPredicate: predicate)
            self.tableView.reloadData()
            break
        case 2:
            let predicate = NSPredicate(format: "startDate < %@ AND isDone == true", Date() as NSDate)
            activities = db.fetch(withPredicate: predicate)
            self.tableView.reloadData()
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as? ActivityTableViewCell{

            cell.nameActivity.text = activities[indexPath.row].title
            cell.nameActivity.sizeToFit()
            
            switch activities[indexPath.row].priority {
            case 3:
                cell.priorityActivity.text = "High"
                cell.priorityActivity.backgroundColor = .red
                break
            case 2:
                cell.priorityActivity.text = "Medium"
                cell.priorityActivity.backgroundColor = .orange
                break
            case 1:
                cell.priorityActivity.text = "Low"
                cell.priorityActivity.backgroundColor = .blue
                break
            default:
                break
            }
            
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                cell.labelTimer.isHidden = false
                cell.labelTimer.text = "Start in"
                cell.timerActivity.text = calculateDate(start: Date(), end: activities[indexPath.row].startDate ?? Date())
                break
            case 1:
                cell.labelTimer.isHidden = false
                if activities[indexPath.row].endDate ?? Date() < Date() {
                    cell.labelTimer.isHidden = true
                    cell.timerActivity.text = "Times up"
                } else{
                    cell.labelTimer.text = "Deadline in"
                    cell.timerActivity.text = calculateDate(start: Date(), end: activities[indexPath.row].endDate ?? Date())
                }
                break
            case 2:
                cell.labelTimer.isHidden = true
                cell.timerActivity.text = "Finish"
                break
            default:
                break
            }
            
            
            return cell
        }
        return ActivityTableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){_,_,_ in
            self.db.remove(self.activities[indexPath.row])
            self.activities.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit"){_,_,_ in
            self.performSegue(withIdentifier: "toEdit", sender: self.activities[indexPath.row])
        }
        
        if segmentedControl.selectedSegmentIndex == 1 {
            let finishAction = UIContextualAction(style: .normal, title: "Finish"){_,_,_ in
                self.activities[indexPath.row].isDone = true
                self.db.save()
                self.activities.remove(at: indexPath.row)
                tableView.reloadData()
            }
            return UISwipeActionsConfiguration(actions: [deleteAction, editAction, finishAction])
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
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
        if let destination = segue.destination as? EditActivityViewController {
            destination.activity = sender as? Activity
        }
    }
    

}
