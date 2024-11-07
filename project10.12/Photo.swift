//
//  Photo.swift
//  project10.12
//
//  Created by Karina Dolmatova on 07.11.2024.
//

import UIKit

class Photo: Codable {
    var caption: String
    var filename: String

    init(caption: String, filename: String) {
        self.caption = caption
        self.filename = filename
    }
}

