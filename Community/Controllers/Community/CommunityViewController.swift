//
//  CommunityViewController.swift
//  Community
//
//  Created by Kevin Gu on 10/13/17.
//  Copyright © 2017 kgulabs. All rights reserved.
//

import UIKit

class CommunityViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    var currCommunties: [String] = ["Renewal", "Sunnyvale Community Group"]
    var communities: [String] = []
    var allCommunities: [String] = ["Radiance", "Renewal", "Sunnyvale Community Group"]
    let communityId = "communityId"
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Search for a community by name"
        return textField
    }()
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let plusImageView: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("+", for: .normal)
        return button
    }()
    
    let noCommunityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You are not in a community"
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        return label
    }()
    
    var addNavigationButton: UIBarButtonItem!
    var cancelNavigationButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.titleView = inputsContainerView
        inputsContainerView.addSubview(searchTextField)
        collectionView?.backgroundColor = .white
        searchTextField.delegate = self
        
        // Set up collection View
        collectionView?.delegate   = self
        collectionView?.dataSource = self
        collectionView?.register(CommunityCell.self, forCellWithReuseIdentifier: communityId)
        
        setupCommunityView(newCommunities: currCommunties, noCommunityMsg: "")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        collectionView?.addGestureRecognizer(tap)
        
        // Setup Navigation items
        cancelNavigationButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelTapped(_:)))
        cancelNavigationButton.tintColor = .white
        addNavigationButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addTapped(_:)))
        addNavigationButton.tintColor = .white
        navigationItem.rightBarButtonItem = addNavigationButton
        
        setupInputContainerView()
        setupSearchTextfield()
        collectionView!.addSubview(noCommunityLabel)
        collectionView!.bringSubview(toFront: noCommunityLabel)
        setupNoCommunityLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupInputContainerView()
        setupSearchTextfield()
    }
    
    func setupCommunityView(newCommunities: [String], noCommunityMsg: String) {
        self.communities = newCommunities
        collectionView!.reloadData()
        if self.communities.count == 0 {
            if noCommunityMsg != "" {
                noCommunityLabel.text = noCommunityMsg
            }
            noCommunityLabel.isHidden = false
            collectionView!.addSubview(noCommunityLabel)
            collectionView!.bringSubview(toFront: noCommunityLabel)
            setupNoCommunityLabel()
        }
        else {
            noCommunityLabel.isHidden = true
        }
    }
    
    func setupNoCommunityLabel() {
        noCommunityLabel.centerXAnchor.constraint(equalTo: collectionView!.centerXAnchor).isActive = true
        noCommunityLabel.topAnchor.constraint(equalTo: collectionView!.topAnchor).isActive = true
        noCommunityLabel.widthAnchor.constraint(equalTo: collectionView!.widthAnchor, constant: -24).isActive = true
        noCommunityLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupInputContainerView() {
        inputsContainerView.centerYAnchor.constraint(equalTo: navigationController!.navigationBar.centerYAnchor).isActive = true
        inputsContainerView.leftAnchor.constraint(equalTo: navigationController!.navigationBar.leftAnchor, constant: 12).isActive = true
        inputsContainerView.heightAnchor.constraint(equalTo: navigationController!.navigationBar.heightAnchor, constant:-12).isActive = true
        inputsContainerView.rightAnchor.constraint(lessThanOrEqualTo: navigationController!.navigationBar.rightAnchor).isActive = true
    }
    
    func setupSearchTextfield() {
        searchTextField.leftAnchor.constraint(lessThanOrEqualTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        searchTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        searchTextField.bottomAnchor.constraint(equalTo: inputsContainerView.bottomAnchor).isActive = true
        searchTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
    }
    
    // MARK: Button Delegates
    
    @objc
    func addTapped(_ sender: UIBarButtonItem){
        self.navigationController?.pushViewController(CreateCommunityViewController(), animated: true)
    }
    
    @objc
    func cancelTapped(_ sender: UIBarButtonItem){
        setupCommunityView(newCommunities: currCommunties, noCommunityMsg: "You are not in a community")
        navigationItem.rightBarButtonItem = addNavigationButton
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
    }
    
    @objc
    func dismissKeyboard(_ sender: UIButton) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: CollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return communities.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: communityId, for: indexPath) as! CommunityCell
        cell.name = communities[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height:50)
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 12)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
    
    // MARK: Text View Delegate Functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Set up collection View
        let msg = "No Community Found"
        setupCommunityView(newCommunities: filterStrings(strings: allCommunities, keyword: textField.text!), noCommunityMsg: msg)
        cancelNavigationButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelTapped(_:)))
        cancelNavigationButton.tintColor = .white
        navigationItem.rightBarButtonItem = cancelNavigationButton
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let msg = "No Community Found"
        setupCommunityView(newCommunities: filterStrings(strings: allCommunities, keyword: textField.text!), noCommunityMsg: msg)
        return false
    }
    
}