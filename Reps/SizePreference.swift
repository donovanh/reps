//
//  SizePreference.swift
//  Reps
//
//  Created by Donovan Hutchinson on 05/02/2024.
//

import Foundation
import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

public extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        self
            .background(
                GeometryReader { geometryProxy in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }

    func readSize(andUpdate value: Binding<CGSize>) -> some View {
        self.readSize { size in
            value.wrappedValue = size
        }
    }
}
