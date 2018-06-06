//
//  FGCheckboxButton.swift
//  FGMultiSelectionPickerView
//
//  Created by Filippo Giove on 06/06/2018.
//  Copyright © 2018 Filippo Giove. All rights reserved.
//

import Foundation

//
//  CheckboxButton.swift
//  CheckboxButton
//
//  Created by Joe Amanse on 30/11/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import UIKit

@IBDesignable
public class FGCheckboxButton: UIButton {
    // MARK: Public properties
    
    /// Line width for the check mark. Default value is 2.
    @IBInspectable public var checkLineWidth: CGFloat = 2.0 {
        didSet {
            layoutLayers()
        }
    }
    
    
    /// Color for the internal of the container of the check mark for OFF State.
    @IBInspectable public var containerColorOnOFFState: UIColor = UIColor.clear {
        didSet {
            colorLayers()
        }
    }
    
    /// Color for the border and internal of the container of the check mark for ON State.
    @IBInspectable public var containerColor: UIColor = FGMULTISELECTIONPICKER_CHECKBOX_SELECTED_COLOR {
        didSet {
            colorLayers()
        }
    }
    
    /// Color for the border of the container of the check mark for OFF State.
    @IBInspectable public var containerColorStrokeOff: UIColor = FGMULTISELECTIONPICKER_BORDER_COLOR {
        didSet {
            colorLayers()
        }
    }
    
    
    /// Color for the check mark.
    @IBInspectable public var checkColor: UIColor = FGMULTISELECTIONPICKER_BORDER_COLOR{
        didSet {
            colorLayers()
        }
    }
    
    /// Line width for the bounding container of the check mark.
    /// Default value is 1.
    @IBInspectable public var containerLineWidth: CGFloat = 1.0 {
        didSet {
            layoutLayers()
        }
    }
    
    
    
    /// If set to `true`, the bounding container of the check mark will be a circle rather than a box.
    /// Default value is false
    @IBInspectable public var circular: Bool = true {
        didSet {
            layoutLayers()
        }
    }
    
    /// If set to `true`, the container gets a fill color similar to the `containerColor` property.
    /// Default value is `false`.
    @IBInspectable public var containerFillsOnToggleOn: Bool = true {
        didSet {
            colorLayers()
        }
    }
    
    /// A Boolean value that determines the off/on state of the checkbox. If `true`, the checkbox is checked.
    @IBInspectable public var on: Bool = false {
        didSet {
            colorLayers()
        }
    }
    
    // MARK: Internal and private properties
    
    internal let containerLayer = CAShapeLayer()
    internal let checkLayer = CAShapeLayer()
    
    internal var containerFrame: CGRect {
        let width = bounds.width
        let height = bounds.height
        
        let x: CGFloat
        let y: CGFloat
        
        let sideLength: CGFloat
        if width > height {
            sideLength = height
            x = (width - sideLength) / 2
            y = 0
        } else {
            sideLength = width
            x = 0
            y = (height - sideLength) / 2
        }
        
        let halfLineWidth = containerLineWidth / 2
        return CGRect(x: x + halfLineWidth, y: y + halfLineWidth, width: sideLength - containerLineWidth, height: sideLength - containerLineWidth)
    }
    
    internal var containerPath: UIBezierPath {
        if circular {
            return UIBezierPath(ovalIn: containerFrame)
        } else {
            return UIBezierPath(rect: containerFrame)
        }
    }
    internal var checkPath: UIBezierPath {
        let containerFrame = self.containerFrame
        
        // Add an offset for circular checkbox
        let inset = containerLineWidth / 2
        let innerRect = containerFrame.insetBy(dx: inset, dy: inset)
        
        // Create check path
        let path = UIBezierPath()
        
        let unit = innerRect.width / 33
        let origin = innerRect.origin
        let x = origin.x
        let y = origin.y
        
        path.move(to: CGPoint(x: x + (7 * unit), y: y + (18 * unit)))
        path.addLine(to: CGPoint(x: x + (14 * unit), y: y + (25 * unit)))
        path.addLine(to: CGPoint(x: x + (27 * unit), y: y + (10 * unit)))
        
        return path
    }
    
    static internal let validBoundsOffset: CGFloat = 80
    
    // MARK: Initialization
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        customInitialization()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        customInitialization()
    }
    
    /**
     Initializes a new `CheckboxButton` with a set state.
     
     - Parameters:
     - frame: Frame of the receiver
     - on: On state of the receiver
     */
    convenience init(frame: CGRect, on: Bool) {
        self.init(frame: frame)
        self.on = on
        self.backgroundColor = UIColor.clear
    }
    
    func customInitialization() {
        // Initial colors
        checkLayer.fillColor = UIColor.clear.cgColor
        
        // Color and layout layers
        colorLayers()
        layoutLayers()
        
        // Add layers
        layer.addSublayer(containerLayer)
        layer.addSublayer(checkLayer)
    }
    
    // MARK: Layout
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // Also layout the layers when laying out subviews
        layoutLayers()
    }
    
    // MARK: Layout layers
    private func layoutLayers() {
        // Set frames, line widths and paths for layers
        containerLayer.frame = bounds
        containerLayer.lineWidth = containerLineWidth
        containerLayer.path = containerPath.cgPath
        
        checkLayer.frame = bounds
        checkLayer.lineWidth = checkLineWidth
        checkLayer.path = checkPath.cgPath
    }
    
    // MARK: Color layers
    private func colorLayers() {
        // Set colors based on 'on' property
        if on {
            containerLayer.strokeColor = containerColor.cgColor//UIColor.searchOptionElementsColor().CGColor
            containerLayer.fillColor = containerFillsOnToggleOn ? containerColor.cgColor : UIColor.clear.cgColor
            checkLayer.strokeColor = checkColor.cgColor
        } else {
            //NSLog("qui off")
            containerLayer.strokeColor = containerColorStrokeOff.cgColor//UIColor.searchOptionSubElementsColor().CGColor
            containerLayer.fillColor = containerColorOnOFFState.cgColor
            checkLayer.strokeColor = UIColor.clear.cgColor
        }
    }
    
    // MARK: Touch tracking
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        return true
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        return true
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        guard let touchLocationInView = touch?.location(in: self) else {
            return
        }
        let offset = type(of: self).validBoundsOffset
        
        
        
        let validBounds = CGRect(x: bounds.origin.x - offset, y: bounds.origin.y - offset, width: bounds.width + (2 * offset), height: bounds.height + (2 * offset))
        
        if validBounds.contains(touchLocationInView) {
            on = !on
            sendActions(for: [UIControlEvents.valueChanged])
        }
    }
    
    // MARK: Interface builder
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        customInitialization()
    }
}

