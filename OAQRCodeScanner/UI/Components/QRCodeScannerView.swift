//
//  QRCodeScanner.swift
//  OAQRCodeScanner
//
//  Created by Davide Montagna on 30/08/22.
//

import Foundation
import UIKit
import AVFoundation

protocol QRScannerViewDelegate: AnyObject {
    func codeFound(code: String)
    func cameraSessionDidStart()
    func cameraSessionDidStop()
}

class QRCodeScannerView: UIView {
    
    weak var delegate: QRScannerViewDelegate?
    
    // MARK: - Properties
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeURL: URL!
    var isRunning = false
    
    // MARK: - View Lifecycle
    
    // Init methods..
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        startCameraSession()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        startCameraSession()
    }
    
    // MARK: - Public methods
    
    func startCameraSession() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to open the camera")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            checkCaptureSessionInput()
            captureSession.addInput(input)

            let captureMetadataOutput = AVCaptureMetadataOutput()
            checkCaptureSessionOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.code128]

            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.frame = self.layer.bounds
            self.layer.addSublayer(videoPreviewLayer!)
        } catch {
            print(error)
            return
       }
    }
    
    func startCaptureSession() {
        if !isRunning {
            captureSession.startRunning()
            delegate?.cameraSessionDidStart()
        }
    }
    
    func stopCaptureSession() {
        if isRunning {
            captureSession.stopRunning()
            delegate?.cameraSessionDidStop()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            delegate?.codeFound(code: stringValue)
        }
    }
    
    // MARK: - Private methods
    
    private func checkCaptureSessionInput() {
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
    }
    
    private func checkCaptureSessionOutput() {
        if let outputs = captureSession.outputs as? [AVCaptureMetadataOutput] {
            for output in outputs {
                captureSession.removeOutput(output)
            }
        }
    }
}

extension QRCodeScannerView: AVCaptureMetadataOutputObjectsDelegate {
    
}
