//
//  ViewController.swift
//  toDoApp
//
//  Created by Muaz Talha Bulut on 27.01.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var taskStore = [[TaskEntity](), [TaskEntity]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.fillerRowHeight = 0.4
      
        getData()
      

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .orange
        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                          .foregroundColor: UIColor.white]

        // Customizing our navigation bar
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
      
    }
    @IBAction func btnAdd(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default ) { _ in
            
            guard let name = alert.textFields?.first?.text else {return}
            print(name)
            
            //core dataya ekleme işlemi
            
            DataBaseHelper.shareInstance.save(name: name, isDone: false)
            
            
          
         //save
            
            self.getData()
         
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField{ textField in
            textField.placeholder = "Enter Task Name..."
        }
        
       //butonlar
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    func getData() {
        
        let tasks = DataBaseHelper.shareInstance.fetch()
        
        taskStore = [tasks.filter{$0.isdone == false}, tasks.filter{$0.isdone == true }]
        
        tableView.reloadData()
    }
    
    }
   
   
    



extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore[section].count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskStore[indexPath.section][indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "To Do": "Done"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.count
    }
}
extension ViewController {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: nil){(action, sourceView, completionHandler)in
           
            let row = self.taskStore[0][indexPath.row] // done olanları done ypmamak için ilk section ı seçme işlemi
            DataBaseHelper.shareInstance.update(name: row.name!, isdone: true)
            self.getData()
            
        }
        
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil){(action, sourceView, completionHandler)in
           
            let row = self.taskStore[indexPath.section][indexPath.row]
            DataBaseHelper.shareInstance.deleteData(name: row.name!)
            self.getData()
            
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}


