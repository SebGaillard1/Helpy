//
//  ClientMyAccountViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 02/03/2022.
//

import UIKit
import FirebaseAuth

struct Section {
    let title: String
    let options: [MyAccountOption]
}

struct MyAccountOption {
    let title: String
    let icon: UIImage?
    let handler: (() -> Void)
}

class ClientMyAccountViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var myAccountTableView: UITableView!
    
    //MARK: - Properties

    var models = [Section]()
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true

        myAccountTableView.dataSource = self
        myAccountTableView.delegate = self
        myAccountTableView.register(UINib.init(nibName: ClientMyAccountTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ClientMyAccountTableViewCell.identifier)
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configure() {
        models.append(Section(title: "Item", options: [
            MyAccountOption(title: "Titre 1", icon: UIImage(systemName: "house"), handler: {
                print("tapped")
            }),
            MyAccountOption(title: "Titre 2", icon: UIImage(systemName: "airplane"), handler: {
                
            }),
            MyAccountOption(title: "Titre 3", icon: UIImage(systemName: "cloud"), handler: {
                
            })
        ]))
        
        models.append(Section(title: "Gestion", options: [
            MyAccountOption(title: "Se déconnecter", icon: UIImage(systemName: "rectangle.portrait.and.arrow.right")?.withTintColor(.red, renderingMode: .alwaysOriginal), handler: {
                do {
                    try Auth.auth().signOut()
                    self.navigationController?.popToRootViewController(animated: true)
                } catch let error {
                    let alert = UIAlertController(title: "Error", message: "Impossible de vous déconnecter : \(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    
                    self.present(alert, animated: true)
                }
            })
        ]))
    }
}

//MARK: - Extensions
extension ClientMyAccountViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = models[indexPath.section].options[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ClientMyAccountTableViewCell.identifier, for: indexPath) as? ClientMyAccountTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: option)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}

extension ClientMyAccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.section].options[indexPath.row]
        model.handler()
    }
}

