//
//  AnimationView2.swift
//  Reps
//
//  Created by Donovan Hutchinson on 04/02/2024.
//

import SwiftUI
import RealityKit

struct AnimationView2: View {
    var body: some View {
        VStack {
            Text("Hello")
            #if os(visionOS)
            Text("TEST")
            Model3D(named: "bridge-01") { model in
                model
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            #else
            Text("Not visionOS")
            #endif
        }
    }
}

#Preview {
    AnimationView2()
}
