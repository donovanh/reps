//
//  AnimationView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 23/08/2023.
//

import SwiftUI
import SceneKit

struct AnimationView: View {
    
    let baseModel: String
    let currentProgressionAnimationName: String
    let currentExerciseIndex: Int
    let width: CGFloat
    let height: CGFloat
    
    // TODO: Add credit for model
    /*
     Name: Wooden mannequin - Rigged
     Author: jgilhutton
     Permalink: http://www.blendswap.com/blends/view/74733
     */
    
    func loadScene(_ currentProgressionAnimationName: String) -> SCNScene {
        guard let scene = SCNScene(named: baseModel),
              let sceneSource = SCNSceneSource(url: Bundle.main.url(forResource: baseModel, withExtension: "dae")!, options: nil) else {
            print("Scene could not be loaded")
            return SCNScene()
        }
        
        guard let animationSceneSourceUrl = Bundle.main.url(forResource: currentProgressionAnimationName, withExtension: "dae"),
              let animationSceneSource = SCNSceneSource(url: animationSceneSourceUrl, options: nil) else {
            print("Animation file \"\(currentProgressionAnimationName)\" could not be loaded")
            
            return SCNScene()
        }

        let animationIdentifier = "action_container-rig"
        let footballObjectIdentifier = "football2_ball"
        let footballAnimationIdentifier = "football2_ball_football2_ballAction_002_transform"
        let cameraIdentifier = "Camera"
        
        // Load dummy animation from source
        if let animationObj = animationSceneSource.entryWithIdentifier(animationIdentifier,
                                                         withClass: CAAnimation.self) {
            animationObj.repeatCount = .infinity
            scene.rootNode.addAnimation(animationObj, forKey: animationIdentifier)
        }
        
        // Load animation for football if found, or try just the position
        if let footballAnimationObj = animationSceneSource.entryWithIdentifier(footballAnimationIdentifier,
                                                         withClass: CAAnimation.self) {
            footballAnimationObj.repeatCount = .infinity
            scene.rootNode.addAnimation(footballAnimationObj, forKey: footballAnimationIdentifier)
        } else {
            if let footballObj = animationSceneSource.entryWithIdentifier(footballObjectIdentifier,
                                                                          withClass: SCNNode.self) {
                let sourceFootballObj = sceneSource.entryWithIdentifier(footballObjectIdentifier,
                                                                        withClass: SCNNode.self)!
                let sourceFootballObjCopy = sourceFootballObj
                sourceFootballObj.removeFromParentNode()
                
                sourceFootballObjCopy.position = footballObj.position
                scene.rootNode.addChildNode(sourceFootballObjCopy)
            }
        }

        // Override camera position
        if let animationSceneCameraNode = animationSceneSource.entryWithIdentifier(cameraIdentifier, withClass: SCNNode.self),
           let existingCameraNode = scene.rootNode.childNode(withName: cameraIdentifier, recursively: true) {
            existingCameraNode.removeFromParentNode()
            scene.rootNode.addChildNode(animationSceneCameraNode)
        }

        // TODO: Set up background for dark mode support
        // scene.background.contents = UIColor.darkText
        return scene
    }
    
    var body: some View {
        SceneView(scene: loadScene(currentProgressionAnimationName), options: [.temporalAntialiasingEnabled])
        .edgesIgnoringSafeArea(.all)
        .frame(width: width, height: height)
    }
}

#Preview {
    AnimationView(
        baseModel: "base-model",
        currentProgressionAnimationName: "hspu--04",
        currentExerciseIndex: 1,
        width: 350,
        height: 400
    )
}

