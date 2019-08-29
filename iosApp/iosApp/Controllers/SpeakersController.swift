import Foundation
import UIKit
import KotlinConfAPI

class SpeakersController : UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var speakersList: UITableView!

    private var speakers: [SpeakerData] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        speakersList.dataSource = self
        speakersList.delegate = self

        Conference.speakers.onChange(block: { speakers in
            return self.onSpeakers(speakers: speakers as! [SpeakerData])
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.tintColor = UIColor.deepSkyBlue
    }

    func onSpeakers(speakers: [SpeakerData]) {
        self.speakers = speakers
        speakersList.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return speakers.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //speakers.count
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpeakerCell") as! SpeakerCellView
        cell.speaker = speakers[indexPath.section]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let board = UIStoryboard(name: "Main", bundle: nil)
        let controller = board.instantiateViewController(withIdentifier: "Speaker") as! SpeakerController

        let speaker = speakers[indexPath.section]
        controller.speaker = speaker

        self.navigationController?.pushViewController(controller, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white
    }
}

class SpeakerCellView : UITableViewCell {
    @IBOutlet weak var speakerName: UILabel!
    @IBOutlet weak var speakerPosition: UILabel!
    @IBOutlet weak var speakerPhoto: UIImageView!

    var speaker: SpeakerData! {
        didSet {
            speakerName.text = speaker.fullName.uppercased()
            speakerPosition.text = speaker.tagLine

            if let profilePicture = speaker.profilePicture {

                do {
                    let pictureUrl = URL(string: profilePicture)
                    speakerPhoto.image = UIImage(data: try Data(contentsOf: pictureUrl!))
                } catch {
                    print("Failed to load image: " + profilePicture)
                }
            }
        }
    }
}
