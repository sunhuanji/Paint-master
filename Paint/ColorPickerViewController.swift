//
//  ColorPickerViewController.swift
//  Paint
//
//  Created by Sun Huanji on 16/3/10.
//  Copyright © 2016年 Sun Huanji. All rights reserved.
//

import UIKit
protocol ColorPickerViewControllerDelegate: class {
    func colorPickerViewControllerFinished(colorPickerViewController: ColorPickerViewController)
}

class ColorPickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var sliderBrush: UISlider!
    @IBOutlet weak var sliderOpacity: UISlider!
    
    @IBOutlet weak var imageViewBrush: UIImageView!
    @IBOutlet weak var imageViewOpacity: UIImageView!
    
    @IBOutlet weak var labelBrush: UILabel!
    @IBOutlet weak var labelOpacity: UILabel!
    
    var width: CGFloat = 1.0
    var opacity: CGFloat = 1.0
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    weak var delegate: ColorPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sliderWidthChanged(sender: UISlider) {
        width = CGFloat(sender.value)
        drawPreview()
    }
    
    func drawPreview() {
        UIGraphicsBeginImageContextWithOptions(imageViewBrush.frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, width)
       
        
        CGContextSetRGBStrokeColor(context, red , green, blue, 1.0)
        
        CGContextMoveToPoint(context, 45.0, 45.0)
        CGContextAddLineToPoint(context, 45.0, 45.0)
        CGContextStrokePath(context)
        imageViewBrush.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
  
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        sliderBrush.value = Float(width)
    
        imageViewBrush.image = UIGraphicsGetImageFromCurrentImageContext()
        
        drawPreview()
    }
    

    
    // Global variables
    var tag: Int = 0
    var color: UIColor = UIColor.grayColor()
   // var delegate: ViewController? = nil
    
   @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.colorPickerViewControllerFinished(self)
    }  
    
    func changeRGBToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    internal func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 16
    }
    
    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        cell.tag = tag++
        
        return cell
    }
    
    internal func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var colorPalette: Array<String>
        let path = NSBundle.mainBundle().pathForResource("colorList", ofType: "plist")
        let pListArray = NSArray(contentsOfFile: path!)
        
        if let colorPalettePlistFile = pListArray {
            colorPalette = colorPalettePlistFile as! [String]
            
            let cell: UICollectionViewCell  = collectionView.cellForItemAtIndexPath(indexPath)! as UICollectionViewCell
            let hexString = colorPalette[cell.tag]
            color = changeRGBToUIColor(hexString)
            drawPreview()
        }
    }
}