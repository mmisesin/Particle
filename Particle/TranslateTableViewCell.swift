//
//  TranslateTableViewCell.swift
//  Particle
//
//  Created by Artem Misesin on 9/11/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class TranslateTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var translationLabel: UILabel!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var synonimsLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        
    }
    
    func setupForTranslation(_ translation: EntireTranslation, atIndexPath indexPath: IndexPath) {
        indexLabel.text = String(describing: indexPath.row + 1)
        translationLabel.text = translation.text ?? "Unknown"
        genderLabel.text = translation.gender ?? ""
        if let synonyms = translation.synonyms {
            var tempStrings = [String]()
            for synonym in synonyms {
                tempStrings.append(synonym.text ?? "")
            }
            synonimsLabel.text = tempStrings.joined(separator: ", ")
        } else {
            synonimsLabel.text = ""
        }
    }

}
