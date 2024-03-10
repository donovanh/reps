//
//  CircularProgressView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 04/03/2024.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let size: CGFloat
    let bgColor: Color
    let highlightColor: Color
    @State var displayNum: Int?
    @State var label: String?
    let active: Bool
    
    var body: some View {
        VStack {
            if label != nil {
                Text(label!)
                    .font(active ? .system(size: size * 0.5).bold() : .system(size: size * 0.5))
                    .textCase(.uppercase)
                    .padding(.bottom, -(size * 0.1))
                    .opacity(active ? 1 : 0.5)
                    .animation(.easeOut, value: active)
            }
            ZStack {
                Circle()
                    .stroke(
                        bgColor.opacity(0.25),
                        lineWidth: size / 3
                    )
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        highlightColor,
                        style: StrokeStyle(
                            lineWidth: size / 3,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: progress)
                if displayNum != nil {
                    Text(displayNum!.formatted())
                        .font(.system(size: size * 0.5).bold())
                }
            }
            .opacity(active ? 1 : 0.5)
            .animation(.easeOut, value: active)
            .frame(width: size, height: size)
            .padding(size * 0.2)
        }
    }
}

#Preview ("Empty"){
    VStack {
        CircularProgressView(
            progress: 0.0,
            size: 100,
            bgColor: .gray,
            highlightColor: Color.themeColor,
            displayNum: 1,
            label: "Sun",
            active: true
        )
        CircularProgressView(
            progress: 0.5,
            size: 100,
            bgColor: .gray,
            highlightColor: Color.themeColor,
            displayNum: 3,
            label: "Mon",
            active: false
        )
        CircularProgressView(
            progress: 0.75,
            size: 100,
            bgColor: .gray,
            highlightColor: Color.themeColor,
            displayNum: 6,
            active: true
        )
    }
}
