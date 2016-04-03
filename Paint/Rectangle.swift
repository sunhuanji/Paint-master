//
//  Rectangle.swift
//  Paint
//
//  Created by Sun Huanji on 16/3/6.
//  Copyright © 2016年 Sun Huanji. All rights reserved.
//
import UIKit

class Rectangle: Tools {
    
    override func drawInContext(context: CGContextRef) {
        CGContextAddRect(context, CGRect(origin: CGPoint(x: min(beginPoint.x, endPoint.x), y: min(beginPoint.y, endPoint.y)),
            size: CGSize(width: abs(endPoint.x - beginPoint.x), height: abs(endPoint.y - beginPoint.y))))
    }
}

