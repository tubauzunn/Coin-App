import UIKit

class CryptoCurrencyListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    var cryptocurrencies: [CryptoCurrency] = []
    var filteredCryptocurrencies: [CryptoCurrency] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        tableView.delegate = self
        tableView.dataSource = self
        setupSearchController()
        self.navigationItem.title = "Coin List"
    }
    
    func fetchData() {
        let url = URL(string: "https://psp-merchantpanel-service-sandbox.ozanodeme.com.tr/api/v1/dummy/coins")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("No data received: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(CryptoDataResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.cryptocurrencies = responseData.data.coins
                    self.filteredCryptocurrencies = self.cryptocurrencies
                    self.tableView.reloadData()
                }
                
            } catch let error {
                print("Error decoding data: ")
                print(error)
            }
        }.resume()
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cryptocurrencies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension CryptoCurrencyListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCryptocurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ctableiden") as? CTableCell {
            cell.configureCell(item: filteredCryptocurrencies[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCrypto = filteredCryptocurrencies[indexPath.row]
        let detailsVC = DetailsViewController()
        detailsVC.selectedCrypto = selectedCrypto
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension CryptoCurrencyListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty {
            filteredCryptocurrencies = cryptocurrencies.filter { cryptoCurrency in
                if let name = cryptoCurrency.name {
                    return name.lowercased().contains(searchText)
                }
                return false
            }
        } else {
            filteredCryptocurrencies = cryptocurrencies
        }
        tableView.reloadData()
    }
}

