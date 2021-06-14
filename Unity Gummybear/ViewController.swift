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
        
        if(hubUrl.count > 1){
            let out = shell("\(hubUrl[1])/Contents/MacOS/Unity\\ Hub -- --headless editors -i");
            
            let versions = out.split(separator: "\n");
            
            for i in 0..<versions.count {
                let versionString = String(versions[i]).split(separator: ",")
                
                let title = String(versionString[0]).replacingOccurrences(of: " ", with: "")
                if(!title.contains("-")) {
                    versionPopUp.addItem(withTitle: title)
                }
            }
            versionPopUp.removeItem(at: 0)
        } else {
            showAlert("Missing Hub", "Could not find Unity Hub at selected path!", .critical)
        }
    }
    
    @IBAction func typeChanged(_ sender: NSSegmentedControl) {
        switch(type.selectedSegment){
        case 0:
            // INSTALL VERSION
            break;
        case 1:
            // INSTALL MODULES
            break;
        default:
            // SELECT INSTALL TYPE
            break;
        }
    }
    
    func showNotification(_ title: String, _ info: String) -> Void {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = info
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func showAlert(_ question: String, _ text: String, _ style: NSAlert.Style) -> Void {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = style
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    func showAlertCancel(_ question: String, _ text: String, _ style: NSAlert.Style) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = style
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        return alert.runModal() == .alertFirstButtonReturn
    }
}

