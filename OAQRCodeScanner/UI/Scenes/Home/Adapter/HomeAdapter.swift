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
    
    var uiitems: [HomeUIItem] = []
    
    // MARK: - Adapter Lifecycle
    
    init(delegate: HomeAdapterDelegate) {
        self.delegate = delegate
    }
}

// MARK: - Extensions

extension HomeAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uiitems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch uiitems[indexPath.row] {
        case .button:
            let cell: ButtonsCell = tableView.dequeueReusableCell(for: ButtonsCell.self, for: indexPath)
            cell.config(with: self)
            return cell
        case .content(let args):
            let cell: ScanResultCell = tableView.dequeueReusableCell(for: ScanResultCell.self, for: indexPath)
            cell.config(with: args)
            return cell
        }
    }
}

extension HomeAdapter: UITableViewDelegate {
}

extension HomeAdapter: ButtonsCellDelegate {
    func didOpenCameraTapped() {
        delegate?.didOpenCameraTapped()
    }
}


