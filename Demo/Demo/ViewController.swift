//
//  ViewController.swift
//  Demo
//
//  Created by Andreas Verhoeven on 16/05/2021.
//

import UIKit

class Z: UICollectionViewFlowLayout {
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}
}

class ViewController: UIViewController {
	let collectionView = CustomPageableCollectionView(frame: .zero, collectionViewLayout: Z())

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground

		let layout = Z()
		layout.scrollDirection = .horizontal
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		layout.sectionInset = .zero
		layout.itemSize = CGSize(width: 178 + 16, height: 700)


		// this is where the magic happens
		collectionView.pagingConfiguration.size = .absolute(width: 178 + 16)
		collectionView.pagingConfiguration.alignment = .centerX

		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.collectionViewLayout = layout
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
		collectionView.collectionViewLayout = layout
		collectionView.backgroundColor = .clear
		collectionView.frame = CGRect(origin: .zero, size: view.bounds.size)
		collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.addSubview(collectionView)
		
		let centerLine = UIView()
		centerLine.backgroundColor = .red
		centerLine.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(centerLine)
		centerLine.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
		centerLine.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
		centerLine.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
		centerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true

	}
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
		cell.contentView.backgroundColor = UIColor(red: CGFloat.random(in: 0..<1), green: CGFloat.random(in: 0..<1), blue: CGFloat.random(in: 0..<1), alpha: 1)
		
		if cell.contentView.subviews.count == 0 {
			let centerLine = UIView()
			centerLine.backgroundColor = .blue
			centerLine.translatesAutoresizingMaskIntoConstraints = false
			cell.contentView.addSubview(centerLine)
			centerLine.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor).isActive = true
			centerLine.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor).isActive = true
			centerLine.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
			centerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		self.collectionView.scrollToPageForItem(with: indexPath, animated: true)
	}
}
