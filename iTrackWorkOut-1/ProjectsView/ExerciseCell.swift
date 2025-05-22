//
//  ExerciseCell.swift
//  iTrackWorkOut-1
//
//  Created by X34 on 20.05.25.
//

import SwiftUI

struct ExerciseCell: View {
    var exercise: Project
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(UIColor.secondarySystemGroupedBackground))
            .overlay(
                Text(exercise.name)
                    .foregroundColor(.primary)
            )
    }
}
