//
//  ToastStyle.swift
//  TigerTorqueForceMotion
//
//  Created by Tiger Torque ForceMotion on 2024/10/25.
//

import UIKit

//MARK: - Toast Style

public struct TigerTorqueToastStyle {
    
    public init() {}
    
    public var backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.8)
    
    public var titleColor: UIColor = .white
    
    public var messageColor: UIColor = .white
    
    public var maxWidthPercentage: CGFloat = 0.8 {
        didSet {
            maxWidthPercentage = max(min(maxWidthPercentage, 1.0), 0.0)
        }
    }
    
    public var maxHeightPercentage: CGFloat = 0.8 {
        didSet {
            maxHeightPercentage = max(min(maxHeightPercentage, 1.0), 0.0)
        }
    }
    
    public var horizontalPadding: CGFloat = 10.0
    
    public var verticalPadding: CGFloat = 10.0
    
    public var cornerRadius: CGFloat = 10.0;
    
    public var titleFont: UIFont = .boldSystemFont(ofSize: 16.0)
    
    public var messageFont: UIFont = .systemFont(ofSize: 16.0)
    
    public var titleAlignment: NSTextAlignment = .left
    
    public var messageAlignment: NSTextAlignment = .left
    
    public var titleNumberOfLines = 0
    
    public var messageNumberOfLines = 0
    
    public var displayShadow = false
    
    public var shadowColor: UIColor = .black
    
    public var shadowOpacity: Float = 0.8 {
        didSet {
            shadowOpacity = max(min(shadowOpacity, 1.0), 0.0)
        }
    }
    
    public var shadowRadius: CGFloat = 6.0
    
    public var shadowOffset = CGSize(width: 4.0, height: 4.0)
    
    public var imageSize = CGSize(width: 80.0, height: 80.0)
    
    public var activitySize = CGSize(width: 100.0, height: 100.0)
    
    public var fadeDuration: TimeInterval = 0.2
    
    public var activityIndicatorColor: UIColor = .white
    
    public var activityBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.8)
    
}
