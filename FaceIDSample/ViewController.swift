//
//  ViewController.swift
//  FaceIDSample
//
//  Created by 都筑一希 on 2018/02/18.
//  Copyright © 2018年 kazuki229. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var canEvaluatePolicyButton: UIButton!
    @IBOutlet weak var evaluatePolicyButton: UIButton!
    var context: LAContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.context = LAContext()
    }
    
    @IBAction func canEvaluatePolicy(_ sender: UIButton) {
        var error: NSError?
        let context = LAContext()
        if !self.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if error == nil {
                return
            }
            
            var message = ""

            // LABiometryType can be used from iOS 11.0.1
            if #available(iOS 11.0.1, *) {
                message += "\nThis device can use " + self.getBiometryTypeText(biometryType: context.biometryType)
            }
            
            let alert = UIAlertController(title: "error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(action)
            show(alert, sender: nil)
            return
        }
        var message = ""
        if #available(iOS 11.0.1, *) {
            message = self.getBiometryTypeText(biometryType: context.biometryType)
        }
        let alert = UIAlertController(title: "Success", message: "This device can use " + message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(action)
        show(alert, sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func evaluatePolicy(_ sender: UIButton) {
        let reason = "For Test."
        if self.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            self.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success, error) in
                if success {
                    let alert = UIAlertController(title: "Success", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.show(alert, sender: nil)
                    return
                }
                
                let nserror = (error as Any) as! NSError
                let alert = UIAlertController(title: "Error", message: self.getLAErrorText(code: LAError.Code(rawValue: nserror.code)!), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.show(alert, sender: nil)
            })
        }
    }
    
    @available(iOS 11.0, *)
    func getBiometryTypeText(biometryType: LABiometryType) -> String {
        // LABiometryType.none can be used from iOS 11.2
        if #available(iOS 11.2, *) {
            switch biometryType {
            case .faceID:
                return "Face ID"
            case .touchID:
                return "Touch ID"
            case .none:
                return "None"
            }
        }
        
        // LABiometryType.LABiometryNone is Deprecated iOS11.0.1-11.1
        switch biometryType {
        case .faceID:
            return "Face ID"
        case .touchID:
            return "Touch ID"
        case .LABiometryNone:
            return "None"
        default:
            return "Unexpected"
        }
    }
    
    func getLAErrorText(code: LAError.Code) -> String {
        var message = "unexpected"
        switch code {
        case .authenticationFailed:
            message = "authenticationFailed"
        case .appCancel:
            message = "appCancel"
        case .invalidContext:
            message = "invalidContext"
        case .notInteractive:
            message = "notInteractive"
        case .passcodeNotSet:
            message = "passcodeNotSet"
        case .systemCancel:
            message = "systemCancel"
        case .userCancel:
            message = "userCancel"
        case .userFallback:
            message = "userFallback"
        case .touchIDLockout:
            message = "touchIDLockout"
        case .touchIDNotEnrolled:
            message = "touchIDNotEnrolled"
        case .touchIDNotAvailable:
            message = "touchIDNotAvailable"
        default:
            break
        }
        
        if #available(iOS 11.0.0, *) {
            switch code {
            case .biometryLockout:
                message = "biometryLockout"
            case .biometryNotEnrolled:
                message = "biometryNotEnrolled"
            case .biometryNotAvailable:
                message = "biometryNotAvailable"
            default:
                break
            }
        }
        
        return message
    }
}
