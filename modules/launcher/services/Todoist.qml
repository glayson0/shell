pragma Singleton

import qs.utils
import QtQuick

QtObject {
    id: root

    function query(search: string): list<int> {
        // Sempre retorna um único item, como a calculadora
        return [0];
    }
}
