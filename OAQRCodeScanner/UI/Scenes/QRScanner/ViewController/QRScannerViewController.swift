//
//  QRScannerViewController.swift
//  OAQRCodeScanner
//
//  Created by Davide Montagna on 30/08/22.
//

import UIKit

class QRScannerViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var qrScannerView: QRCodeScannerView!
    @IBOutlet weak var openBrowserButton: UIButton!
    
    // MARK: - ViewModel
    
    lazy var viewModel = QRScannerViewModel(delegate: self)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        qrScannerView.delegate = self
        qrScannerView.startCaptureSession()
        qrScannerView.isRunning = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        qrScannerView.stopCaptureSession()
        qrScannerView.isRunning = false
    }
    
    @IBAction func openBrowserTapped(_ sender: Any) {
        viewModel.showBrowser()
    }
}

// MARK: - Extensions

extension QRScannerViewController: QRScannerViewDelegate {
    func codeFound(code: String) {
        guard let url = URL(string: code) else {
            openBrowserButton.isHidden = true
            return
        }
        viewModel.setUrl(url: url)
        viewModel.vibrate()
        openBrowserButton.isHidden = false
    }
    
    func cameraSessionDidStart() {
        print("Camera session did start")
    }
    
    func cameraSessionDidStop() {
        print("Camera session did stop")
    }
}

extension QRScannerViewController: QRScannerViewModelDelegate {
    func onSuccess(by useCase: QRScannerUseCases) {
        switch useCase {
        case .showBrowser:
            if let url = viewModel.url {
                UIApplication.shared.open(url)
            }
        case .vibrate:
            UIDevice.vibrate()
        }
    }
}

