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
        signal uploadScaledImage(int width, int height)
    }

    // model
    DataModel {
        id: dataModel
        dispatcher: logic // data model handles actions sent by logic

        // global error handling
        onUploadScaledImageFailed: nativeUtils.displayMessageBox(qsTr("Failed to upload"), error)
    }

    NavigationStack {

        Page {
            // use qsTr for strings you want to translate
            title: qsTr("Pinch to resize")

            rightBarItem: NavigationBarRow {
                // network activity indicator
                ActivityIndicatorBarItem {
                    enabled: dataModel.isBusy
                    visible: enabled
                    showItem: showItemAlways // do not collapse into sub-menu on Android
                }
            }

            // show a message on successful upload
            Connections {
                target: dataModel
                onScaledImageUploaded: {
                    InputDialog.confirm(app,
                                        qsTr("Uploaded image scaled to ") +
                                        width + " x " + height,
                                        null,
                                        false)
                    img.scale = 1.0
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
                        logic.uploadScaledImage(img.scale * img.width,
                                                img.scale * img.height)
                    }
                }
            }

            // show an image
            Image {
                id: img
                source: dataModel.url
                anchors.centerIn: parent
            }
        }

    }
}
