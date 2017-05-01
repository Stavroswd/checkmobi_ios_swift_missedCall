//
//  ValidatePinViewController.swift
//  CheckMobi_MissedCall
//
//  Created by Stavros Filippidis on 30/04/2017.
//  Copyright © 2017 Stavros Filippidis. All rights reserved.
//

import UIKit

class ValidatePinViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet var validationDigits: UITextField!
    @IBOutlet var confirm: UIButton!
    
    var registrationID = String()
    var id = String()
    
    let checkMobi = CheckMobi()
    
    @IBAction func validatePin(_ sender: Any) {
        if((validationDigits.text?.characters.count)! == 0){
            validationDigits.shake()
        }else{
            checkMobi.validatePin(pin: validationDigits.text!, validationId: self.id, completionHandler: { (validationWorked) in
                if(validationWorked){
                    self.performSegue(withIdentifier: "verificationSuccess", sender: self)
                }else{
                    self.validationDigits.shake()
                }
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.id = registrationID
        UIView.animate(withDuration: 0.3, animations: {
            self.validationDigits.becomeFirstResponder()
        })
    }
    
    override func viewDidLoad() {
        validationDigits.delegate = self
        setTextfieldStyles()
        setConfirmButtonStyles()
    }
    
    func setTextfieldStyles(){
        validationDigits.layer.borderColor = UIColor.white.cgColor
        validationDigits.layer.borderWidth = 1
        validationDigits.attributedPlaceholder = NSAttributedString(string: validationDigits.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        validationDigits.autocorrectionType = .no
        validationDigits.keyboardType = .phonePad
        validationDigits.keyboardAppearance = .dark
    }
    
    func setConfirmButtonStyles(){
        confirm.layer.borderWidth = 1
        confirm.layer.borderColor = UIColor.white.cgColor
    }
}

/*
extension ValidatePinViewController: UITextFieldDelegate{
    
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
 */
