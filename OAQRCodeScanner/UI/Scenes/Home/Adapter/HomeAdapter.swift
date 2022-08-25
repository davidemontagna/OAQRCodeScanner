//
//  HomeAdapter.swift
//  OAQRCodeScanner
//
//  Created by Davide Montagna on 24/08/22.
//

import Foundation
import UIKit

protocol HomeAdapterDelegate {
    func didOpenCameraTapped()
}

class HomeAdapter: NSObject {
    
    // MARK: - Delegate
    
    var delegate: HomeAdapterDelegate?
    
    // MARK: - Properties
    
    var uiitems: [QRCodeUIItem] = []
    
    // MARK: - Adapter Lifecycle
    
    init(delegate: HomeAdapterDelegate) {
        self.delegate = delegate
    }
}

// MARK: - Extensions

extension HomeAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CameraCell = tableView.dequeueReusableCell(for: CameraCell.self, for: indexPath)
        cell.config(with: self)
        return cell
    }
}

extension HomeAdapter: UITableViewDelegate {
}

extension HomeAdapter: CameraCellDelegate {
    func didOpenCameraTapped() {
        delegate?.didOpenCameraTapped()
    }
}
