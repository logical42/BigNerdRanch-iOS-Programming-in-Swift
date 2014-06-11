//
//  BNRItemsViewController.swift
//  Homepwner
//
//  Created by Han Kang on 6/10/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import UIKit
@IBDesignable
class BNRItemsViewController: UITableViewController {
    @IBOutlet var _headerView:UIView?
    @IBInspectable var headerView:UIView {
        get {
            if _headerView? {
                return _headerView!
            }
            NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil)
            return _headerView!
        }
    }
    init() {
        super.init(style:UITableViewStyle.Plain)
        for i in 0...5 {
            BNRItemStore.sharedStore.createItem()
        }
    }
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }
    init(style:UITableViewStyle) {
        super.init(style:style)
    }
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "blah")
        var header = self.headerView
        self.tableView.tableHeaderView = header
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // #pragma mark - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return BNRItemStore.count
    }

    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        var cell = tableView!.dequeueReusableCellWithIdentifier("blah", forIndexPath: indexPath) as UITableViewCell
        if indexPath!.row % 2 == 0 {
            cell.backgroundColor = UIColor.blueColor()
            cell.textColor = UIColor.whiteColor()
        }
        var items = BNRItemStore.items
        var item = items[indexPath!.row] as BNRItem
        cell.textLabel.text = item.description

        return cell
    }
    @IBAction func addNewItem(sender:AnyObject) {
        var newItem = BNRItemStore.sharedStore.createItem()
        let lastRow = BNRItemStore.items.indexOfObject(newItem)
        
        let indexPath = NSIndexPath(forRow:lastRow, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
    }
    
    @IBAction func toggleEditingMode(sender:AnyObject) {
        if self.editing {
            self.setEditing(false, animated: true)
            sender.setTitle("Editing", forState: UIControlState.Normal)
        }
        else {
            self.setEditing(true, animated: true)
            sender.setTitle("Done", forState: UIControlState.Normal)
        }
    }
    override func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let items = BNRItemStore.items
            let item = items.objectAtIndex(indexPath!.row) as BNRItem
            BNRItemStore.sharedStore.removeItem(item)
            // Delete the row from the data source
            tableView!.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }

    override func tableView(tableView: UITableView?, moveRowAtIndexPath fromIndexPath: NSIndexPath?, toIndexPath: NSIndexPath?) {
        BNRItemStore.sharedStore.moveItemAtIndex(fromIndexPath!.row, toIndex: toIndexPath!.row)
    }
    override func tableView(tableView: UITableView?, didSelectRowAtIndexPath indexPath: NSIndexPath?) {
        var detailViewController = BNRDetailViewController(nibName: nil, bundle: nil)
        self.navigationController.pushViewController(detailViewController, animated: true)
    }
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView?, canMoveRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
