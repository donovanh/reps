//
//  ProgressionViewerModel.swift
//  Reps
//
//  Created by Donovan Hutchinson on 03/02/2024.
//

import Foundation
import SwiftUI

extension ProgressionViewer {
    
    typealias MainAction = (_: Progression, _: Level, _: Int, _: DismissAction, _: ScrollViewProxy?) -> Void
    
    @Observable
    class ViewModel {
        
        func getPrevStageLevel(stage: Int, level: Level) -> (stage: Int, level: Level) {
            var result = (stage: stage, level: level)
            if level == .beginner {
                result.stage = stage > 0 ? stage - 1 : stage
                result.level = stage > 0 ? .progression : .beginner
            } else {
                switch level {
                case .intermediate: result.level = .beginner
                case .progression: result.level = .intermediate
                default: result.level = level
                }
            }
            
            return result
        }
        
        func getNextStageLevel(stage: Int, level: Level) -> (stage: Int, level: Level) {
            var result = (stage: stage, level: level)
            if level == .progression {
                result.stage = stage < 9 ? stage + 1 : stage
                result.level = stage < 9 ? .beginner : .progression
            } else {
                switch level {
                case .beginner: result.level = .intermediate
                case .intermediate: result.level = .progression
                default: result.level = level
                }
            }
            
            return result
        }
        
        func calculateScrollWidth(screenWidth: CGFloat, numberOfProgressions: Int) -> CGFloat {
            return screenWidth * CGFloat(numberOfProgressions)
        }
        
        func visibleExerciseIndex(screenWidth: CGFloat, forOffset offset: CGFloat) -> Int {
            return Int((offset / screenWidth).rounded(.toNearestOrAwayFromZero))
        }
        
        func calculateOpacityOfAnimation(screenWidth: CGFloat, forOffset offset: CGFloat, numberOfExercises: Int) -> Double {
            let maxWidth = screenWidth * CGFloat(numberOfExercises - 1)

            if offset < 0 || offset > maxWidth {
                return 1
            }
            let index = visibleExerciseIndex(screenWidth: screenWidth, forOffset: offset)
                
            let nearestIndexOffset = CGFloat(index) * screenWidth // Calculate the offset of the nearest index
     
            let distance = abs(offset - nearestIndexOffset) // Calculate the distance from that offset value
            
            let halfScreenWidth = screenWidth / 2
            let opacity = 1 - Double(min(distance, halfScreenWidth)) / Double(halfScreenWidth)
            
            return max(opacity, 0) // Ensure opacity is not negative
        }
        
        func calculateXOffset(screenWidth: CGFloat, forOffset offset: CGFloat) -> Double {
            let index = visibleExerciseIndex(screenWidth: screenWidth, forOffset: offset)
            let nearestIndexOffset = CGFloat(index) * screenWidth // Calculate the offset of the nearest index
            let distance = offset - nearestIndexOffset // Calculate the distance from that offset value
            
            return (0 - distance / 3)
        }
        
        struct ViewOffsetKey: PreferenceKey {
            typealias Value = CGFloat
            static var defaultValue = CGFloat.zero
            static func reduce(value: inout Value, nextValue: () -> Value) {
                value += nextValue()
            }
        }
    }
}
