//
//  APIService.swift
//  RxSwift+MVVM_season1&2
//
//  Created by jc.kim on 2/25/21.
//

import Foundation
import RxSwift


let MenuUrl = "https://firebasestorage.googleapis.com/v0/b/rxswiftin4hours.appspot.com/o/fried_menus.json?alt=media&token=42d5cb7e-8ec4-48f9-bf39-3049e796c936"

class APIService {
    static func fetchAllMenus(onComplete: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: URL(string: MenuUrl)!) { data, res, err in
            if let err = err {
                onComplete(.failure(err))
                return
            }
            guard let data = data else {
                let httpResponse = res as! HTTPURLResponse
                onComplete(.failure(NSError(domain: "no data",
                                            code: httpResponse.statusCode,
                                            userInfo: nil)))
                return
            }
            onComplete(.success(data))
        }.resume()
    }
    
    
    static func fetchAllMenusRx() -> Observable<Data> {
        return Observable.create { emitter in
            
            fetchAllMenus { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
