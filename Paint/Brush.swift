//
//  Brush.swift
//  Paint
//
//  Created by Sun Huanji on 16/3/6.
//  Copyright © 2016年 Sun Huanji. All rights reserved.
//

import UIKit

class Brush: Tools {
    
    override func drawInContext(context: CGContextRef) {
    // 三次元曲線の引き方
  /*  let alpha : CGFloat = 1.0/4.0
            guard !self.samplePoints.isEmpty else { return }
            CGContextMoveToPoint(context,self.samplePoints[0].x, self.samplePoints[0].y)
            
            let n = self.samplePoints.count - 1
            
            for index in 0..<n
            {
                var currentPoint = self.samplePoints[index]
                var nextIndex = (index + 1) % self.samplePoints.count
                var prevIndex = index == 0 ? self.samplePoints.count - 1 : index - 1
                var previousPoint = self.samplePoints[prevIndex]
                var nextPoint = self.samplePoints[nextIndex]
                let endPoint = nextPoint
                var mx : CGFloat
                var my : CGFloat
                
                if index > 0
                {
                    mx = (nextPoint.x - previousPoint.x) / 2.0
                    my = (nextPoint.y - previousPoint.y) / 2.0
                }
                else
                {
                    mx = (nextPoint.x - currentPoint.x) / 2.0
                    my = (nextPoint.y - currentPoint.y) / 2.0
                }
                
                let controlPoint1 = CGPoint(x: currentPoint.x + mx * alpha, y: currentPoint.y + my * alpha)
                currentPoint = self.samplePoints[nextIndex]
                nextIndex = (nextIndex + 1) % self.samplePoints.count
                prevIndex = index
                previousPoint = self.samplePoints[prevIndex]
                nextPoint = self.samplePoints[nextIndex]
                
                if index < n - 1
                {
                    mx = (nextPoint.x - previousPoint.x) / 2.0
                    my = (nextPoint.y - previousPoint.y) / 2.0
                }
                else
                {
                    mx = (currentPoint.x - previousPoint.x) / 2.0
                    my = (currentPoint.y - previousPoint.y) / 2.0
                }
                
                let controlPoint2 = CGPoint(x: currentPoint.x - mx * alpha, y: currentPoint.y - my * alpha)
                
                CGContextAddCurveToPoint(context, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, endPoint.x, endPoint.y)
            }  */
        
  // 二次元曲線の引き方
        
        if self.samplePoints.isEmpty {
            
        }
        else if self.samplePoints.count == 1{
            
        }
        else if self.samplePoints.count == 2{
            var mid: CGPoint
            mid = CGPointMake((beginPoint.x + endPoint.x)/2, (beginPoint.y + endPoint.y)/2)
            CGContextMoveToPoint(context, beginPoint.x, beginPoint.y)
            CGContextAddLineToPoint(context, mid.x, mid.y)
            
        }
        else if self.samplePoints.count >= 3{
            var currentPoint: CGPoint!
            var PrePoint: CGPoint!
            var PrePrePoint: CGPoint!
            var controlPoint1: CGPoint!
            var mid1: CGPoint!
            var mid2: CGPoint!
            var mx : CGFloat
            var my : CGFloat
            let alpha : CGFloat = 1.0/20.0
            
            currentPoint = self.samplePoints[self.samplePoints.count-1]
            PrePoint = self.samplePoints[self.samplePoints.count-2]
            PrePrePoint = self.samplePoints[self.samplePoints.count-3]
            
            mx = (currentPoint.x - PrePrePoint.x) / 2.0
            my = (currentPoint.y - PrePrePoint.y) / 2.0
            
            controlPoint1 = CGPoint(x: PrePoint.x + mx * alpha, y: PrePoint.y + my * alpha)
           // controlPoint2 = CGPoint(x: PrePoint.x - mx * alpha, y: PrePoint.y - my * alpha)
            
            mid1 = CGPointMake((PrePrePoint.x + PrePoint.x)/2, (PrePrePoint.y + PrePoint.y)/2)
            mid2 = CGPointMake((PrePoint.x + currentPoint.x)/2, (PrePoint.y + currentPoint.y)/2)
            CGContextMoveToPoint(context, mid1.x, mid1.y)
            //CGContextAddCurveToPoint(context, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, mid2.x, mid2.y)
            CGContextAddQuadCurveToPoint(context, PrePoint.x, PrePoint.y, mid2.x, mid2.y)
            endPoint = controlPoint1
        }
   
        
    }
    
  override func supportedContinuousDrawing() -> Bool {
        return true
    }
}
