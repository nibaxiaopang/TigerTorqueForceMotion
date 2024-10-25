//
//  CylinderVC.swift
//  Tiger Torque ForceMotion
//
//  Created by Tiger Torque ForceMotion on 23/10/24.
//

import UIKit

class TigerTorqueCylinderVC: UIViewController {

    @IBOutlet weak var txtOilFlowInInchesCubicPerMinute: UITextField!
    @IBOutlet weak var txtPistonAreaInInchesSquare: UITextField!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var viewResult: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        self.viewResult.isHidden = true
    }
    
    @IBAction func TapOnCalculate(_ sender: Any) {
        self.viewResult.isHidden = false
        
        calculateCylinderTravelSpeed()
    }
    
    @IBAction func TapOnClear(_ sender: Any) {
        self.viewResult.isHidden = true
        
        txtOilFlowInInchesCubicPerMinute.text = ""
        txtPistonAreaInInchesSquare.text = ""
        lblResult.text = ""
    }
    
    @IBAction func TapOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func calculateCylinderTravelSpeed() {
        guard let oilFlowText = txtOilFlowInInchesCubicPerMinute.text,
              let pistonAreaText = txtPistonAreaInInchesSquare.text,
              let oilFlow = Double(oilFlowText),
              let pistonArea = Double(pistonAreaText) else {
            lblResult.text = "Invalid input"
            return
        }
        
        if pistonArea == 0 {
            lblResult.text = "Piston area cannot be zero"
            return
        }
        
        let travelSpeed = oilFlow / pistonArea
        
        lblResult.text = String(format: "Cylinder Travel Speed: %.2f inches/min", travelSpeed)
    }
}
