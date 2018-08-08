////
////  VPN.swift
////  Particle
////
////  Created by Artem Misesin on 4/8/18.
////  Copyright © 2018 Artem Misesin. All rights reserved.
////
//
//import Foundation
//import NetworkExtension
//
//class VPN {
//    
//    /// The target VPN configuration.
//    var vpnManager = NEVPNManager.shared()
//    
//    private var vpnLoadHandler: (Error?) -> Void { return
//    { (error:Error?) in
//        if ((error) != nil) {
//            print("Could not load VPN Configurations")
//            return;
//        }
//        let p = NEVPNProtocolIPSec()
//        p.username = "SOME_USERNAME"
//        p.serverAddress = "example.com"
//        p.authenticationMethod = NEVPNIKEAuthenticationMethod.sharedSecret
//        
//        let kcs = KeychainService();
//        kcs.save(key: "SHARED", value: "MY_SHARED_KEY")
//        kcs.save(key: "VPN_PASSWORD", value: "MY_PASSWORD")
//        p.sharedSecretReference = kcs.load(key: "SHARED")
//        p.passwordReference = kcs.load(key: "VPN_PASSWORD")
//        p.useExtendedAuthentication = true
//        p.disconnectOnSleep = false
//        self.vpnManager.protocolConfiguration = p
//        self.vpnManager.localizedDescription = "Contensi"
//        self.vpnManager.isEnabled = true
//        self.vpnManager.saveToPreferences(completionHandler: self.vpnSaveHandler)
//        }
//    }
//    
//    private var vpnSaveHandler: (Error?) -> Void {
//        let handler = { (error: Error?) in
//            if error != nil {
//                print("Could not save VPN Configurations")
//                return
//            } else {
//                do {
//                    try self.vpnManager.connection.startVPNTunnel()
//                } catch let error {
//                    print("Error starting VPN Connection \(error.localizedDescription)");
//                }
//            }
//        }
//        self.vpnlock = false
//    }
//    
//    public func connectVPN() {
//        //For no known reason the process of saving/loading the VPN configurations fails.On the 2nd time it works
//        do {
//            try self.vpnManager.loadFromPreferences(completionHandler: self.vpnLoadHandler)
//        } catch let error {
//            print("Could not start VPN Connection: \(error.localizedDescription)" )
//        }
//    }
//    
//    public func disconnectVPN() ->Void {
//        vpnManager.connection.stopVPNTunnel()
//    }
//}
