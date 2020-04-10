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
    
    var activity: Activity? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDate.text = dateConverter(tanggal: (activity?.startDate)!)
        endDate.text = dateConverter(tanggal: (activity?.endDate)!)
        
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
        taskDescription.text = activity?.description
        
    }
    
    @IBAction func editActivity(_ sender: Any) {
        performSegue(withIdentifier: "toEdit", sender: activity)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditActivityViewController {
            destination.activity = sender as? Activity
        }
    }
    
}
