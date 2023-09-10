//
//  HapticManager.swift
//  SwiftfulCrypto
//
//  Created by Trung Nguyen on 10/09/2023.
//

import Foundation
import SwiftUI

final class HapticManager {
  static private let generator = UINotificationFeedbackGenerator()
  
  static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
    generator.notificationOccurred(type)
  }
}
