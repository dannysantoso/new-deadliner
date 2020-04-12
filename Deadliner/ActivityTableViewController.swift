//
//  ActivityTableViewController.swift
//  Deadliner
//
//  Created by Muhammad Iksanul on 07/04/20.
//  Copyright © 2020 Peter Andrew. All rights reserved.
//

import UIKit

protocol BackHandler {
    func onBackHome()
}

class ActivityTableViewController: UITableViewController, BackHandler {
    var db = DBManager()

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var activities: [Activity] = []
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.selectedSegmentIndex = 1
        refreshData()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            for activity in self.activities {
                self.checkActivityDate(activity: activity)
            }
        }
    }
    
    @IBAction func toAddActivity(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toAdd", sender: nil)
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
        refreshData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as? ActivityTableViewCell{
            let activity = activities[indexPath.row]
            
            cell.nameActivity.text = activity.title
            cell.nameActivity.sizeToFit()

            switch activity.priority {
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
            
            updateTimeLabel(for: cell, at: indexPath)
            
            switch segmentedControl.selectedSegmentIndex {
                case 0:
                    cell.labelTimer.isHidden = false
                    cell.labelTimer.text = "Start in"
                    break
                case 1:
                    cell.labelTimer.isHidden = false
                    if activity.endDate ?? Date() < Date() {
                        cell.labelTimer.isHidden = true
                        cell.timerActivity.text = "Times up"
                    } else{
                        cell.labelTimer.text = "Deadline in"
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
        
        let activity = activities[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){_,_,_ in
            self.db.remove(activity)
            self.activities.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit"){_,_,_ in
            self.performSegue(withIdentifier: "toEdit", sender: activity)
        }
        
        if segmentedControl.selectedSegmentIndex == 1 {
            let finishAction = UIContextualAction(style: .normal, title: "Finish"){_,_,_ in
                activity.isDone = true
                self.db.save(object: activity, operation: .update)
                self.activities.remove(at: indexPath.row)
                tableView.reloadData()
            }
            return UISwipeActionsConfiguration(actions: [deleteAction, editAction, finishAction])
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: activities[indexPath.row])
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditActivityViewController {
            destination.activity = sender as? Activity
            destination.delegate = self
        } else if let destination = segue.destination as? DetailView {
            destination.delegate = self
            destination.activity = sender as? Activity
        } else if let destination = segue.destination as? AddActivityViewController{
            destination.delegate = self
        } 
    }
    
}

// MARK: -  Activities Functionality
extension ActivityTableViewController {
    
    //MARK: - Modal Dismissed Handler
    
    func onBackHome() {
        refreshData()
    }
    
    func refreshData() {
        var predicate: NSPredicate!
        
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                predicate = NSPredicate(format: "startDate > %@ AND isDone == false", Date() as NSDate)
            case 1:
                predicate = NSPredicate(format: "startDate < %@ AND isDone == false", Date() as NSDate)
            case 2:
                predicate = NSPredicate(format: "isDone == true", Date() as NSDate)
                
            default:
                print("Invalid user action.")
        }
        
        activities = db.fetch(withPredicate: predicate)
        self.tableView.reloadData()
    }
    
    private func checkActivityDate(activity: Activity) {
        let now = Date()
        
        activity.isDone = now >= activity.endDate! ? true : false
        
        db.save(object: activity, operation: .update)
        
        refreshData()
        self.tableView.reloadData()
    }
    
    func updateTimeLabel(for cell: ActivityTableViewCell, at indexPath: IndexPath) {
        let activity = activities[indexPath.row]
        let now = Date()
        let nowInterval = now.timeIntervalSinceNow
        let startDateInterval = activity.startDate!.timeIntervalSinceNow
        let endDateInterval = activity.endDate!.timeIntervalSinceNow
        var remainingTime: Int = 0
        
        if nowInterval < startDateInterval {
            remainingTime = Int(startDateInterval - nowInterval)
            if !activity.isDone && remainingTime < 60 {
                cell.timerActivity.text = "\(remainingTime) Seconds"
            } else {
                cell.timerActivity.text = calculateDate(start: now, end: activity.startDate ?? Date())
            }
        } else if nowInterval >= startDateInterval && nowInterval <= endDateInterval {
            remainingTime = Int(endDateInterval - nowInterval)
            if !activity.isDone && remainingTime < 60 {
                cell.timerActivity.text = "\(remainingTime) Seconds"
            } else {
                cell.timerActivity.text = calculateDate(start: now, end: activity.endDate ?? Date())
            }
        }
        
    }
}
