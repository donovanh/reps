//
//  AnimationView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 23/08/2023.
//

import SwiftUI
import SceneKit

struct AnimationView: View {
    
    let currentProgressionAnimationName: String
    let currentExerciseIndex: Int
    let width: CGFloat
    let height: CGFloat
    
    func loadScene(_ currentProgressionAnimationName: String) -> SCNScene {
        guard let scene = SCNScene(named: "base-model") else {
            print("Scene could not be loaded")
            return SCNScene()
        }
        print(currentProgressionAnimationName)
        let sceneURL = Bundle.main.url(forResource: currentProgressionAnimationName, withExtension: "dae")
        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
        var animations = [String: CAAnimation]()
        
        let animationIdentifier = "action_container-rig"
        
        if let animationObj = sceneSource?.entryWithIdentifier(animationIdentifier,
                                                         withClass: CAAnimation.self) {
            animationObj.repeatCount = .infinity
//            animationObj.fadeInDuration = CGFloat(0)
//            animationObj.fadeOutDuration = CGFloat(0.5)

            animations["loaded-animation"] = animationObj
        }
        
        if animations["loaded-animation"] != nil {
            scene.rootNode.addAnimation(animations["loaded-animation"]!, forKey: "action_container-rig")
        }
        
        // TODO: Set up background for dark mode support
        // scene.background.contents = UIColor.darkText
        return scene
    }
    
    var body: some View {
        SceneView(scene: loadScene(currentProgressionAnimationName))
        .edgesIgnoringSafeArea(.all)
        .frame(width: width, height: height)
    }
}
