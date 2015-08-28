//
//  Meme.swift
//  Meme
//
//  Created by Martin Kelly on 27/08/2015.
//  Copyright (c) 2015 Scriptable. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topString:String
    var bottomString:String
    var originalImage:UIImage
    var memeImage:UIImage
    
    init(topString:String, bottomString:String, originalImage:UIImage, memeImage:UIImage) {
        self.topString = topString
        self.bottomString = bottomString
        self.originalImage = originalImage
        self.memeImage = memeImage
    }
}