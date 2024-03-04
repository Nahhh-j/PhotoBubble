//
//  ViewController.swift
//  PhotoBubble
//
//  Created by 조나영 on 2022/05/10.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
        
        /*
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        */
    }
    
    
    private func setupSceneView() {
        sceneView?.delegate = self
        let omni = SCNNode()
        omni.position = SCNVector3(x: 1, y: 1, z: -10)
        // +x: 화면 오른쪽, -x:화면 왼쪽, +y: 화면 위쪽, -y: 화면 아래쪽, +z: 화면 멀리, -z: 화면 가까이
        omni.light = SCNLight()
        omni.light?.intensity = 1000
        omni.light!.type = .directional
        sceneView.scene.rootNode.addChildNode(omni)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
        let configuration = ARFaceTrackingConfiguration()
                
        sceneView.session.run(configuration)
         */
        
        /*
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        */
    }
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        // sceneView.session.pause()
    }
    
    func resetTracking() {
            let configuration = ARFaceTrackingConfiguration()
            sceneView.session.run(configuration,
                                  options: [.resetTracking, .removeExistingAnchors])
    }
    
}

/*
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else { return nil }
        
        let resourceName = "Logo_gltf_2_dae"
        let contentNode = SCNReferenceNode(named: resourceName)
        
        
//        let resourceName2 = "ship"
//        let contentNode2 = SCNReferenceNode(named: resourceName2)
        
//        contentNode.childNodes.first?.geometry?.firstMaterial?.lightingModel = .physicallyBased
        
        return contentNode
    }
}
 */

//extension ViewController: ARSCNViewDelegate {
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        guard let sceneView = renderer as? ARSCNView,
//                    anchor is ARFaceAnchor else { return nil }
//
//        let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!)!
//
//        let node = SCNNode(geometry: faceGeometry)
//        node.geometry?.firstMaterial?.fillMode = .lines
//
//        return node
//    }
//
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry,
//            let faceAnchor = anchor as? ARFaceAnchor
//            else { return }
//
//        faceGeometry.update(from: faceAnchor.geometry)
//    }
//}



class Hat : SCNNode {
    init(geometry : ARSCNFaceGeometry) {
        geometry.firstMaterial!.colorBufferWriteMask = []
        let occlusionNode = SCNNode(geometry: geometry)
        occlusionNode.renderingOrder = -1

        super.init()
        addChildNode(occlusionNode)

        guard let url = Bundle.main.url(forResource: "Red_Basic", withExtension: "scn", subdirectory: "art.scnassets") else {fatalError("missing hat resource")}
        let node = SCNReferenceNode(url: url)!
        node.load()

        addChildNode(node)
        
        guard let url2 = Bundle.main.url(forResource: "White_Circle", withExtension: "scn", subdirectory: "art.scnassets") else {fatalError("missing hat resource")}
        let node2 = SCNReferenceNode(url: url2)!
        node2.load()

        addChildNode(node2)
    }//init

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARFaceAnchor) {
        let faceGeometry = geometry as! ARSCNFaceGeometry
        faceGeometry.update(from: anchor.geometry)
        node.position.y = faceGeometry.boundingSphere.radius
    }//upadate


    required init?(coder aDecoder: NSCoder) {
        fatalError("(#function) has not been implemented")
    }//r init
}//class

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let sceneView = renderer as? ARSCNView,
                    anchor is ARFaceAnchor else { return nil }

        let hatGeometry = ARSCNFaceGeometry(device: sceneView.device!, fillMesh: true)!
        let hat = Hat(geometry: hatGeometry)
        
        return hat
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry,
            let faceAnchor = anchor as? ARFaceAnchor
            else { return }

        faceGeometry.update(from: faceAnchor.geometry)
    }
}


    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    /*
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    */
//}
