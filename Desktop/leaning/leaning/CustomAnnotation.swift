//
//  customAnnotation.swift
//  leaning
//
//  Created by Tenna on 2/3/2 R.
//  Copyright © 2 Reiwa Tenna. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift

class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: String?

    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, image: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.image = image
        
        super.init()
    }
}
