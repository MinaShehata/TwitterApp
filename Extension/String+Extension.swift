//
//  String+Extension.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/3/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import Foundation

extension String {
    // MARK:- base64Encode String for twitter authentication
    public func getBase64EncodeString(consumerKey: String, and consumerSecret: String) -> String {
        guard let consumerkey = consumerKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let consumersecret = consumerSecret.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return "" }
        let concatenateKeyAndSecret = consumerkey + ":" + consumersecret
        guard let secretAndKeyData = concatenateKeyAndSecret.data(using: String.Encoding.ascii, allowLossyConversion: true) else { return "" }
        // final result
        let base64EncodeKeyAndSecret = secretAndKeyData.base64EncodedString(options: Data.Base64EncodingOptions())
        return base64EncodeKeyAndSecret
    }
    
    // format date to human readable String Date + time from server
    func formatDateFromServer() -> String {
        let indexStartOfMonth = self.index(self.startIndex, offsetBy: 3)
        let indexEndOfMonth = self.index(indexStartOfMonth, offsetBy: 7)
        let date = self[indexStartOfMonth...indexEndOfMonth]
        
        let startTime = self.index(indexEndOfMonth, offsetBy: 1)
        let endTime = self.index(startTime, offsetBy: 7)
        
        let startYear = self.index(endTime, offsetBy: 7)
        let year = self[startYear...]
        let time = self[startTime...endTime]
        
        let allDate = "\(time)\(date)\(year)"
        return allDate
    }
 
}
