//
//  EditActivityViewController.swift
//  Deadliner
//
//  Created by danny santoso on 09/04/20.
//  Copyright © 2020 Peter Andrew. All rights reserved.
//

import UIKit

class EditActivityViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var tableForm: UITableView!
            
            @IBOutlet weak var tfActivityName: UITextField!
            @IBOutlet weak var tfStartDate: UITextField!
            @IBOutlet weak var tfPriority: UITextField!
            @IBOutlet weak var tvActivityDescription: UITextView!
            
            @IBOutlet weak var lblPriority: UILabel!
            @IBOutlet weak var lblDeadlineDate: UILabel!
            @IBOutlet weak var lblStartDate: UILabel!
    
            @IBOutlet weak var titleActivity: UILabel!
    
            let datePicker = UIDatePicker()
            let datePickerDeadline = UIDatePicker()
            let pickerView = UIPickerView()
            let placeholder = "Activity Description"
            
            @IBOutlet weak var tfDeadlineDate: UITextField!
            
            var pickerData: [String] = [String]()
    
            var activity: Activity? = nil
            var priorityIndex = 0
            
            var result = ""
    
            var delegate: BackHandler?
    
            var db = DBManager()
            
            override func viewDidLoad() {
                super.viewDidLoad()
                
                
                
                pickerData = ["High","Medium","Low"]
                
        //        tfActivityName.textAlignment = .right
        //        tfStartDate.textAlignment = .right
                
                tfStartDate.text = dateConverter(tanggal: (activity?.startDate)!)
                datePicker.setDate(activity?.startDate ?? Date(), animated: true)
                tfDeadlineDate.text = dateConverter(tanggal: (activity?.endDate)!)
                datePickerDeadline.setDate(activity?.endDate ?? Date(), animated: true)
                tfActivityName.text = activity?.title
                switch activity?.priority {
                case 3:
                    tfPriority.text = "High"
                case 2:
                    tfPriority.text = "Medium"
                case 1:
                    tfPriority.text = "Low"
                default:
                    tfPriority.text = "High"
                }
                
                
                tvActivityDescription.delegate = self
                
                if activity?.notes == nil{
                    tvActivityDescription.text = placeholder
                    tvActivityDescription.textColor = hexStringToUIColor(hex: "C6C6C8")
                }else{
                    tvActivityDescription.text = activity?.notes
                    tvActivityDescription.textColor = UIColor.black
                }
                
                
                
                
                
                self.pickerView.delegate = self
                self.pickerView.dataSource = self
                
                
                pickerData = ["High","Medium","Low"]

                createDatePicker()
                createDatePickerForDeadline()
                createPriority()
                
                
                activityDescriptionSetting()
                lightAndDark()
            }
            
            func activityDescriptionSetting(){
                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))

                view.addGestureRecognizer(tap)
                
                
                
            }
            
            @objc func dismissKeyboard() {
                   view.endEditing(true)
            }
            
            func textViewDidBeginEditing(_ tvActivityDescription: UITextView) {
                if tvActivityDescription.textColor == hexStringToUIColor(hex: "C6C6C8") {
                    tvActivityDescription.text = ""
                    if traitCollection.userInterfaceStyle == .dark {
                        tvActivityDescription.textColor = UIColor.white
                    }else{
                        tvActivityDescription.textColor = UIColor.black
                    }
                }
            }
            
            func textViewDidEndEditing(_ tvActivityDescription: UITextView) {
                if tvActivityDescription.text.isEmpty {
                    tvActivityDescription.text = placeholder
                    tvActivityDescription.textColor = hexStringToUIColor(hex: "C6C6C8")
                }
            }
            
            override func didReceiveMemoryWarning() {
                super.didReceiveMemoryWarning()
                // Dispose of any resources that can be recreated.
            }
            
            func numberOfComponents(in pickerView: UIPickerView) -> Int {
                return 1
            }
            
            func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
                return pickerData.count
            }
            
            func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
                return pickerData[row]
            }
            
            func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
                result = pickerData[row]
                tfPriority.text = "\(result)"
            }
            
            override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                view.endEditing(true)
            }
            
            func createDatePicker(){
                
                //toolbar
                let toolbar = UIToolbar()
                toolbar.sizeToFit()
                
                //bar button
                let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
                toolbar.setItems([doneBtn], animated: true)
                
                //assign toolbar
                tfStartDate.inputAccessoryView = toolbar
                
                tfStartDate.inputView = datePicker
                
                
                
                //date picker mode
                //datePicker.datePickerMode = .date
                
            }
            
            func createDatePickerForDeadline(){
                
                //toolbar
                let toolbar = UIToolbar()
                toolbar.sizeToFit()
                
                //bar button
                let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedForDeadline))
                toolbar.setItems([doneBtn], animated: true)
                
                //assign toolbar

                
                tfDeadlineDate.inputAccessoryView = toolbar
                tfDeadlineDate.inputView = datePickerDeadline
                
                
                //date picker mode
                //datePicker.datePickerMode = .date
                
            }
            
            @objc func donePressed(){
                let formater = DateFormatter()
                formater.dateFormat = "MMMM dd, yyyy hh:mm aa"
                let result = formater.string(from: datePicker.date)
                tfStartDate.text = "\(result)"
                self.view.endEditing(true)
            }
            
            @objc func donePressedForDeadline(){
                let formater = DateFormatter()
                formater.dateFormat = "MMMM dd, yyyy hh:mm aa"
    //            formater.dateFormat = "dd.MM.yyyy hh.mm.ss aa"
                let result = formater.string(from: datePickerDeadline.date)
                tfDeadlineDate.text = "\(result)"
                self.view.endEditing(true)
            }
            
            func createPriority(){
                //toolbar
                let toolbar = UIToolbar()
                toolbar.sizeToFit()
                
                //bar button
                let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedPriority))
                
                toolbar.setItems([doneBtn], animated: true)
                
                tfPriority.inputAccessoryView = toolbar
                tfPriority.inputView = pickerView
            }
            
            @objc func donePressedPriority(){
                
                tfPriority.text = "\(result)"
                self.view.endEditing(true)
                
            }
            
            func hexStringToUIColor (hex:String) -> UIColor {
                var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

                if (cString.hasPrefix("#")) {
                    cString.remove(at: cString.startIndex)
                }

                if ((cString.count) != 6) {
                    return UIColor.gray
                }

                var rgbValue:UInt64 = 0
                Scanner(string: cString).scanHexInt64(&rgbValue)

                return UIColor(
                    red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                    green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                    blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                    alpha: CGFloat(1.0)
                )
            }
    
    func priorityIndexGenerator() -> Int{
        switch tfPriority.text {
        case "High":
            priorityIndex = 3
        case "Medium":
            priorityIndex = 2
        case "Low":
            priorityIndex = 1
        default:
            priorityIndex = 0
        }
        return priorityIndex
    }

    @IBAction func btnSave(_ sender: Any) {
        
        if tfActivityName.text?.isEmpty == true {
            alertValidation("Please fill your Activity Name")
        }else if tfStartDate.text?.isEmpty == true{
            alertValidation("Please fill your Start Date")
        }else if tfDeadlineDate.text?.isEmpty == true{
            alertValidation("Please fill your Deadline Date")
        }else if datePicker.date >= datePickerDeadline.date{
            alertValidation("Your Start Date can't be above from Deadline Date")
        }else if priorityIndexGenerator() == 0{
            alertValidation("Please Choose your activity priority")
        }else if tvActivityDescription.text.isEmpty || tvActivityDescription.text == placeholder{
            alertValidation("Please fill your Activity Description")
        }else{
        
        
            guard let activity = activity else {return}
            activity.title = tfActivityName.text
            activity.startDate = datePicker.date
            activity.endDate = datePickerDeadline.date
            activity.notes = tvActivityDescription.text
            activity.isDone = false
            activity.priority = NSNumber(value: priorityIndexGenerator())
            db.save(object: activity, operation: .update)
            
        }
        dismiss(animated: true){
            self.delegate?.onBackHome()
        }
        
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true){
            self.delegate?.onBackHome()
        }
    }
    func alertValidation(_ input:String){
        let alert = UIAlertController(title: "Message Alert", message: input, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func lightAndDark() {
        if traitCollection.userInterfaceStyle == .dark {
                    
            
            
            lblPriority.textColor = UIColor.white
            lblDeadlineDate.textColor = UIColor.white
            lblStartDate.textColor = UIColor.white
            titleActivity.textColor = UIColor.white
            tvActivityDescription.textColor = UIColor.white
            
            
                    
        }

    }
}
