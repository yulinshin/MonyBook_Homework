//
//  TransactionListViewController.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import UIKit
import SnapKit

class TransactionListViewController: UIViewController {

    private var viewObject: TransactionListViewObject?
    private let viewModel: TransactionListViewModel

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionListDetailTableViewCell.self, forCellReuseIdentifier: TransactionListDetailTableViewCell.identifier)
        return tableView
    }()

    public init(viewModel: TransactionListViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        viewModel.getTransactionListViewObjects().subscribe { result in
            switch result {
            case .success(let object):

                self.viewObject = object
                self.tableView.reloadData()

            case .failure(let error):
                print(error)
            }
        }.disposed(by: viewModel.disposeBag)
    }

    private func initView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

extension TransactionListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        let sectionCount = self.viewObject?.sections.count ?? 0
        return sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellCount = self.viewObject?.sections[section].cells.count ?? 0
        print(cellCount)
        return cellCount
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionListDetailTableViewCell.identifier, for: indexPath) as? TransactionListDetailTableViewCell else { return UITableViewCell() }
        guard let viewObject = viewObject else { return UITableViewCell()}
        cell.updateView(viewObject.sections[indexPath.section].cells[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let viewObject = viewObject {
            let sectionView = TransactionListSectionView(frame: tableView.rectForHeader(inSection: section), transactionListItemViewObject:  viewObject.sections[section])
            return sectionView
        }
        return nil
    }
    
}

