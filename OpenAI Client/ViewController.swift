//
//  ViewController.swift
//  OpenAI Client
//
//  Created by Gavin Ryder on 1/16/23.
//

import UIKit
import SwiftUI


class ViewController: UIViewController, UITableViewDataSource {
    
    private let field: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter query here..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray
        textField.layer.cornerRadius = 10
        let paddingView = UIView(frame: CGRectMake(0, 0, 5, textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = UITextField.ViewMode.always
        textField.returnKeyType = .send
        return textField
    }()
    
    private var dialogueEntries = [DialogueEntry]()
    
    private let table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let loadingView: UIView = {
       let host = UIHostingController(rootView: ResponseProgressView())
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.isHidden = true
        return host.view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        field.delegate = self
        view.addSubview(field)
        view.addSubview(table)
        view.addSubview(loadingView)
        table.delegate = self
        table.dataSource = self
        
        
        NSLayoutConstraint.activate([
            field.heightAnchor.constraint(equalToConstant: 50),
            field.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            field.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            field.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -5),
            
            table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            table.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.bottomAnchor.constraint(equalTo: field.topAnchor),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
        ])
    }


}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogueEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = UIListContentConfiguration.cell()
        let dialogueEntry = dialogueEntries[indexPath.row]
        if case .query(_) = dialogueEntry {
            config.textProperties.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            config.textProperties.color = .white
        } else if case .response(_) = dialogueEntry {
            config.textProperties.font = UIFont.systemFont(ofSize: 14, weight: .thin)
            config.textProperties.color = .white
        }
        config.text = stringForDialogue(dialogueEntry)
        config.textProperties.numberOfLines = 0
        cell.contentConfiguration = config
        return cell
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let input = textField.text, !input.isEmpty {
            print("Submitting: \(input)")
            DispatchQueue.main.async {
                self.loadingView.isHidden = false
                self.field.text = nil
            }
            APICaller.shared.getResponse(input: input, completion: { [weak self] result in
                switch result {
                case .success(let output):
                    print(output)
                    self?.dialogueEntries.append(.query(input))
                    self?.dialogueEntries.append(.response(output))
                    DispatchQueue.main.async {
                        self?.table.reloadData()
                        self?.loadingView.isHidden = true

                    }
                case .failure:
                    print("***API Call Failed!")
                }
            })
        } else {
            print("Not valid entry!")
            return false
        }
        return true
    }
}

