//
//  GradiantView.swift
//  TigerTorqueForceMotion
//
//  Created by Tiger Torque ForceMotion on 2024/10/25.
//

import UIKit

@IBDesignable
class GradiantView : UIView
{
    
    @IBInspectable var firstColor : UIColor = UIColor.white{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var secondColor : UIColor = UIColor.white{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var horizontalGradiant : Bool = false{
        didSet{
            updateView()
        }
    }
    
    
    override class var layerClass : AnyClass{
        get{
            return CAGradientLayer.self
        }
    }
    
    
    func updateView(){
        
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor.cgColor,secondColor.cgColor]
        
        if horizontalGradiant{
            layer.startPoint = CGPoint(x: 0.0, y: 0.5)
            layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        else{
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 0, y: 1)
        }
        
    }
}
