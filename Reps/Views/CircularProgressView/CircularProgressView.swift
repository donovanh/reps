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
    
    var body: some View {
        VStack {
            if label != nil {
                Text(label!)
                    .font(.system(size: size * 0.5).bold())
                    .textCase(.uppercase)
                    .padding(.bottom, -(size * 0.1))
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
            label: "Sun"
        )
        CircularProgressView(
            progress: 0.5,
            size: 100,
            bgColor: .gray,
            highlightColor: Color.themeColor,
            displayNum: 3,
            label: "Mon"
        )
        CircularProgressView(
            progress: 0.75,
            size: 100,
            bgColor: .gray,
            highlightColor: Color.themeColor,
            displayNum: 6
        )
    }
}
