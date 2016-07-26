//
//  KeychainManager.swift
//  Swift3Keychain
//
//  Created by Flávio Silvério on 24/07/16.
//  Copyright © 2016 Flávio Silvério. All rights reserved.
//

import Foundation

class KeychainManager {
    
    private var hasSavedDetails : Bool?
    private var login : String?
    private var password : String?
    private var keychainWrapper : KeychainWrapper?
    private var dataDictionary : Dictionary<String,AnyObject>?
    
    init() {
        
        keychainWrapper = KeychainWrapper()
        hasSavedDetails = UserDefaults.standard().bool(forKey: "hasUserDataStoredInKeychain")
        dataDictionary = Dictionary<String,AnyObject>()
        
        if hasSavedDetails == true {

            self.password = keychainWrapper?.myObject(forKey: kSecValueData) as? String
            self.login = keychainWrapper?.myObject(forKey: kSecAttrAccount) as? String
            //self.dataDictionary = try! JSONSerialization.jsonObject(with: keychainWrapper?.myObject(forKey: kSecAttrGeneric) as! Data, options: .allowFragments) as! Dictionary<String, AnyObject>
        }
    }
    
    func set(login: String){
    
        self.login = login
        keychainWrapper!.mySetObject(login, forKey: kSecAttrAccount)
    }
    
    func set(password: String){
    
        self.password = password
        keychainWrapper!.mySetObject(password, forKey:kSecValueData)

    }
    
    func set(login: String, and password: String){
        set(login: login)
        set(password: password)
    }
    
    func check(login: String)->Bool{
        return self.login == login
    }
    
    func check(password: String) -> Bool{
        return self.password == password
    }
    
    func check(login: String, and password: String)->Bool{
        return check(login: login) && check(password: password)
    }
    
    func add(item: AnyObject, withKey key:String){
        dataDictionary![key] = item
        keychainWrapper!.mySetObject(dictionaryToData(), forKey:kSecAttrGeneric)
    }
    
    func getItemWith(key: String)->AnyObject?{
        return dataDictionary?[key]
    }
    
    func getItemsWith(keys:[String])->Array<AnyObject>{
        var items = [AnyObject]()
        for key in keys {
            items.append(dataDictionary![key]!)
        }
        return items
    }
    
    func save(){
        
        keychainWrapper?.writeToKeychain()
        
        hasSavedDetails = true
        UserDefaults.standard().set(hasSavedDetails, forKey: "hasUserDataStoredInKeychain")
        UserDefaults.standard().synchronize()
    }
    
    func reset(){
        
        keychainWrapper!.resetKeychainItem()
        dataDictionary = [String: AnyObject]()
        hasSavedDetails = false
        UserDefaults.standard().set(hasSavedDetails, forKey: "hasUserDataStoredInKeychain")
        UserDefaults.standard().synchronize()
    }

    
    func dictionaryToData()->Data?{
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dataDictionary!, options: .prettyPrinted)
            return jsonData
            
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
    
    func dataToDictionary()->Dictionary<String,AnyObject>?{
        do {
            let decoded = try JSONSerialization.jsonObject(with: keychainWrapper?.myObject(forKey: kSecAttrGeneric) as! Data, options: [])
            return decoded as? Dictionary<String, AnyObject>
            
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
    
}
