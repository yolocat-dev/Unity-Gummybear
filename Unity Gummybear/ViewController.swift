//
//  ViewController.swift
//  Unity Gummybear
//
//  Created by Valter Sporrenstrand on 2021-03-29.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var type: NSSegmentedCell!
    @IBOutlet weak var path: NSPathControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func typeChanged(_ sender: Any) {
        switch(type.selectedSegment){
        case 0:
            path.isHidden = false;
            break;
        case 1:
            path.isHidden = true;
            break;
        default:
            path.isHidden = true;
            break;
        }
    }
}

