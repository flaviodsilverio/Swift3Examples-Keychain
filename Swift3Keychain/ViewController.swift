//
//  ViewController.swift
//  Swift3Keychain
//
//  Created by Flávio Silvério on 24/07/16.
//  Copyright © 2016 Flávio Silvério. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let keychain = KeychainManager()
       // print(keychain.hasSavedDetails)
        
        keychain.set(login: "test")
        keychain.set(password: "again")
        
        print(keychain.check(login: "oi", and: "ui"))
        print(keychain.check(login: "test"))
        print(keychain.check(password: "again"))
        keychain.add(item: "try", withKey: "this")
        keychain.add(item: "again", withKey: "other")

        keychain.save()
        
        
     //   print(keychain.hasSavedDetails)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

