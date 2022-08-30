//
//  QRScannerViewController.swift
//  OAQRCodeScanner
//
//  Created by Davide Montagna on 30/08/22.
//

import UIKit
import AVFoundation

protocol QRScannerViewControllerDelegate {
    func printQRCodeUrl(url: URL)
}

class QRScannerViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var QRScannerView: QRCodeScanner!
    
    // MARK: - Delegate
    
    var delegate: QRScannerViewControllerDelegate?
    
    // MARK: - Properties
    
    var captureSession = AVCaptureSession()
    var url: URL!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        QRScannerView.startCameraSession()
        self.captureSession = QRScannerView.captureSession
        startCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopCaptureSession()
        url = QRScannerView.QRcodeURL
        if let url = url {
            delegate?.printQRCodeUrl(url: url)
        }
    }
    
    // MARK: - Private methods
    
    private func startCaptureSession() {
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    private func stopCaptureSession() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
}

