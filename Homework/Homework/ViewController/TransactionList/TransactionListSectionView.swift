//
//  TransactionListSectionView.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import UIKit

class TransactionListSectionView: UIView {

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .right
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()

    private lazy var deleteButton: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        btn.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return btn
    }()

    @objc func didTapDeleteButton(){
        handelDeleteButton?()
    }

    var handelDeleteButton: (() -> Void)?

    init(frame: CGRect, transactionListItemViewObject:TransactionListSectionViewObject) {
        super.init(frame: frame)

        titleLabel.text = transactionListItemViewObject.title
        timeLabel.text = transactionListItemViewObject.time

        addSubview(titleLabel)
        addSubview(timeLabel)
        addSubview(deleteButton)
        backgroundColor = UIColor.black

        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(8)
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        timeLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(deleteButton.snp.left).offset(-8)
        }

        deleteButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(timeLabel.snp.right).offset(8)
            make.right.equalToSuperview().inset(8)
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
