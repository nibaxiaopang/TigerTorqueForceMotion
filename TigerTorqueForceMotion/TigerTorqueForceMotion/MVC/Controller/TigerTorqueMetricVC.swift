//
//  MetricViewController.swift
//  Tiger Torque ForceMotion
//
//  Created by Tiger Torque ForceMotion on 24/10/24.
//

import UIKit

class TigerTorqueMetricVC: UIViewController {
    
    @IBOutlet weak var txtPressureInBar: UITextField!
    @IBOutlet weak var txtPistonAreaInInchesSquare: UITextField!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var viewResult: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        self.viewResult.isHidden = true
    }
    
    // Action for Calculate button
    @IBAction func TapOnCalculate(_ sender: Any) {
        self.viewResult.isHidden = false
        
        calculateForceOfCylinderMetric()
    }
    
    // Action for Clear button
    @IBAction func TapOnClear(_ sender: Any) {
        self.viewResult.isHidden = true
        txtPressureInBar.text = ""
        txtPistonAreaInInchesSquare.text = ""
        lblResult.text = ""
    }
    
    @IBAction func TapOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func calculateForceOfCylinderMetric() {
        guard let pressureText = txtPressureInBar.text,
              let pistonAreaText = txtPistonAreaInInchesSquare.text,
              let pressureInBar = Double(pressureText),
              let pistonAreaInInchesSquare = Double(pistonAreaText) else {
            lblResult.text = "Invalid input"
            return
        }
        
        if pistonAreaInInchesSquare == 0 {
            lblResult.text = "Piston area cannot be zero"
            return
        }
        
        let squareInchesToSquareCentimeters = 6.4516
        
        let pistonAreaInCmSquare = pistonAreaInInchesSquare * squareInchesToSquareCentimeters
        
        let forceInNewtons = pressureInBar * pistonAreaInCmSquare * 100
        
        lblResult.text = String(format: "Force: %.2f N", forceInNewtons)
    }
}
