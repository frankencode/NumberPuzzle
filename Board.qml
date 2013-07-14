import QtQuick 2.0
import "game.js" as Game

Rectangle {
  property var rowCount: 4
  property var colCount: rowCount
  property var hole: new Game.Tile(rowCount - 1, colCount -1)
  function moveTile(tile) {
    var i = hole.row, k = hole.col
    hole = new Game.Tile(tile.row, tile.col)
    return new Game.Tile(i, k, tile.index)
  }
  width: 600
  height: width
  color: "darkCyan"
  Repeater {
    model: rowCount * colCount - 1
    delegate: Item {
      property var tile: {
        var row = Math.floor(index / colCount)
        var col = index % colCount
        return new Game.Tile(row, col, index)
      }
      x: tile.col * width
      y: tile.row * height
      width:  parent.width  / colCount
      height: parent.height / rowCount
      Rectangle {
        anchors.fill: parent
        anchors.margins: 2
        radius: 4
        smooth: true
        Text {
          anchors.centerIn: parent
          text: index + 1
          font.pixelSize: parent.height / 3
        }
      }
      MouseArea {
        anchors.fill: parent
        enabled: tile.laysNextTo(hole)
        drag.target: parent
        drag.minimumX: Math.min(tile.col, hole.col) * width
        drag.maximumX: Math.max(tile.col, hole.col) * width
        drag.minimumY: Math.min(tile.row, hole.row) * height
        drag.maximumY: Math.max(tile.row, hole.row) * height
        drag.onActiveChanged: {
          if (!drag.active) {
            var dx = Math.abs(parent.x - tile.col * width)
            var dy = Math.abs(parent.y - tile.row * height)
            if (dx > width / 2 || dy > height / 2) tile = moveTile(tile)
            parent.x = Qt.binding(function() { return tile.col * width } )
            parent.y = Qt.binding(function() { return tile.row * height } )
          }
        }
      }
      Connections {
        target: parent
        onShuffle: {
          if (tile.laysNextTo(hole))
            tile = moveTile(tile)
        }
      }
    }
  }
  signal shuffle
  Connections {
    Component.onCompleted: {
      for (var i = 0; i < 30; i = i + 1)
        shuffle()
    }
  }
}
