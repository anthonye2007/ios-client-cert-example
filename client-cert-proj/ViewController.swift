//
//  ViewController.swift
//  client-cert-proj
//
//  Created by Anthony Elliott on 3/26/18.
//  Copyright © 2018 Pillar Technology. All rights reserved.
//

import UIKit
import Alamofire
import Security

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

        let cert = PKCS12.init(mainBundleResource: "client", resourceType: "p12", password: "test");

        Manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
                return (URLSession.AuthChallengeDisposition.useCredential, cert.urlCredential());
            }
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                return (URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!));
            }
            return (URLSession.AuthChallengeDisposition.performDefaultHandling, Optional.none);
        }

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

