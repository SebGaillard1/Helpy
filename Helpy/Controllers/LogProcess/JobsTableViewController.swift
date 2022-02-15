//
//  JobsTableViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 13/02/2022.
//

import UIKit

class JobsTableViewController: UITableViewController {
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Properties
    let cellIdentifier = "jobCell"
    
    
    let allJobs = Jobs.arrayOfJobs
    var filteredJobs = [String]()
    
    var delegate: JobsTableViewControllerDelegate!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        filteredJobs = allJobs
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredJobs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = filteredJobs[indexPath.row]
        cell.contentConfiguration = content
        
        return cell
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.sendJobSelected(job: filteredJobs[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UISearchBar Extension
extension JobsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredJobs = searchText.isEmpty ? allJobs : allJobs.filter({ job in
            return job.range(of: searchText, options:  .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//MARK: - Protocol
protocol JobsTableViewControllerDelegate {
    func sendJobSelected(job: String)
}

