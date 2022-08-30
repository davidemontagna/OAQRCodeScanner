//
//  HomeViewController.swift
//  OAQRCodeScanner
//
//  Created by Davide Montagna on 24/08/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Adapter
    
    lazy var adapter = HomeAdapter(delegate: self)
    
    // MARK: - ViewModel
    
    lazy var viewModel = HomeViewModel(delegate: self)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cell: ButtonsCell.self)
        tableView.register(cell: ScanResultCell.self)
        //Setup TableView
        tableView.delegate = adapter
        tableView.dataSource = adapter
        adapter.uiitems = viewModel.uiitems
        errorLabel.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? QRScannerViewController {
            destination.delegate = self
        }
    }
}

// MARK: - Extensions

extension HomeViewController: HomeAdapterDelegate {
    func didOpenCameraTapped() {
        viewModel.startCamera()
    }
}

extension HomeViewController: HomeViewModelDelegate {    
    func onSuccess(by useCase: HomeViewModelUseCases) {
        switch useCase {
        case .showResult:
            adapter.uiitems = viewModel.uiitems
            tableView.reloadData()
        case .startCamera:
            self.performSegue(withIdentifier: "show_scanner", sender: nil)
        }
    }
}

extension HomeViewController: QRScannerViewControllerDelegate {
    func printQRCodeUrl(url: URL) {
        viewModel.showScanResult(url: url)
    }
}

