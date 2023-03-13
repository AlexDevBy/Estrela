//
//  ProvicyPolicyViewController.swift
//  Estrela
//
//  Created by Alex Misko on 28.12.22.
//

import UIKit
import WebKit

enum ContentType {
    case privacyPolicy
    case termsOfUse
    case sendFeedback
}


class ProvicyPolicyViewController: UIViewController, WKNavigationDelegate, WKUIDelegate  {

    @IBOutlet weak var webView: WKWebView!
    
    var contentType: ContentType?

    override func viewDidLoad() {
        super.viewDidLoad()

        var webURl: URL?
        if contentType == .privacyPolicy{
            webURl = URL(string: "https://estrelabot.host/privacy.html")
        } else if contentType == .termsOfUse {
            webURl = URL(string: "https://estrelabot.host/terms.html")
        } else {
            webURl = URL(string: "https://estrelabot.host/#three")
        }
        let request = URLRequest(url: webURl!)
        self.webView.navigationDelegate = self
        self.webView.load(request)
        self.showLoading()
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideLoading()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.hideLoading()
    }

}
