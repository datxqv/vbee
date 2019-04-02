//
//  NSDataExtension.swift
//  Visunite
//
//  Created by luckymanbk on 8/30/16.
//  Copyright © 2016 Paditech. All rights reserved.
//

import Foundation
import UIKit

private let pngHeader: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]
private let jpgHeaderSOI: [UInt8] = [0xFF, 0xD8]
private let jpgHeaderIF: [UInt8] = [0xFF]
private let gifHeader: [UInt8] = [0x47, 0x49, 0x46]

enum ImageFormat {
    case unknown, png, jpeg, gif
}

extension Data {
    var imageFormat: ImageFormat {
        var buffer = [UInt8](repeating: 0, count: 8)
        (self as NSData).getBytes(&buffer, length: 8)
        if buffer == pngHeader {
            return .png
        } else if buffer[0] == jpgHeaderSOI[0] && buffer[1] == jpgHeaderSOI[1] && buffer[2] == jpgHeaderIF[0] {
            return .jpeg
        } else if buffer[0] == gifHeader[0] && buffer[1] == gifHeader[1] && buffer[2] == gifHeader[2] {
            return .gif
        }
        
        return .unknown
    }
    
    var imageFormatString: String {
        switch self.imageFormat {
        case .png:
            return "image/png"
        case .jpeg:
            return "image/jpeg"
        case .gif:
            return "image/gif"
        default:
            return "application/octet-stream" // default type
        }
    }
    
    func mimeTypeForData() -> String? {
        var buffer = [UInt8](repeating: 0, count: 1)
        (self as NSData).getBytes(&buffer, length: 1)
        
        switch (buffer[0]) {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x49:
            return "image/tiff"
        case 0x4D:
            return "image/tiff"
        default:
            return "application/octet-stream" // default type
        }
    }
}
