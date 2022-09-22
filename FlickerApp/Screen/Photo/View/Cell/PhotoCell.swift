//
//  PhotoCell.swift
//  FlickerApp
//
//  Created by Shrikant Mundhe on 19/09/2022.
//

import Foundation
import UIKit

class PhotoCell: UITableViewCell {
    @IBOutlet var photoID: UILabel!
    @IBOutlet var userIcon: UIImageView!
    @IBOutlet var tags: UILabel!
    @IBOutlet var photo: UIImageView!

    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    var cellViewModel: PhotoCellViewModel? {
        didSet {
            photoID.text = cellViewModel?.photoID
            setUserIcon()
            if let pictureUrl = cellViewModel?.photo,
               let url = URL(string: pictureUrl){
                photo.load(url: url)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    func initView() {
        // Cell view customization
        backgroundColor = .clear

        // Line separator full width
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }

    func setUserIcon() {
        if let farm = cellViewModel?.farm,
           let server = cellViewModel?.server,
           let owner = cellViewModel?.owner,
           let url = URL(string: "https://farm\(farm).staticflickr.com/\(server)/buddyicons/\(owner).jpg"){
            userIcon.load(url: url)
        }
    }
}



