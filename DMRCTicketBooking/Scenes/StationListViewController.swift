//
//  StationListViewController.swift
//  DMRCTicketBooking
//
//  Created by Ahmad Waqas on 28/10/20.
//

import UIKit
protocol StationListViewControllerDelegate: class {
  func stationListViewControllerDidSelectStation(_ selectedStation: Metro?)
}
class StationListViewController: UIViewController {
    weak var listDelegate: StationListViewControllerDelegate?
    //MARK: Private properties
    private let table: UITableView = UITableView()
    private var stations: [Metro] = []
    var selectedStation: Metro? {
        didSet {
            if (selectedStation != nil) {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }

    /// Search controller to help us with filtering items in the table view.
    var searchController: UISearchController!
    var filteredStations: [Metro] = []

    /// Helps to intiate network call with search string
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    var searchResult:  [Metro] = []

    private func setupSearchController()
    {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        // Place the search bar in the navigation bar.
        navigationItem.searchController = searchController
        // Make the search bar always visible.
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Stations"
        definesPresentationContext = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStations()
        setupTableView()
        setupSearchController()
        setupNavigationbar()
    }
    // MARK: Object lifecycle
    init(title: String? ){
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("Storyboards/Xibs deliberately not used in this project")
    }
    fileprivate func setupTableView() {
        view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        table.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.estimatedRowHeight = 100
        table.delegate = self
        table.dataSource = self
    }
    
    fileprivate func setupNavigationbar() {
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        self.navigationItem.rightBarButtonItem = done
        //to invoke didSet manually
        self.selectedStation = { self.selectedStation }()
    }
    @objc func doneTapped(){
        self.listDelegate?.stationListViewControllerDidSelectStation(selectedStation ?? nil)
    }
    fileprivate func fetchStations() {
        let metroLocalData = MetroLocalStore()
        let metroFetchWorker = MetroFetchWorker(metroStore: metroLocalData)
        metroFetchWorker.fetchMetroStations { (result) in
            switch result {
                case .success(let metros): do {
                    self.stations = metros
                    self.table.reloadData()
                }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
      filteredStations = stations.filter { (metro: Metro) -> Bool in
        return metro.name.lowercased().contains(searchText.lowercased())
      }
        table.reloadData()
    }
}

extension StationListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text?.removeAll()
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    }
}
extension StationListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
      if isFiltering {
        return filteredStations.count
      }
        
      return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let metro:Metro
        if isFiltering {
            metro = filteredStations[indexPath.row]
        } else {
            metro = stations[indexPath.row]
        }
        if (metro == selectedStation) {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        cell.textLabel?.text = metro.name
        cell.detailTextLabel?.text = metro.detail
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        let metro:Metro
        if isFiltering {
            metro = filteredStations[indexPath.row]
        } else {
            metro = stations[indexPath.row]
        }
        self.selectedStation = metro
        tableView.reloadData()
       // self.listDelegate?.stationListViewControllerDidSelectStation(metro)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
}

extension StationListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}

