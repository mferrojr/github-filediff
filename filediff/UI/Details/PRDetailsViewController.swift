//
//  PRDetailsViewController.swift
//  filediff
//
//  Created by Michael Ferro on 7/10/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import Foundation
import UIKit

final class PRDetailsViewController: UIViewController {
    
    //MARK: - Variables
    
    //MARK: Public
    weak var coordinator: MainCoordinator?

    //MARK: Private
    private var entity: GitHubPREntity
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var viewDiffBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(.localize(.viewDiff), for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.addTarget(self, action:#selector(self.viewDiffPressed), for: .touchUpInside)
        return btn
    }()
    
    private let MARGIN: CGFloat = 20
    
    // MARK: - Initialization
    init(entity: GitHubPREntity) {
        self.entity = entity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpScrollView()
        self.setUpStackView()
        self.setUp(label: self.titleLabel)
        self.setUp(label: self.descriptionLabel, hasTopMargin: false)
        self.setUpViewDiffButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "PR #\(self.entity.number)"
        self.titleLabel.text = self.entity.title
        self.descriptionLabel.text = self.entity.body
    }
    
    // MARK: - Functions
    
    // MARK: Public
    
    // MARK: Private
    @objc
    private func viewDiffPressed(_ sender: UIButton) {
        self.coordinator?.viewPullRequestDiff(entity: self.entity)
    }
    
    private func setUpScrollView() {
        self.view.addSubview(self.scrollView)
        
        self.scrollView.leadingAnchor.constraint(
            equalTo: self.view.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(
            equalTo: self.view.trailingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(
            equalTo: self.view.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(
            equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func setUpStackView() {
        self.scrollView.addSubview(self.stackView)
        
        self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        self.stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }

    private func setUpViewDiffButton() {
        self.stackView.addArrangedSubview(self.viewDiffBtn)
    }
    
    private func setUp(label: UILabel, hasTopMargin: Bool = true) {
        let containerView = UIView()
        
        containerView.addSubview(label)

        label.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor, constant: MARGIN).isActive = true
        label.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor, constant: -MARGIN).isActive = true
        label.topAnchor.constraint(
            equalTo: containerView.topAnchor, constant: hasTopMargin ? MARGIN : 0).isActive = true
        label.bottomAnchor.constraint(
            equalTo: containerView.bottomAnchor, constant: -MARGIN).isActive = true

        self.stackView.addArrangedSubview(containerView)
    }
    
}

// MARK: - Extensions
