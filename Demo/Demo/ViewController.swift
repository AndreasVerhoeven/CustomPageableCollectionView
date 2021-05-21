//
//  ViewController.swift
//  Demo
//
//  Created by Andreas Verhoeven on 16/05/2021.
//

import UIKit

class ViewController: UIViewController {
	let collectionView = CustomPageableCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground

		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		layout.sectionInset = .zero
		layout.itemSize = CGSize(width: 320, height: 200)


		// this is where the magic happens
		collectionView.pagingConfiguration.size = .absolute(height: 200)
		collectionView.pagingConfiguration.alignment = .centerY

		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.collectionViewLayout = layout
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
		collectionView.collectionViewLayout = layout
		collectionView.backgroundColor = .clear
		collectionView.frame = CGRect(origin: .zero, size: view.bounds.size)
		collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.addSubview(collectionView)

	}
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 50
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
		cell.contentView.backgroundColor = UIColor(red: CGFloat.random(in: 0..<1), green: CGFloat.random(in: 0..<1), blue: CGFloat.random(in: 0..<1), alpha: 1)
		return cell
	}
}
