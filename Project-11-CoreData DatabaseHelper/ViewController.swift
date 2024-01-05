//
//  ViewController.swift
//  Project-11-CoreData DatabaseHelper
//
//  Created by suhail on 05/10/23.
//

import UIKit

class ViewController: UIViewController {
  
    @IBOutlet var tblPersons: UITableView!
    
    var persons: [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblPersons.delegate = self
        tblPersons.dataSource = self
        
        fetchAllPersons()
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Add Person", message: nil, preferredStyle: .alert)
        ac.addTextField { txt in
            txt.placeholder = "Enter the name"
        }
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            guard let newPersonName  = ac.textFields?[0].text else { return }
            
            DatabaseHelper.shared.createNewPerson(personName: newPersonName) { success in
                if success{
                    self.fetchAllPersons()
                }
            }
            
        }))
        present(ac,animated: true)
    }
    
    @IBAction func filterPressed(_ sender: Any) {
        let ac = UIAlertController(title: "Choose a condition", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Sort in ascending order", style: .default,handler: { _ in
            DatabaseHelper.shared.sortByNameAscending { sortedPersons in
                self.persons = sortedPersons
                DispatchQueue.main.async{
                    self.tblPersons.reloadData()
                }
            }
        }))
        ac.addAction(UIAlertAction(title: "Sort in deccending order", style: .default,handler: { _ in
            DatabaseHelper.shared.sortByNameDescending{ sortedPersons in
                self.persons = sortedPersons
                DispatchQueue.main.async{
                    self.tblPersons.reloadData()
                }
            }
        }))
        ac.addAction(UIAlertAction(title: "Filter by name", style: .default,handler: { _ in
            
            let ac = UIAlertController(title: "Filter by Name", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                guard let filterName = ac.textFields?[0].text else { return }
                DatabaseHelper.shared.filterByName(name: filterName) { filteredPersons in
                    self.persons = filteredPersons
                    DispatchQueue.main.async{
                        self.tblPersons.reloadData()
                    }
                }
            }))
            self.present(ac,animated: true)
        }))
        ac.addAction(UIAlertAction(title: "Undo Filter", style: .default,handler: { _ in
            self.fetchAllPersons()
        }))
        present(ac,animated: true)
    }
}


extension ViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let persons = persons else { return  0 }
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let persons = persons else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = persons[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard  let person = persons?[indexPath.row] else { return }
        
        let ac = UIAlertController(title: "Edit Person", message: nil, preferredStyle: .alert)
        ac.addTextField { txt in
            txt.text = person.name
        }
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            guard let newName = ac.textFields?[0].text else { return }
            DatabaseHelper.shared.updatePerson(person: person, newName: newName) { success in
                if success{
                    self.fetchAllPersons()
                }
            }
        }))
        present(ac,animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            guard let personToDelete = persons?[indexPath.row] else { return }
            DatabaseHelper.shared.deletePerson(person: personToDelete) { success in
                if success{
                    self.fetchAllPersons()
                }
            }
        }
    }
    
}

//user defined functions
extension ViewController{
    func fetchAllPersons(){
        DatabaseHelper.shared.getAllPersons { personEntries in
            self.persons = personEntries
            DispatchQueue.main.async{
                self.tblPersons.reloadData()
            }
            
        }
    }

    
}
