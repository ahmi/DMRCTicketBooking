//
//  DashboardViewController.swift
//  DMRCTicketBooking
//
//  Created by Ahmad Waqas on 28/10/20.
//

import UIKit

class DashboardViewController: UIViewController {

    private let btnSelectInitial : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.init(light: .titleColorforLight, dark: .titleColorforDark), for: .normal)
        btn.setTitle("Select Initial Station", for: .normal)
        btn.addTarget(self, action: #selector(btnDestinationTapped), for: .touchUpInside)
        btn.tag = 1
        return btn
    }()
    
    private let btnSelectDestination : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.init(light: .titleColorforLight, dark: .titleColorforDark), for: .normal)
        btn.setTitle("Select Destination", for: .normal)
        btn.addTarget(self, action: #selector(btnDestinationTapped), for: .touchUpInside)
        btn.tag = 2
        return btn
    }()
    private let btnShare : UIButton = {
        let btn = UIButton()
        btn.titleLabel?.textColor = .init(light: .titleColorforLight, dark: .titleColorforDark)
        btn.titleLabel?.text = "Share"
        btn.addTarget(self, action: #selector(btnDestinationTapped), for: .touchUpInside)
        btn.tag = 3
        return btn
    }()
    
    private let stackButtons : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.backgroundColor = .blue
        return stackView
    }()
    private let stackPrice : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    private let priceLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(light: .titleColorforLight, dark: .titleColorforDark)
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let mapView : UIView = {
        let map = UIView()
        map.backgroundColor = .init(light: .gray, dark: .lightText)

        return map
    }()

    @objc private func btnDestinationTapped(sender: UIButton) {
        print ("btn tapped \(sender.tag)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    fileprivate func setupSelectStationViews() {
        stackButtons.addArrangedSubview(btnSelectInitial)
        stackButtons.addArrangedSubview(btnSelectDestination)
        view.addSubview(stackButtons)
        
        stackButtons.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    fileprivate func setupView() {
        setupSelectStationViews()
        setupPriceStackView()
       // setupMapView()
      //  setupTableView()
    }
    func setupPriceStackView(){
    let stackView = UIStackView(arrangedSubviews:[priceLabel,btnShare])
           stackView.translatesAutoresizingMaskIntoConstraints = false
           stackView.distribution = .fillEqually
           stackView.axis = .vertical
           stackView.spacing = 10
        stackView.backgroundColor = .green
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: stackButtons.bottomAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
    }
    fileprivate func setupMapView(){
        
    }
}
