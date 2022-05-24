//
//  CategoryTableViewController.swift
//  OrderApp
//
//  Created by Daria Salamakha on 14.05.2022.
//

import UIKit

// MARK: - CategoryTableViewController
class CategoryTableViewController: UITableViewController {
    
    // MARK: - Properties
    var categories = [String]()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestAuthorization { granted in
            switch granted {
            case true:
                print("yay!")
            case false:
                print("aww.")
            }
        }

        MenuController.shared.fetchCategories { (result) in
            switch result {
            case .success(let categories):
                self.updateUI(with: categories)
            case .failure(let error):
                self.displayError(error, title: "Failed to Fetch Categories")
            }
        }
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MenuController.shared.updateUserActivity(with: .categories)
    }
    
    // MARK: - Outlets
   func requestAuthorization(completion: @escaping  (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
            completion(granted)
        }
    }
    
    func updateUI(with categories: [String]) {
        DispatchQueue.main.async {
            self.categories = categories
            self.tableView.reloadData()
        }
    }
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)

        configureCell(cell, forCategoryAt: indexPath)

        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, forCategoryAt indexPath: IndexPath) {
        let category  = categories[indexPath.row]
        cell.textLabel?.text = category.capitalized
    }
    
    // MARK: - Actions
    @IBSegueAction func showMenu(_ coder: NSCoder, sender: Any?) -> MenuTableViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return nil }
        let category = categories[indexPath.row]
        return MenuTableViewController(coder: coder, category: category)
    }
}
