//
//  ExerciseCell.swift
//  RecordProgress
//
//  Created by admin on 25.03.2026.
//
import SwiftUI

struct ExerciseView: View {
    var exercise: Exercise
    var needShowSets: Bool

    var body: some View {
        HStack {
            if needShowSets {
                Text(exercise.name)
            } else {
                Text(exercise.name)
                ForEach(exercise.sets, id: \.id) { set in
                    VStack {
                        Text("\(set.weight)")
                            .frame(width: 120, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)

                        Text("\(set.count)")
                            .frame(width: 120, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                }
            }
        }
    }
}
