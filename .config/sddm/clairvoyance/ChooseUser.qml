import QtQuick 2.0

ListView {
  height: currentItem.height + 100
  width: this.count * currentItem.width
  model: userModel
  delegate: UserDelegate {}
  currentIndex: userModel.lastIndex
  orientation: ListView.Horizontal
  flickableDirection: Flickable.AutoFlickIfNeeded

  anchors {
    horizontalCenter: parent.horizontalCenter
    verticalCenter: parent.verticalCenter
  }

  focus: true
  clip: true

  Keys.onSpacePressed: {
    page.state = "login";
    loginFrame.name = currentItem.name
    loginFrame.realName = currentItem.realName
    loginFrame.icon = currentItem.icon
    focus = false
	
   if (config.autoFocusPassword == "true")
	  focusDelay.start();
    else
      loginFrame.focus = true;
    }

  Timer {
    id: focusDelay
    interval: 500
    running: false
    repeat: false

    onTriggered: {
        loginFrame.focusPassword();
    }
  }

  

}
