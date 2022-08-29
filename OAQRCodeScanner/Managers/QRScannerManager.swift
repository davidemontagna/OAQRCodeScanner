//
//  QRScannerManager.swift
//  OAQRCodeScanner
//
//  Created by Davide Montagna on 29/08/22.
//

import Foundation
import AVFoundation
import UIKit

class QRScannerManager: NSObject {
    
    // MARK: - Properties
    
    static let shared = QRScannerManager()
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var view: UIView!
    
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
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            if let view = view {
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)
            }
            captureSession.startRunning()
        } catch {
            print(error)
            return
       }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        videoPreviewLayer.removeFromSuperlayer()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            guard let url = URL(string: stringValue) else { return }
            UIApplication.shared.open(url)
        }
        UIDevice.vibrate()
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

extension QRScannerManager: AVCaptureMetadataOutputObjectsDelegate {
    
}

