//
//  Helper.swift
//  nearbyapp
//
//  Created by Samuel Ryc on 2017-02-24.
//
//

import Foundation

class Helper {
    
    func stringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss +zzzz"
        dateFormatter.locale = Locale.init(identifier: "fr_CA")
        
        let dateObj = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateObj!
    }
    
}
