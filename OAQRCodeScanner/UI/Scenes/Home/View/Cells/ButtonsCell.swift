//
//  ButtonsCell.swift
//  OAQRCodeScanner
//
//  Created by Davide Montagna on 24/08/22.
//

import UIKit

protocol ButtonsCellDelegate {
    func didOpenCameraTapped()
}

class ButtonsCell: UITableViewCell {
    
    // MARK: - Delegate
    
    var delegate: ButtonsCellDelegate?

    // MARK: - Outlets

    @IBOutlet weak var openCameraButton: UIView!
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Actions
    
    @IBAction func openCameraTapped(_ sender: Any) {
        delegate?.didOpenCameraTapped()
    }
    
    // MARK: - Public methods
    
    func config(with delegate: ButtonsCellDelegate) {
        self.delegate = delegate        
    }
}

