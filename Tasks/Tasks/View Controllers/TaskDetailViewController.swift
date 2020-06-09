//
//  TaskDetailViewController.swift
//  Tasks
//
//  Created by Kenneth Jones on 6/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    // MARK: - Properties
    var taskController: TaskController?
    var task: Task?
    var wasEdited = false
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var priorityControl: UISegmentedControl!
    @IBOutlet weak var notesTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited {
            guard let name = nameTextField.text,
                !name.isEmpty,
                let task = task else {
                return
            }
            let notes = notesTextView.text
            task.name = name
            task.notes = notes
            let priorityIndex = priorityControl.selectedSegmentIndex
            task.priority = TaskPriority.allCases[priorityIndex].rawValue
            taskController?.sendTaskToServer(task: task)
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing { wasEdited = true }
        nameTextField.isUserInteractionEnabled = editing
        notesTextView.isUserInteractionEnabled = editing
        priorityControl.isUserInteractionEnabled = editing
        navigationItem.hidesBackButton = editing
    }
    
    // MARK: - Actions
    
    @IBAction func toggleComplete(_ sender: UIButton) {
        wasEdited = true
        task?.complete.toggle()
        sender.setImage((task?.complete ?? false) ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle"), for: .normal)
    }
    
    // MARK: - Private
    private func updateViews() {
        nameTextField.text = task?.name
        nameTextField.isUserInteractionEnabled = isEditing
        
        notesTextView.text = task?.notes
        notesTextView.isUserInteractionEnabled = isEditing
        
        completeButton.setImage((task?.complete ?? false) ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle"), for: .normal)
        
        let priority: TaskPriority
        if let taskPriority = task?.priority {
            priority = TaskPriority(rawValue: taskPriority)!
        } else {
            priority = .normal
        }
        
        priorityControl.selectedSegmentIndex = TaskPriority.allCases.firstIndex(of: priority) ?? 1
        priorityControl.isUserInteractionEnabled = isEditing
    }
    
}
