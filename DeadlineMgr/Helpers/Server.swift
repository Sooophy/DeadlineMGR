//
//  Server.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/10/29.
//

import Foundation

class Server {
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
    }

    private static func genRequest(_ url: String, _ method: String, _ headers: [String: String]? = nil, _ body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        request.httpBody = body
        if method == "POST"{
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        if headers != nil {
            for (key, value) in headers! {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }

    private static func performRequest(_ request: URLRequest) async -> (Data?, HTTPURLResponse?, Error?) {
        await withCheckedContinuation {
            continuation in
            let task = URLSession.shared.dataTask(with: request) { data, resp, err in
                if err != nil {
                    continuation.resume(returning: (nil, resp as? HTTPURLResponse, err))
                    return
                }
                assert((resp as! HTTPURLResponse).statusCode == 200)
                print(request.httpMethod!, request.url!, "\nbody:", (request.httpBody != nil) ? String(data: request.httpBody!, encoding: .utf8)! : "nil" as Any, "\nresp:", String(data: data!, encoding: .utf8) as Any)
                continuation.resume(returning: (data, resp as? HTTPURLResponse, err))
            }
            task.resume()
        }
    }

    static func request(_ url: String,
                        _ method: Method,
                        _ headers: [String: String]? = nil,
                        _ body: Data? = nil)
        async -> (Data?, HTTPURLResponse?, Error?)
    {
        let request = Server.genRequest(url, method.rawValue, headers, body)
        return await performRequest(request)
    }
}
