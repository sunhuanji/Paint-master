//
//  Eraser.swift
//  Paint
//
//  Created by Sun Huanji on 16/3/6.
//  Copyright © 2016年 Sun Huanji. All rights reserved.
//
import UIKit

class Eraser: Brush {
    
    override func drawInContext(context:CGContextRef) {
        CGContextSetBlendMode(context, CGBlendMode.Clear)
        
        super.drawInContext(context)
    }
}

