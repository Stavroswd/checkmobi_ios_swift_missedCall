# Missed Call Verification 

This simple but powerful verification is made by intercepting a missed call from a random number allowing you to verify a user with a seamless user experience that removes the pin-entry on Android and reduces signup friction. Using Checkmobi SDKs you can integrate Missed Call verification with just a few lines on code.

## Getting Started


### Prerequisites

There is no need to include the checkMobi Swift Framework since the missed call is handled by HTTP requests.

### Code


```

import UIKit
import Alamofire
import CallKit

class CheckMobi: NSObject {
    
    let baseURLForCall = "https://api.checkmobi.com/v1/validation/request"
    let baseURLForPinValidation = "https://api.checkmobi.com/v1/validation/verify"

    let headers: HTTPHeaders = [
        "Authorization": "7C90A4CB-B18B-40E2-A55F-0859250B9F2F"
    ]
    
    func makeMissedCallWithNumber(phoneNumber:String, completionHandler: @escaping (String) -> Void){
        
        let parameters: Parameters = [
            "number": phoneNumber,
            "type": "reverse_cli",
            "platform": "ios"
        ]
   
        Alamofire.request(baseURLForCall, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers:headers).responseJSON { (response) in
            
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
                        
                        completionHandler(true)
                    }
                }
                
            case .failure:
                completionHandler(false)
            }
        }
    }
}

```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

```
Alamofire 
```

## Versioning

```
Cocoapods 

```

## Authors

* **Stavros Filippidis** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

With the help of Silviu (Customer Service Checkmobi) 
