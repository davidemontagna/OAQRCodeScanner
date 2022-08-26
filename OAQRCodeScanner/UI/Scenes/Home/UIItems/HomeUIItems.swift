//
//  HomeUIItems.swift
//  OAQRCodeScanner
//
//  Created by Davide Montagna on 24/08/22.
//

import Foundation

enum HomeUIItem {
    case button
    case content(QRCodeArgs)
}

struct QRCodeArgs {
    let qrCodeUrl: String
}
