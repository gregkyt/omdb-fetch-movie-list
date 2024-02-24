//
//  NetworkUtil.swift
//  MovieAPI
//
//  Created by Bangkit on 23/02/24.
//

import Foundation
import Alamofire

protocol NetworkAvailabilityChecker {
    var reachabilityManager: NetworkReachabilityManager? { get set }
    
    func startListening(
        completion: @escaping (NetworkReachabilityManager.NetworkReachabilityStatus) -> ()
    )
}

class NetworkAvailabilityCheckerImpl: NetworkAvailabilityChecker {
    var reachabilityManager: NetworkReachabilityManager? =
        NetworkReachabilityManager(host: "www.apple.com")
    
    static let shared = NetworkAvailabilityCheckerImpl()
    // var reachabilityManager = NetworkReachabilityManager(host: "www.apple.com")

//    init() {
//        startListening()
//    }

    func startListening(
        completion: @escaping (NetworkReachabilityManager.NetworkReachabilityStatus) -> ()
    ) {
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                // print("Internet is not available.")
                completion(.notReachable)
            case .reachable(.ethernetOrWiFi):
                // print("Internet is available .")
                completion(.reachable(.ethernetOrWiFi))
            case .reachable(.cellular):
                // print("Internet is available via cellular data.")
                completion(.reachable(.cellular))
            case .unknown:
                // print("Internet availability is unknown.")
                completion(.unknown)
            }
        }
    }
}
