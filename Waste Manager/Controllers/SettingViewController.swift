//
//  SettingViewController.swift
//  Waste Manager
//
//  Created by 최유현 on 11/6/23.
//

import UIKit
import FirebaseAuth

class SettingViewController: UIViewController {
    
    let settingView = SettingView()
    
    let settingsOptions = ["Language Settings", "Log Out", "Data Deletion"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingView.tableView.delegate = self
        settingView.tableView.dataSource = self
        
        view.addSubview(settingView)
        
        NSLayoutConstraint.activate([
            settingView.topAnchor.constraint(equalTo: view.topAnchor),
            settingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            settingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func showLanguageOptions() {
        let alert = UIAlertController(title: "Choose Language", message: nil, preferredStyle: .actionSheet)
        // Example languages
        let languages = ["English", "Spanish", "French"]
        for language in languages {
            alert.addAction(UIAlertAction(title: language, style: .default, handler: { _ in
                // Set the language preferences
                print("Language set to \(language)")
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
            print("LogOut Success")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    private func deleteData() {
        // Perform data deletion logic
        print("Data deleted")
    }
}

// MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch settingsOptions[indexPath.row] {
        case "Language Settings":
            showLanguageOptions()
        case "Log Out":
            logOut()
        case "Data Deletion":
            deleteData()
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource
extension SettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: settingsOptions[indexPath.row])
        return cell
    }
}

