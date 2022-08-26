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

    @IBOutlet weak var borderButton: UIView!
    @IBOutlet weak var openCameraButton: UIView!
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Actions
    
    @IBAction func openCameraTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.4,
                       animations: {
            self.borderButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.4) {
                self.borderButton.transform = CGAffineTransform.identity
                self.delegate?.didOpenCameraTapped()
            }
        })
    }
    
    // MARK: - Public methods
    
    func config(with delegate: ButtonsCellDelegate) {
        self.delegate = delegate        
    }
}

