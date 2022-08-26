//
//  UIDevice+Extensions.swift
//  OAQRCodeScanner
//
//  Created by Davide Montagna on 26/08/22.
//

import Foundation
import UIKit
import AVFoundation

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
