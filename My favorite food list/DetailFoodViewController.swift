//
//  DetailFoodViewController.swift
//  My favorite food list
//
//  Created by 이민지 on 2022/01/27.
//

import UIKit

class DetailFoodViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewUI: UIView!
    
    var tag: Int = 0
    
    let foodViewModel = FoodViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(detailViewController(_:)), name: NSNotification.Name("dialogPostViewController"), object: nil)
        
        self.view.tag = tag
        foodViewModel.loadTasks()
        uiDesign()
        addButton.addTarget(self, action: #selector(goAlert), for: .touchUpInside)
    }
    
    @objc func detailViewController(_ noti: Notification) {
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }
    
    @objc func goAlert() {
        let alert = self.storyboard?.instantiateViewController(withIdentifier: "dialog") as! DialogViewController
        alert.modalPresentationStyle = .overCurrentContext
        alert.tag = tag
        present(alert, animated: false, completion: nil)
    }
    
    @IBAction func respondToSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizer.Direction.right :
            self.dismiss(animated: true, completion: nil)
        default: break
        }
    }
    
    @IBAction func backTapButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func swipeRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func uiDesign() {
        tableView.backgroundColor = .clear
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
}

extension DetailFoodViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodViewModel.allCount(tag: tag).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailListCell", for: indexPath) as? DetailListCell else { return UITableViewCell() }
        var food: Food
        food = foodViewModel.allCount(tag: tag)[indexPath.item]
        cell.updateUI(food)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNonzeroMagnitude
    }
}

extension DetailFoodViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actions1 = UIContextualAction(style: .normal, title: "삭제", handler: { action, view, completionHandler in
            var food: Food
            food = self.foodViewModel.allCount(tag: self.tag)[indexPath.item]
            self.foodViewModel.deleteFood(food)
            self.tableView.reloadData()
            completionHandler(true)
        })
        actions1.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [actions1])
    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            var food: Food
//            food = foodViewModel.foods[indexPath.item]
//            foodViewModel.deleteFood(food)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            print("--> \(food)")
//            tableView.reloadData()
//        } else if editingStyle == .insert { }
//    }
}

class DetailListCell: UITableViewCell {
    @IBOutlet weak var foodName: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func updateUI(_ food: Food) {
        foodName.text = food.foodDetail
    }
}
