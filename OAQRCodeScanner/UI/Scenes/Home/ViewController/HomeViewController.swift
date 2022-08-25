//
//  HomeViewController.swift
//  OAQRCodeScanner
//
//  Created by Davide Montagna on 24/08/22.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Adapter
    
    lazy var adapter = HomeAdapter(delegate: self)
    
    // MARK: - ViewModel
    
    lazy var viewModel = HomeViewModel()
    
    // MARK: - Properties
    
    let captureSession = AVCaptureSession()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cell: CameraCell.self)
        //Setup TableView
        tableView.delegate = adapter
        tableView.dataSource = adapter
    }
    
    // MARK: - Public methods
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.captureSession.stopRunning()
        viewModel.getUrlfromMetadata(metadataObjects: metadataObjects)
        UIApplication.shared.open(viewModel.QRCodeUrl)
    }
}

// MARK: - Extensions

extension HomeViewController: HomeAdapterDelegate {
    func didOpenCameraTapped() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to open the camera device")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            self.captureSession.addInput(input)
            var videoPreviewLayer: AVCaptureVideoPreviewLayer?
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            self.captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            self.captureSession.startRunning()
        } catch {
            print(error)
            return
        }
    }
}

extension HomeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
}
