//
//  TaskTableViewCell.swift
//  Tasks
//
//  Created by Ben Gohlke on 4/20/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

protocol TaskTableViewCellDelegate: class {
    func didUpdateTask(task: Task)
}

class TaskTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: TaskTableViewCellDelegate?
    static let reuseIdentifier = "TaskCell"
    
    var task: Task? {
        didSet {
            updateViews()
        }
    }
    
    @IBAction func toggleComplete(_ sender: UIButton) {
        guard let task = task else { return }
        
        task.complete.toggle()
        
        completedButton.setImage(task.complete ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle"), for: .normal)
        delegate?.didUpdateTask(task: task)
        
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    // MARK: - Private
    private func updateViews() {
        guard let task = task else { return }
        
        taskNameLabel.text = task.name
        
        completedButton.setImage(task.complete ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle"), for: .normal)
    }
}
