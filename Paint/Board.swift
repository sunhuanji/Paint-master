//
//  Board.swift
//  Paint
//
//  Created by Sun Huanji on 16/3/6.
//  Copyright © 2016年 Sun Huanji. All rights reserved.
//

import UIKit

enum DrawingState {
    case Began, Moved, Ended
}


class Board: UIImageView {
    
    
    var drawImage: UIImage?
    
    // Path to draw
    private let path = UIBezierPath()
    
    var shouldClear = false
    
    var brush: Tools?
    var realImage: UIImage?
    private var boardMemoryManager = memoryManager() 
    var strokeWidth: CGFloat
    var strokeColor: UIColor
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    
    
    //var undoImages = [UIImage]()
    //var redoImages = [UIImage]()
    
    override init(frame: CGRect) {
        self.strokeColor = UIColor.blackColor()
        self.strokeWidth = 1
        self.red = 0.0
        self.blue = 0.0
        self.green = 0.0
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.strokeColor = UIColor.blackColor()
        self.strokeWidth = 1
        self.red = 0.0
        self.blue = 0.0
        self.green = 0.0
        super.init(coder: aDecoder)
    }
    
    private var drawingState: DrawingState!
    
    func takeImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        
        self.backgroundColor?.setFill()
        UIRectFill(self.bounds)
        
        self.image?.drawInRect(self.bounds)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }    // MARK: - touches methods
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let brush = self.brush {
            brush.lastPoint = nil
            
            brush.beginPoint = touches.first!.locationInView(self)
            brush.samplePoints.removeAll()
            brush.samplePoints.append(touches.first!.locationInView(self))
            brush.endPoint = brush.beginPoint
            
            self.drawingState = .Began
            
            self.drawingImage()
            
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let brush = self.brush {
            
           //for coalescedTouch in event!.coalescedTouchesForTouch(touches.first!)! {
            //    brush.samplePoints.append(coalescedTouch.locationInView(self))
           //}
            brush.samplePoints.append(touches.first!.locationInView(self))
            //setNeedsDisplay()
            
            brush.endPoint = touches.first!.locationInView(self)
            
            self.drawingState = .Moved
            
            self.drawingImage()
            
        }
    }
    
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = nil
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = touches.first!.locationInView(self)
            brush.samplePoints.append(touches.first!.locationInView(self))
            self.drawingState = .Ended

            self.drawingImage()
            
            
        }
    }
    
    func getMidPointFromA(a: CGPoint, andB b: CGPoint) -> CGPoint {
        return CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2)
    }
 
    var canUndo: Bool {
        get {
            return self.boardMemoryManager.canUndo
        }
    }
    
    var canRedo: Bool {
        get {
            return self.boardMemoryManager.canRedo
        }
    }
    
    // undo 和 redo 的逻辑都有所简化
    func undo() {
        if self.canUndo == false {
            return
        }
        
        self.image = self.boardMemoryManager.imageForUndo()
        
        self.realImage = self.image
    }
    
    func redo() {
        if self.canRedo == false {
            return
        }
        
        self.image = self.boardMemoryManager.imageForRedo()
        
        self.realImage = self.image
    }
    
    func clearBoard(){
        self.realImage = nil
        self.boardMemoryManager.images = [UIImage]()
        self.boardMemoryManager.index = -1   
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func clearImage()
    {
        self.realImage = nil
        self.boardMemoryManager.images = [UIImage]()
        self.boardMemoryManager.index = -1
    }
    // MARK: - drawing
    
    private func drawingImage() {
        if let brush = self.brush {
       
           //UIGraphicsBeginImageContext(self.bounds.size)
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)

            let context = UIGraphicsGetCurrentContext()
            
            UIColor.clearColor().setFill()
            UIRectFill(self.bounds)
            
            CGContextSetLineCap(context, CGLineCap.Round)
            CGContextSetLineWidth(context, self.strokeWidth)
            CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor)

            if let realImage = self.realImage {
                realImage.drawInRect(self.bounds)
            }
            brush.strokeWidth = self.strokeWidth
            
            brush.drawInContext(context!)
            CGContextStrokePath(context)
            
            let previewImage = UIGraphicsGetImageFromCurrentImageContext()
            if self.drawingState == .Ended || brush.supportedContinuousDrawing() {
                self.realImage = previewImage
            }
            
            UIGraphicsEndImageContext()
    
            if self.drawingState == .Ended {
                self.boardMemoryManager.addImage(self.image!)
            }
        
            self.image = previewImage
            
            brush.lastPoint = brush.endPoint
        }
    }
    private class memoryManager {
        class ImageFault: UIImage {}
        
        private static var INVALID_INDEX = -1
        private var images = [UIImage]()    // a image stack to save images
        private var index = INVALID_INDEX
        
        func clearImageStack()
        {
            images = [UIImage]()
            index = -1
        }
        
        var canUndo: Bool {
            get {
                return index != memoryManager.INVALID_INDEX
            }
        }
        
        var canRedo: Bool {
            get {
                return index + 1 < images.count
            }
        }
        
        func addImage(image: UIImage) {
            if index < images.count - 1 {
                images[index + 1 ... images.count - 1] = []
            }
            
            images.append(image)
            
            index = images.count - 1
            
            setCache()
        }
        
        func imageForUndo() -> UIImage? {
            if self.canUndo {
                --index
                if self.canUndo == false {
                    return nil
                } else {
                    setCache()
                    return images[index]
                }
            } else {
                return nil
            }
        }
        
        func imageForRedo() -> UIImage? {
            var image: UIImage? = nil
            if self.canRedo {
                image = images[++index]
            }
            setCache()
            return image
        }
        
        // MARK: - Cache
        
        private static let cahcesLength = 3
        private func setCache() {
            if images.count >= memoryManager.cahcesLength {
                let location = max(0, index - memoryManager.cahcesLength)
                let length = min(images.count - 1, index + memoryManager.cahcesLength)
                for i in location ... length {
                    autoreleasepool {
                        let image = images[i]
                        
                        if i > index - memoryManager.cahcesLength && i < index + memoryManager.cahcesLength {
                            setRealImage(image, index: i)
                        } else {
                            setFaultImage(image, index: i)
                        }
                    }
                }
            }
        }
        
        private static var basePath: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        private func setFaultImage(image: UIImage, index: Int) {
            if !image.isKindOfClass(ImageFault.self) {
                let imagePath = (memoryManager.basePath as NSString).stringByAppendingPathComponent("\(index)")
                UIImagePNGRepresentation(image)!.writeToFile(imagePath, atomically: false)
                images[index] = ImageFault()
            }
        }
        
        private func setRealImage(image: UIImage, index: Int) {
            if image.isKindOfClass(ImageFault.self) {
                let imagePath = (memoryManager.basePath as NSString).stringByAppendingPathComponent("\(index)")
                images[index] = UIImage(data: NSData(contentsOfFile: imagePath)!)!
            }
        }
    }    // Image to cache previous paths
    
}