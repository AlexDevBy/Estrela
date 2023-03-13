//
//  UIViewController+Extension.swift
//  Estrela
//
//  Created by Alex Misko on 28.12.22.
//

import Foundation
import UIKit
import MBProgressHUD
private var loadingRefCount = 0

private var hub: MBProgressHUD?

extension UIViewController {
    
    func showToast(_ text: String, duration: TimeInterval = 3 , completeBlock:(()->())? = nil) {
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.mode = .text
        hub.animationType = .zoom
        hub.label.text = text
        hub.label.numberOfLines = 0
        hub.completionBlock = completeBlock
        hub.hide(animated: true, afterDelay: duration)
    }
    
    func removeLoading() {
        loadingRefCount = 0
        hub?.hide(animated: true)
        hub = nil
    }
    
    func showLoading() {
        loadingRefCount += 1
        if hub == nil {
            hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    func hideLoading() {
        if hub == nil {
            return
        }
        loadingRefCount -= 1
        if loadingRefCount <= 0 {
            hub?.hide(animated: true)
            hub = nil
        }
    }
    
    func dismissKeyboard() {
           let tap: UITapGestureRecognizer = UITapGestureRecognizer( target:     self, action:    #selector(UIViewController.dismissKeyboardTouchOutside))
           tap.cancelsTouchesInView = false
           view.addGestureRecognizer(tap)
        }
        
        @objc private func dismissKeyboardTouchOutside() {
           view.endEditing(true)
        }
    
}
