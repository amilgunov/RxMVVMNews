//
//  URLRequest+Extensions.swift
//  RxMVVMNews
//
//  Created by Alexander Milgunov on 17.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

struct Resource<T> {
    let url: URL
}

extension URLRequest {
    
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T?> {
        
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        return Observable.just(resource.url)
            .observeOn(scheduler)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.response(request: request)
            }
            .map { response, data in
                if 200..<300 ~= response.statusCode {
                    return try? JSONDecoder().decode(T.self, from: data)
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
            }.asObservable()
    }
}
