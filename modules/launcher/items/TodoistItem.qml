import "../services"
import qs.components
import qs.services
import qs.config
import Quickshell
import QtQuick

Item {
    id: root

    required property var list
    readonly property string command: list.search.text.slice("td ".length)
    readonly property var parsed: {
        const parts = command.split(" ");
        return {
            action: parts[0] || "",
            args: parts.slice(1).join(" ")
        };
    }

    function getCommandInfo(): var {
        const action = parsed.action;
        switch (action) {
            case "add":
                return {
                    icon: "add_task",
                    name: "add",
                    description: parsed.args ? `Adicionar: "${parsed.args}"` : "Adicionar nova tarefa"
                };
            case "list":
                return {
                    icon: "checklist",
                    name: "list",
                    description: "Listar todas as tarefas"
                };
            case "next":
                return {
                    icon: "today",
                    name: "next",
                    description: "Ver próxima tarefa prioritária"
                };
            case "complete":
                return {
                    icon: "check_circle",
                    name: "complete",
                    description: "Completar última tarefa"
                };
            case "projects":
                return {
                    icon: "folder",
                    name: "projects",
                    description: "Listar projetos"
                };
            case "today":
                return {
                    icon: "event",
                    name: "today",
                    description: "Tarefas de hoje"
                };
            default:
                return {
                    icon: "help_outline",
                    name: action || "?",
                    description: "Comandos: add, list, next, complete, projects, today"
                };
        }
    }

    readonly property var info: getCommandInfo()

    function onClicked(): void {
        list.visibilities.launcher = false;
        
        switch (parsed.action) {
            case "add":
                if (parsed.args.trim()) {
                    Quickshell.execDetached(["tod", "t", "q", "-c", parsed.args.trim()]);
                }
                break;
            
            case "list":
                Quickshell.execDetached(["tod", "t", "l"]);
                break;
            
            case "next":
                Quickshell.execDetached(["tod", "t", "n"]);
                break;
            
            case "complete":
                Quickshell.execDetached(["tod", "t", "c"]);
                break;
            
            case "projects":
                Quickshell.execDetached(["tod", "p", "l"]);
                break;
            
            case "today":
                Quickshell.execDetached(["tod", "t", "l", "--filter", "today"]);
                break;
        }
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

        // Ícone customizado do Todoist (imagem SVG/PNG)
        Item {
            id: icon

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left

            implicitWidth: Appearance.font.size.large * 1.5
            implicitHeight: Appearance.font.size.large * 1.5

            Image {
                anchors.fill: parent
                source: "file:///home/gnbo/.config/quickshell/caelestia/assets/todoist-icon.svg"
                sourceSize.width: parent.width
                sourceSize.height: parent.height
                fillMode: Image.PreserveAspectFit
                smooth: true
                
                // Fallback: se a imagem não carregar, mostra o círculo vermelho
                onStatusChanged: {
                    if (status === Image.Error) {
                        visible = false;
                        fallbackIcon.visible = true;
                    }
                }
            }

            // Fallback icon
            StyledRect {
                id: fallbackIcon
                
                anchors.fill: parent
                color: "#E44332" // Cor vermelha do Todoist
                radius: width / 2
                visible: false

                MaterialIcon {
                    anchors.centerIn: parent
                    text: "check"
                    color: "white"
                    font.pointSize: Appearance.font.size.normal
                }
            }
        }

        Column {
            anchors.left: icon.right
            anchors.leftMargin: Appearance.spacing.normal
            anchors.verticalCenter: parent.verticalCenter

            width: parent.width - icon.width - anchors.leftMargin
            spacing: 0

            StyledText {
                text: `td ${root.info.name}`
                font.pointSize: Appearance.font.size.normal
                font.weight: Font.Medium
            }

            StyledText {
                text: root.info.description
                font.pointSize: Appearance.font.size.small
                color: Colours.palette.m3outline

                elide: Text.ElideRight
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }
    }
}
