//
//  FGMultiSelectionPickerTableViewCell.swift
//  FGMultiSelectionPickerView
//
//  Created by Filippo Giove on 05/06/2018.
//  Copyright © 2018 Filippo Giove. All rights reserved.
//

import UIKit

protocol FGMultiSelectionPickerViewCellDelegate{
   
    // Inform the delegate that a row has change is value
    func cellHasChangeIsValue(actualRow:Int,newValue:Bool);
    
}

class FGMultiSelectionPickerTableViewCell: UITableViewCell {

    
    var delegate:FGMultiSelectionPickerViewCellDelegate!
    
    @IBOutlet var extraTouchableAreaForCheckBoxButton: UIButton!
    
    @IBOutlet var checkBoxButton: FGCheckboxButton!
    @IBOutlet var titleLabel: UILabel!
    private var selectionState:Bool!
    var row:Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.contentView.translatesAutoresizingMaskIntoConstraints = false
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        self.backgroundColor = FGMULTISELECTIONPICKER_CELL_NOT_SELECTED_COLOR
    }

    
    func getSeletionState()->Bool{
        return selectionState
    }
    
    func setSelectionState(selectionState:Bool){

        self.selectionState = selectionState;
        self.checkBoxButton.on = self.selectionState

    }
    
    override func layoutSubviews() {

        super.layoutSubviews();
        if(self.selectionState == nil){
            self.selectionState = false;
        }
        self.checkBoxButton.on = self.selectionState
        self.imageView?.image = nil;
        self.imageView?.highlightedImage = nil;
        self.backgroundColor = FGMULTISELECTIONPICKER_CELL_NOT_SELECTED_COLOR
        self.titleLabel.textColor = FGMULTISELECTIONPICKER_TEXT_NOT_SELECTED_COLOR
        self.layer.borderColor = FGMULTISELECTIONPICKER_BORDER_COLOR.cgColor
        self.layer.borderWidth = FGMULTISELECTIONPICKER_BORDER_WIDTH
        




    }
    @IBAction func extraAreaTouched(_ sender: FGCheckboxButton) {
        self.checkBoxButton.on = !self.checkBoxButton.on
        self.checkBoxHasChangedValue(self.checkBoxButton)
    }
    
    @IBAction func checkBoxHasChangedValue(_ sender: FGCheckboxButton) {
        self.selectionState = sender.on
        self.delegate.cellHasChangeIsValue(actualRow: self.row,newValue: self.selectionState)
    }
    
    
}




