//
//  YSTableViewController.swift
//  YSTableView
//
//  Created by 悠二 on 1/13/16.
//  Copyright © 2016 Yuji. All rights reserved.
//

import UIKit

class YSTableViewController: UITableViewController {
    
    var hightlightedRows = [NSIndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addKeyboardCommands()
    }
    
    private func addKeyboardCommands() {
        let upArrowCommnd = UIKeyCommand(input: UIKeyInputUpArrow, modifierFlags: UIKeyModifierFlags.init(rawValue: 0), action: "upArrowKeyDidPressed")
        let downArrowCommand = UIKeyCommand(input: UIKeyInputDownArrow, modifierFlags: UIKeyModifierFlags.init(rawValue: 0), action: "downArrowKeyDidPressed")
        let returnCommand = UIKeyCommand(input: "\r", modifierFlags: UIKeyModifierFlags.init(rawValue: 0), action: "returnKeyDidPressed")
        self.addKeyCommand(upArrowCommnd)
        self.addKeyCommand(downArrowCommand)
        self.addKeyCommand(returnCommand)
    }
    
    private func arrowKeyPressed(input: String) {
        if hightlightedRows.count == 0 {
            hightlightTopVisibleCell()
            return
        }
        switch input {
        case UIKeyInputUpArrow: hightlightCellAtIndexPath(tableView.perviousIndexPath(currentPath: hightlightedRows[0]), position: input)
        case UIKeyInputDownArrow: hightlightCellAtIndexPath(tableView.nextIndexPath(currentPath: hightlightedRows[0]), position: input)
        default: break
        }
    }
    
    private func hightlightTopVisibleCell() -> NSIndexPath? {
        if let indexPaths = self.tableView.indexPathsForVisibleRows {
            if indexPaths.count > 0 {
                let indexPath = indexPaths[0]
                hightlightCellAtIndexPath(indexPath)
                return indexPath
            }
        }
        return nil
    }
 
    private func dehightlightedCell() {
        for row in self.hightlightedRows {
            self.tableView.cellForRowAtIndexPath(row)?.highlighted = false
        }
        if let row = self.tableView.indexPathForSelectedRow {
            self.tableView.cellForRowAtIndexPath(row)?.selected = false
        }
        self.hightlightedRows.removeAll()
    }
    
    private func hightlightCellAtIndexPath(indexPath: NSIndexPath?, position: String? = nil) {
        if let indexPath = indexPath {
            dehightlightedCell()
            
            if !tableView.indexPathsForVisibleRows!.contains(indexPath) {
                if let position = position {
                    switch position {
                    case UIKeyInputUpArrow: self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
                    case UIKeyInputDownArrow: self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
                    default: break
                    }
                }
            }
            
            if let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
                cell.highlighted = true
                self.hightlightedRows.append(indexPath)
            }
        } else {
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !self.hightlightedRows.contains(indexPath) {
            self.hightlightedRows.append(indexPath)
        }
    }
 
    func upArrowKeyDidPressed() {
        self.arrowKeyPressed(UIKeyInputUpArrow)
        self.tableView.scrollToRowAtIndexPath(hightlightedRows[0], atScrollPosition: .Top, animated: false)
    }
    
    func downArrowKeyDidPressed() {
        self.arrowKeyPressed(UIKeyInputDownArrow)
        self.tableView.scrollToRowAtIndexPath(hightlightedRows[0], atScrollPosition: .Bottom, animated: false)
    }
    
    func returnKeyDidPressed() {
        if self.hightlightedRows.count == 1 {
            tableView(self.tableView, didSelectRowAtIndexPath: self.hightlightedRows[0])
        }
    }
}

extension UITableView {
    func perviousIndexPath(currentPath path: NSIndexPath) -> NSIndexPath? {
        if path.row > 0 {
            return NSIndexPath(forRow: path.row - 1, inSection: path.section)
        } else {
            if path.section > 0 {
                let rows = self.numberOfRowsInSection(path.section - 1)
                if rows != 0 {
                    return NSIndexPath(forRow: rows - 1, inSection: path.section-1)
                } else {
                    return perviousIndexPath(currentPath: NSIndexPath(forRow: 0, inSection: path.section - 1))
                }
            } else {
                return nil
            }
        }
    }
    
    func nextIndexPath(currentPath path: NSIndexPath) -> NSIndexPath? {
        if path.section < numberOfSections - 1 {
            if path.row < numberOfRowsInSection(path.section) - 1 { //next row exists
                
                return NSIndexPath(forRow: path.row + 1, inSection: path.section)
            }
            if path.section < numberOfSections - 2 { //Not the last section
                if numberOfRowsInSection(path.section + 1) != 0 {
                    return NSIndexPath(forRow: 0, inSection: path.section + 1)
                } else {
                    return nextIndexPath(currentPath: NSIndexPath(forRow: 0, inSection: path.section + 1))
                }
            }
        }
        return nil
    }
    
}
