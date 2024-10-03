import QtQuick 2.0
import Qt5Compat.GraphicalEffects 1.0


Item {
  id: userProfile
  width: 250
  height: 250

  anchors{
      horizontalCenter: parent.horizontalCenter
      verticalCenter: parent.verticalCenter
  }
  property string name: model.name
  property string realName: (model.realName === "") ? model.name : model.realName
  property string icon: config.pfp

  MouseArea {
    anchors.fill: parent
    onClicked: {
      listView.currentIndex = index;
      page.state = "login";
      loginFrame.name = name
      loginFrame.realName = realName
      loginFrame.icon = icon
      listView.focus = false

	  if (config.autoFocusPassword == "true")
		  focusDelay.start();
	  else
        loginFrame.focus = true;
    }
  }
}

