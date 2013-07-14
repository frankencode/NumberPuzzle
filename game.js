function Tile(row, col, index) {
  this.row = row
  this.col = col
  this.index = index
}

Tile.prototype.laysNextTo = function(other) {
  var r = other.row - this.row
  var s = other.col - this.col
  return r * r + s * s == 1
}
