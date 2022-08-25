//
//  ButtonsCell.swift
//  OAQRCodeScanner
//
//  Created by Davide Montagna on 24/08/22.
//

import UIKit
import AVFoundation

protocol CameraCellDelegate {
    func didOpenCameraTapped()
}

class CameraCell: UITableViewCell {
    
    // MARK: - Delegate
    
    var delegate: CameraCellDelegate?

    // MARK: - Outlets

    @IBOutlet weak var cameraView: UIView!
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
    
    func config(with delegate: CameraCellDelegate) {
        self.delegate = delegate
    }
}

