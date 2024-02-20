//
//  UIScreen-Extension.swift
//  Reps
//
//  Created by Donovan Hutchinson on 20/02/2024.
//

import Foundation
import UIKit

extension UIScreen {

    /// Retrieve the (small) width from portrait mode
    static var portraitWidth : CGFloat { return min(UIScreen.main.bounds.width, UIScreen.main.bounds.size.height) }

    /// Retrieve the (big) height from portrait mode
    static var portraitHeight : CGFloat { return max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)  }

    /// Retrieve the (big) width from landscape mode
    static var landscapeWidth : CGFloat { return max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) }

    /// Retrieve the (small) height from landscape mode
    static var landscapeHeight : CGFloat { return min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) }
}
