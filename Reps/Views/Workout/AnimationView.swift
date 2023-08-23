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

        let animationUrl = Bundle.main.url(forResource: currentProgressionAnimationName, withExtension: "dae")
        let animationSceneSource = SCNSceneSource(url: animationUrl!, options: nil)
        
        let animationIdentifier = "action_container-rig"
        let cameraIdentifier = "Camera"
        
        // Load animation from source
        if let animationObj = animationSceneSource?.entryWithIdentifier(animationIdentifier,
                                                         withClass: CAAnimation.self) {
            animationObj.repeatCount = .infinity
            scene.rootNode.addAnimation(animationObj, forKey: "action_container-rig")
        }
        
        // Override camera position
        if let animationSceneCameraNode = animationSceneSource?.entryWithIdentifier(cameraIdentifier, withClass: SCNNode.self),
           let existingCameraNode = scene.rootNode.childNode(withName: cameraIdentifier, recursively: true) {
            existingCameraNode.removeFromParentNode()
            scene.rootNode.addChildNode(animationSceneCameraNode)
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
