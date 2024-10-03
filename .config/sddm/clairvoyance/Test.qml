Text {
    id: passwordStatus

    text: "Incorrect Password!"
    color: "white"
    font {
      pointSize: 10
      family: "FiraMono"
    }

    anchors {
      horizontalCenter: parent.horizontalCenter
      bottom: passwordBox.top
      bottomMargin: 20
    }

    opacity: 0

    Timer {
      id: passwordTimer
      interval: 3000
      running: false
      repeat: false
      onTriggered: {
        passwordStatus.opacity= 0
      }
    }

    Behavior on opacity {
      NumberAnimation{
        duration: 500
        easing.type: Easing.InOutQuad
      }
    }

}

Item {
    id: passwordBox

    width: 300
    height: 50
    anchors {
      horizontalCenter: parent.horizontalCenter
    }

    Text {
      id: defaultPasswordText

      anchors {
        fill: parent
      }
      text: "Password..."
      color: "white"
      font {
        pointSize: 14
        family: "FiraMono"
      }
      opacity: 1
    }

    TextInput {
      id: passwordInput

      verticalAlignment: TextInput.AlignVCenter
      anchors {
        fill: parent
        leftMargin: 15
        rightMargin: 50
      }
      font {
        pointSize: 14
        family: "FiraMono"
        letterSpacing: 2
      }
      color: "white"
      echoMode:TextInput.Password
      clip: true
      inputMethodHints: Qt.ImhNoPredictiveText
      onAccepted: {
        loginFrame.login()
      }
      focus: false
    }

    Image {
      id: submitPassword
      x: 260
      y: 10
      width: 30
      height: 30
      opacity: 0
      source: "Assets/RightArrow.png"

      MouseArea {
        anchors.fill: parent
        onClicked: {
          loginFrame.login()
        }
      }
    }

  }

  Rectangle {
    id: passwordUnderline

    width: passwordBox.width
    height: 1
    anchors {
      bottom: passwordBox.bottom
      left: passwordBox.left
    }
    color: "white"
    opacity: 0.3
    radius: 50
  }