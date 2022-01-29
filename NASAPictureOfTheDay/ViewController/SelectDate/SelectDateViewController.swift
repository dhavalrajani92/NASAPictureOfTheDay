//
//  SelectDateViewController.swift
//  NASAPictureOfTheDay
//
//  Created by Dhaval Rajani on 29/01/22.
//

import UIKit

protocol SelectDateDelegate {
  func didAction(_ action: SelectDateActions)
}

enum SelectDateActions {
  case navigateToDetails(date: String)
}

final class SelectDateViewController: UIViewController {
  @IBOutlet weak var dateTextField: UITextField!
  
  var delegate: SelectDateDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.dateTextField.datePicker(target: self, doneAction: #selector(doneAction), cancelAction: #selector(cancelAction))
    self.dateTextField.becomeFirstResponder()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
  }
  
  @objc
  func cancelAction() {
    self.dateTextField.resignFirstResponder()
  }
  
  @objc
  func doneAction() {
    if let datePickerView = self.dateTextField.inputView as? UIDatePicker {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      let dateString = dateFormatter.string(from: datePickerView.date)
      self.dateTextField.text = dateString
      self.dateTextField.resignFirstResponder()
      delegate?.didAction(.navigateToDetails(date: dateString))
    }
  }
  
}
