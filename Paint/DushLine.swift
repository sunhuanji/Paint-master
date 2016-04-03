//
//  DottedLine.swift
//  Paint
//
//  Created by Sun Huanji on 16/3/6.
//  Copyright © 2016年 Sun Huanji. All rights reserved.
//
import UIKit

class DushLine: Tools {
    
    override func drawInContext(context: CGContextRef) {
        let lengths: [CGFloat] = [self.strokeWidth * 3, self.strokeWidth * 3]
        CGContextSetLineDash(context, 0, lengths, 2)
        
        CGContextMoveToPoint(context, beginPoint.x, beginPoint.y)
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
    }
}

