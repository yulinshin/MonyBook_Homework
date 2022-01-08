//
//  TransactionDetailViewController.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/7.
//

import UIKit
import SnapKit

class TransactionDetailViewController: UIViewController {

    #warning("DOTO: Transaction Detail ")

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        return label
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        return label
    }()

    private lazy var detailTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        return tableView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {

        let stackView = UIStackView()
        stackView.axis = .horizontal
        view.addSubview(stackView)
        view.addSubview(descriptionLabel)
        view.addSubview(detailTableView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(20)
            make.left.equalTo(view).offset(20)
            make.bottom.equalTo(descriptionLabel).offset(-20)
            make.right.equalTo(view).offset(-20)
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(stackView).offset(20)
            make.left.equalTo(view).offset(20)
            make.bottom.equalTo(detailTableView).offset(-20)
            make.right.equalTo(view).offset(-20)
        }
        detailTableView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel).offset(20)
            make.left.equalTo(view).offset(20)
            make.bottom.equalTo(view).offset(-20)
            make.right.equalTo(view).offset(-20)
        }

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(timeLabel)
    }

}
