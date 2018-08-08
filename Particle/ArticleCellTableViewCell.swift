//
//  ArticleCellTableViewCell.swift
//  Particle
//
//  Created by Artem Misesin on 6/25/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

final class ArticleCellTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with article: ParticleReading, at indexRow: Int, searchStatus: SearchStatus) {
        if let articleTitle = article.title {
            mainLabel.text = articleTitle
        } else {
            mainLabel.text = Constants.unknownTitle
        }
        if let articleURL = article.url {
            secondaryLabel.text = crop(url: articleURL)
        } else {
            secondaryLabel.text = Constants.unknownLink
        }
        if let imgData = article.thumbnail {
            mainImage.image = UIImage(data: imgData as Data)
        } else {
            mainImage.image = UIImage()
        }
        if indexRow == 0 {
            let height = 1 / UIScreen.main.scale
            let line = UIView(frame: CGRect(x: 15, y: 0, width: bounds.width - 30, height: height))
            line.backgroundColor = Colors.separatorColor
            addSubview(line)
        }
        setupColors(for: searchStatus)
    }
    
    private func setupViews() {
        backgroundColor = .white
        separatorInset.right = 16
        separatorInset.left = 16
        //mainImage.layer.cornerRadius = 4
        mainImage.contentMode = .scaleAspectFill
        mainImage.clipsToBounds = true
        mainLabel.textAlignment = .left
        secondaryLabel.textAlignment = .left
    }
    
    private func setupColors(for searchStatus: SearchStatus) {
        switch searchStatus {
        case .active(let range):
            mainLabel.textColor = Colors.desaturatedHeaderColor
            guard let text = mainLabel.text else { return }
            let attributedString = NSMutableAttributedString(string: text, attributes:
                [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)])
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: Colors.headerColor, range: range)
            mainLabel.attributedText = attributedString
        case .nonActive:
            mainLabel.textColor = Colors.headerColor
        }
        secondaryLabel.textColor = Colors.subHeaderColor
    }
    
    private func crop(url: String) -> String {
        
        if let startRange = url.range(of: "://") {
            let tempString = String(url[startRange.upperBound..<url.endIndex])
            if let endRange = tempString.range(of: "/") {
                let shortURL = String(tempString[tempString.startIndex..<endRange.lowerBound])
                return shortURL
            }
        }
        return url
    }

}
