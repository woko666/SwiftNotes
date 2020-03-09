import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import SVProgressHUD
import CleanroomLogger

protocol NotesListViewControllerDelegate: class {
    func editNote(_ note: NoteViewModel, viewController: NotesListViewController)
    func newNote(_ viewController: NotesListViewController)
}

class NotesListViewController: UIViewController, StoryboardInstantiableType {
    public typealias VCType = NotesListViewController
    weak var delegate: NotesListViewControllerDelegate?
    var viewModel: NotesListViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    let search = UISearchController(searchResultsController: nil)
    
    let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = L10n.notes
        loadBarButtons()
        setupDataBindings()
        setupStyle()
        viewModel.loadValues()
    }
    
    func loadBarButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "add_circle").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(onAdd))
    }
    
    lazy var tableSource: RxTableViewSectionedAnimatedDataSource<NotesListSection> = {
        return RxTableViewSectionedAnimatedDataSource<NotesListSection>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                           reloadAnimation: .fade,
                                                           deleteAnimation: .left),
            configureCell: { ds, tv, ip, item in
                guard let cell = tv.dequeueReusableCell(withIdentifier: NoteCell.Identifier, for: ip) as? NoteCell else { return UITableViewCell() }
                cell.viewModel = item
                return cell
            },
            titleForHeaderInSection: { ds, index in
                if ds.sectionModels.count == 1 {
                    return nil
                }
                return ds.sectionModels[index].header
            },
            canEditRowAtIndexPath: { _, _ in true }
        )
    }()
    
    func setupDataBindings() {
        // table view data
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.output.notes.bind(to: tableView.rx.items(dataSource: tableSource)).disposed(by: disposeBag)
        
        // table view actions
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.tableView.deselectRow(at: indexPath, animated: false)
            
            let note = self.tableSource[indexPath]
            self.delegate?.editNote(note, viewController: self)
            
        }).disposed(by: disposeBag)
        
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            
            let note = self.tableSource[indexPath]
            self.deleteNote(note.id)
        }).disposed(by: disposeBag)
        
        // refresh control
        refreshControl.rx.controlEvent(.valueChanged).asDriver().drive(viewModel.input.refreshNotes).disposed(by: disposeBag)
        
        viewModel.output.isLoading.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            Log.debug?.message("isLoading:", isLoading)
            if !isLoading {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
        }).disposed(by: disposeBag)
        
        // search
        navigationItem.searchController = search
        search.searchBar.rx.text.orEmpty
            .asDriver()
            .throttle(.milliseconds(200))
            .distinctUntilChanged()
            .drive(viewModel.input.search)
            .disposed(by: disposeBag)
    }
    
    func setupStyle() {
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .all
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
        
        let attributes = [NSAttributedString.Key.foregroundColor: ColorName.mainTint.color]
        refreshControl.attributedTitle = NSAttributedString(string: L10n.pullToRefresh, attributes: attributes)
        refreshControl.tintColor = ColorName.lightTint.color
        
        search.obscuresBackgroundDuringPresentation = false
        search.dimsBackgroundDuringPresentation = false
    }
    
    // MARK: Actions
    @objc func onAdd() {
        delegate?.newNote(self)
    }
    
    func deleteNote(_ id: Int) {
        SVProgressHUD.show(withStatus: L10n.deleting)
        viewModel.deleteNote(id: id, success: {
            SVProgressHUD.dismiss()
        }, error: { [weak self] in
            SVProgressHUD.dismiss()
            
            self?.showOkDialog(title: L10n.error, message: L10n.errorDeletingNote)
        })
    }
}

// MARK: UITableViewDelegate
extension NotesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.contentView.backgroundColor = ColorName.lightTint.color
        (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = ColorName.defaultText.color
    }
}
