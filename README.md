# Missed Call Verification 

This simple but powerful verification is made by intercepting a missed call from a random number allowing you to verify a user with a seamless user experience that removes the pin-entry on Android and reduces signup friction. Using Checkmobi SDKs you can integrate Missed Call verification with just a few lines on code.

## Getting Started


### Prerequisites

There is no need to include the checkMobi Swift Framework since the missed call is handled by HTTP requests.

### Code


```
// Performing the Call 

 let baseURLForValidation = "https://api.checkmobi.com/v1/validation/request"

 let validationParameters: Parameters = [
            "number": phoneNumber,
            "type": "reverse_cli",
            "platform": "ios"
        ]
        
 let headers: HTTPHeaders = [
            "Authorization": "YOUR_API_KEY"
        ]
  
  Alamofire.request(baseURLForValidation, method: .post, parameters: validationParameters, encoding: JSONEncoding.default,headers:headers).responseJSON { (response) in
            
            switch response.result {
            case .success:
    
                if let responseValue = response.value as? NSDictionary{
                    
                    if let errorCode = responseValue.object(forKey:"code") as? NSNumber{
                        
                        if(errorCode == 2){
                            print("Wrong Number!")
                            completionHandler("NonValidNumber")
                        }
                    }else{
                        let res = response.value! as? NSDictionary
                        let id = res?.object(forKey: "id")! as! String
                        
                        print("The response when making the missed call \(res)")
                        
                        completionHandler(id)
                    }
                }
            case .failure(let error):
                completionHandler("Error!")
            }
        }
        
    // Validating the last 4 Digits 
    
            let BASE_PIN_VALIDATION_URL = "https://api.checkmobi.com/v1/validation/verify"
        
        let headers: HTTPHeaders = [
            "Authorization": "7C90A4CB-B18B-40E2-A55F-0859250B9F2F"
        ]
        
        let parameters: Parameters = [
            "id": validationId,
            "pin": pin,
            "use_server_hangup": true
        ]
        
        Alamofire.request(BASE_PIN_VALIDATION_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers:headers).responseJSON { (response) in
            switch response.result {
            case .success:
                
                if let responseValue = response.value as? NSDictionary{
                    if let errorCode = responseValue.object(forKey:"code") as? NSNumber{
                        print("Error!")
                        print("Error Code!")
                        completionHandler(false)
                    }else{
                        let res = response.value! as? NSDictionary
                        let id = res?.object(forKey: "id")! as! String
                        print("The Correct Id from the Response \(id)")
                        completionHandler(true)
                    }
                }
                
            case .failure(let error):
                print(error)
                completionHandler(false)
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
