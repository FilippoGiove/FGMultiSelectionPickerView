# FGMultiSelectionPickerView (iOS)
A multi-selection PickerView (iOS)

![Gif](https://github.com/FilippoGiove/FGMultiSelectionPickerView/blob/master/gif_example.gif)


### Installing

Just copy in your project all the swift classes in the Library Group .

## Example

```
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
    
    
    //mark: example of how to extract all selected contents
    func updateTextViewContent(){
        var text = ""
        for row in 0..<entries.count{
            let isSelected = self.pickerView(pickerView: self.picker, selectionStateForRow: row)
            if(isSelected){
                let row_selected_text = self.pickerView(pickerView: self.picker, textForRow: row)
                if(text == ""){
                    text = "\(row_selected_text)"
                }
                else{
                    text = "\(text);\(row_selected_text)"
                }
            }
        }
        self.optionSelectedTextView.text = text;
    }
   
    
}
```

## Authors

[Filippo Giove](https://github.com/FilippoGiove)


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details


