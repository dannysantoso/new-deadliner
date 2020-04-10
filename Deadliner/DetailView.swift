//
//  DetailView.swift
//  Deadliner
//
//  Created by Alfon on 09/04/20.
//  Copyright © 2020 Peter Andrew. All rights reserved.
//

import UIKit

class DetailView: UIViewController {
    
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var priorityLevel: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var activityTitle: UILabel!
    
    
    var activity: Activity? = nil
    var db = DBManager()
    var delegate: BackHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priorityLevel.layer.cornerRadius = 5
        priorityLevel.layer.masksToBounds = true
        startDate.text = dateConverter(tanggal: (activity?.startDate)!)
        endDate.text = dateConverter(tanggal: (activity?.endDate)!)
        activityTitle.text = activity?.title
        switch activity?.priority {
        case 3:
            priorityLevel.text = "High"
            priorityLevel.backgroundColor = .red
            break
        case 2:
            priorityLevel.text = "Medium"
            priorityLevel.backgroundColor = .orange
            break
        case 1:
            priorityLevel.text = "Low"
            priorityLevel.backgroundColor = .blue
            break
        default:
            break
        }
        taskDescription.text = activity?.notes
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.onBackHome()
    }
    
    @IBAction func editActivity(_ sender: Any) {
        performSegue(withIdentifier: "toEdit", sender: activity)
    }
    
    @IBAction func deleteActivity(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Activity", message: "You are about to delete this activity, are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            switch action.style{
            case .destructive:
                self.db.remove(self.activity!)
                self.navigationController?.popViewController(animated: true)
                break
            default:
                break
            }}))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {action in
            switch action.style{
            case .cancel:
                break
            default:
                break
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditActivityViewController {
            destination.activity = sender as? Activity
        }
    }
    
}
