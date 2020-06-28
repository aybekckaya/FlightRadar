//
//  Network.swift
//  FlightRadar
//
//  Created by aybek can kaya on 30.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON

// MARK: Network Route - Protocol
protocol NetworkRoute {
    var url:String { get }
    var method:RequestMethod { get }
}

// MARK: Request Method - Enum
enum RequestMethod {
    case get
   
    var stringify:String {
        switch self {
            case .get: return "GET"
        }
    }
}


// MARK: Network Error - Enum
enum NetworkError {
    case urlCannotBeFormed
    case responseCodeIsNotSatisfied
    case mimeTypeIsNotSatisfied
    case responseDataIsNil
    case responseDataCannotBeConvertedToJSON
    case urlRequestCannotBeFormed
    case downloadedURLIsNull
    case builtInError(error:NSError)
    
    var error:NSError {
        switch self {
        case .urlCannotBeFormed:
            return NSError(domain: "Network-Error", code: 10000, userInfo: ["desc" : "URL Cannot Be Formed"])
        case .responseCodeIsNotSatisfied:
            return NSError(domain: "Network-Error", code: 10001, userInfo: ["desc" : "Response Code is not satisfied"])
        case .mimeTypeIsNotSatisfied:
            return NSError(domain: "Network-Error", code: 10002, userInfo: ["desc" : "Mime type not satisfied"])
        case .responseDataIsNil:
            return NSError(domain: "Network-Error", code: 10003, userInfo: ["desc" : "Response Data is Null"])
        case .responseDataCannotBeConvertedToJSON:
            return NSError(domain: "Network-Error", code: 10004, userInfo: ["desc" : "Response data cannot be converted to json"])
        case .downloadedURLIsNull:
            return NSError(domain: "Network-Error", code: 10005, userInfo: ["desc" : "Downloaded URL is NULL"])
        case .urlRequestCannotBeFormed:
            return NSError(domain: "Network-Error", code: 10005, userInfo: ["desc" : "URL request cannot be formed"])
        case .builtInError(let error):
            return NSError(domain: "Network-Error", code: 10006, userInfo: ["desc" : error.localizedDescription])
        }
    }
}


// MARK: Network Request - Struct
struct NetworkRequest {
    let route:NetworkRoute
    let parameters:[String:Any]?
    
    init(route:NetworkRoute , parameters:[String:Any]?) {
        self.route = route
        self.parameters = parameters
    }
}


// MARK: Network Response - Struct
struct NetworkResponse {
    let result:JSON
    let error:NSError?
    
    init(result:JSON , error:NSError?) {
        self.result = result
        self.error = error
    }
}


//MARK: Network {Class}
class Network {
       fileprivate var session:URLSession = URLSession.shared
       fileprivate var dataTask:URLSessionDataTask?
       fileprivate var request:NetworkRequest!
       
       fileprivate init() {
           
       }
}

//MARK: Request
extension Network {
    static func request(request:NetworkRequest)->Observable<NetworkResponse> {
        let nw = Network()
        nw.request = request
        guard let req = nw.urlRequest() else {
            let res = NetworkResponse(result: JSON.null, error: NetworkError.urlRequestCannotBeFormed.error)
            return Observable.of(res)
        }
        
    
        return Observable.create { observer -> Disposable in
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
               
                nw.dataTask = nw.session.dataTask(with: req, completionHandler: { (data, response, error) in
                    
                    if let error = error {
                        Network.resolveObservableWithError(error: error, obs: observer)
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                        Network.resolveObservableWithError(error: NetworkError.responseCodeIsNotSatisfied.error, obs: observer)
                        return
                    }
                    
                    guard let response = response , let mime = response.mimeType, mime == "application/json" else {
                        Network.resolveObservableWithError(error: NetworkError.mimeTypeIsNotSatisfied.error, obs: observer)
                        return
                    }
                    
                    guard let data = data else {
                        Network.resolveObservableWithError(error: NetworkError.responseDataIsNil.error, obs: observer)
                        return
                    }
                    
                    do {
                        let json = try JSON(data: data)
                        DispatchQueue.main.async { observer.onNext(NetworkResponse(result: json, error: nil)) }
                    } catch let err {
                        Network.resolveObservableWithError(error: err, obs: observer)
                    }
                })
               nw.dataTask?.resume()
            }
            return Disposables.create()
        }
    }
    
    private static func resolveObservableWithError(error:Error , obs:AnyObserver<NetworkResponse>) {
        DispatchQueue.main.async {
            let res = NetworkResponse(result: JSON.null, error: error as? NSError)
            obs.onNext(res)
        }
    }
}

// MARK: Request Private methods
extension Network {
    fileprivate func urlRequest()->URLRequest? {
        switch self.request.route.method {
        case .get:
            return self.getRequest()
        }
    }
    
    private func getRequest()->URLRequest? {
        guard let reqMain:URLRequest = self.requestMain() else { return nil }
        return reqMain
    }
    
    private func requestMain()->URLRequest? {
        guard let url = URL(string: self.request.route.url) else { return nil }
        var req = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10)
        req.httpMethod = self.request.route.method.stringify
        return req
    }
}
