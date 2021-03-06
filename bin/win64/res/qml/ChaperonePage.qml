import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import matzman666.advsettings 1.0

MyStackViewPage {
    headerText: "Chaperone Settings"

    MyDialogOkPopup {
        id: chaperoneMessageDialog
        function showMessage(title, text) {
            dialogTitle = title
            dialogText = text
            open()
        }
    }

    MyDialogOkCancelPopup {
        id: chaperoneDeleteProfileDialog
        property int profileIndex: -1
        dialogTitle: "Delete Profile"
        dialogText: "Do you really want to delete this profile?"
        onClosed: {
            if (okClicked) {
                ChaperoneTabController.deleteChaperoneProfile(profileIndex)
            }
        }
    }

    MyDialogOkCancelPopup {
        id: chaperoneNewProfileDialog
        dialogTitle: "Create New Profile"
        dialogWidth: 800
        dialogHeight: 780
        dialogContentItem: ColumnLayout {
            RowLayout {
                Layout.topMargin: 16
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                MyText {
                    text: "Name: "
                }
                TextField {
                    id: chaperoneNewProfileName
                    color: "#cccccc"
                    text: ""
                    Layout.fillWidth: true
                    font.pointSize: 20
                    onActiveFocusChanged: {
                        if (activeFocus) {
                            OverlayController.showKeyboard(text, 101)
                        }
                    }
                    Connections {
                        target: OverlayController
                        onKeyBoardInputSignal: {
                            if (userValue == 101) {
                                chaperoneNewProfileName.text = input
                            }
                        }
                    }
                }
            }
            MyText {
                Layout.topMargin: 24
                text: "What to include:"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludeGeometry
                Layout.leftMargin: 32
                text: "Chaperone Geometry"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludeStyle
                Layout.leftMargin: 32
                text: "Chaperone Style"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludeBoundsColor
                Layout.leftMargin: 32
                text: "Chaperone Color"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludeVisibility
                Layout.leftMargin: 32
                text: "Visibility Setting"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludeFadeDistance
                Layout.leftMargin: 32
                text: "Fade Distance Setting"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludeCenterMarker
                Layout.leftMargin: 32
                text: "Center Marker Setting"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludePlaySpaceMarker
                Layout.leftMargin: 32
                text: "Play Space Marker Setting"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludeFloorBoundsMarker
                Layout.leftMargin: 32
                text: "Floor Bounds Always On Setting"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludeForceBounds
                Layout.leftMargin: 32
                text: "Force Bounds Setting"
            }
        }
        onClosed: {
            if (okClicked) {
                if (chaperoneNewProfileName.text == "") {
                    chaperoneMessageDialog.showMessage("Create New Profile", "ERROR: Empty profile name.")
                } else if (!chaperoneNewProfileIncludeGeometry.checked
                            && !chaperoneNewProfileIncludeVisibility.checked
                            && !chaperoneNewProfileIncludeFadeDistance.checked
                            && !chaperoneNewProfileIncludeCenterMarker.checked
                            && !chaperoneNewProfileIncludePlaySpaceMarker.checked
                            && !chaperoneNewProfileIncludeFloorBoundsMarker.checked
                            && !chaperoneNewProfileIncludeBoundsColor.checked
                            && !chaperoneNewProfileIncludeStyle.checked
                            && !chaperoneNewProfileIncludeForceBounds.checked) {
                    chaperoneMessageDialog.showMessage("Create New Profile", "ERROR: Nothing included.")
                } else {
                    ChaperoneTabController.addChaperoneProfile(chaperoneNewProfileName.text,
                                                               chaperoneNewProfileIncludeGeometry.checked,
                                                               chaperoneNewProfileIncludeVisibility.checked,
                                                               chaperoneNewProfileIncludeFadeDistance.checked,
                                                               chaperoneNewProfileIncludeCenterMarker.checked,
                                                               chaperoneNewProfileIncludePlaySpaceMarker.checked,
                                                               chaperoneNewProfileIncludeFloorBoundsMarker.checked,
                                                               chaperoneNewProfileIncludeBoundsColor.checked,
                                                               chaperoneNewProfileIncludeStyle.checked,
                                                               chaperoneNewProfileIncludeForceBounds.checked)
                }

            }
        }
        function openPopup() {
            chaperoneNewProfileName.text = ""
            chaperoneNewProfileIncludeGeometry.checked = false
            chaperoneNewProfileIncludeVisibility.checked = false
            chaperoneNewProfileIncludeFadeDistance.checked = false
            chaperoneNewProfileIncludeCenterMarker.checked = false
            chaperoneNewProfileIncludePlaySpaceMarker.checked = false
            chaperoneNewProfileIncludeFloorBoundsMarker.checked = false
            chaperoneNewProfileIncludeBoundsColor.checked = false
            chaperoneNewProfileIncludeStyle.checked = false
            chaperoneNewProfileIncludeForceBounds.checked = false
            open()
        }
    }


    content: ColumnLayout {
        spacing: 18

        ColumnLayout {
            Layout.bottomMargin: 32
            spacing: 18
            RowLayout {
                spacing: 18

                MyText {
                    text: "Profile:"
                }

                MyComboBox {
                    id: chaperoneProfileComboBox
                    Layout.maximumWidth: 799
                    Layout.minimumWidth: 799
                    Layout.preferredWidth: 799
                    Layout.fillWidth: true
                    model: [""]
                    onCurrentIndexChanged: {
                        if (currentIndex > 0) {
                            chaperoneApplyProfileButton.enabled = true
                            chaperoneDeleteProfileButton.enabled = true
                        } else {
                            chaperoneApplyProfileButton.enabled = false
                            chaperoneDeleteProfileButton.enabled = false
                        }
                    }
                }

                MyPushButton {
                    id: chaperoneApplyProfileButton
                    enabled: false
                    Layout.preferredWidth: 200
                    text: "Apply"
                    onClicked: {
                        if (chaperoneProfileComboBox.currentIndex > 0) {
                            ChaperoneTabController.applyChaperoneProfile(chaperoneProfileComboBox.currentIndex - 1)
                            chaperoneProfileComboBox.currentIndex = 0
                        }
                    }
                }
            }
            RowLayout {
                spacing: 18
                Item {
                    Layout.fillWidth: true
                }
                MyPushButton {
                    id: chaperoneDeleteProfileButton
                    enabled: false
                    Layout.preferredWidth: 200
                    text: "Delete Profile"
                    onClicked: {
                        if (chaperoneProfileComboBox.currentIndex > 0) {
                            chaperoneDeleteProfileDialog.profileIndex = chaperoneProfileComboBox.currentIndex - 1
                            chaperoneDeleteProfileDialog.open()
                        }
                    }
                }
                MyPushButton {
                    Layout.preferredWidth: 200
                    text: "New Profile"
                    onClicked: {
                        chaperoneNewProfileDialog.openPopup()
                    }
                }
            }
        }

        GridLayout {
            columns: 5

            MyText {
                text: "Visibility:"
                Layout.rightMargin: 12
            }

            MyPushButton2 {
                text: "-"
                Layout.preferredWidth: 40
                onClicked: {
                    chaperoneVisibilitySlider.value -= 0.1
                }
            }

            MySlider {
                id: chaperoneVisibilitySlider
                from: 0.0
                to: 1.0
                stepSize: 0.01
                value: 0.6
                Layout.fillWidth: true
                onPositionChanged: {
                    var val = this.position * 100
                    chaperoneVisibilityText.text = Math.round(val) + "%"
                }
                onValueChanged: {
                    ChaperoneTabController.setBoundsVisibility(this.value.toFixed(2), false)
                }
            }

            MyPushButton2 {
                text: "+"
                Layout.preferredWidth: 40
                onClicked: {
                    chaperoneVisibilitySlider.value += 0.1
                }
            }

            MyText {
                id: chaperoneVisibilityText
                text: "100%"
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: 85
            }

            MyText {
                text: "Fade Distance:"
                Layout.rightMargin: 12
            }

            MyPushButton2 {
                text: "-"
                Layout.preferredWidth: 40
                onClicked: {
                    chaperoneFadeDistanceSlider.decrease()
                }
            }

            MySlider {
                id: chaperoneFadeDistanceSlider
                from: 0.0
                to: 2.0
                stepSize: 0.1
                value: 0.7
                Layout.fillWidth: true
                onPositionChanged: {
                    var val = this.from + ( this.position  * (this.to - this.from))
                    chaperoneFadeDistanceText.text = val.toFixed(1)
                }
                onValueChanged: {
                    ChaperoneTabController.setFadeDistance(this.value.toFixed(1), false);
                }
            }

            MyPushButton2 {
                text: "+"
                Layout.preferredWidth: 40
                onClicked: {
                    chaperoneFadeDistanceSlider.increase()
                }
            }

            MyText {
                id: chaperoneFadeDistanceText
                text: "9.9"
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: 85
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 32

            MyToggleButton {
                id: chaperoneCenterMarkerToggle
                text: "Center Marker"
                Layout.fillWidth: false
                onCheckedChanged: {
                    ChaperoneTabController.setCenterMarker(this.checked, false)
                }
            }

            MyToggleButton {
                id: chaperonePlaySpaceToggle
                text: "Play Space"
                onCheckedChanged: {
                    ChaperoneTabController.setPlaySpaceMarker(this.checked, false)
                }
            }

            MyToggleButton {
                id: chaperoneForceBoundsToggle
                text: "Force Bounds"
                onCheckedChanged: {
                    ChaperoneTabController.setForceBounds(this.checked, false)
                }
            }
        }

        MyPushButton {
            id: chaperoneFlipOrientationButton
            text: "Flip Orientation"
            Layout.preferredWidth: 250
            onClicked: {
                ChaperoneTabController.flipOrientation()
            }
        }

        Item { Layout.fillHeight: true; Layout.fillWidth: true}

        RowLayout {
            Layout.fillWidth: true

            MyPushButton {
                id: chaperoneResetButton
                text: "Reset"
                Layout.preferredWidth: 250
                onClicked: {
                    chaperoneVisibilitySlider.value = 0.6
                    chaperoneFadeDistanceSlider.value = 0.7
                    chaperoneCenterMarkerToggle.checked = false
                    chaperonePlaySpaceToggle.checked = false
                    chaperoneForceBoundsToggle.checked = false
                }
            }

            Item { Layout.fillWidth: true}

            MyPushButton {
                id: chaperoneReloadFromDiskButton
                text: "Reload from Disk"
                Layout.preferredWidth: 250
                onClicked: {
                    ChaperoneTabController.reloadFromDisk()
                }
            }
        }

        Component.onCompleted: {
            chaperoneVisibilitySlider.value = ChaperoneTabController.boundsVisibility
            chaperoneFadeDistanceSlider.value = ChaperoneTabController.fadeDistance
            chaperoneCenterMarkerToggle.checked = ChaperoneTabController.centerMarker
            chaperonePlaySpaceToggle.checked = ChaperoneTabController.playSpaceMarker
            chaperoneForceBoundsToggle.checked = ChaperoneTabController.forceBounds
            reloadChaperoneProfiles()
        }

        Connections {
            target: ChaperoneTabController
            onBoundsVisibilityChanged: {
                if (Math.abs(chaperoneVisibilitySlider.value - ChaperoneTabController.boundsVisibility) > 0.008) {
                    chaperoneVisibilitySlider.value = ChaperoneTabController.boundsVisibility
                }
            }
            onFadeDistanceChanged: {
                if (Math.abs(chaperoneFadeDistanceSlider.value - ChaperoneTabController.fadeDistance) > 0.08) {
                    chaperoneFadeDistanceSlider.value = ChaperoneTabController.fadeDistance
                }
            }
            onCenterMarkerChanged: {
                chaperoneCenterMarkerToggle.checked = ChaperoneTabController.centerMarker
            }
            onPlaySpaceMarkerChanged: {
                chaperonePlaySpaceToggle.checked = ChaperoneTabController.playSpaceMarker
            }
            onForceBoundsChanged: {
                chaperoneForceBoundsToggle.checked = ChaperoneTabController.forceBounds
            }
            onChaperoneProfilesUpdated: {
                reloadChaperoneProfiles()
            }
        }
    }

    function reloadChaperoneProfiles() {
        var profiles = [""]
        var profileCount = ChaperoneTabController.getChaperoneProfileCount()
        for (var i = 0; i < profileCount; i++) {
            profiles.push(ChaperoneTabController.getChaperoneProfileName(i))
        }
        chaperoneProfileComboBox.currentIndex = 0
        chaperoneProfileComboBox.model = profiles
    }
}
