//
//  ViewController.swift
//  AsyncAwaitExample
//
//  Created by SeungMin on 12/31/23.
//

import UIKit

enum ButtonState {
    case normal, selected
}

class ViewController: UIViewController {
    let postTableViewModel = PostTableViewModel()
    var buttonState: ButtonState = .normal
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("오른쪽", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .blue
        button.addTarget(self,
                         action: #selector(clickedButton(_:)),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var postTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self,
                           forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        fetchPosts()
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        
        view.addSubview(button)
        view.addSubview(postTableView)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 80),
            
            postTableView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            postTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            postTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            postTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    func fetchPosts() {
        // MainActor 사용 코드
        Task.detached(priority: .background) { [weak self] in
            await self?.postTableViewModel.request(requestType: .post)
            
            await MainActor.run { [weak self] in
                self?.postTableView.reloadData()
            }
        }
        
        // DispatchQueue main 사용 코드
//        Task.detached(priority: .background) { [weak self] in
//            await self?.postTableViewModel.request(requestType: .post)
//            
//            DispatchQueue.main.async { [weak self] in
//                self?.postTableView.reloadData()
//            }
//        }
    }
    
    @objc func clickedButton(_ sender: UIButton) {
        if buttonState == .normal {
            buttonState = .selected
            button.setTitle("왼쪽", for: .normal)
            postTableView.reloadData()
        } else {
            Task {
                fetchPosts()
            }
            buttonState = .normal
            button.setTitle("오른쪽", for: .normal)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if buttonState == .normal {
            return postTableViewModel.posts.count
        } else {
            return postTableViewModel.filteredPosts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if buttonState == .normal {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier,
                                                     for: indexPath) as! PostTableViewCell
            cell.label.text = postTableViewModel.posts[indexPath.row].title
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier,
                                                     for: indexPath) as! PostTableViewCell
            cell.label.text = postTableViewModel.filteredPosts[indexPath.row].title
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

