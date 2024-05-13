import UIKit

// Struct to represent historical prices
struct Sparkline {
    let date: String
    let value: String
}

class DetailsViewController: UIViewController {
    
   
    var selectedCrypto: CryptoCurrency?
    
    var historicalPrices: [Sparkline] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    // UI Elements
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    let changeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let historicalPricesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Historical Prices"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateUI()
        setupTableView()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add iconImageView to the main view
        view.addSubview(iconImageView)
        
        // Add nameLabel to the main view
        view.addSubview(nameLabel)
        
        // Add symbolLabel to the main view
        view.addSubview(symbolLabel)
        
        // Add priceLabel to the main view
        view.addSubview(priceLabel)
        
        // Add changeLabel to the main view
        view.addSubview(changeLabel)
        
        // Add historicalPricesLabel to the main view
        view.addSubview(historicalPricesLabel)
        
        // Add tableView to the main view
        view.addSubview(tableView)
        
        iconImageView.image = UIImage(named: "coinIcon")
        
        // Layout constraints
        NSLayoutConstraint.activate([
            // iconImageView constraints
            iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            iconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 100),
            iconImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // nameLabel constraints
            nameLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // symbolLabel constraints
            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            symbolLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            symbolLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            // priceLabel constraints
            priceLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 5),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            // changeLabel constraints
            changeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),
            changeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            changeLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            // historicalPricesLabel constraints
            historicalPricesLabel.topAnchor.constraint(equalTo: changeLabel.bottomAnchor, constant: 20),
            historicalPricesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // tableView constraints
            tableView.topAnchor.constraint(equalTo: historicalPricesLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func updateUI() {
        guard let selectedCrypto = selectedCrypto else { return }
        
        // Update UI elements with selected cryptocurrency data
        nameLabel.text = selectedCrypto.name
        symbolLabel.text = selectedCrypto.symbol
        
        if let iconUrl = selectedCrypto.iconUrl {
            URLSession.shared.dataTask(with: iconUrl) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.iconImageView.image = image
                    }
                }
            }.resume()
        }
        
        if let price = selectedCrypto.price,
           let priceValue = Double(price) {
           let priceStr = String(format: "%.2f", priceValue)
            
            if let highValue = Double(selectedCrypto.highVal), let lowValue = Double(selectedCrypto.lowVal) {
                let formattedHighValue = String(format: "%.2f", highValue)
                let formattedLowValue = String(format: "%.2f", lowValue)
                priceLabel.text = "Price: \(priceStr)\n(High: \(formattedHighValue) / Low: \(formattedLowValue))"
            } else {
                priceLabel.text = "Price: \(priceStr)"
            }
        }
        

        
        if let change = selectedCrypto.change {
            changeLabel.text = change
            if let changeValue = Double(change) {
                changeLabel.textColor = changeValue >= 0 ? .green : .red
            }
        }
        
        if let sparkline = selectedCrypto.sparkline {
            for (index, value) in sparkline.enumerated() {
                if let priceValue = Double(value) {
                    let formattedPrice = String(format: "%.2f", priceValue)
                    historicalPrices.append(Sparkline(date: "\(index)", value: formattedPrice))
                }
            }
        }
    }
    

    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: historicalPricesLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Set delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historicalPrices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let sparkline = historicalPrices[indexPath.row]
        cell.textLabel?.text = "\(sparkline.date): \(sparkline.value)"
        return cell
    }
}
