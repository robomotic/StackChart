//
//  Env.swift
//  HeatSpot
//
//  Created by Paolo Di Prodi on 21/02/2016.
//  Copyright © 2016 Paolo Di Prodi. All rights reserved.
//

import UIKit

class Env {
    
    static var iPad: Bool {
        return UIDevice.currentDevice().userInterfaceIdiom == .Pad
    }
}

