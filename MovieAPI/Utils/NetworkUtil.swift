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

    func startListening(
        completion: @escaping (NetworkReachabilityManager.NetworkReachabilityStatus) -> ()
    ) {
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                completion(.notReachable)
            case .reachable(.ethernetOrWiFi):
                completion(.reachable(.ethernetOrWiFi))
            case .reachable(.cellular):
                completion(.reachable(.cellular))
            case .unknown:
                completion(.unknown)
            }
        }
    }
}
