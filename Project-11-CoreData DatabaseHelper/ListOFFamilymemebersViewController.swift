//
//  ListOFFamilymemebersViewController.swift
//  Project-11-CoreData DatabaseHelper
//
//  Created by suhail on 06/10/23.
//

import UIKit

class ListOFFamilymemebersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tblMembers: UITableView!
    var family: Family?
    var persons: [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMembers.dataSource = self
        tblMembers.delegate = self
        persons = family?.members?.allObjects as? [Person]
      
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let persons = persons else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = persons[indexPath.row].name
        return cell
    }
    
   
}
