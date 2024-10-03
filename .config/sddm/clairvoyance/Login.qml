import QtQuick 2.0
import QtQuick.Controls 2.0
import Qt5Compat.GraphicalEffects 1.0

Item {
  id: loginFrame

  width: page.width
  height: page.height
  anchors.horizontalCenter: page.horizontalCenter
  anchors.verticalCenter: page.verticalCenter

  property string name
  property string realName
  property string icon
  focus: false

  Behavior on opacity {
    NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
  }

  //Logins in with current details
  function login() {
    loginFrame.opacity = 0;
    sddm.login(loginFrame.name, passwordInput.text, sessionSelect.currentIndex);
  }

  //Goes back to user select
  function back() {
    page.state = "";
    listView.focus = true;
  }

  function focusPassword() {
   passwordInput.focus = true;
  }

  KeyNavigation.tab: passwordInput
  Keys.onEscapePressed: back()


  Connections {
    target: sddm
    onLoginSucceeded: {
    }

    onLoginFailed: {
      loginFrame.opacity = 1;
      passwordInput.text = ""
      passwordStatus.opacity = 1;
      passwordTimer.start();
    }
  }

  states: State {
      name: "active"
      when: passwordInput.activeFocus == true || passwordInput.text != ""

      PropertyChanges {
        target: defaultPasswordText
        opacity: 0
      }

      PropertyChanges {
        target: submitPassword
        opacity: 1
      }

      PropertyChanges {
        target: passwordUnderline
        height: 50
      }
  }

  transitions: Transition {
    from: ""
    to: "active"
    reversible: true

    PropertyAnimation {
      properties: "opacity"
      easing.type: Easing.InOutQuad
      duration: 150
    }

    PropertyAnimation {
      properties: "height"
      easing.type: Easing.InOutQuad
      duration: 150
    }
  }

  Item {
    id: userProfile
    width: 250
    height: 250
    
    anchors{
      horizontalCenter: parent.horizontalCenter
      verticalCenter: parent.verticalCenter
    }
    //User's Name
    Text {
    id: usersName
    color: "white"
    font {
      family: "FiraMono"
      pointSize: 25
      weight: 500
    }
    text: realName
    anchors.horizontalCenter: parent.horizontalCenter
    }

  
   Image {
        anchors{
          top: usersName.bottom
          left: userProfile.left
          leftMargin: userProfile.width / 2 - img.width / 2
          topMargin: 20
        }  
        id: img
        source: icon
        width: 140
        height: 140
        fillMode: Image.PreserveAspectCrop
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: mask
        }
    }

    Rectangle {
        id: mask
        width: 140
        height: 140
        radius: width/2
        visible: false
    }   

  }

  //Back Button
  Image {
    anchors {
      right: userProfile.left
      top: userProfile.top
      topMargin: usersName.height + (img.height/2 - backBtn.height / 2)  + 15
    }
    id: backBtn
    width: 32
    height: 32
    source: "Assets/Selector.png"
    transform: Rotation { origin.x : 16; origin.y: 16; angle: 270}

    MouseArea {
      anchors.fill: parent
      onClicked: {
        loginFrame.back();
      }
    }
  }

  Item {
    id: passwordBox

    width: 300
    height: 50
    anchors {
      top: userProfile.bottom
      horizontalCenter: parent.horizontalCenter
    }

    Text {
      id: defaultPasswordText

      anchors {
        fill: parent
        leftMargin: 15
        rightMargin: 50
        topMargin: 10
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

  
}
