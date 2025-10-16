import "../services"
import qs.components
import qs.services
import qs.config
import Quickshell
import QtQuick

Item {
    id: root

    required property var list
    readonly property string command: {
        const text = list.search.text;
        // Remove "$" ou "$ " do início
        if (text.startsWith("$ "))
            return text.slice(2).trim();
        if (text.startsWith("$"))
            return text.slice(1).trim();
        return "";
    }

    function onClicked(): void {
        if (command.length === 0)
            return;
        
        list.visibilities.launcher = false;
        
        // Executa o comando usando sh -c para suportar pipes, &&, etc
        Quickshell.execDetached(["sh", "-c", command]);
    }

    implicitHeight: Config.launcher.sizes.itemHeight

    anchors.left: parent?.left
    anchors.right: parent?.right

    StateLayer {
        radius: Appearance.rounding.normal

        function onClicked(): void {
            root.onClicked();
        }
    }

    Item {
        anchors.fill: parent
        anchors.leftMargin: Appearance.padding.larger
        anchors.rightMargin: Appearance.padding.larger
        anchors.margins: Appearance.padding.smaller

        MaterialIcon {
            id: icon

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left

            text: "terminal"
            color: Colours.palette.m3primary
            font.pointSize: Appearance.font.size.large
        }

        Column {
            anchors.left: icon.right
            anchors.leftMargin: Appearance.spacing.normal
            anchors.verticalCenter: parent.verticalCenter

            width: parent.width - icon.width - anchors.leftMargin
            spacing: 0

            StyledText {
                text: root.command.length > 0 ? root.command : "$ "
                font.pointSize: Appearance.font.size.normal
                font.weight: Font.Medium
                font.family: "monospace"
                color: root.command.length > 0 ? Colours.palette.m3onSurface : Colours.palette.m3onSurfaceVariant
            }

            StyledText {
                text: root.command.length > 0 ? "Execute shell command" : "Type a command to execute"
                font.pointSize: Appearance.font.size.small
                color: Colours.palette.m3outline

                elide: Text.ElideRight
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }
    }
}
