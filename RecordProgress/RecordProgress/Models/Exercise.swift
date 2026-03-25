//
//  Exercise.swift
//  RecordProgress
//
//  Created by admin on 10.03.2026.
//

class Exercise: Identifiable {
    let id: Int
    let name: String
    var isChoosen: Bool
    var sets: [Set]
    var doubleWeigth: Bool
    var bodyweight: Bool
    
    init(id: Int, name: String, isChoosen: Bool, sets: [Set], doubleWeigth: Bool, bodyweight: Bool) {
        self.id = id
        self.name = name
        self.isChoosen = isChoosen
        self.sets = sets
        self.doubleWeigth = doubleWeigth
        self.bodyweight = bodyweight
    }
}
