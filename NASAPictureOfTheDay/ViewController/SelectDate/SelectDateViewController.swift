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
  case navigateToFavoriteListing
}

final class SelectDateViewController: UIViewController {
  @IBOutlet weak var dateTextField: UITextField!
  @IBOutlet weak var manageFavoriteListingLink: UILabel!
  @IBOutlet weak var dateTextLabel: UILabel!
  
  var delegate: SelectDateDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.dateTextField.datePicker(target: self, doneAction: #selector(doneAction), cancelAction: #selector(cancelAction))
    self.dateTextField.becomeFirstResponder()
    setupView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
  }
  
  private func setupView() {
    manageFavoriteListingLink.textColor = .blue
    manageFavoriteListingLink.text = "Manage favorite listing"
    manageFavoriteListingLink.isUserInteractionEnabled = true
    dateTextLabel.text = "Select date"
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    manageFavoriteListingLink.addGestureRecognizer(tap)
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
  
  @objc func handleTap(_ sender: UITapGestureRecognizer) {
    delegate?.didAction(.navigateToFavoriteListing)
  }
  
}
