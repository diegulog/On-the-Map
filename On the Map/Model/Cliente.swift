//
//  Cliente.swift
//  On the Map
//
//  Created by Diego on 24/09/2020.
//

import Foundation

class Client {
    
    struct Auth {
        static var account: Account?
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        static let signUpURL = "https://auth.udacity.com/sign-up"
        case login
        case signUp
        case studentLocation
        case createLocation
        case getUserData(String)
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "session"
            case .signUp: return Endpoints.signUpURL
            case .studentLocation: return Endpoints.base + "StudentLocation?limit=100&order=-updatedAt"
            case .createLocation: return Endpoints.base + "StudentLocation"
            case .getUserData(let userId): return Endpoints.base + "users/" + userId
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
        
        
    }
    
    class func getUserData(completion: @escaping (UserModel?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getUserData(Auth.account!.key).url,skipCaracters: true, responseType: UserModel.self) { (response, error) in
            if let response = response{
                completion(response, nil)
            }else{
                completion(nil, error)
            }
        }
    }
    
    class func createLocation(studentLocation: StudentLocation, completion: @escaping (Bool, Error?) -> Void){
        
        var urlString: String = Endpoints.createLocation.stringValue
        if let objectId = StudentInformationModel.userLocation?.objectId {
            urlString.append("/\(objectId)")
        }
        
        let body = StudentLocation(createdAt: nil, firstName: studentLocation.firstName, lastName: studentLocation.lastName, latitude: studentLocation.latitude, longitude: studentLocation.longitude, mapString: studentLocation.mapString, mediaURL: studentLocation.mediaURL, objectId: nil, uniqueKey: studentLocation.uniqueKey, updatedAt: nil)
        taskForPOSTRequest(url: URL(string: urlString)!,update: (StudentInformationModel.userLocation?.objectId != nil), skipCaracters: false, responseType: StudentLocationPostResponse.self, body: body) { (response, error) in
            if let response = response {
                if (StudentInformationModel.userLocation == nil ){
                    StudentInformationModel.userLocation = response
                }
                completion(true, nil)
            }else{
                completion(false, error)
            }
        }
    }
    
    
    class func getStudentLocation(completion: @escaping ([StudentLocation], Error?) -> Void) {
        
        taskForGETRequest(url: Endpoints.studentLocation.url , skipCaracters: false, responseType: StudentInformation.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            }else{
                completion([], error)
            }
        }
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(username: username, password: password)
        taskForPOSTRequest(url: Endpoints.login.url,skipCaracters: true, responseType: SessionResponse.self, body: body) { (response, error) in
            if let response = response {
                Auth.account = response.account
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
        
    }
    
    class func logout(completion: @escaping () -> Void){
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            Auth.account = nil
            completion()
        }
        task.resume()
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL,update :Bool = false, skipCaracters: Bool, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
        
        var request = URLRequest(url: url)
        if update {
            request.httpMethod = "PUT"
        } else {
            request.httpMethod = "POST"
            
        }
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response , error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            if skipCaracters {
                let range = Range(NSRange(5..<data.count))
                data = data.subdata(in: range!)
            }
            do{
                
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
    }
    
    @discardableResult
    class func taskForGETRequest<ResponseType: Decodable>(url: URL,skipCaracters: Bool, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            if skipCaracters {
                let range = Range(NSRange(5..<data.count))
                data = data.subdata(in: range!)
            }
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    
}
