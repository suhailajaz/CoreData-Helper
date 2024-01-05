//
//  FamilyViewControllerTableViewController.swift
//  Project-11-CoreData DatabaseHelper
//
//  Created by suhail on 06/10/23.
//

import UIKit

class FamilyViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var tblFamilies: UITableView!
    var families:[Family]?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Families"
        tblFamilies.delegate = self
        tblFamilies.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewFamily))
        
        DatabaseHelper.shared.getAllFamilies { fams in
            self.families = fams
            DispatchQueue.main.async{
                self.tblFamilies.reloadData()
            }
        }
        
    }
    
    @objc func addNewFamily(){
        let ac = UIAlertController(title: "Add New Family", message: nil, preferredStyle: .alert)
        ac.addTextField { txt in
            txt.placeholder = "Enter family name"
        }
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            guard let newFamilyName  = ac.textFields?[0].text else { return }
            
            DatabaseHelper.shared.createFamily(name: newFamilyName) { success in
                DatabaseHelper.shared.getAllFamilies { fams in
                    self.families = fams
                    DispatchQueue.main.async{
                        self.tblFamilies.reloadData()
                    }
                }
            }
            
        }))
        present(ac,animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return families?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let families = families else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = families[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let vc = storyboard?.instantiateViewController(withIdentifier: "list") as! ListOFFamilymemebersViewController
        guard let families = families else { return  }
        vc.family = families[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        
    }
}
