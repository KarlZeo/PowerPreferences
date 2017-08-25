//
//  ViewController.swift
//  PowerPreferences
//
//  Created by Zeo on 22/08/2017.
//  Copyright © 2017 Karl Zeo. All rights reserved.
//

import Cocoa
import SwiftShell

class ViewController: NSViewController {
    
    @IBOutlet var hiddenFileButton: NSButton!
    @IBOutlet var safariDebugButton: NSButton!
    @IBOutlet var macAppStoreDebugButton: NSButton!
    
    @IBOutlet var installAnyWhereButton: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    
    override func viewWillAppear() {
        let checkHiddenFile = run("/usr/bin/defaults", "read", "com.apple.finder", "AppleShowAllFiles")
        if checkHiddenFile.stdout == "1" {
            self.hiddenFileButton.title = "隐藏"
        }else {
            self.hiddenFileButton.title = "显示"
        }
        
        
        let checkSafraiDebug = run("/usr/bin/defaults", "read", "com.apple.Safari", "IncludeInternalDebugMenu")
        if checkSafraiDebug.stdout == "1" {
            self.safariDebugButton.title = "隐藏"
        }else {
            self.safariDebugButton.title = "显示"
        }
        
        
        if #available(macOS 10.12, *) {
            
            self.macAppStoreDebugButton.title = "废弃"
            
        } else {
            
            let checkmacAppStoreDebug = run("/usr/bin/defaults", "read", "com.apple.appstore", "ShowDebugMenu")
            if checkmacAppStoreDebug.stdout == "1" {
                self.macAppStoreDebugButton.title = "隐藏"
            }else {
                self.macAppStoreDebugButton.title = "显示"
            }
            
        }
        
        
        
        let checkInstallAnyWhere = run("/usr/sbin/spctl", "--status")
        if checkInstallAnyWhere.stdout == "assessments disabled" {
            self.installAnyWhereButton.title = "关闭"
        }else if checkInstallAnyWhere.stdout == "assessments enable" {
            self.installAnyWhereButton.title = "开启"
        }
    }
    
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func hiddenFile(_ sender: Any) {
        
        let checkHiddenFile = run("/usr/bin/defaults", "read", "com.apple.finder", "AppleShowAllFiles")
        if checkHiddenFile.stdout == "1" {
            run("/usr/bin/defaults", "write", "com.apple.finder", "AppleShowAllFiles", "0")
            run("/usr/bin/killall", "Finder")
            self.hiddenFileButton.title = "显示"
        }
        if checkHiddenFile.stdout == "0"{
            run("/usr/bin/defaults", "write", "com.apple.finder", "AppleShowAllFiles", "1")
            run("/usr/bin/killall", "Finder")
            self.hiddenFileButton.title = "隐藏"
        }
        
    }
    
    @IBAction func safraiDebug(_ sender: Any) {
        let checkSafraiDebug = run("/usr/bin/defaults", "read", "com.apple.Safari", "IncludeInternalDebugMenu")
        if checkSafraiDebug.stdout == "1" {
            run("/usr/bin/defaults", "write", "com.apple.Safari", "IncludeInternalDebugMenu", "0")
            run("/usr/bin/killall", "Safari")
            self.hiddenFileButton.title = "显示"
        }else{
            run("/usr/bin/defaults", "write", "com.apple.Safari", "IncludeInternalDebugMenu", "1")
            run("/usr/bin/killall", "Safari")
            self.hiddenFileButton.title = "隐藏"
        }
    }
    
    @IBAction func anyWhereInstall(_ sender: Any) {
//        let checkInstallAnyWhere = run("/usr/sbin/spctl", "--status")
        if self.installAnyWhereButton.title == "关闭" {
            runAdmin("/usr/sbin/spctl", "--master-enable")
            self.installAnyWhereButton.title = "开启"
        }else if self.installAnyWhereButton.title == "开启" {
            runAdmin("/usr/sbin/spctl", "--master-disable")
            self.installAnyWhereButton.title = "关闭"
        }
    }
    
    func runAdmin(_ command: String,_ argument: String ){
        let script: String = "\(command) \(argument)"
        let fullScript: String = "do shell script \"\(script)\" with administrator privileges"
        let appleScript: NSAppleScript = NSAppleScript(source: fullScript)!
        appleScript.executeAndReturnError(nil)
    }
    
    @IBAction func resetLaunchPad(_ sender: Any) {
        run("/usr/bin/defaults", "write", "com.apple.dock", "ResetLaunchPad", "-bool", "true")
        run("/usr/bin/killall", "Dock")
    }
    
    @IBAction func resetDock(_ sender: Any) {
        run("/usr/bin/defaults", "delete", "com.apple.dock")
    }
    
    
    @IBAction func macAppStoreDebug(_ sender: Any) {
        
        if #available(macOS 10.12, *) {
            
            let alert = NSAlert()
            
            alert.addButton(withTitle: "收到")
            
            alert.messageText = "⚠️警告"
            
            alert.informativeText = "这项功能在10.12以上的系统被废弃了"
            
            alert.alertStyle = .informational
            
            alert.beginSheetModal(for: self.view.window!, completionHandler: { returnCode in
                
            })
            
        } else {
            
            let checkmacAppStoreDebug = run("/usr/bin/defaults", "read", "com.apple.appstore", "ShowDebugMenu")
            if checkmacAppStoreDebug.stdout == "1" {
                run("/usr/bin/defaults", "write", "com.apple.appstore", "ShowDebugMenu", "-bool", "false")
                self.hiddenFileButton.title = "显示"
            }else{
                run("/usr/bin/defaults", "write", "com.apple.appstore", "ShowDebugMenu", "-bool", "true")
                self.hiddenFileButton.title = "隐藏"
            }
            
        }
        
    }
    
    @IBAction func restartFinder(_ sender: Any) {
        run("/usr/bin/killall", "Finder")
    }
}

