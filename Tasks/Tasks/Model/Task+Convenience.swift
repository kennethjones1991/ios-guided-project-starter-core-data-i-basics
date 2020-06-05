//
//  Task+Convenience.swift
//  Tasks
//
//  Created by Kenneth Jones on 6/2/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum TaskPriority: String, CaseIterable {
    case low, normal, high, critical
}

extension Task {
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        name: String,
                                        notes: String? = nil,
                                        complete: Bool = false,
                                        priority: TaskPriority = .normal,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.name = name
        self.notes = notes
        self.complete = complete
        self.priority = priority.rawValue
    }
}
