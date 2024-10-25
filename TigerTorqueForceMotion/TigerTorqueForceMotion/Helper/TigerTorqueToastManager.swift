//
//  ToastManager.swift
//  TigerTorqueForceMotion
//
//  Created by Tiger Torque ForceMotion on 2024/10/25.
//

import UIKit


//MARK: - Toast Manager

public class TigerTorqueToastManager {
    
    public static let shared = TigerTorqueToastManager()
    
    public var style = TigerTorqueToastStyle()
    
    public var isTapToDismissEnabled = true
    
    public var isQueueEnabled = false
    
    public var duration: TimeInterval = 3.0
    
    public var position: TigerTorqueToastPosition = .bottom
    
}
