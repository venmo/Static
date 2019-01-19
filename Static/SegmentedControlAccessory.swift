import UIKit

class SegmentedControlAccessory: UISegmentedControl {
    typealias ValueChange = (Int, Any?) -> ()
    var valueChange: ValueChange? = nil
    
    init(items: [Any], selectedIndex: Int, valueChange: (ValueChange)? = nil) {
        super.init(items: items)
        
        self.valueChange = valueChange
        self.selectedSegmentIndex = selectedIndex
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    fileprivate init() {super.init(frame: .zero)}
    fileprivate override init(frame: CGRect) {super.init(frame: frame)}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func valueChanged() {
        let segmentContents: Any? = titleForSegment(at: selectedSegmentIndex) ?? imageForSegment(at: selectedSegmentIndex)
        valueChange?(selectedSegmentIndex, segmentContents)
    }
}
