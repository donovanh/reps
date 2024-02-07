import SwiftUI
import SceneKit
import SpriteKit

// TODO: Tidy this function

func loadScene(_ currentProgressionAnimationName: String, isPaused: Bool) -> SCNScene {
    guard let scene = SCNScene(named: "base-model"),
          let sceneSource = SCNSceneSource(url: Bundle.main.url(forResource: "base-model", withExtension: "dae")!, options: nil) else {
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
    let footballAnimationIdentifier = "football2_ball_football2_ballAction_transform"
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
    
    // Pause animation
    scene.isPaused = isPaused

    // TODO: Set up background for dark mode support
    scene.background.contents = Color.clear
    return scene
}

struct AnimationView: View {

    var progressionAnimationName: String
    let height: CGFloat
    var isPaused = false
    
    // TODO: Add credit for model
    /*
     Name: Wooden mannequin - Rigged
     Author: jgilhutton
     Permalink: http://www.blendswap.com/blends/view/74733
     */
    
    var body: some View {
        let size = height > 0 ? height : 300
//        let scene = loadScene(<#T##String#>)
//        SceneView(
//            scene: loadScene(progressionAnimationName),
//            options: [.temporalAntialiasingEnabled]
//        )
        AnimationSpriteView(animationName: progressionAnimationName, isPaused: isPaused)
            .id(progressionAnimationName)
        .frame(width: size, height: size)
    }
}

struct AnimationSpriteView: View {
    @State var animationName: String
    var isPaused: Bool
    
    var createdScene: SKScene {
        let scene = SKScene()
        scene.backgroundColor = UIColor.clear
        let model = SK3DNode()
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        model.scnScene = loadScene(animationName, isPaused: isPaused)
        scene.addChild(model)
        return scene
    }
    
    var body: some View {
        SpriteView(scene: createdScene, options: [.allowsTransparency])
    }
}

#Preview {
    ZStack {
        Ellipse()
            .fill(Color.lightAnimationBg)
            .frame(width: 280, height: 200)
            .rotationEffect(.degrees(-45))
        AnimationView(
            progressionAnimationName: "pushup-05",
            height: 300
        )
        .colorMultiply(.green)
        .saturation(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
    }
}

