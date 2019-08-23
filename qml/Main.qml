import Felgo 3.0
import QtQuick 2.0

App {
    id: app
    // You get free licenseKeys from https://felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://felgo.com/licenseKey>"

    // business logic
    Item {
        id: logic

        // actions
        signal uploadScaled(string url, int width, int height)
    }

    // model
    DataModel {
        id: dataModel
        dispatcher: logic // data model handles actions sent by logic

        // handle successful upload
        onScaledUploaded: InputDialog.confirm(app,
                                              "Uploaded image scaled to " +
                                              width + " x " + height,
                                              null,
                                              false)

        // global error handling
        onUploadScaledFailed: nativeUtils.displayMessageBox("Failed to upload", error)
    }

    NavigationStack {

        Page {
            title: qsTr("HttpImageUtils")

            rightBarItem: NavigationBarRow {
                // network activity indicator
                ActivityIndicatorBarItem {
                    enabled: dataModel.isBusy
                    visible: enabled
                    showItem: showItemAlways // do not collapse into sub-menu on Android
                }
            }

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
                    enabled: !dataModel.isBusy
                    onClicked: {
                        logic.uploadScaled(img.source,
                                           img.scale * img.width,
                                           img.scale * img.height)
                    }
                }
            }

            // show an image
            Image {
                id: img
                source: "https://dummyimage.com/300"
                anchors.centerIn: parent
            }
        }

    }
}
