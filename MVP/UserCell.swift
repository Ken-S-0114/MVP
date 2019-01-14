//
//  UserCell.swift
//  MVP
//
//  Created by 佐藤賢 on 2019/01/15.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import UIKit
import GitHub

class UserCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    private var task: URLSessionTask?

    // 非表示となって必要なくなったセルが再利用される場合，prepareForReuse が呼び出される．
    // セルを初期化する事ができる．
    override func prepareForReuse() {
        super.prepareForReuse()

        task?.cancel()
        task = nil
        imageView?.image = nil
    }

    func configure(user: User) {
        task = {
            let url = user.avatarURL
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let imageData = data else { return }

                DispatchQueue.global().async { [weak self] in
                    guard let image = UIImage(data: imageData) else { return }

                    DispatchQueue.main.async {
                        self?.iconImageView.image = image
                        self?.setNeedsLayout()
                    }

                }

            }
            task.resume()
            return task
        }()

        nameLabel.text = user.login
    }
}
