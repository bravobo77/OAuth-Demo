

import UIKit
import AuthenticationServices

@available(iOS 12.0, *)
class ViewController: UIViewController {
    
    private var session: ASWebAuthenticationSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonAction(_ sender: Any) {
        
        authTokenWithWebLogin()
        
    }
    
    private func authTokenWithWebLogin() {
        let authURL = URL(string: "https://keycloak.stgsrv.work:8443/auth/realms/sample_service")
        let callbackURLScheme = "radiko://radiko.jp"
        
            self.session = ASWebAuthenticationSession(url: authURL!, callbackURLScheme: callbackURLScheme, completionHandler: { (callback: URL?, error: Error?) in
                guard error == nil, let successURL = callback else { return }
                let oAuthToken = URLComponents(string: successURL.absoluteString)?.queryItems?.filter({$0.name == "token"}).first?.value
                UserDefaults.setValue(oAuthToken, forKey: "token")
            })
        if #available(iOS 13.0, *) {
            self.session?.presentationContextProvider = self
        } else {
            // Fallback on earlier versions
        }
        self.session?.start()
    }
    
}

@available(iOS 12.0, *)
extension ViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
            return view.window!
        }
}

