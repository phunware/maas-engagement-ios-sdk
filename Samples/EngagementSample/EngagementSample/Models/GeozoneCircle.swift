//
//  GeozoneCircle.swift
//  EngagementSample
//
//  Created on 8/20/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import UIKit
import MapKit

enum GeozoneStatus {
    case inside
    case outside
    case unmonitored
}

class GeozoneCircle: MKCircle {

    var geozoneStatus = GeozoneStatus.outside
}
