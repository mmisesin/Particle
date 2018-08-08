//
//  ArticleContentTableViewCell.swift
//  Particle
//
//  Created by Artem Misesin on 7/19/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

final class ArticleContentTableViewCell: UITableViewCell {
    
    var readerController: ReaderViewController?
    weak var delegate: TranslateWordDelegate?
    private var menuController: UIMenuController?
    var prevSelectedRange = UITextRange()
    private var selectedDefinition: Definition?
    
    private var selectionView: UIView = {
        let wordHighlightView = UIView()
        wordHighlightView.backgroundColor = Colors.mainColor
        wordHighlightView.alpha = 0.3
        wordHighlightView.layer.cornerRadius = 5
        return wordHighlightView
    }()
    
    @IBOutlet weak var figureImage: UIImageView?
    @IBOutlet weak var figureCaption: UILabel?
    @IBOutlet weak var paragraphView: UITextView?
    @IBOutlet weak var quoteLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnTextView(_:)))
        tap.delegate = self
        paragraphView?.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(with paragraph: ArticleParagraph) {
        figureImage?.isHidden = true
        figureCaption?.isHidden = true
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        var font = UIFont.systemFont(ofSize: 17)
        var textColor = UIColor.black
        var lineSpacing: CGFloat = 5.0
        var textInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        quoteLine.isHidden = true
        switch paragraph.styleTag {
        case .blockquote:
            textInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            lineSpacing = 5
            font = UIFont.italicSystemFont(ofSize: 17)
            textColor = Colors.quoteColor
            quoteLine.isHidden = false
        case .h1:
            font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.bold)
        case .h2:
            font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.bold)
        case .h3:
            font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        case .h4:
            font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.bold)
        default: break
        }
        paragraphView?.textContainerInset = textInsets
        paragraphStyle.lineSpacing = lineSpacing
        let attributedString = NSMutableAttributedString(string: paragraph.content, attributes: [NSAttributedStringKey.font: font])
        let attributedRange = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttributes(
            [NSAttributedStringKey.paragraphStyle: paragraphStyle,
             NSAttributedStringKey.foregroundColor: textColor],
            range: attributedRange)
        paragraphView?.attributedText = attributedString
    }
    
    @objc private func tapOnTextView(_ tapGesture: UITapGestureRecognizer) {
        selectionView.removeFromSuperview()
        let point = tapGesture.location(in: paragraphView)
        guard let range = getRange(at: point), range != prevSelectedRange else {
            removeSelection()
            return
        }
        prevSelectedRange = range
        guard let word = getWord(in: range) else {
            return
        }
        guard let rect = self.paragraphView?.firstRect(for: range) else {
            return
        }
        self.addSelection(in: rect)
        Translator.shared.translate(word) { translation in
            guard
                let definition = translation?.definitions.first
            else {
                return
            }
            self.selectedDefinition = definition
            DispatchQueue.main.async {
                self.setupMenu(withWord: definition.translations.first?.text)
                self.showMenu(from: rect)
            }
        }
    }
    
    private func addSelection(in rect: CGRect) {
        if readerController?.selectedParagraph == nil {
            readerController?.selectedParagraph = self
        }
        if let selectedCell = readerController?.selectedParagraph, selectedCell != self {
            selectedCell.removeSelection()
            readerController?.selectedParagraph = self
        }
        let newRect = CGRect(x: rect.minX - 2, y: rect.minY, width: rect.width + 4, height: rect.height)
        selectionView.frame = newRect
        paragraphView?.addSubview(selectionView)
    }
    
    func removeSelection() {
        selectionView.removeFromSuperview()
        menuController?.setMenuVisible(false, animated: true)
        menuController = nil
        prevSelectedRange = UITextRange()
    }
    
    @objc private func showTranslateVC() {
        guard let definition = selectedDefinition else { return }
        delegate?.didTapOn(definition: definition)
    }
    
}

// MARK: Parsing data from tap

extension ArticleContentTableViewCell {
    
    private final func getWord(in range: UITextRange) -> String? {
        return paragraphView?.text(in: range)
    }
    
    private final func getRange(at position: CGPoint) -> UITextRange? {
        if let textPosition = paragraphView?.closestPosition(to: position) {
            guard let range = paragraphView?.tokenizer.rangeEnclosingPosition(textPosition, with: .word, inDirection: 1) else {
                return nil
            }
            return range
        } else {
            return nil
        }
    }
}

// MARK: Menu-related methods

extension ArticleContentTableViewCell {
    private func setupMenu(withWord word: String?) {
        menuController = UIMenuController.shared
        let translateMenuItem = UIMenuItem(title: word ?? "", action: #selector(translateAction))
        let copyMenuItem = UIMenuItem(title: "Copy", action: #selector(copyAction))
        let shareMenuItem = UIMenuItem(title: "Share", action: #selector(shareAction))
        self.menuController?.menuItems = [translateMenuItem, copyMenuItem, shareMenuItem]
        menuController?.arrowDirection = .down
    }
    
    private func showMenu(from rect: CGRect) {
        becomeFirstResponder()
        menuController?.setTargetRect(rect, in: self)
        menuController?.setMenuVisible(true, animated: true)
        setNeedsDisplay()
    }
    
    @objc func translateAction() {
        showTranslateVC()
    }
    
    @objc func copyAction() {
        
    }
    
    @objc func shareAction() {
        
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case #selector(ArticleContentTableViewCell.translateAction),
             #selector(ArticleContentTableViewCell.copyAction),
             #selector(ArticleContentTableViewCell.shareAction):
            return true
        default:
            return false
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
