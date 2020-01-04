//
//  FrequencyPicker.swift
//  CleanReminder
//
//  Created by Andrius Shiaulis on 04.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import UIKit

class FrequencyPicker: UIPickerView {

    var selectedFrequency: Frequency {
        let row = self.selectedRow(inComponent: 0)
        return self.frequencies[row]
    }

    var defaultFrequency: Frequency = .monthly

    var selectedBlock: ((Frequency) -> Void)?

    private var frequencies: [Frequency]

    required init?(coder: NSCoder) {
        self.frequencies = Frequency.allCases
        super.init(coder: coder)

        self.dataSource = self
        self.delegate = self
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        select(frequency: self.defaultFrequency, animated: false)
    }

    func select(frequency: Frequency, animated: Bool) {
        let indexToBeSelected = Int(frequency.rawValue)
        self.selectRow(indexToBeSelected, inComponent: 0, animated: animated)
        selectedBlock?(frequency)
    }
}

extension FrequencyPicker: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.frequencies.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.frequencies[row].title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedFrequency = self.frequencies[row]
        self.selectedBlock?(selectedFrequency)
    }

}
