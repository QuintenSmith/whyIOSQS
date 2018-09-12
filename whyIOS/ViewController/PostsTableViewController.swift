//
//  PostsTableViewController.swift
//  whyIOS
//
//  Created by Quinten Smith on 9/5/18.
//  Copyright © 2018 Quinten Smith. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController {
    
    var posts: [Post] = []
    
    func refresh() {
        PostController.fetchPosts { (posts) in
            guard let posts = posts else { return }
            self.posts = posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell
        let post = posts[indexPath.row] 
        cell?.nameLabel.text = post.name
        cell?.reasonLabel.text = post.reason
        cell?.cohortLabel.text = post.cohort
        
        return cell ?? UITableViewCell()
    }
    
    @IBAction func refreshButtonWasTapped(_ sender: Any) {
        refresh()
    }
    
    @IBAction func addButtonWasTapped(_ sender: Any) {
        addReason()
    }
    
}

extension PostsTableViewController {
    func addReason() {
        var nameTextFieldForReason: UITextField?
        var reasonTextFieldForReason: UITextField?
        var cohortTextFieldforReason: UITextField?
        
        let reasonAlert = UIAlertController(title: "Why iOS?", message: nil, preferredStyle: .alert)
        
        reasonAlert.addTextField { (nameTextField) in
            nameTextField.placeholder = "Enter your name"
            nameTextFieldForReason = nameTextField
        }
        
        reasonAlert.addTextField { (cohortTextField) in
            cohortTextField.placeholder = "What is your cohort"
            cohortTextFieldforReason = cohortTextField
        }
        
        reasonAlert.addTextField { (reasonTextField) in
            reasonTextField.placeholder = "Why iOS?"
            reasonTextFieldForReason = reasonTextField
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addReasonAction = UIAlertAction(title: "Add Reason", style: .default) { (_) in
            guard let name = nameTextFieldForReason?.text,
                let cohort = cohortTextFieldforReason?.text,
                let reason = reasonTextFieldForReason?.text else { return }
            PostController.putPost(name: name, reason: reason, cohort: cohort, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.refresh()
                    }
                } else {
                    print("Fail")
                }
            })
        }
        reasonAlert.addAction(addReasonAction)
        reasonAlert.addAction(cancelAction)
        present(reasonAlert, animated: true)
    }
    
}








