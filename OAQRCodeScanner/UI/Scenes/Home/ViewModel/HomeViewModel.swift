//
//  HomeViewModel.swift
//  OAQRCodeScanner
//
//  Created by Davide Montagna on 24/08/22.
//

import UIKit
import Foundation
import AVFoundation

class HomeViewModel: NSObject {
    
    // MARK: - Properties
    
    var QRCodeUrl: URL!
    var uiitems: [QRCodeUIItem] = []
    
    // MARK: - Public methods
    
    func getUrlfromMetadata(metadataObjects: [AVMetadataObject]) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            guard let url = URL(string: stringValue) else { return }
            QRCodeUrl = url
        }
    }
}
