//
//  WebViewViewController.swift
//  wittyfeed_ios_api
//
//  Created by sudama dewda on 12/28/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://www.thepopple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

}
