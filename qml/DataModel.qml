import QtQuick 2.0

Item {

    // property to configure target dispatcher / logic
    property alias dispatcher: logicConnection.target

    // action success signals
    signal scaledUploaded(var data)

    // action error signals
    signal uploadScaledFailed(var error)

    // listen to actions from dispatcher
    Connections {
        id: logicConnection

        // action 1 - upload scaled image
        onUploadScaled: {
            api.uploadScaled(url, width, height,
                             function(data) {
                                 scaledUploaded(data)
                             },
                             function(error) {
                                 uploadScaledFailed(error)
                             })
        }
    }

    // dummy rest api for scaled image upload
    Item {
        id: api

        function uploadScaled(url, width, height, success, error) {
            error("Not implemented " + width + height)
        }
    }
}
