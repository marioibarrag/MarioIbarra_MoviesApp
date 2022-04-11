import Foundation
import UIKit

extension UILabel {
    func addSystemImage(imageName: String) {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(systemName: imageName)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text ?? "")
        strLabelText.append(attachmentString)
        
        self.attributedText = strLabelText
    }
}
