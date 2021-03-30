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
    
    func shell(_ command: String) -> String {
        let task = Process();
        let pipe = Pipe();
        
        task.standardOutput = pipe;
        task.standardError = pipe;
        task.arguments = ["-c", command];
        task.launchPath = "/bin/zsh";
        task.launch();
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile();
        let output = String(data: data, encoding: .utf8)!;
        
        return output;
    }
    
    @IBOutlet weak var versionPopUp: NSPopUpButton!
    
    @IBAction func run(_ sender: NSButton) {
        let url = URL(fileURLWithPath: path.stringValue);
        let hubUrl = url.relativeString.replacingOccurrences(of: "%2520", with: "\\ ").split(separator: ":");
        let out = shell("\(hubUrl[1])/Contents/MacOS/Unity\\ Hub -- --headless editors -i");
        let versions = out.split(separator: "\n");
        
        for i in 0..<versions.count {
            if(i == 0 || i == 1){
                versionPopUp.removeItem(at: 0);
            } else if(i == (versions.count-1)){
                versionPopUp.removeItem(at: versions.count-1)
            }
            let versionString = String(versions[i]).split(separator: ",")
            versionPopUp.addItem(withTitle: String(versionString[0]).replacingOccurrences(of: " ", with: ""))
        }
    }
    
    @IBAction func typeChanged(_ sender: NSSegmentedControl) {
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

