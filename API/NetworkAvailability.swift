//
//  NetworkAvailability.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/7/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import Foundation
import Reachability

class NetworkAvailability
{
    static var connected = false
    static let reachability = Reachability()!

    static func checkNetworkConnection() -> Bool
    {

        do {
            try reachability.startNotifier()
        }
        catch { print(error.localizedDescription) }
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                self.connected = true
            }
            if reachability.connection == .cellular {
                print("Reachable via cellular")
                self.connected = true
            }
        }
        reachability.whenUnreachable = { _ in
            if reachability.connection == .none {
                print("Reachable via cellular")
            }
            self.connected = false
        }
        return connected
    }
    
    static func stopNotifier() {
        reachability.stopNotifier()
    }
}
