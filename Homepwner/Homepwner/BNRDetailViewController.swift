//
//  BNRDetailViewController.swift
//  Homepwner
//
//  Created by Han Kang on 6/11/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import UIKit

class BNRDetailViewController: UIViewController {

    @IBOutlet var nameField : UITextField
    @IBOutlet var serialNumberField : UITextField
    @IBOutlet var valueField : UITextField
    @IBOutlet var dateLabel : UILabel

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
