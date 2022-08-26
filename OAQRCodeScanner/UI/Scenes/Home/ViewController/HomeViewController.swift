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
    
    lazy var viewModel = HomeViewModel(delegate: self)
    
    // MARK: - Properties
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cell: ButtonsCell.self)
        tableView.register(cell: ScanResultCell.self)
        //Setup TableView
        tableView.delegate = adapter
        tableView.dataSource = adapter
        adapter.uiitems = viewModel.uiitems
    }
    
    // MARK: - Public methods
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.captureSession.stopRunning()
        videoPreviewLayer.removeFromSuperlayer()
        viewModel.getUrlfromMetadata(metadataObjects: metadataObjects)
        UIDevice.vibrate()
        dismiss(animated: true)
        viewModel.showScanResult()
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

// MARK: - Extensions

extension HomeViewController: HomeAdapterDelegate {
    func didOpenCameraTapped() {
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
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            captureSession.startRunning()
        } catch {
            print(error)
            return
        }
    }
}

extension HomeViewController: HomeViewModelDelegate {    
    func onSuccess(by useCase: HomeViewModelUseCases) {
        switch useCase {
        case .showResult:
            adapter.uiitems = viewModel.uiitems
            tableView.reloadData()
        }
    }
}

extension HomeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
}
