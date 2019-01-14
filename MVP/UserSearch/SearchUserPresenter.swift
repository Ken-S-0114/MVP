//
//  SearchUserPresenter.swift
//  MVP
//
//  Created by 佐藤賢 on 2019/01/14.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import GitHub

protocol SearchUserPresenterInput {
    var numberOfUsers: Int { get }
    func user(forRow row: Int) -> User?
    func didSelectRow(at index: IndexPath)
    func didTapSearchButton(text: String?)
}

// View に描画指示を出す
protocol SearchUserPresenterOutput: AnyObject {
    func updateUser(_ user: [User])
    func transitionToUserDetail(userName: String)
}

final class SearchUserPresenter: SearchUserPresenterInput {

    private(set) var users: [User] = []

    private weak var view: SearchUserPresenterOutput!
    private var model: SearchUserModelInput!

    init(view: SearchUserPresenterOutput, model: SearchUserModelInput) {
        self.view = view
        self.model = model
    }

    var numberOfUsers: Int {
        return users.count
    }

    func user(forRow row: Int) -> User? {
        guard row < users.count else { return nil }
        return users[row]
    }

    func didSelectRow(at index: IndexPath) {
        guard let user = user(forRow: index.row) else { return }
        view.transitionToUserDetail(userName: user.login)
    }

    func didTapSearchButton(text: String?) {
        guard let query = text else { return }
        guard !query.isEmpty else { return }

        model.fetchUser(query: query) { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                DispatchQueue.main.async {
                    self?.view.updateUser(users)
                }
            case .failure(let error):
                // TODO: Error Handling
                debugPrint(error)
            }
        }
    }
}
