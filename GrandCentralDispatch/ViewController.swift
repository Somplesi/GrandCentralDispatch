//
//  ViewController.swift
//  GrandCentralDispatch
//
//  Created by Rodolphe DUPUY on 17/08/2020.
//  Copyright © 2020 Rod Data. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var _value: Int = 0
    private var _dispatchQueue: DispatchQueue = DispatchQueue(label: "net.roddata.www", qos: .default)
    
    @IBOutlet weak var ui_counter: UILabel!
    @IBOutlet weak var ui_switchPerf: UISwitch!
    @IBOutlet weak var ui_typeOfDispatch: UISegmentedControl!
    @IBOutlet weak var ui_progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ui_switchPerf.isOn = false
        ui_typeOfDispatch.isEnabled = false
        ui_progressView.progress = 0.0
        
        updateDisplay()
    }
    
    @IBAction func stepValueChanged(_ sender: UIStepper) {
        _value = Int(sender.value)
        if ui_switchPerf.isOn {
            if ui_typeOfDispatch.selectedSegmentIndex == 0 {
                // Dispatch Global to secondary Threads
                print("Global Dispatch")
                DispatchQueue.global(qos: .default).async {
                    self.doImportantWork()
                }
            } else {
                // Dispatch Specific to secondary Threads
                print("Specific Dispatch")
                _dispatchQueue.async {
                    self.doImportantWork()
                }
            }
        } else {
            doImportantWork()
        }
        updateDisplay()
    }
    
    @IBAction func activDispatch(_ sender: UISwitch) {
        if sender.isOn {
            ui_typeOfDispatch.isEnabled = true
        } else {
            ui_typeOfDispatch.isEnabled = false
        }
    }
    
    private func updateDisplay() {
        ui_counter.text = "\(_value)"
    }
    
    private func doImportantWork() {
        var progress: Float = 0
        let maxValue = 1000 * _value + 1
        for i in 0...maxValue {
            print("Traitement \(i) ...")
            // Back to the Main Tread
            progress = Float(i) / Float(maxValue)
            if Thread.isMainThread {
                ui_progressView.progress = progress
            } else {
                DispatchQueue.main.sync {
                    ui_progressView.progress = progress
                }
            }
        }
    }
    
}

