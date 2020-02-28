//
//  PinItem.swift
//  leaning
//
//  Created by Tenna on 2/14/2 R.
//  Copyright © 2 Reiwa Tenna. All rights reserved.
//

import Foundation
import RealmSwift

class PinItem: Object {
    @objc dynamic var coordinateLat: String!
    @objc dynamic var coordinateLon: String!
    @objc dynamic var title: String?
    @objc dynamic var subtitle: String?
    @objc dynamic var image: String?
}

class UserPin: Object {
    @objc dynamic var name: String?
}

class ThemeColor: Object {
    @objc dynamic var r: String?
    @objc dynamic var g: String?
    @objc dynamic var b: String?
}

class UserSetting {
    static var pinColor = "redpin-1.png"
    static var color1: UIColor?
    static var color2: UIColor?
    static var color3: UIColor?
    static var pinImage: String?
}

class Screen {
    static let w = UIScreen.main.bounds.size.width
    static let h = UIScreen.main.bounds.size.height
}

class Color {
    static let color1 = UIColor(red: 184/255, green: 218/255, blue: 255/255, alpha: 1)
    static let color2 = UIColor(red: 242/255, green: 207/255, blue: 20/255, alpha: 1)
    static let color3 = UIColor(red: 242/255, green: 175/255, blue: 175/255, alpha: 1)
    static let color4 = UIColor(red: 213/255, green: 230/255, blue: 230/164, alpha: 1)
    static let color5 = UIColor(red: 213/255, green: 185/255, blue: 164/255, alpha: 1)
    static let color6 = UIColor(red: 213/255, green: 139/255, blue: 164/255, alpha: 1)
    static let color7 = UIColor(red: 95/255, green: 139/255, blue: 164/255, alpha: 1)
    static let color8 = UIColor(red: 95/255, green: 139/255, blue: 70/255, alpha: 1)
    static let color9 = UIColor(red: 223/255, green: 216/255, blue: 255/255, alpha: 1)
    static let color10 = UIColor(red: 71/255, green: 216/255, blue: 140/255, alpha: 1)
    static let color11 = UIColor(red: 255/255, green: 74/255, blue: 104/255, alpha: 1)
    static let color12 = UIColor(red: 255/255, green: 74/255, blue: 0/255, alpha: 1)
    static let color13 = UIColor(red: 255/255, green: 172/255, blue: 0/255, alpha: 1)
    static let color14 = UIColor(red: 255/255, green: 172/255, blue: 147/255, alpha: 1)
    static let color15 = UIColor(red: 255/255, green: 77/255, blue: 82/255, alpha: 1)
    static let color16 = UIColor(red: 228/255, green: 183/255, blue: 190/255, alpha: 1)
    static let color17 = UIColor(red: 204/255, green: 229/255, blue: 190/255, alpha: 1)
    static let color18 = UIColor(red: 204/255, green: 161/255, blue: 145/255, alpha: 1)
    static let color19 = UIColor(red: 81/255, green: 144/255, blue: 212/255, alpha: 1)
    static let color20 = UIColor(red: 37/255, green: 93/255, blue: 108/255, alpha: 1)
    static let color21 = UIColor(red: 126/255, green: 93/255, blue: 108/255, alpha: 1)
    static let color22 = UIColor(red: 112/255, green: 140/255, blue: 218/255, alpha: 1)
    static let color23 = UIColor(red: 204/255, green: 206/255, blue: 255/255, alpha: 1)
    static let color24 = UIColor(red: 125/255, green: 101/255, blue: 79/255, alpha: 1)
    static let color25 = UIColor(red: 211/255, green: 182/255, blue: 79/255, alpha: 1)
    static let color26 = UIColor(red: 180/255, green: 142/255, blue: 137/255, alpha: 1)
    static let color27 = UIColor(red: 0/255, green: 142/255, blue: 137/255, alpha: 1)
    static let color28 = UIColor(red: 0/255, green: 88/255, blue: 57/255, alpha: 1)
    static let color29 = UIColor(red: 94/255, green: 78/255, blue: 133/255, alpha: 1)
    static let color30 = UIColor(red: 179/255, green: 255/255, blue: 215/255, alpha: 1)
    static let color31 = UIColor(red: 255/255, green: 255/255, blue: 215/255, alpha: 1)
    static let color32 = UIColor(red: 255/255, green: 209/255, blue: 215/255, alpha: 1)
    static let color33 = UIColor(red: 206/255, green: 209/255, blue: 0/255, alpha: 1)
    static let color34 = UIColor(red: 206/255, green: 41/255, blue: 41/255, alpha: 1)
    static let color35 = UIColor(red: 255/255, green: 218/255, blue: 194/255, alpha: 1)
    
    static let colorArray: [UIColor] = [color1, color2, color3, color4, color5, color6, color7, color8, color9, color10, color11, color12, color13, color14, color15, color16, color17, color18, color19, color20, color21, color22, color23, color24, color25, color26, color27, color28, color29, color30, color31, color32, color33, color34, color35]
}
