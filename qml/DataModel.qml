import Felgo 3.0
import QtQuick 2.0

Item {

    // property to configure target dispatcher / logic
    property alias dispatcher: logicConnection.target

    // whether api is busy (ongoing network requests)
    readonly property bool isBusy: api.busy

    // model data properties
    readonly property alias url: _.url

    // action success signals
    signal scaledUploaded(int width, int height)

    // action error signals
    signal uploadScaledFailed(var error)

    // listen to actions from dispatcher
    Connections {
        id: logicConnection

        // action 1 - upload scaled image
        onUploadScaled: {
            api.uploadScaled(url, width, height,
                             function(data) {
                                 if (data.ok) {
                                     _.url = _.makeURL()
                                     scaledUploaded(width, height)
                                 }
                                 else {
                                     uploadScaledFailed("HTTP Response " + data.status)
                                 }
                             },
                             function(error) {
                                 uploadScaledFailed(error)
                             })
        }
    }

    // small rest api for scaled image upload
    Item {
        id: api

        // loading state
        readonly property bool busy: HttpNetworkActivityIndicator.enabled

        // configure request timeout
        property int maxRequestTimeout: 5000

        // initialization
        Component.onCompleted: {
            // immediately activate loading indicator when a request is started
            HttpNetworkActivityIndicator.setActivationDelay(0)
        }

        function uploadScaled(url, width, height, success, error) {
            HttpRequest.get(url)
            .timeout(maxRequestTimeout)
            .then(function(res) {
                var reader = HttpImageUtils.createReader(res.body)
                reader.setScaledSize(width, height, Image.PreserveAspectFit)
                var scaled = reader.read();
                HttpRequest.post("http://httpbin.org/post")
                .timeout(maxRequestTimeout)
                .attach('jpg', scaled, 'scaled.jpg')
                .then(function(res) {
                    success(res)
                })
                .catch(function(err) { error(err) });;
            })
            .catch(function(err) { error(err) });
        }
    }

    // private
    Item {
        id: _

        // data properties
        property string url: makeURL()  // image url

        // generate a random image URL
        function makeURL() {
            return ("https://dummyimage.com/" +
                    utils.generateRandomValueBetween(100, 500) + "x" +
                    utils.generateRandomValueBetween(100, 500) + "/" +
                    utils.randomColor().substr(1) +
                    "&text=Hi!")
        }
    }
}
