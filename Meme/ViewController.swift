//
//  ViewController.swift
//  Meme
//
//  Created by Martin Kelly on 27/08/2015.
//  Copyright (c) 2015 Scriptable. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        //NSFontAttributeName: UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    // MARK: Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        self.topTextField.defaultTextAttributes = self.memeTextAttributes
        self.bottomTextField.defaultTextAttributes = self.memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
    }
    
    func save(memeImage:UIImage) {
        var meme = Meme(topString: topTextField.text!, bottomString: topTextField.text!, originalImage: self.imagePickerView.image!, memeImage: memeImage)
    }
    
    func generateMemedImage() -> UIImage {
        
        self.topBar.hidden = true
        self.bottomBar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.topBar.hidden = false
        self.bottomBar.hidden = false
        
        return memedImage
    }
    
    //MARK: Actions
    @IBAction func selectImage(sender: UIBarButtonItem) {
        selectOrCreatePhoto(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func takePhoto(sender: UIBarButtonItem) {
        selectOrCreatePhoto(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        var image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activity, success, items, error) in
            self.save(image)
            controller.dismissViewControllerAnimated(true, completion: nil)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    //MARK: Image Selection
    func selectOrCreatePhoto(source:UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Keyboard
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
}

