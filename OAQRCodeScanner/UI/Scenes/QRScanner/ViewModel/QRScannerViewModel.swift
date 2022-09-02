//
//  QRScannerViewModel.swift
//  OAQRCodeScanner
//
//  Created by Davide Montagna on 02/09/22.
//

import Foundation

protocol QRScannerViewModelDelegate {
    func onSuccess(by useCase: QRScannerUseCases)
}

class QRScannerViewModel {
    
    // MARK: - Delegate
    
    var delegate: QRScannerViewModelDelegate?
    
    // MARK: - Properties
    
    var url: URL?
    
    // MARK: - ViewModel Lifecycle
    
    init(delegate: QRScannerViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Public methods
    
    func showBrowser() {
        delegate?.onSuccess(by: .showBrowser)
    }
    
    func setUrl(url: URL) {
        self.url = url
    }
    
    func vibrate() {
        delegate?.onSuccess(by: .vibrate)
    }
}
