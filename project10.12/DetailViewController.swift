//
//  DetailViewController.swift
//  project10.12
//
//  Created by Karina Dolmatova on 07.11.2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedPhoto: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let selectedPhoto = selectedPhoto else { return }
        
        let path = getDocumentsDirectory().appendingPathComponent(selectedPhoto.filename)

        imageView.image = UIImage(contentsOfFile: path.path)
        captionLabel.text = selectedPhoto.caption
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
