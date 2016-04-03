//
//  ViewController.swift
//  Paint
//
//  Created by Sun Huanji on 16/3/6.
//  Copyright © 2016年 Sun Huanji. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var tools = [Brush(),  StraightLine(), DushLine(),Rectangle(), Eraser(),Circle()]
    var colors = [UIColor.blackColor(),UIColor.redColor(),UIColor.yellowColor(),UIColor.blueColor()]
    @IBOutlet var undoButton: UIButton!
    @IBOutlet var redoButton: UIButton!
    @IBOutlet var settingButton: UIButton!
    @IBOutlet var brushButton: UIButton!
    @IBOutlet var eraserButton: UIButton!
    @IBOutlet var rulerButton: UIButton!
    @IBOutlet var dividerButton: UIButton!
    @IBOutlet var settingWidthSlider:UISlider!
    @IBOutlet var board: Board!
    var backgroundImageChangedBlock: ((backgroundImage: UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.board.brush = tools[0]
        setupBackgroundSettingsView()
        selectButton()
        /* let image = self.board.realImage      // image zoom in and zoom out
        imageView = UIImageView(image: image)
        scrollView.addSubview(imageView)
        scrollView.contentSize = image!.size
        let doubleTap = UITapGestureRecognizer(target: self, action: "doubleTappedScrollView")
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTap)
        */
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*   func doubleTappedScrollView(recognizer: UITapGestureRecognizer) {
    let pointInView = recognizer.locationInView(imageView)
    var newZoomScale = scrollView.zoomScale * 1.5
    newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
    let scrollViewSize = scrollView.bounds.size
    let w = scrollViewSize.width / newZoomScale
    let h = scrollViewSize.height / newZoomScale
    let x = pointInView.x - (w / 2.0)
    let y = pointInView.y - (h / 2.0)
    let rectToZoomTo = CGRectMake(x, y, w, h);
    scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return imageView
    }   */
    
    @IBAction func share(sender: AnyObject) {
        UIGraphicsBeginImageContext(self.board.bounds.size)
        self.board.image?.drawInRect(CGRect(x: 0, y: 0,
            width: self.board.frame.size.width, height:self.board.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        presentViewController(activity, animated: true, completion: nil)
    }
    
    @IBAction func settingWidth(sender: UISlider) {
        
            self.board.strokeWidth = CGFloat(sender.value)
        
    }
    var isSelected = 1
    
    @IBAction func BrushButtonPressed(sender: AnyObject){
        self.board.brush = self.tools[0]
        isSelected = 1
        selectButton()

    }
    @IBAction func EraserButtonPressed(){
        self.board.brush = self.tools[4]
        isSelected = 2
        selectButton()
    }
    
    @IBAction func StraightButtonPressed(){
        self.board.brush = self.tools[1]
        isSelected = 3
        selectButton()
    }
    
    
    @IBAction func CircleButtonPressed(){
        self.board.brush = self.tools[5]
        isSelected = 4
        selectButton()
    }
    
    func selectButton()
    {
      if isSelected==1
      {
        brushButton.setBackgroundImage(UIImage(named: "brush_1"), forState: UIControlState.Normal)
        eraserButton.setBackgroundImage(UIImage(named: "eraser_0"), forState: UIControlState.Normal)
        rulerButton.setBackgroundImage(UIImage(named: "ruler_0"), forState: UIControlState.Normal)
        dividerButton.setBackgroundImage(UIImage(named: "yuangui_0"), forState: UIControlState.Normal)
      }
      else if isSelected==2
      {
        brushButton.setBackgroundImage(UIImage(named: "brush_0"), forState: UIControlState.Normal)
        eraserButton.setBackgroundImage(UIImage(named: "eraser_1"), forState: UIControlState.Normal)
        rulerButton.setBackgroundImage(UIImage(named: "ruler_0"), forState: UIControlState.Normal)
        dividerButton.setBackgroundImage(UIImage(named: "yuangui_0"), forState: UIControlState.Normal)      }
      else if isSelected==3
      {
        brushButton.setBackgroundImage(UIImage(named: "brush_0"), forState: UIControlState.Normal)
        eraserButton.setBackgroundImage(UIImage(named: "eraser_0"), forState: UIControlState.Normal)
        rulerButton.setBackgroundImage(UIImage(named: "ruler_1"), forState: UIControlState.Normal)
        dividerButton.setBackgroundImage(UIImage(named: "yuangui_0"), forState: UIControlState.Normal)
      }
      else
      {
        brushButton.setBackgroundImage(UIImage(named: "brush_0"), forState: UIControlState.Normal)
        eraserButton.setBackgroundImage(UIImage(named: "eraser_0"), forState: UIControlState.Normal)
        rulerButton.setBackgroundImage(UIImage(named: "ruler_0"), forState: UIControlState.Normal)
        dividerButton.setBackgroundImage(UIImage(named: "yuangui_1"), forState: UIControlState.Normal)
      }
    }

    @IBAction func DushButtonPressed(){
        self.board.brush = self.tools[2]
    }
    @IBAction func RectangleButtonPressed(){
        self.board.brush = self.tools[3]
    }
    
    @IBAction func undo(sender: UIButton) {
        self.board.undo()
    }
    
    @IBAction func redo(sneder: UIButton) {
        self.board.redo()
    }
    @IBAction func clearBoard(sneder: UIButton) {
        self.board.clearBoard()
    }
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        
        let alertController = UIAlertController(title: "Attention",
            message: "Save successfully", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func saveToAlbum() {
        
            UIImageWriteToSavedPhotosAlbum(self.board.takeImage(), self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    lazy private var pickerController: UIImagePickerController = {
        [unowned self] in
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        return pickerController
        }()
    
    @IBAction func pickImage() {
        let alertController = UIAlertController(title: "Attention",
            message: "Your drawings now will be cleared if you open another picture", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Back", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "Ok", style: .Default,
            handler: {
                action in
                self.presentViewController(self.pickerController, animated: true, completion: nil)
                self.board.clearImage()
                // self.board.undoImages = [UIImage]()
                // self.board.redoImages = [UIImage]()
                self.board.image = UIGraphicsGetImageFromCurrentImageContext()
                
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func createNewBoard() {
        let alertController = UIAlertController(title: "Attention",
            message: "Do you want to create a new board? ", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "No", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "Yes", style: .Default,
            handler: {
                action in
                self.board.backgroundColor=UIColor.whiteColor()
                self.board.clearImage()
               // self.board.undoImages = [UIImage]()
               // self.board.redoImages = [UIImage]()
                self.board.image = UIGraphicsGetImageFromCurrentImageContext()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if let backgroundImageChangedBlock = self.backgroundImageChangedBlock {
            backgroundImageChangedBlock(backgroundImage: image)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }


    func setupBackgroundSettingsView() {
        self.backgroundImageChangedBlock = {
            [unowned self] (backgroundImage: UIImage) in
                   // self.board.layer.backgroundColor = UIColor(patternImage: backgroundImage).CGColor
            
            let mainScreenSize : CGSize = UIScreen.mainScreen().bounds.size // Getting main screen size of iPhone
            
            let imageObbj:UIImage! =   self.imageResize(backgroundImage, sizeChange: CGSizeMake(mainScreenSize.width, mainScreenSize.height))
            
            self.board.backgroundColor = UIColor(patternImage: imageObbj)
            
            UIGraphicsEndImageContext() //show background image

            
        }

    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            let colorPickerViewController = segue.destinationViewController as! ColorPickerViewController
            colorPickerViewController.delegate = self
            colorPickerViewController.color = self.board.strokeColor
            colorPickerViewController.width = self.board.strokeWidth
            colorPickerViewController.red = self.board.red
            colorPickerViewController.green = self.board.green
            colorPickerViewController.blue = self.board.blue
        
    }
    
}

extension ViewController: ColorPickerViewControllerDelegate {
    func colorPickerViewControllerFinished(colorPickerViewController: ColorPickerViewController) {
        self.board.strokeColor = colorPickerViewController.color
         self.board.strokeWidth = colorPickerViewController.width
         self.board.blue = colorPickerViewController.blue
        self.board.red = colorPickerViewController.red
        self.board.green = colorPickerViewController.green
    }
}
