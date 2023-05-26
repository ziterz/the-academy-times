//
//  ViewController.swift
//  TheAcademyTimes
//
//  Created by Ziady Mubaraq on 18/05/23.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {
  
  @IBOutlet var sceneView: ARSCNView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set the view's delegate
    sceneView.delegate = self
    
    // Show statistics such as fps and timing information
    sceneView.showsStatistics = false
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Create a session configuration
    let configuration = ARImageTrackingConfiguration() // To track the anchors
    
    if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main)
    { // Tell what images are to be tracked where are they to be found
      
      configuration.trackingImages = trackedImages
      
      configuration.maximumNumberOfTrackedImages = 10  // How many images can be tracked at a single point
      
    }
    
    // Run the view's session
    sceneView.session.run(configuration)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Pause the view's session
    sceneView.session.pause()
  }
  
  // MARK: - ARSCNViewDelegate
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    
    // Check we have detected an ARImageAnchor
    guard let validAnchor = anchor as? ARImageAnchor else { return }
    
    
    // Create a Video Player Node for each detected target
    node.addChildNode(createdVideoPlayerNodeFor(validAnchor.referenceImage))
    
  }
  
  func createdVideoPlayerNodeFor(_ target: ARReferenceImage) -> SCNNode{
    
    // Create an SCNNode to hold our Video Player
    let videoPlayerNode = SCNNode()
    
    // Create an SCNPlane & AVPlayer
    let videoPlayerGeometry = SCNPlane(width: target.physicalSize.width, height: target.physicalSize.height)
    var videoPlayer = AVPlayer()
    
    // If we have a valid anchor name & valid video URL the instanciate the AVPlayer
    if let targetName = target.name,
       let validURL = Bundle.main.url(forResource: targetName, withExtension: "mp4", subdirectory: "/video.scnassets") {
      videoPlayer = AVPlayer(url: validURL)
      videoPlayer.play()
    }
    
    // Assign the AVPlayer & the geometry to the Video Player
    videoPlayerGeometry.firstMaterial?.diffuse.contents = videoPlayer
    videoPlayerNode.geometry = videoPlayerGeometry
    
    // Rotate it by 90 degrees
    videoPlayerNode.eulerAngles.x = -.pi / 2
    
    return videoPlayerNode
    
  }
  
  func session(_ session: ARSession, didFailWithError error: Error) {
    // Present an error message to the user
    
  }
  
  func sessionWasInterrupted(_ session: ARSession) {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    
  }
}
