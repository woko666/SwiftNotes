import Foundation
import UIKit

class NoteCell: UITableViewCell {
    @IBOutlet weak var noteText: UILabel!
    
    static var Identifier: String {
        return "NoteCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        noteText.textColor = ColorName.defaultText.color
    }
    var viewModel: NoteViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }

            noteText.text = viewModel.title.replacingOccurrences(of: "\n", with: " ")
            
            accessoryType = .disclosureIndicator
        }
    }    
}
