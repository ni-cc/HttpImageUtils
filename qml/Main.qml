import Felgo 3.0
import QtQuick 2.0

App {
    // You get free licenseKeys from https://felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://felgo.com/licenseKey>"

    NavigationStack {

        Page {
            title: qsTr("HttpImageUtils")

            // handle pinch gesture by resizing the image below
            PinchArea {
                anchors.fill: parent
                pinch.target: img
                pinch.minimumScale: 0.1
                pinch.maximumScale: 3.0

                // upload the image
                AppButton {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    text: qsTr("Upload")
                }
            }

            // show an image
            Image {
                id: img
                source: "../assets/felgo-logo.png"
                anchors.centerIn: parent
            }
        }

    }
}
