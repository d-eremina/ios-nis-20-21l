//
//  EntryViewController.swift
//  TaskTracker
//
//  Created by Daria Eremina on 10.02.2021.
//

import CoreData
import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var heading: UITextField!
    @IBOutlet var annotation: UITextView!
    @IBOutlet var date: UIDatePicker!
    @IBOutlet var status: UIPickerView!
    let pickerContent = ["New", "In Progress", "Done"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heading.delegate = self
        status.dataSource = self
        status.delegate = self
        date.preferredDatePickerStyle = .compact
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        return true
    }
    
    @IBAction func saveTask() {
        guard let heading = heading.text, !heading.isEmpty else {
            return
        }
        
        guard let annotation = annotation.text, !annotation.isEmpty else {
            return
        }
        
        let taskStatus = pickerContent[status.selectedRow(inComponent: 0)]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy\nHH:mm"
        let taskDate = dateFormatter.string(from: date.date)
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Task",
                                                in: managedContext)!
        let savedTask = NSManagedObject(entity: entity,
                                        insertInto: managedContext)
        savedTask.setValue(heading, forKey: "heading")
        savedTask.setValue(annotation, forKey: "annotation")
        savedTask.setValue(taskDate, forKey: "date")
        savedTask.setValue(taskStatus, forKey: "status")
        
        do {
            try managedContext.save()
            let viewController = storyboard?.instantiateViewController(identifier: "Main") as! ViewController
            viewController.tasks.append(savedTask)
            navigationController?.popViewController(animated: true)
            navigationController?.popViewController(animated: false)
            _ = viewController.view
            viewController.updateTasks()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

extension EntryViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerContent[row]
    }
}
