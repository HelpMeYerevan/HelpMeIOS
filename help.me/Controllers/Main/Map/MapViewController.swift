//
//  MapViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 11/17/21.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils
import Alamofire

public final class MapViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet private weak var mapMarkersFilterSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var filterByCategoriesTableView: UITableView!
    @IBOutlet private weak var filterByCategoriesTableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var filterByCategoriesActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var filterByCategoriesButton: UIButton!
    @IBOutlet private weak var workBackgroundView: UIView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var workView: UIView!
    @IBOutlet private weak var workImageView: UIImageView!
    @IBOutlet private weak var workImageActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var categoryNameLabel: UILabel!
    @IBOutlet private weak var createdDateLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var informationLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var acceptButton: UIButton!
    
    // MARK: Properties
    private lazy var clusterManager: GMUClusterManager = {
        let buckets: [NSNumber] = [10, 20, 30, 40, 50, 100, 200, 300, 400, 500]
        let backgroundImage: UIImage = .iconMarker ?? UIImage()
        let iconGenerator = GMUDefaultClusterIconGenerator(buckets: buckets, backgroundImages: [backgroundImage, backgroundImage, backgroundImage, backgroundImage, backgroundImage, backgroundImage, backgroundImage, backgroundImage, backgroundImage, backgroundImage])
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        let clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        clusterManager.setMapDelegate(self)
        return clusterManager
    }()
    private var coordinates: [WorkCoordinate]?
    private var categories: Categories?
    private var nearByMeCoordinates: [WorkCoordinate] {
        var nearByMeCoordinates = [WorkCoordinate]()
        var smallestDistance: CLLocationDistance?
        for location in coordinates ?? [] {
            if let currentDistance = currentLocation?.distance(from: CLLocation(latitude: location.lat ?? 0, longitude: location.long ?? 0)) {
                if let distance = smallestDistance {
                    if currentDistance < distance {
                        nearByMeCoordinates.append(location)
                        smallestDistance = currentDistance
                    }
                } else {
                    nearByMeCoordinates.append(location)
                    smallestDistance = currentDistance
                }
            }
        }
        return nearByMeCoordinates
    }
    private var filteredByCategoriesCoordinates: [WorkCoordinate] = []
    private var selectedMarker: GMSMarker?
    private var selectedWork: Work? {
        didSet {
            guard let selectedWork = selectedWork else { return }
            self.setImage(from: selectedWork)

        }
    }
    private var isLoadingCategories = false
    
    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCategoryView()
        setupTableView()
        getCategories()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMap()
    }
    
    // MARK: Methods
    public override func setupView() {
        mapMarkersFilterSegmentedControl.setBorder(withColor: .hex_C4C4C4, andWidth: 1)
    }
    
    private func setupMap() {
        view.addSubview(mapView)
        mapView.layer.zPosition = -1
        mapView.delegate = self
        view.bringSubviewToFront(workBackgroundView)
        view.bringSubviewToFront(filterByCategoriesTableView)
        view.bringSubviewToFront(mapMarkersFilterSegmentedControl)
        view.bringSubviewToFront(filterByCategoriesButton)
    }
    
    private func setupCategoryView() {
        workView.setCornerRadius(Constants.cornerRadius_10)
        acceptButton.setCornerRadius(Constants.cornerRadius_10)
    }
    
    private func setupMarkers() {
        clusterManager.clearItems()
        var coordinates = self.coordinates
        switch mapMarkersFilterSegmentedControl.selectedSegmentIndex {
            case 1: coordinates = nearByMeCoordinates
            case 2: coordinates = filteredByCategoriesCoordinates
            default: break
        }
        coordinates?.forEach({ coordinate in
            addMarker(for: coordinate)
        })
        clusterManager.cluster()
    }
    
    private func setupSelectedWork() {
        guard let selectedWork = selectedWork else { return }
        categoryNameLabel.text = selectedWork.translate?.name
        addressLabel.text = selectedWork.address
        priceLabel.text = selectedWork.price
        informationLabel.text = selectedWork.workDescription
    }
    
    private func setupTableView() {
        filterByCategoriesTableView.delegate = self
        filterByCategoriesTableView.dataSource = self
        filterByCategoriesTableView.register(SelectableSubcategoryTableViewCell.cellNibName, forCellReuseIdentifier: SelectableSubcategoryTableViewCell.cellIdentifier)
        filterByCategoriesTableView.contentInset = .init(top: 50, left: 0, bottom: 25, right: 0)
    }
    
    private func addMarker(for coordinate: WorkCoordinate) {
        guard let latitude = coordinate.lat, let longitude = coordinate.long else { return }
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        marker.icon = .iconMarker
        marker.userData = coordinate
        clusterManager.add(marker)
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        mapMarkersFilterSegmentedControl.setLocalizedString(.map_latest, index: 0)
        mapMarkersFilterSegmentedControl.setLocalizedString(.map_nearByMe, index: 1)
        mapMarkersFilterSegmentedControl.setLocalizedString(.map_byCategories, index: 2)
        acceptButton.setLocalizedString(.map_accept)
    }
    
    // MARK: Actions
    @IBAction private func mapSegmentedControlAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0, 1:
                mapView.isHidden = false
                UIView.animate(withDuration: Constants.animationDuration) {
                    if self.filterByCategoriesTableViewBottomConstraint.constant == 0 {
                        self.filterByCategoriesTableViewBottomConstraint.constant = -UIScreen.main.bounds.height
                    }
                    self.view.layoutIfNeeded()
                }
                setupMarkers()
            default: break
        }
    }
    
    @IBAction private func filterByCategoriesButtonAction(_ sender: UIButton) {
        mapMarkersFilterSegmentedControl.selectedSegmentIndex = 2
        UIView.animate(withDuration: Constants.animationDuration) {
            self.filterByCategoriesTableViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.mapView.isHidden = true
        }
    }
    
    @IBAction private func closeButtonAction(_ sender: UIButton) {
        selectedMarker?.icon = .iconMarker
        workBackgroundView.isHidden = true
    }
    
    @IBAction private func acceptButtonAction(_ sender: UIButton) {
        guard let selectedWork = selectedWork else { return }
        pushToOfferViewController(for: selectedWork)
    }
}

// MARK: Navigations
extension MapViewController {
    private func pushToOfferViewController(for work: Work) {
        guard let viewController = viewController(from: .main, withIdentifier: .offerViewController) as? OfferViewController else { return }
        viewController.setSelectedWork(work)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: Requests
extension MapViewController {
    private func getCoordinates(with categoryID: Int? = nil, completion: ((Bool) -> ())? = nil) {
        showActivityIndicator()
        NetworkManager.shared.getCoordinates(with: categoryID) { [weak self] response in
            guard let self = self else { return }
            if categoryID != nil {
                self.filteredByCategoriesCoordinates = response
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.setupMarkers()
                    self.hideActivityIndicator()
                    completion?(true)
                }
            } else {
                self.coordinates = response
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.setupMarkers()
                    self.hideActivityIndicator()
                    completion?(true)
                }
            }
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.hideActivityIndicator()
            completion?(false)
        }
    }
    
    private func getCurrentWork(with workID: Int) {
        showActivityIndicator()
        NetworkManager.shared.getCurrentCoordinate(with: workID) { [weak self] response in
            guard let self = self else { return }
            self.selectedWork = response.data
            self.setupSelectedWork()
            self.workBackgroundView.isHidden = false
            self.hideActivityIndicator()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.hideActivityIndicator()
        }
    }
    
    private func getCategories(for page: Int = 1) {
        isLoadingCategories = true
        NetworkManager.shared.getCategories(for: page) { [weak self] response in
            guard let self = self else { return }
            if self.categories != nil {
                self.categories?.updateData(with: response)
                ConfigDataProvider.categories?.updateData(with: response)
            } else {
                self.categories = response
                ConfigDataProvider.categories = response
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isLoadingCategories = false
                self.filterByCategoriesTableView.reloadData()
            }
            self.filterByCategoriesActivityIndicatorView.stopAnimating()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.isLoadingCategories = false
            self.filterByCategoriesActivityIndicatorView.stopAnimating()
        }
    }
    
    func setImage(from model: Work) {
        workImageView.image = UIImage()
        AF.request(model.imageURL).responseData { response in
            DispatchQueue.global(qos: .userInitiated).async {
                if let image = response.data {
                    model.originalImage = UIImage(data: image)
                    model.thumbnailImage = model.originalImage?.thumbnail
                    DispatchQueue.main.async {
                        self.workImageView.image = model.thumbnailImage
                        self.workImageActivityIndicatorView.stopAnimating()
                    }
                }
            }
        }
    }
}

// MARK: GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    public func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if coordinates == nil {
            getCoordinates()
        }
    }
    
    public func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let currentCoordinate = marker.userData as? WorkCoordinate {
            selectedMarker?.icon = .iconMarker
            selectedMarker = marker
            selectedMarker?.icon = .iconMarkerSelected
            if let workID = currentCoordinate.id {
                getCurrentWork(with: workID)
            }
        }
        return true
    }
    
    public func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        return nil
    }
}

// MARK: UITableViewDelegate
extension MapViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: UITableViewDataSource
extension MapViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.data?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let data = categories?.data, let currentPage = categories?.currentPage, let nextPage = categories?.nextPage, let lastPage = categories?.lastPage else { return }
        if !isLoadingCategories, data.count != 0, indexPath.item == data.count - 5, currentPage < lastPage {
            getCategories(for: nextPage)
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableSubcategoryTableViewCell.cellIdentifier, for: indexPath) as? SelectableSubcategoryTableViewCell, let category = categories?.data?[indexPath.row] else { return UITableViewCell() }
        cell.setData(from: category)
        cell.selectButtonDidTapped = { [weak self] in
            guard let self = self else { return }
            self.categories?.data?.forEach { category in
                category.isSelected = false
            }
            category.isSelected.toggle()
            self.filterByCategoriesTableView.reloadData()
            self.getCoordinates(with: category.id) { [weak self] isSuccess in
                guard let self = self else { return }
                if isSuccess {
                    self.mapView.isHidden = false
                    UIView.animate(withDuration: Constants.animationDuration) {
                        if self.filterByCategoriesTableViewBottomConstraint.constant == 0 {
                            self.filterByCategoriesTableViewBottomConstraint.constant = -UIScreen.main.bounds.height
                        }
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
        return cell
    }
}
