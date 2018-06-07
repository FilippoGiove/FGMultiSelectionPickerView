//
//  ViewController.swift
//  FGMultiSelectionPickerView
//
//  Created by Filippo Giove on 05/06/2018.
//  Copyright © 2018 Filippo Giove. All rights reserved.
//

import UIKit

class ViewController: UIViewController,FGMultiSelectionPickerViewDelegate {
    
    
    

    @IBOutlet var openButton: UIButton!
    @IBOutlet var optionSelectedTextView: UITextView!
    @IBOutlet var picker: FGMultiSelectionPickerView!
    
    var entries :NSMutableArray!
    var selectionState:NSMutableDictionary!
    var isPickerHidden:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isPickerHidden = true
        self.picker.isHidden = isPickerHidden
        self.picker.delegate = self

        // Do any additional setup after loading the view, typically from a nib.
        let numElements = 200;
        entries = NSMutableArray()
        for i in 0...numElements{
            entries.add("Row \(i)")
        }

        self.selectionState = NSMutableDictionary()
        for key  in entries {
            self.selectionState.setObject(false, forKey: key as! NSString)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openPicker(_ sender: UIButton) {
        isPickerHidden = !isPickerHidden
        if(isPickerHidden){
            self.picker.showFromBottom()
        }
        else{
            self.picker.hideToBottom()
        }
        
    }
    
    
    //mark: FGMultiSelectionPickerViewDelegate
    
    func numberOfRowsForPickerView(pickerView: FGMultiSelectionPickerView) -> NSInteger {
        return entries.count
    }
    
    func pickerView(pickerView: FGMultiSelectionPickerView, textForRow row: NSInteger) -> NSString {
        return entries.object(at: row) as! NSString
    }
    
    func pickerView(pickerView: FGMultiSelectionPickerView, selectionStateForRow row: NSInteger) -> Bool {
        let key = entries.object(at: row) as! NSString
        let state = (selectionState.object(forKey: key) as! Bool)
        return state
    }
    
    func pickerView(pickerView: FGMultiSelectionPickerView, didCheckRow row: NSInteger) {
        let key = entries.object(at: row) as! String
        self.selectionState.setObject(true, forKey: key as NSString)
        self.updateTextViewContent()
        
        
    }
    
    func pickerView(pickerView: FGMultiSelectionPickerView, didUncheckRow row: NSInteger) {
        let key = entries.object(at: row) as! String
        self.selectionState.setObject(false, forKey: key as NSString)
        self.updateTextViewContent()

    }
    
    func getActualOptionSelections(pickerView: FGMultiSelectionPickerView) -> NSArray {
        let selections = NSMutableArray()
        for row in 0..<entries.count{
            let isSelected = self.pickerView(pickerView: self.picker, selectionStateForRow: row)
            if(isSelected){
                let row_selected_text = self.pickerView(pickerView: self.picker, textForRow: row)
                selections.add(row_selected_text)
            }
        }
        return selections
    }
    
    
    
    
    //mark: other for test
    func updateTextViewContent(){
        var text:String = ""
        let selections = self.getActualOptionSelections(pickerView: self.picker)
        for selection in selections{
            if(text == ""){
                text = "\(selection)"
            }
            else{
                text = "\(text);\(selection)"
            }
        }
        self.optionSelectedTextView.text = text;
    }
    

    
    
    
    
    
}

