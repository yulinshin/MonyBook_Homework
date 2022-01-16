//
//  InsertTransactionViewController.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/7.
//

import UIKit
import SnapKit

class InsertTransactionViewController: UIViewController {

    // MARK: - Private
    private let viewModel: InsertTransactionViewModel

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InsertTransactionViewTableViewCell.self, forCellReuseIdentifier: InsertTransactionViewTableViewCell.identifier)
        tableView.register(TransactionListDetailTableViewCell.self, forCellReuseIdentifier: TransactionListDetailTableViewCell.identifier)
        tableView.register(InsertTransitionViewTableViewButtonCell.self, forCellReuseIdentifier: InsertTransitionViewTableViewButtonCell.identifier)

        return tableView
    }()

    // MARK: - Constructor
    init() {
        self.viewModel = InsertTransactionViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNav()
    }

    func setupTableView() {
        self.view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        viewModel.details.subscribe { event in
            self.tableView.reloadSections([3], with: .none)
        }.disposed(by: viewModel.disposeBag)

    }

    func setupNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
       navigationItem.title = "InsertTransaction"

    }

    @objc func saveTapped() {
        viewModel.saveTransaction()
        self.navigationController?.popViewController(animated: true)
    }

}

extension InsertTransactionViewController: UITableViewDelegate, UITableViewDataSource {

        func numberOfSections(in tableView: UITableView) -> Int {
            let sectionCount = self.viewModel.sections.count
            return sectionCount
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            switch viewModel.sections[section] {

            case .time:
                return 1
            case .title:
                return 1
            case .transactionDescription:
                return 1
            case .details:
                var cellCount = 0
                viewModel.details.subscribe { event in
                    cellCount += event.element?.count ?? 0
                }.disposed(by: viewModel.disposeBag)
                return cellCount
            case .addDetails:
                return 1
            }

        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 44
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let title = viewModel.sections[indexPath.section].title
            switch viewModel.sections[indexPath.section]{

            case .time:

                guard let cell = tableView.dequeueReusableCell(withIdentifier: InsertTransactionViewTableViewCell.identifier, for: indexPath) as? InsertTransactionViewTableViewCell else { return UITableViewCell() }
                cell.callback = { time in
                    self.viewModel.timeRelay.accept(time)
                }
                cell.configure(title: title )
                cell.createDatePicker()
                return cell

            case .title:

                guard let cell = tableView.dequeueReusableCell(withIdentifier: InsertTransactionViewTableViewCell.identifier, for: indexPath) as? InsertTransactionViewTableViewCell else { return UITableViewCell() }
                cell.callback = { title in
                    self.viewModel.titleRelay.accept(title)
                }
                cell.configure(title: title )
                return cell


            case .transactionDescription:

                guard let cell = tableView.dequeueReusableCell(withIdentifier: InsertTransactionViewTableViewCell.identifier, for: indexPath) as? InsertTransactionViewTableViewCell else { return UITableViewCell() }
                cell.callback = { transactionDescription in
                    self.viewModel.descriptionRelay.accept(transactionDescription)
                }
                cell.configure(title: title )
                return cell

            case .details:

                guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionListDetailTableViewCell.identifier, for: indexPath) as? TransactionListDetailTableViewCell else { return UITableViewCell() }

                viewModel.details.subscribe {
                    cell.updateView($0.element?[indexPath.row])
                }.disposed(by: viewModel.disposeBag)

                return cell

            case .addDetails:

                guard let cell = tableView.dequeueReusableCell(withIdentifier: InsertTransitionViewTableViewButtonCell.identifier, for: indexPath) as? InsertTransitionViewTableViewButtonCell else { return UITableViewCell() }

                return cell
            }

        }

        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 44
        }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch viewModel.sections[indexPath.section] {

        case .time, .title, .transactionDescription:
            return
        case .details:
            print("didTapDetail")
        case .addDetails:
            showAlertForAddDetail()
        }

    }



    func showAlertForAddDetail() {
        let ac = UIAlertController(title: "Add Transaction Detail", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addTextField()
        ac.addTextField()

        ac.textFields![0].placeholder = "Name"
        ac.textFields![1].placeholder = "Price"
        ac.textFields![1].keyboardType = .numberPad
        ac.textFields![2].placeholder = "quantity"
        ac.textFields![2].keyboardType = .numberPad

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            guard let name = ac.textFields![0].text,
                  let price = ac.textFields![1].text,
                  let quantity = ac.textFields![2].text else {
                      return
                  }
            self.viewModel.addTransactionDetail(name: name, quantity: Int(price) ?? 0, price: Int(quantity) ?? 0)

        }

        ac.addAction(submitAction)

        present(ac, animated: true)
    }

}

