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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cell: CameraCell.self)
        //Setup TableView
        tableView.delegate = adapter
        tableView.dataSource = adapter
    }
}

// MARK: - Extensions

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}

extension HomeViewController: HomeAdapterDelegate {
    func didOpenCameraTapped() {
        print("Open camera tapped")
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self;
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
}
