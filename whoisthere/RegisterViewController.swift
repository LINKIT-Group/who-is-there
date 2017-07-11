//
//  RegisterViewController.swift
//  whoisthere
//
//  Created by Efe Kocabas on 10/07/2017.
//  Copyright (c) 2017 Efe Kocabas. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pickColorButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var isUpdateScreen : Bool = false
    
    
    @IBAction func nextButtonClick(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        let avatarId = defaults.integer(forKey: UserDataKeys.avatarId)
        let name : String = nameTextField.text ?? ""
        
        if (avatarId == 0) {
            
            AlertHelper.warn(delegate: self, message: "Please choose an avatar")
        }
        else if (name.isEmpty) {
            
            AlertHelper.warn(delegate: self, message: "Please enter your name")
        }
        else {
            
            let defaults = UserDefaults.standard
            defaults.set(name, forKey: UserDataKeys.name)
            defaults.set(true, forKey: UserDataKeys.hasProperData)
            
            if (isUpdateScreen) {
                
                self.navigationController?.popViewController(animated: true)
            }
            else {
                
                if let target = self.storyboard?.instantiateViewController(withIdentifier: "MainController") as? MainController {
                    target.navigationItem.hidesBackButton = true;
                    self.navigationController?.pushViewController(target, animated: true)
                }
            }
        }
    }
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        
        nextButton.layer.cornerRadius = 10
        nameTextField.delegate = self
        pickColorButton.setTitle("_register_pick_color".localized, for: .normal)
    }
    
    func initData() {
        
        isUpdateScreen = UserDefaults.standard.bool(forKey: UserDataKeys.hasProperData)
        
        self.navigationItem.title = isUpdateScreen ? "_register_title".localized : "_profile_title".localized
        
        let buttonTitle = isUpdateScreen ? "_save".localized : "_next".localized
        nextButton.setTitle(buttonTitle, for: .normal)
        
        let defaults = UserDefaults.standard
        let avatarId = defaults.integer(forKey: UserDataKeys.avatarId)
        avatarButton.setImage(UIImage(named: String(format: "avatar%d", avatarId)), for: UIControlState.normal)
        
        let colorId = defaults.integer(forKey: UserDataKeys.colorId)
        self.view.backgroundColor = ColorList.colors[colorId]
        
        nameTextField.text = defaults.string(forKey: UserDataKeys.name)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        initData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        
        return true
    }
}
