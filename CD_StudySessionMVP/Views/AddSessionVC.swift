//
//  AddSessionVC.swift
//  CD_StudySessionMVP
//
//  Created by Miguel on 26/05/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import UIKit

class AddSessionVC: UIViewController, AddSessionViewInterface, UIPickerViewDataSource, UIPickerViewDelegate {
 
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMins: UILabel!
    @IBOutlet weak var pickerSubject: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var segMins: UISegmentedControl!
    var presenter: AddSessionPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewInterface = self
        setupUI()
    }
    
    func setupUI() {
        pickerSubject.dataSource = self
        pickerSubject.delegate = self
        pickerView(pickerSubject, didSelectRow: 0, inComponent: 1)  // Default value
        
        datePicker.locale = Locale.current
        datePicker.datePickerMode = .dateAndTime
        datePicker.backgroundColor = .white
        onDatePickerValueChanged(datePicker) // Default value
        
        segMins.removeAllSegments()
        for (i,min) in K.arrMinutes.enumerated() {
            segMins.insertSegment(withTitle: "\(min)", at: i, animated: false)
        }
        segMins.selectedSegmentIndex = 0
        onSegMinsValueChanged(segMins)  // Default value
    }

    // MARK: - IBActions
    
    @IBAction func onDatePickerValueChanged(_ sender: UIDatePicker) {
        presenter.beginDate = sender.date
    }
    
    @IBAction func onSegMinsValueChanged(_ sender: UISegmentedControl) {
        presenter.mins = K.arrMinutes[sender.selectedSegmentIndex]
    }
    
    @IBAction func onBtnCancel() {
        dismiss()
    }
    
    @IBAction func onBtnAdd() {
        presenter.add()
    }
    
    
    // MARK: - AddSessionViewInterface
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        K.Subject.allCases.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return K.Subject.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        presenter.subject = K.Subject.allCases[row].rawValue
    }
}
