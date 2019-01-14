//
//  SearchUserModel.swift
//  MVP
//
//  Created by 佐藤賢 on 2019/01/14.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import GitHub

protocol SearchUserModelInput {
    func fetchUser(query: String, completion: @escaping (Result<[User]>) -> ())
}

final class SearchUserModel: SearchUserModelInput {
    func fetchUser(query: String, completion: @escaping (Result<[User]>) -> ()) {
        let session = GitHub.Session()
        let request = SearchUsersRequest(query: query, sort: nil, order: nil, page: nil, perPage: nil)

        session.send(request) { result in
            switch result {
            case .success(let response):
                completion(.success(response.0.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
