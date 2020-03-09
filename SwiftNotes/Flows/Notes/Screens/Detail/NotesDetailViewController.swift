import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import UITextView_Placeholder
import SVProgressHUD
import CleanroomLogger

protocol NotesDetailViewControllerDelegate: class {
    func dismiss(_ viewController: NotesDetailViewController)
}

class NotesDetailViewController: UIViewController, StoryboardInstantiableType {
    public typealias VCType = NotesDetailViewController
    weak var delegate: NotesDetailViewControllerDelegate?
    var viewModel: NotesDetailViewModel!
    
    @IBOutlet weak var textArea: UITextView!
    
    var deleteButton: UIBarButtonItem?
    var saveButton: UIBarButtonItem?
    let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = nil
        setupStyle()
        loadBarButtons()
        setupDataBindings()
        
        textArea.text = viewModel.text
        if !viewModel.isEditing {
            textArea.becomeFirstResponder()
        }
    }
    
    func setupStyle() {
        navigationItem.largeTitleDisplayMode = .never
        textArea.placeholder = L10n.notePlaceholder
        textArea.placeholderColor = ColorName.placeholder.color
        textArea.tintColor = ColorName.mainTint.color
        textArea.textColor = ColorName.defaultText.color
    }
    
    func loadBarButtons() {
        if viewModel.isEditing {
            deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(onDelete))
            navigationItem.rightBarButtonItem = deleteButton
        }
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(onSave))
    }
    
    func setupDataBindings() {
        textArea.rx.didBeginEditing.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigationItem.setRightBarButtonItems([self.saveButton, self.deleteButton].compactMap { $0 }, animated: true)
        })
        .disposed(by: disposeBag)
        
        textArea.rx.didEndEditing.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigationItem.setRightBarButtonItems([self.deleteButton].compactMap { $0 }, animated: true)
        })
        .disposed(by: disposeBag)
    }
    
    // MARK: Actions
    @objc func onDelete() {
        showYesNoDialog(title: L10n.deleteNoteTitle, message: L10n.deleteNoteText, yes: L10n.yes, no: L10n.no, callback: { delete in
            if delete {
                self.deleteNote()
            }
        })
    }
    
    func deleteNote() {
        view.endEditing(true)
        
        SVProgressHUD.show(withStatus: L10n.deleting)
        viewModel.deleteNote(success: { [weak self] in
            SVProgressHUD.dismiss()
            
            guard let self = self else { return }
            self.delegate?.dismiss(self)
        }, error: { [weak self] in
            SVProgressHUD.dismiss()
            
            self?.showOkDialog(title: L10n.error, message: L10n.errorDeletingNote)
        })
    }
    
    @objc func onSave() {
        Log.debug?.message("Saving note")
        view.endEditing(true)
        
        SVProgressHUD.show(withStatus: L10n.sending)
        if viewModel.isEditing {
            viewModel.editNote(text: textArea.text, success: { _ in
                SVProgressHUD.dismiss()
            }, versionError: { [weak self] previousText in
                SVProgressHUD.dismiss()
                
                self?.processVersionError(previousText)
            }, error: { [weak self] in
                SVProgressHUD.dismiss()
                
                self?.showErrorMessage()
            })
        } else {
            viewModel.createNote(text: textArea.text, success: { [weak self] _ in
                SVProgressHUD.dismiss()
                
                guard let self = self else { return }
                self.delegate?.dismiss(self)
            }, error: { [weak self] in
                SVProgressHUD.dismiss()
                
                self?.showErrorMessage()
            })
        }
    }
    
    func processVersionError(_ previousText: String) {
        showYesNoDialog(title: L10n.noteChanged, message: L10n.errorNoteChanged, yes: L10n.saveThisNote, no: L10n.reloadFromServer, callback: { save in
            if save {
                self.forceSave()
            } else {
                self.reloadNote(previousText)
            }
        })
    }
    
    func forceSave() {
        SVProgressHUD.show(withStatus: L10n.sending)
        viewModel.forceEditNote(text: textArea.text, success: { _ in
            SVProgressHUD.dismiss()
        }, error: { [weak self] in
            SVProgressHUD.dismiss()
            
            self?.showErrorMessage()
        })
    }
    
    func reloadNote(_ text: String) {
        viewModel.replaceNoteTitle(text)
        textArea.text = text
    }
    
    func showErrorMessage() {
        showOkDialog(title: L10n.error, message: L10n.errorSavingNote) { [weak self] in
            self?.textArea.becomeFirstResponder()
        }
    }
}
