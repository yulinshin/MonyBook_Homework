//
//  InsertTransactionViewTableViewCell.swift
//  Homework
//
//  Created by yulin on 2022/1/15.
//

import UIKit

class InsertTransactionViewTableViewCell: UITableViewCell {

    static var identifier = "InsertTransactionViewTableViewCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        return label
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        return textField
    }()

    var callback: ((_ text: String) -> Void)?
    let datePicker = UIDatePicker()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)

        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(8)
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        textField.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(8)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func configure(title: String) {

        titleLabel.text = title
        textField.delegate = self

        self.textField.isHidden = false
        self.textField.placeholder = title

    }


    func createDatePicker () {

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressedFromDate))

        toolbar.autoresizingMask = [.flexibleWidth, .flexibleHeight]

         let leftSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbar.setItems([leftSpace, doneBtn], animated: true)

        textField.inputAccessoryView = toolbar

        textField.inputView = datePicker

        datePicker.datePickerMode = .date

        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }

    }

  @objc func donePressedFromDate() {

      let formatter = DateFormatter()
      formatter.dateStyle = .medium
      formatter.timeStyle = .none
      textField.text = formatter.string(from: datePicker.date)
      textField.resignFirstResponder()

    }
}

extension InsertTransactionViewTableViewCell: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {

        guard let text = textField.text else { return }
        callback?(text)

    }

}
