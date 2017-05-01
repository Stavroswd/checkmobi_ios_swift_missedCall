//
//  ViewController.swift
//  CheckMobi_MissedCall
//
//  Created by Stavros Filippidis on 30/04/2017.
//  Copyright © 2017 Stavros Filippidis. All rights reserved.
//

import UIKit

class PhoneNumberEntry: UIViewController{

    var registrationID = String()
    
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var confirm: UIButton!
    
    @IBAction func requestCallForVerificatio(_ sender: Any) {
    
        if((phoneNumberTextField.text?.characters.count)! == 0){
            phoneNumberTextField.shake()
        }else{
            checkMobi.makeMissedCallWithNumber(phoneNumber: phoneNumberTextField.text!, completionHandler: { (response) in
                
                guard response != "NonValidNumber" else {
                    self.phoneNumberTextField.shake()
                    return 
                }
                
                self.registrationID = response
                self.performSegue(withIdentifier: "digitEntrance", sender:self)
              
                print("Call starts!")
            })
        }
    }
    
    let checkMobi = CheckMobi()
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.phoneNumberTextField.becomeFirstResponder()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextfieldStyles()
        setConfirmButtonStyles()
        phoneNumberTextField.delegate = self
    }
    
    func setTextfieldStyles(){
        phoneNumberTextField.layer.borderColor = UIColor.white.cgColor
        phoneNumberTextField.layer.borderWidth = 1
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: phoneNumberTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        phoneNumberTextField.autocorrectionType = .no
        phoneNumberTextField.keyboardType = .phonePad
        phoneNumberTextField.keyboardAppearance = .dark
    }
    
    func setConfirmButtonStyles(){
        confirm.layer.borderWidth = 1
        confirm.layer.borderColor = UIColor.white.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "digitEntrance") {
            if let vc = segue.destination as? ValidatePinViewController {
                vc.registrationID = self.registrationID
            }
        }
    }
}

extension PhoneNumberEntry: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Textfield did begin editing!")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Textfield did end editing!")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}


extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

