//
//  ViewController.swift
//  client-cert-proj
//
//  Created by Anthony Elliott on 3/26/18.
//  Copyright © 2018 Pillar Technology. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    private let Manager: Alamofire.SessionManager = {
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "localhost": .disableEvaluation
        ]
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let man = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        return man
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeSecureRequest()
    }

    private func makeSecureRequest() {
        Manager.request("https://localhost/").responseJSON { response in
            print("got response")
            print(response.result.debugDescription)
            print(response.response?.statusCode)
        }
    }
}

