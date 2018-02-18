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
        if !self.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if error == nil {
                return
            }
            
            var message: String!
    
            switch error!.code {
                case LAError.passcodeNotSet.rawValue:
                    message = "Passcode is not set."
                case LAError.biometryLockout.rawValue:
                    message = "Biometry is locked out."
                case LAError.biometryNotAvailable.rawValue:
                    message = "Biometry is not available."
                case LAError.biometryNotEnrolled.rawValue:
                    message = "Biometry is not enrolled."
                default:
                message = "unexpected"
            }
            
            // LABiometryType can be used from iOS 11.0.1
            if #available(iOS 11.0.1, *) {
                message = message + "\nThis device can use " + getBiometryText()
            }
            
            let alert = UIAlertController(title: "error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default, handler:nil)
            alert.addAction(action)
            show(alert, sender: nil)
            return
        }
        
        let alert = UIAlertController(title: "Success", message: "This device can use " + getBiometryText(), preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler:nil)
        alert.addAction(action)
        show(alert, sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getBiometryText() -> String {
        // LABiometryType.none can be used from iOS 11.2
        if #available(iOS 11.2, *) {
            switch self.context.biometryType {
            case .faceID:
                return "Face ID"
            case .touchID:
                return "Touch ID"
            case .none:
                return "None"
            }
        }
        
        // LABiometryType.LABiometryNone is Deprecated iOS11.0.1-11.1
        switch self.context.biometryType {
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
                
                let description: String!
                switch (error! as NSError).code {
                case LAError.appCancel.rawValue:
                    description = "app is canceled"
                case LAError.authenticationFailed.rawValue:
                    description = "authentication is failed"
                case LAError.invalidContext.rawValue:
                    description = "invalid context"
                case LAError.notInteractive.rawValue:
                    description = "not interactive"
                case LAError.passcodeNotSet.rawValue:
                    description = "passcode is not set"
                case LAError.systemCancel.rawValue:
                    description = "system cancel"
                case LAError.userCancel.rawValue:
                    description = "user cancel"
                case LAError.userFallback.rawValue:
                    description = "user fallback"
                case LAError.biometryNotAvailable.rawValue:
                    description = "biometry is not available"
                default:
                    description = "unexpected"
                }
                let alert = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.show(alert, sender: nil)
            })
        }
    }
}

