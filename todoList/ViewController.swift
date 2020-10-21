//
//  ViewController.swift
//  todoList
//
//  Created by Jéssica Araujo on 21/10/20.
//  Copyright © 2020 academy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taskTextField: UITextField!
    
    //MARK: - Elements
    
    var tasksList = Task.fetchAll()
    
    var enteredTask = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: -IBActions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        addNewTask()
    }
    
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        
        deleteAllTasks()
    }
    
    private func addNewTask() {
        
        self.enteredTask = taskTextField.text!
        
        saveTask(named: self.enteredTask)
        
        self.tasksList = Task.fetchAll()
        
        tableView.reloadData()
        
        taskTextField.text = ""
    }
    
    private func saveTask(named name: String) {
        
        let task = Task(context: AppDelegate.viewContext)
        
        task.taskName = name
        
        try? AppDelegate.viewContext.save()
    }
    
    private func saveData() {
        
        try? AppDelegate.viewContext.save()
    }
    
    private func deleteAllTasks() {
        
        Task.deleteAll()
        
        tasksList = Task.fetchAll()
        
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let taskCell = UITableViewCell()
        
        taskCell.textLabel?.text = tasksList[indexPath.row].taskName!
        
        return taskCell
    }
}

extension ViewController: UITableViewDelegate {
    
    //Update
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Selected task
        let taskSelected = self.tasksList[indexPath.row]
        
        let alert = UIAlertController(title: "Edit", message: "Task to edit: ", preferredStyle: .alert)
        alert.addTextField()
        
        let textField = alert.textFields?.first
        textField?.text = taskSelected.taskName
        
        let saveButton = UIAlertAction(title: "Save task", style: .default) { (action) in
            
            let textEditedInTextField = alert.textFields?.first
            
            taskSelected.taskName = textEditedInTextField?.text
            
            self.saveData()
            
            self.tasksList = Task.fetchAll()
            
            tableView.reloadData()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    //Delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           
            //Create swipe action
            let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
               
            //Which person to remove
            let taskToRemove = self.tasksList[indexPath.row]
               
            //Remove the person
            AppDelegate.viewContext.delete(taskToRemove)
               
            //Save the data
            self.saveData()
               
            //Re-fetch the data
            self.tasksList = Task.fetchAll()
            self.tableView.reloadData()
           }
           
           return UISwipeActionsConfiguration(actions: [action])
       }
}
