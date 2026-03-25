//
//  MuscleGroup.swift
//  RecordProgress
//
//  Created by admin on 10.03.2026.
//

class MuscleGroup {
    let id: Int
    let name: String
    var exercises: [Exercise]
    
    init(id: Int, name: String, exercises: [Exercise]) {
        self.id = id
        self.name = name
        self.exercises = exercises
    }
}
