//
//  ViewController.swift
//  project10.12
//
//  Created by Karina Dolmatova on 07.11.2024.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photo Gallery"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPhoto))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        loadPhotos()
    }
    
    @objc func addNewPhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Add a caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let caption = ac?.textFields?[0].text else { return }
            let photo = Photo(caption: caption, filename: imageName)
            self?.photos.append(photo)
            self?.savePhotos()
            self?.tableView.reloadData()
        })
        
        present(ac, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let photo = photos[indexPath.row]
        
        cell.textLabel?.text = photo.caption
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(photo.filename)
        cell.imageView?.image = UIImage(contentsOfFile: imagePath.path)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.selectedPhoto = photos[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func savePhotos() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(photos) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "photos")
        } else {
            print("Failed to save photos.")
        }
    }
    
    func loadPhotos() {
        let defaults = UserDefaults.standard
        if let savedPhotos = defaults.object(forKey: "photos") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                photos = try jsonDecoder.decode([Photo].self, from: savedPhotos)
            } catch {
                print("Failed to load photos.")
            }
        }
    }
}
