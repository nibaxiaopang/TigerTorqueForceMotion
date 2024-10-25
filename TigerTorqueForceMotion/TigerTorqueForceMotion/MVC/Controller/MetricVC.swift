//
//  MetricVC.swift
//  TTHorseFind
//
//  Created by mac on 23/10/24.
//

import UIKit

class MetricVC: UIViewController {
    
    @IBOutlet weak var txtPowerInKW: UITextField!
    @IBOutlet weak var txtRPM: UITextField!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var viewResult: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        viewResult.isHidden = true
    }
  
    @IBAction func TapOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func TapOnCalculate(_ sender: Any) {
        viewResult.isHidden = false
        calculateTorqueMetric()
    }
    
    @IBAction func TapOnReset(_ sender: Any) {
        viewResult.isHidden = true
        txtPowerInKW.text = ""
        txtRPM.text = ""
        lblResult.text = ""
    }
    
    private func calculateTorqueMetric() {
        guard let powerText = txtPowerInKW.text,
              let rpmText = txtRPM.text,
              let powerInKW = Double(powerText),
              let rpm = Double(rpmText) else {
            lblResult.text = "Invalid input"
            return
        }

        if rpm == 0 {
            lblResult.text = "RPM cannot be zero"
            return
        }

        let constant = 9549.0

        let torqueInNm = (powerInKW * constant) / rpm

        lblResult.text = String(format: "Torque: %.2f Nm", torqueInNm)
    }
}
