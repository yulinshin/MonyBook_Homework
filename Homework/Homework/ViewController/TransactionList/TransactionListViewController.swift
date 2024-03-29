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
        setupNavBar()
        updateData()
    }

    private func initView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refreshTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        navigationItem.backButtonTitle = "Back to list"
    }

    @objc func refreshTapped() {
        updateData()
    }

    @objc func addTapped() {

        let insertVC = InsertTransactionViewController()
        self.navigationController?.pushViewController(insertVC, animated: true)

    }

   private func updateData(){
        viewModel.getTransactionListViewObjects().subscribe { result in
            switch result {
            case .success(let object):

                self.viewObject = object
                self.title = "Total: \(object.sum)"
                self.tableView.reloadData()

            case .failure:
                self.viewObject =  self.viewModel.getTransactionListViewObjectsFromLocal()
                if let object = self.viewObject {
                    self.title = "Total: \(object.sum)"
                } else {
                    self.title = "Total: -"
                }

                self.tableView.reloadData()
            }
        }.disposed(by: viewModel.disposeBag)
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
            sectionView.handelDeleteButton = { [weak self] in
                self?.viewObject?.sections.remove(at: section)
                self?.tableView.deleteSections([section], with: .fade)
                self?.viewModel.deleteTransaction(id: viewObject.sections[section].id)
            }
            return sectionView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let detailVC = TransactionDetailViewController(viewModel: TransactionDetailViewModel(transactionId: viewObject!.sections[indexPath.section].id ))
        self.navigationController?.pushViewController(detailVC, animated: true)

    }
}

