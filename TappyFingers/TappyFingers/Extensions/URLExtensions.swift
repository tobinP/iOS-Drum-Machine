//
//  URLExtensions.swift
//  TappyFingers
//
//  Created by Tobin Pomeroy on 3/7/18.
//  Copyright © 2018 Tobin Pomeroy. All rights reserved.
//

import Foundation

extension URL {
    static func getFileURL(fileName: String) -> URL? {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil}
        return URL(fileURLWithPath: path).appendingPathComponent(fileName)
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

