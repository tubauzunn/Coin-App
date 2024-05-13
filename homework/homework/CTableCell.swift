import Foundation
import UIKit

class CTableCell: UITableViewCell {
    @IBOutlet weak var cellLabel:UILabel!
    @IBOutlet weak var cellShortName:UILabel!
    @IBOutlet weak var cellPrice:UILabel!
    @IBOutlet weak var cellChange:UILabel!
    @IBOutlet weak var cellImage:UIImageView!

    func configureCell(item: CryptoCurrency) {
        cellLabel.text = item.name
        cellShortName.text = item.symbol
        cellPrice.text = item.price
        cellChange.text = item.change
        
        // Check if price is not nil
        if let priceString = item.price, let price = Double(priceString) {
            // Round price to 2 decimal places
            cellPrice.text = String(format: "$ %.2f", price)
        } else {
            cellPrice.text = "N/A" // or any default value you prefer
        }
        
        // Check if change is not nil
        if let changeString = item.change, let change = Double(changeString) {
            // Round change to 2 decimal places
            cellChange.text = String(format: "%.2f", change)
            
            // Set text color based on change
            if change >= 0 {
                cellChange.textColor = .green
            } else {
                cellChange.textColor = .red
            }
        } else {
            cellChange.text = "N/A" // or any default value you prefer
            cellChange.textColor = .black // Set default text color if change is nil
        }
        
        // Set placeholder image
        cellImage.image = UIImage(named: "coinIcon")
        
        if let iconUrl = item.iconUrl {
            // Güvenlik kontrolü: iconUrl boş olamaz
            let iconURLString = iconUrl.absoluteString
            if iconURLString.lowercased().hasSuffix(".svg") {
                let urlString = iconURLString.replacingOccurrences(of: ".svg", with: ".png")
                if let url = URL(string: urlString) {
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                // Check if the cell is still displaying the correct item
                                if self.cellImage.image == UIImage(named: "coinIcon") {
                                    self.cellImage.image = image
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
