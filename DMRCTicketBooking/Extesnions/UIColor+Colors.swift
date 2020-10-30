//
//  UIColor+Colors.swift
//  DMRCTicketBooking
//
//  Created by Ahmad Waqas on 28/10/20.
//

import UIKit

///Tip: type #colorLiteral() to choose color from picker
public extension UIColor {
    //MARK:- Custom colors
    static let titleColor = UIColor.init(light: .darkText, dark: .lightText)
    static let mapRouteColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
    static let buttonBackground = UIColor.init(light: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), dark: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
}
