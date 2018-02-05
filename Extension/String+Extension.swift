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
    
    func formatDateFromServer() -> String {
        let indexStartOfText = self.index(self.startIndex, offsetBy: 9)
        let serverValue = self[...indexStartOfText]
        return String(serverValue)
    }
    
}
