//
//  ScanResultCell.swift
//  OAQRCodeScanner
//
//  Created by Davide Montagna on 26/08/22.
//

import UIKit

class ScanResultCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var resultLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resultLabel.isHidden = true
    }

    // MARK: - Public methods
    
    func config(with args: QRCodeArgs) {
        print(args.qrCodeUrl)
        resultLabel.text = "The scanned code contains the link: \(args.qrCodeUrl)"
        resultLabel.isHidden = false
    }
    
}
