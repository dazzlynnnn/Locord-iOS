//
//  dateTextField.swift
//  locord
//
//  Created by 이해린 on 2021/02/17.
//

import Foundation
import UIKit

typealias DatePickerTextFieldChanged = ((Date)->Void)
final class DateTextfield: UITextField {
    //날짜 처리
    private let datePicker = UIDatePicker(frame: .zero)
    public var dateChanged : DatePickerTextFieldChanged?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createDatePickerView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.createDatePickerView()
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }
    
    func createDatePickerView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.donePushed))
        toolbar.setItems([spaceButton, doneButton], animated: true)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        self.datePicker.addTarget(self, action: #selector(self.valueChanged), for: .valueChanged)
        self.inputAccessoryView = toolbar
        self.inputView = datePicker
    }
    
    @objc func updateText() {
        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy/MM/dd"
        
        self.text = formatter.string(from: datePicker.date)
    }
    
    @objc func valueChanged(){
        self.updateText()
        self.dateChanged?(self.datePicker.date)
    }
    @objc func donePushed(){
        self.updateText()
        self.endEditing(true)
    }
}
