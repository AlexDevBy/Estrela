//
//  UIView+Extension.swift
//  Estrela
//
//  Created by Alex Misko on 09.01.23.
//

import Foundation
import UIKit

extension UIView {
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return self.topAnchor
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leftAnchor
        }
        return self.leftAnchor
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.rightAnchor
        }
        return self.rightAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        return self.bottomAnchor
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 3
    }
}


extension UIViewController {
    func displayMsg(title: String?,
                    msg: String,
                    style: UIAlertController.Style = .alert,
                    dontRemindKey: String? = nil,
                    completionHandler: (()->())? = nil) {
      
        if dontRemindKey != nil,
            UserDefaults.standard.bool(forKey: dontRemindKey!) == true {
            return
        }
        
        let ac = UIAlertController.init(title: title,
                                        message: msg, preferredStyle: style)
        
        ac.addAction(UIAlertAction.init(title: "OK",
                                        style: .default,
                                        handler: {_ in completionHandler?()}))
        
        if dontRemindKey != nil {
            ac.addAction(UIAlertAction.init(title: "Don't Remind",
                                            style: .default, handler: { (_) in
                                                UserDefaults.standard.set(true, forKey: dontRemindKey!)
                                                UserDefaults.standard.synchronize()
            }))
        }
        
        DispatchQueue.main.async {
            ac.show()
        }
    }
    
    func displayMsgWithoutActions(
        title: String?,
        msg: String
    ) {
        
        let ac = UIAlertController.init(title: title,
                                        message: msg, preferredStyle: .alert)
        DispatchQueue.main.async {
            ac.show()
        }
    }
}

extension UIAlertController {

  func show(animated: Bool = true, completion: (() -> Void)? = nil) {
    if let visibleViewController = UIApplication.shared.keyWindow?.visibleViewController {
      visibleViewController.present(self, animated: animated, completion: completion)
    }
  }
}

extension UIWindow {
    
    var visibleViewController: UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        return visibleViewController(for: rootViewController)
    }
    
    private func visibleViewController(for controller: UIViewController) -> UIViewController {
        var nextOnStackViewController: UIViewController? = nil
        if let presented = controller.presentedViewController {
            nextOnStackViewController = presented
        } else if let navigationController = controller as? UINavigationController,
                  let visible = navigationController.visibleViewController {
            nextOnStackViewController = visible
        } else if let tabBarController = controller as? UITabBarController,
                  let visible = (tabBarController.selectedViewController ??
                                 tabBarController.presentedViewController) {
            nextOnStackViewController = visible
        }
        
        if let nextOnStackViewController = nextOnStackViewController {
            return visibleViewController(for: nextOnStackViewController)
        } else {
            return controller
        }
    }
    
}
