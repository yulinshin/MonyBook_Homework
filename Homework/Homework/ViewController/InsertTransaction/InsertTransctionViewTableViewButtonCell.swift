//
//  InsertTransitionViewTableViewButtonCell.swift
//  Homework
//
//  Created by yulin on 2022/1/15.
//

import UIKit

class InsertTransitionViewTableViewButtonCell: UITableViewCell {

    static var identifier = "InsertTransitionViewTableViewButtonCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Add transition detail"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
