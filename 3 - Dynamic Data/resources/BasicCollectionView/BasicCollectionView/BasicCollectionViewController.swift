import UIKit

private let reuseIdentifier = "Cell"

private let items = [
    "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware",
    "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky",
    "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri",
    "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York",
    "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island",
    "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington",
    "West Virginia", "Wisconsin", "Wyoming"
]

class BasicCollectionViewController: UICollectionViewController {
	enum Section: CaseIterable {
		case main
	}
	
	let searchController = UISearchController()
	var filteredItems: [String] = items
	var dataSource: UICollectionViewDiffableDataSource<Section, String>!
	var filteredItemsSnapshot: NSDiffableDataSourceSnapshot<Section, String> {
		var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
		
		snapshot.appendSections([.main])
		snapshot.appendItems(filteredItems)
		
		return snapshot
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.searchController = searchController
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchResultsUpdater = self
		navigationItem.hidesSearchBarWhenScrolling = false
		
		collectionView.setCollectionViewLayout(generateLayout(), animated: false)
		collectionView.register(BasicCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		
		createDataSource()
	}
	
	func createDataSource() {
		let cellRegistration = UICollectionView.CellRegistration<BasicCollectionViewCell, String> { cell, indexPath, itemIdentifier in
			cell.label.text = itemIdentifier
		}
		dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier -> BasicCollectionViewCell? in
			return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
		}
		
		dataSource.apply(filteredItemsSnapshot)
	}
	
	private func generateLayout() -> UICollectionViewLayout {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .fractionalHeight(1.0)
		)
		
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let spacing: CGFloat = 10.0
		
		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .absolute(70.0)
		)
		
		let group = NSCollectionLayoutGroup.horizontal(
			layoutSize: groupSize,
			subitem: item,
			count: 1
		)
		
		group.contentInsets = NSDirectionalEdgeInsets(
			top: spacing,
			leading: spacing,
			bottom: 0,
			trailing: spacing
		)
		
		let section = NSCollectionLayoutSection(group: group)
		
		let layout = UICollectionViewCompositionalLayout(section: section)
		
		return layout
	}
}

extension BasicCollectionViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		if let searchString = searchController.searchBar.text,
		   !searchString.isEmpty {
			filteredItems = items.filter { $0.localizedCaseInsensitiveContains(searchString)
			}
		} else {
			filteredItems = items
		}
		dataSource.apply(filteredItemsSnapshot, animatingDifferences: true)
	}
}
