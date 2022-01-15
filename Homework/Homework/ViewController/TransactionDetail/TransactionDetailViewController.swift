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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionListDetailTableViewCell.self, forCellReuseIdentifier: TransactionListDetailTableViewCell.identifier)
        return tableView
    }()

    private var viewObject: TransactionDetailViewObject?
    private let viewModel: TransactionDetailViewModel

    public init(viewModel: TransactionDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        viewModel.getTransactionDetailViewObject().subscribe { result in

            switch result {

            case .success(let object):
                self.viewObject = object
                self.timeLabel.text = object.time
                self.titleLabel.text = object.title
                self.descriptionLabel.text = object.description
                self.detailTableView.reloadData()
                self.navigationItem.title = "\(object.title) Detail"
            case .failure(let error):
                print(error)
            }
        }.disposed(by: viewModel.disposeBag)

    }

    private func initView() {
        self.view.backgroundColor = .white
        let stackView = UIStackView()
        stackView.axis = .horizontal
        view.addSubview(stackView)
        view.addSubview(descriptionLabel)
        view.addSubview(detailTableView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp_topMargin).offset(20)
            make.left.equalTo(view).offset(20)
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-20)
            make.right.equalTo(view).offset(-20)
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.left.equalTo(view).offset(20)
            make.bottom.equalTo(detailTableView.snp.top).offset(-20)
            make.right.equalTo(view).offset(-20)
        }
        detailTableView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.left.equalTo(view).offset(20)
            make.bottom.equalTo(view).offset(-20)
            make.right.equalTo(view).offset(-20)
        }

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(timeLabel)
    }

}

extension TransactionDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellCount = self.viewObject?.cells.count ?? 0
        print(cellCount)
        return cellCount
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionListDetailTableViewCell.identifier, for: indexPath) as? TransactionListDetailTableViewCell else { return UITableViewCell() }
        guard let viewObject = viewObject else { return UITableViewCell()}
        cell.updateView(viewObject.cells[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

}

