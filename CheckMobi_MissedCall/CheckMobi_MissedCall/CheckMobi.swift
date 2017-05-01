//
//  CheckMobi.swift
//  Livision
//
//  Created by Stavros Filippidis on 25/04/2017.
//  Copyright © 2017 Livision. All rights reserved.
//

import UIKit
import Alamofire
import CallKit

class CheckMobi: NSObject {
    
    let baseURLForCall = "https://api.checkmobi.com/v1/validation/request"
    let baseURLForPinValidation = "https://api.checkmobi.com/v1/validation/verify"

    let headers: HTTPHeaders = [
        "Authorization": "YOUR_API_KEY"
    ]
    
    func makeMissedCallWithNumber(phoneNumber:String, completionHandler: @escaping (String) -> Void){
        
        let parameters: Parameters = [
            "number": phoneNumber,
            "type": "reverse_cli",
            "platform": "ios"
        ]
   
        Alamofire.request(baseURLForCall, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers:headers).responseJSON { (response) in
           
            print(response)

            switch response.result {
            case .success:
                
                if let responseValue = response.value as? NSDictionary{

                    if let errorCode = responseValue.object(forKey:"code") as? NSNumber{
                        if(errorCode == 2){
                            completionHandler("NonValidNumber")
                        }
                    }else{
                        let responseValue = response.value! as? NSDictionary
                        let returnedValidationID = responseValue?.object(forKey: "id")! as! String
                        
                        completionHandler(returnedValidationID)
                    }
                }
            case .failure:
                completionHandler("Error!")
            }
        }
    }
    
    func validatePin(pin:String,validationId:String,completionHandler: @escaping (Bool) -> Void){
        
        let parameters: Parameters = [
            "id": validationId,
            "pin": pin,
            "use_server_hangup": true
        ]
        
        Alamofire.request(baseURLForPinValidation, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers:headers).responseJSON { (response) in
            switch response.result {
            case .success:
                
                if let responseValue = response.value as? NSDictionary{
                    if let errorCode = responseValue.object(forKey:"code") as? NSNumber{
                        print("Error Code \(errorCode)")
                        completionHandler(false)
                    }else{
                        let res = response.value! as? NSDictionary
                        let validated = res?.object(forKey: "validated")! as! Bool
                        
                        if(validated){
                            completionHandler(true)
                        }else if(!validated){
                            completionHandler(false)
                        }
                    }
                }
            case .failure:
                completionHandler(false)
            }
        }
    }
}
