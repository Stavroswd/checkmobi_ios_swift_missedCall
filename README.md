# Missed Call Verification 

This simple but powerful verification is made by intercepting a missed call from a random number allowing you to verify a user with a seamless user experience that removes the pin-entry on Android and reduces signup friction. Using Checkmobi SDKs you can integrate Missed Call verification with just a few lines on code.

## Getting Started



### Prerequisites

There is no need to include the checkMobi Swift Framework since the missed call is handled by HTTP requests.
In my case i used Alamofire as Network framework. You could also use something else like: 
https://developer.apple.com/reference/foundation/urlsession. 

### Code


```

import UIKit
import Alamofire

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
            
            switch response.result {
            case .success:
                
                if let responseValue = response.value as? NSDictionary{

                    if let errorCode = responseValue.object(forKey:"code") as? NSNumber{
                        /* You can handle all the other errors here as well.*/ 
                        if(errorCode == 2){
                            completionHandler("NonValidNumber")
                        }
                    }else{
                        let responseValue = response.value! as? NSDictionary
                        let returnedValidationID = responseValue?.object(forKey: "id")! as! String
                        
                        /* Checkmobi was able to call a phonenumber. 
                           You now need to save the returned validation id..
                           We will need it together with the last 4 Digits of 
                           the calling number later. 
                        */ 
                        
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
                        /*  The 4 Digits provided by the users were correct. The validation worked. */ 
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
## Missed Call Settings

At the checkmobile clipboard you can also change the ring time and the pin length of your validation process. 
https://cloud.githubusercontent.com/assets/15252364/25580040/995f92f8-2e7d-11e7-96e5-fb11a53ed2f5.png

## Frameworks used

Alamofire -> https://github.com/Alamofire/Alamofire

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

With the help of Silviu (Customer Service Checkmobi). 
