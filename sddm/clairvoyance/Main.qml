import QtQuick 2.0
import SddmComponents 2.0
import Qt5Compat.GraphicalEffects 1.0

Item {
  id: page
  width: 1920
  height: 1080

  //Put everything below the background or it won't be shown
  Image {
    id: background
    anchors.fill: parent
    source: config.background

    
  }

  

  // Add blur effect to the background image
  GaussianBlur {
        id: blurEffect
        anchors.fill: background
        source: background
        radius: 8
        samples: 16
        visible: false
        opacity: 0
  }

  ColorOverlay {
      id: darkOverlay
      anchors.fill: background
      source: background
      color: "black"
      opacity: 0.13// Adjust opacity to control the darkness level
  }

  Login {
    id: loginFrame
    visible: false
    opacity: 0
  }

  PowerFrame {
    id: powerFrame
  }

  ListView {
    id: sessionSelect
    width: currentItem.width
    height: current.height
    model: sessionModel
    currentIndex: sessionModel.lastIndex
    visible: false
    opacity: 0
    flickableDirection: Flickable.AutoFlickIfNeeded
    anchors {
      bottom: powerFrame.top
      right: page.right
      rightMargin: 35
    }

    delegate: Item {
      width: 100
      height: 50
      Text {
        width: parent.width
        height: parent.height
        text: name
        color: "white"
        opacity: (delegateArea.containsMouse || sessionSelect.currentIndex == index) ? 1 : 0.3
        font {
          pointSize: (config.enableHDPI == "true") ? 6 : 12
          family: "FiraMono"
        }
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        Behavior on opacity {
          NumberAnimation { duration: 150; easing.type: Easing.InOutQuad}
        }
      }

      MouseArea {
        id: delegateArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
          sessionSelect.currentIndex = index
          sessionSelect.state = ""
        }
      }
    }

    states: State {
      name: "show"
      PropertyChanges {
        target: sessionSelect
        visible: true
        opacity: 1
      }
      
    }

    transitions: [
      Transition {
        from: ""
        to: "show"
        SequentialAnimation {
          PropertyAnimation {
            target: sessionSelect
            properties: "visible"
            duration: 0
          }
          PropertyAnimation {
            target: sessionSelect
            properties: "opacity"
            duration: 200
          }
          
        }
      },
      Transition {
        from: "show"
        to: ""
        SequentialAnimation {
          PropertyAnimation {
            target: sessionSelect
            properties: "opacity"
            duration: 200
          }
          PropertyAnimation {
            target: sessionSelect
            properties: "visible"
            duration: 0
          }

        }
      }
    ]

  }

  ChooseUser {
    id: listView
    visible: true
    opacity: 1
  }

  Item{
    anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: parent.height * 0.25
    }
    id: currentTime
    opacity: 1
    visible: true
    // Time Display
    Text {
        id: clockTime
        text: Qt.formatDateTime(new Date(), "hh:mm")
        color: "white"
        font {
            family: "FiraMono"
            pixelSize: 120
            bold:true
        }
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: parent.height * 0.25
        }

        Timer {
            interval: 1000 // Update every second
            running: true
            repeat: true
            onTriggered: {
                clockTime.text = Qt.formatDateTime(new Date(), "hh:mm")
            }
        }
    }
    Text {
        id: dateTimdateTimee
        text: Qt.formatDateTime(new Date(), "dd MMMM yyyy")
        color: "white"
        font {
            family: "FiraMono"
            pixelSize: 32
            bold:true
        }
        anchors {
            top: clockTime.bottom
            horizontalCenter: parent.horizontalCenter
        }

        Timer {
            interval: 1000 // Update every second
            running: true
            repeat: true
            onTriggered: {
                dateTime.text = Qt.formatDateTime(new Date(), "dd MMMM yyyy")
            }
        }
    }
  }
  states: State {
    name: "login"

    PropertyChanges {
        target: blurEffect
        visible: true
        opacity: 1
    }

    PropertyChanges {
      target: listView
      visible: false
      opacity: 0
    }

    PropertyChanges {
      target: currentTime
      visible: false
      opacity: 0
    }

    PropertyChanges {
      target: loginFrame
      visible: true
      opacity: 1
    }
  }

  transitions: [
  Transition {
    from: ""
    to: "login"
    reversible: false

    SequentialAnimation {

      ParallelAnimation {
        PropertyAnimation {
        target: blurEffect
        properties: "visible"
        duration: 0
      }
      PropertyAnimation {
        target: blurEffect
        properties: "opacity"
        duration: 200
      }

      PropertyAnimation {
        target: currentTime
        properties: "visible"
        duration: 200
      }
      PropertyAnimation {
        target: currentTime
        properties: "opacity"
        duration: 200
      }
    }
      
      
      PropertyAnimation {
        target: listView
        properties: "opacity"
        duration: 200
      }
      PropertyAnimation {
        target: listView
        properties: "visible"
        duration: 0
      }
      PropertyAnimation {
        target: loginFrame
        properties: "visible"
        duration: 0
      }
      PropertyAnimation {
        target: loginFrame
        properties: "opacity"
        duration: 200
      }
          
    }
  },
  Transition {
    from: "login"
    to: ""
    reversible: false

    SequentialAnimation {
      PropertyAnimation {
        target: loginFrame
        properties: "opacity"
        duration: 200
      }
      PropertyAnimation {
        target: loginFrame
        properties: "visible"
        duration: 0
      }
      PropertyAnimation {
        target: listView
        properties: "visible"
        duration: 0
      }
      PropertyAnimation {
        target: listView
        properties: "opacity"
        duration: 200
      }
    }
  }]

}
