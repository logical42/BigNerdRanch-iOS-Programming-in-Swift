//
//  BNRDetailViewController.swift
//  Homepwner
//
//  Created by Han Kang on 6/11/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import UIKit

class BNRDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet var nameField : UITextField
    @IBOutlet var serialNumberField : UITextField
    @IBOutlet var valueField : UITextField
    @IBOutlet var dateLabel : UILabel
    @IBOutlet var imageView : UIImageView
    @IBOutlet var toolbar : UIToolbar
    
    @IBAction func backgroundTapped(sender : AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func takePicture(sender : AnyObject) {
        
        let imagePicker = UIImagePickerController()
        let cameraSourceType = UIImagePickerControllerSourceType.Camera
        if UIImagePickerController.isSourceTypeAvailable(cameraSourceType) {
            imagePicker.sourceType = cameraSourceType
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    class var dateFormatter:NSDateFormatter {
        get {
            GlobalDateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            GlobalDateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            return GlobalDateFormatter
        }
    }
    var _item:BNRItem?
    var item:BNRItem {
        get {
            return self._item!
        }
        set(item) {
            self._item = item
            self.navigationItem!.title = self.item.itemName
        }
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let item = self.item
        self.nameField.text = item.itemName
        self.serialNumberField.text = item.serialNumber
        self.valueField.text = String(item.valueInDollars)
        self.dateLabel.text = BNRDetailViewController.dateFormatter.stringFromDate(item.dateCreated)
        let image = BNRImageStore.sharedStore.imageForKey(item.itemKey)
        self.imageView.image = image
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        let item = self.item
        item.itemName = self.nameField.text
        item.serialNumber = self.serialNumberField.text
        item.valueInDollars = self.valueField.text.toInt()!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
        let image = info!.valueForKey(UIImagePickerControllerOriginalImage)! as UIImage
        BNRImageStore.sharedStore.setImage(image, forKey:self.item.itemKey)
        self.imageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func textFieldShouldReturn(textField:UITextField?) -> Bool {
        textField!.resignFirstResponder()
        return true
    }

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
let GlobalDateFormatter = NSDateFormatter()
