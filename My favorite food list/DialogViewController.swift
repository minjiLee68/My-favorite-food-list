//
//  DialogViewController.swift
//  My favorite food list
//
//  Created by 이민지 on 2022/01/28.
//

import UIKit

class DialogViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var viewUI: UIView!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var dialogView: UIView!
    
    var tag: Int = 0
    
    let foodViewModel = FoodViewModel()
    let DialogPostViewController: Notification.Name = Notification.Name("dialogPostViewController")

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        
//        self.view.tag = tag
    }
    
    func viewDesign() {
        viewUI.layer.cornerRadius = 20
        saveButton.layer.cornerRadius = 15
    }
    
    @IBAction func tapBG(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func addTaskButtonTapped(_ sender: Any) {
        guard let detail = inputText.text, detail.isEmpty == false else { return }
        self.view.tag = tag
        let food = FoodManager.shared.createFood(detail: detail, tag: self.view.tag)
        foodViewModel.addFood(food)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: DialogPostViewController, object: nil, userInfo: nil)
    }
}