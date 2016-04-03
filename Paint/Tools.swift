//
//  Tools.swift
//  Paint
//
//  Created by Sun Huanji on 16/3/6.
//  Copyright © 2016年 Sun Huanji. All rights reserved.
//

import CoreGraphics

protocol PaintBrush {
    
    func supportedContinuousDrawing() -> Bool
    
    func drawInContext(context: CGContextRef)
    
}

class Tools : NSObject, PaintBrush {
    var beginPoint: CGPoint!
    var endPoint: CGPoint!
    var lastPoint: CGPoint?
    var samplePoints = [CGPoint]()
    
    var strokeWidth: CGFloat!
    
    func supportedContinuousDrawing() -> Bool {
        return false
    }
    
    func drawInContext(context: CGContextRef) {
        assert(false, " ")
    }
    
}