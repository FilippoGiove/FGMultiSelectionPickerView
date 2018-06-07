//
//  FGMultiSelectionPickerView.swift
//  FGMultiSelectionPickerView
//
//  Created by Filippo Giove on 05/06/2018.
//  Copyright © 2018 Filippo Giove. All rights reserved.
//

import UIKit






protocol FGMultiSelectionPickerViewDelegate{
    // Return the number of elements of your pickerview
    func numberOfRowsForPickerView(pickerView:FGMultiSelectionPickerView)->NSInteger;
    // Return a plain UIString to display on the given row
    func pickerView(pickerView:FGMultiSelectionPickerView, textForRow row:NSInteger) ->NSString
    // Return a boolean selection state on the given row
    func pickerView(pickerView:FGMultiSelectionPickerView, selectionStateForRow row:NSInteger)->Bool
    // Inform the delegate that a row got selected, if row = -1 all rows are selected
    func pickerView(pickerView:FGMultiSelectionPickerView, didCheckRow row:NSInteger);
    // Inform the delegate that a row got deselected, if row = -1 all rows are deselected
    func pickerView(pickerView:FGMultiSelectionPickerView, didUncheckRow row:NSInteger);
    func getActualOptionSelections(pickerView:FGMultiSelectionPickerView)->NSArray;

    

}
class FGMultiSelectionPickerView: UIView, UITableViewDataSource, UITableViewDelegate, FGMultiSelectionPickerViewCellDelegate {

    
    

    var delegate:FGMultiSelectionPickerViewDelegate!
    
    
    var topOverlayView :UIView!
    var topOverlayViewBottomBorder:UIView!
    var bottomOverlayView: UIView!
    var bottomOverlayViewTopBorder:UIView!
    //var allOptionTitle : NSString!
    var cellFont:UIFont!
    
    var internalTableView:UITableView!
    //mark - init methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.constructView();
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       self.constructView();
    }
    
    func constructView(){
        self.backgroundColor = FGMULTISELECTIONPICKER_BACKGROUND_COLOR
        self.internalTableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), style: UITableViewStyle.plain)
        self.internalTableView.delegate = self;
        self.internalTableView.dataSource = self;
        self.internalTableView.separatorStyle = UITableViewCellSeparatorStyle.none;
        self.internalTableView.showsVerticalScrollIndicator = false;
        self.internalTableView.scrollsToTop = false;
        self.internalTableView.register(UINib(nibName: "CheckBoxCell", bundle: nil), forCellReuseIdentifier: FGMULTISELECTIONPICKER_CELL_IDENTIFIER as String)
        self.addSubview(self.internalTableView)
       
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.internalTableView.frame = CGRect(x:0, y:0,width: frame.size.width, height:frame.size.height);
        self.internalTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine;
    }
    
    
    
    //mark - Custom methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Reload whole pickerview from delegate
    func reloadAllComponents(){
        internalTableView.reloadData()
    }
    
    
    //mark - table view methods
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numOfROws =  delegate != nil ? delegate.numberOfRowsForPickerView(pickerView: self) :  0
        return numOfROws
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FGMULTISELECTIONPICKER_ROW_HEIGHT;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FGMULTISELECTIONPICKER_CELL_IDENTIFIER as String, for: indexPath as IndexPath) as! FGMultiSelectionPickerTableViewCell
        
        
        
        let actualRow = indexPath.row
        cell.titleLabel.text = delegate.pickerView(pickerView: self, textForRow: actualRow) as String
        cell.row = actualRow
        cell.delegate = self
        cell.setSelectionState(selectionState: delegate.pickerView(pickerView: self, selectionStateForRow: actualRow))
        if (cellFont != nil) {
            cell.textLabel!.font = cellFont;
        }
        return cell;
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func showFromBottom(){
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func hideToBottom(){
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }

    
    func cellHasChangeIsValue(actualRow:Int, newValue: Bool) {
        if (newValue) {
            delegate.pickerView(pickerView:self, didCheckRow:actualRow)
        }
        else {
            delegate.pickerView(pickerView:self, didUncheckRow:actualRow)
        }
    }
    


}
