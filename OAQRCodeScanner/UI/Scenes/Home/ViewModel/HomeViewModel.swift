//
//  HomeViewModel.swift
//  OAQRCodeScanner
//
//  Created by Davide Montagna on 24/08/22.
//

import Foundation
import AVFoundation
import UIKit

protocol HomeViewModelDelegate {
    func onSuccess(by useCase: HomeViewModelUseCases)
}

class HomeViewModel: NSObject {
    
    // MARK: - Delegate
    
    var delegate: HomeViewModelDelegate?
    
    // MARK: - Properties
    
    var QRCodeUrl: URL!
    var stringURL: String!
    var uiitems: [HomeUIItem] {
        var items: [HomeUIItem] = []
        items.append(.button)
        if let url = stringURL {
            items.append(.content(QRCodeArgs(qrCodeUrl: url)))
        }
        return items
    }
    
    // MARK: - ViewModel Lifecycle
    
    init(delegate: HomeViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Public methods
    
    func getUrlfromMetadata(metadataObjects: [AVMetadataObject]) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            guard let url = URL(string: stringValue) else { return }
            stringURL = stringValue
            QRCodeUrl = url
            if let url = QRCodeUrl {
                UIApplication.shared.open(url)
            }
        }
    }
    
    func showScanResult() {
        self.delegate?.onSuccess(by: .showResult)
    }
}
