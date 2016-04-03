//
//  SettingsViewController.swift
//  Paint
//
//  Created by Sun Huanji on 16/3/9.
//  Copyright © 2016年 Sun Huanji. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func settingsViewControllerFinished(settingsViewController: SettingsViewController)
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var sliderBrush: UISlider!
    @IBOutlet weak var sliderOpacity: UISlider!
    
    @IBOutlet weak var imageViewBrush: UIImageView!
    @IBOutlet weak var imageViewOpacity: UIImageView!
    
    @IBOutlet weak var labelBrush: UILabel!
    @IBOutlet weak var labelOpacity: UILabel!
    
    var width: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    @IBOutlet var board: Board!
    
    weak var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.settingsViewControllerFinished(self)
    }
    
    
    @IBAction func sliderWidthChanged(sender: UISlider) {
        
        width = CGFloat(sender.value)
        //   labelBrush.text = NSString(format: "%.2f", brush.native) as String
        
        drawPreview()
    }
    
    @IBAction func sliderOpacityChanged(sender: UISlider) {
        
        opacity = CGFloat(sender.value)
        //   labelBrush.text = NSString(format: "%.2f", brush.native) as String
        
        drawPreview()
    }
    
    func drawPreview() {
        UIGraphicsBeginImageContext(imageViewBrush.frame.size)
        var context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, width)
        
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextMoveToPoint(context, 45.0, 45.0)
        CGContextAddLineToPoint(context, 45.0, 45.0)
        CGContextStrokePath(context)
        imageViewBrush.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(imageViewBrush.frame.size)
        context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, 20)
        CGContextMoveToPoint(context, 45.0, 45.0)
        CGContextAddLineToPoint(context, 45.0, 45.0)
        
        CGContextSetRGBStrokeColor(context, red, green, blue, opacity)
        CGContextStrokePath(context)
        imageViewOpacity.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        sliderBrush.value = Float(width)
        //  labelBrush.text = NSString(format: "%.1f", brush.native) as String
        sliderOpacity.value = Float(opacity)
        
        drawPreview()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

