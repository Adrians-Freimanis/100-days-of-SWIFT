//
//  ViewController.swift
//  Project25
//
//  Created by adrians.freimanis on 03/08/2023.
//
//
import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate {

    var images = [UIImage]()
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!

    override func viewDidLoad() {
        super.viewDidLoad()


        title = "Selfie Share"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        
        let connectedDevicesButton = UIBarButtonItem(title: "Connected Devices", style: .plain, target: self, action: #selector(showConnectedDevices))
            navigationItem.rightBarButtonItem = connectedDevicesButton
        
        collectionView.collectionViewLayout = CustomLayout()
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID!, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    


    @objc func importPicture() {
//        let picker = UIImagePickerController()
//        picker.allowsEditing = true
//        picker.delegate = self
//        present(picker, animated: true)
        
        
        let ac = UIAlertController(title: "Send Message", message: "Enter your message:", preferredStyle: .alert)
           ac.addTextField()

           let sendAction = UIAlertAction(title: "Send", style: .default) { [weak self, weak ac] _ in
               guard let message = ac?.textFields?[0].text else { return }
               self?.sendMessage(message)
           }

           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

           ac.addAction(sendAction)
           ac.addAction(cancelAction)
           present(ac, animated: true)
    }
    
    @objc func showConnectedDevices() {
        let connectedDevices = mcSession.connectedPeers.map { $0.displayName }
        
        let message = connectedDevices.isEmpty ? "No devices connected." : connectedDevices.joined(separator: "\n")

        let alert = UIAlertController(title: "Connected Devices", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

    
    
    func sendMessage(_ message: String) {
        if mcSession.connectedPeers.count > 0 {
            if let data = message.data(using: .utf8) {
                do {
                    try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)

        if let imageView = cell.viewWithTag(1000) as? UIImageView{
            imageView.image = images[indexPath.item]
        }

        return cell
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        dismiss(animated: true)

        images.insert(image, at: 0)
        collectionView.reloadData()
        
        // 1
        if mcSession.connectedPeers.count > 0 {
            // 2
            if let imageData = image.pngData() {
                // 3
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func startHosting(action: UIAlertAction) {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }

    func joinSession(action: UIAlertAction) {
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }

    @objc(session:didReceiveStream:withName:fromPeer:) func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }

    @objc(session:didStartReceivingResourceWithName:fromPeer:withProgress:) func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }

    @objc(session:didFinishReceivingResourceWithName:fromPeer:atURL:withError:) func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }

    @objc func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }

    @objc func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }

    @objc(session:peer:didChangeState:) func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")

        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")

        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            
            DispatchQueue.main.async { [weak self] in
                            // Show an alert when disconnected
                            let alert = UIAlertController(title: "Disconnected", message: "\(peerID.displayName) has disconnected.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self?.present(alert, animated: true)
                        }
        }
    }

//    @objc(session:didReceiveData:fromPeer:) func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        if let image = UIImage(data: data) {
//            DispatchQueue.main.async { [unowned self] in
//                self.images.insert(image, at: 0)
//                self.collectionView?.reloadData()
//            }
//        }
//    }
    
    @objc(session:didReceiveData:fromPeer:)
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let message = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async { [weak self] in
                // Display the received message using an alert or any other UI element
                let alert = UIAlertController(title: "Message Received", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        } else {
            print("Failed to decode received data into a UTF-8 string.")
        }
    }



    func sendImage(img: UIImage) {
        if mcSession.connectedPeers.count > 0 {
            if let imageData = img.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }




}







