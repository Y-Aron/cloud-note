function goTop() {
	var o = document.documentElement.scrollTop || document.body.scrollTop, e = Math.floor(o / 20);
	(function () {
		o -= e, o > -e && (0 == document.documentElement.scrollTop ? document.body.scrollTop = o : document.documentElement.scrollTop = o, setTimeout(arguments.callee, 20))
	})()
}
window.$docsify = {
  name: '????',
  repo: 'https://github.com/Y-Aron/cloud-note',
  loadSidebar: true,
  auto2top: true,
  subMaxLevel: 6,
  themeable: {
    readyTransition: true,
    responsiveTables: true
  }
}
var key = 'CACHE_TAIL'
var tail = ""
if (window.sessionStorage && window.sessionStorage.getItem(key)) {
  tail = window.sessionStorage.getItem(key)
} else {
  tail = "?v=" + Math.random().toString().slice(-6);
  window.sessionStorage.setItem(key, tail)
}
var scriptStr = "<script src=\"https://cdn.bootcss.com/docsify/4.9.4/docsify.min.js" + tail + "\"><\/script>\n"
    + "<script src=\"https://cdn.jsdelivr.net/npm/docsify-themeable@0" + tail + "\"><\/script>"
document.write(scriptStr)

function _typeof(obj) { if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function _possibleConstructorReturn(self, call) { if (call && (_typeof(call) === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _instanceof(left, right) { if (right != null && typeof Symbol !== "undefined" && right[Symbol.hasInstance]) { return !!right[Symbol.hasInstance](left); } else { return left instanceof right; } }

function _classCallCheck(instance, Constructor) { if (!_instanceof(instance, Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

var Circle =
/*#__PURE__*/
function () {
  //????
  //???????
  //????? x?y???r???_mx?_my?????
  //this.r????????????????
  //this._mx,this._my?????????????
  function Circle(x, y) {
    _classCallCheck(this, Circle);

    this.x = x;
    this.y = y;
    this.r = Math.random() * 10;
    this._mx = Math.random();
    this._my = Math.random();
  } //canvas ??????
  //????????canvas????
  //??????????????????????????????????????????????


  _createClass(Circle, [{
    key: "drawCircle",
    value: function drawCircle(ctx) {
      ctx.beginPath(); //arc() ??????????????????????????????

      ctx.arc(this.x, this.y, this.r, 0, 360);
      ctx.closePath();
      ctx.fillStyle = 'rgba(204, 204, 204, 0.3)';
      ctx.fill();
    }
  }, {
    key: "drawLine",
    value: function drawLine(ctx, _circle) {
      var dx = this.x - _circle.x;
      var dy = this.y - _circle.y;
      var d = Math.sqrt(dx * dx + dy * dy);

      if (d < 150) {
        ctx.beginPath(); //???????????? this.x,this.y??????? _circle.x,_circle.y ?????

        ctx.moveTo(this.x, this.y); //???

        ctx.lineTo(_circle.x, _circle.y); //??

        ctx.closePath();
        ctx.strokeStyle = 'rgba(204, 204, 204, 0.3)';
        ctx.stroke();
      }
    } // ????
    // ???????????????

  }, {
    key: "move",
    value: function move(w, h) {
      this._mx = this.x < w && this.x > 0 ? this._mx : -this._mx;
      this._my = this.y < h && this.y > 0 ? this._my : -this._my;
      this.x += this._mx / 2;
      this.y += this._my / 2;
    }
  }]);

  return Circle;
}(); //?????????


var currentCirle =
/*#__PURE__*/
function (_Circle) {
  _inherits(currentCirle, _Circle);

  function currentCirle(x, y) {
    _classCallCheck(this, currentCirle);

    return _possibleConstructorReturn(this, _getPrototypeOf(currentCirle).call(this, x, y));
  }

  _createClass(currentCirle, [{
    key: "drawCircle",
    value: function drawCircle(ctx) {
      ctx.beginPath(); //??????????????????
      //this.r = (this.r < 14 && this.r > 1) ? this.r + (Math.random() * 2 - 1) : 2;

      this.r = 8;
      ctx.arc(this.x, this.y, this.r, 0, 360);
      ctx.closePath(); //ctx.fillStyle = 'rgba(0,0,0,' + (parseInt(Math.random() * 100) / 100) + ')'

      ctx.fillStyle = 'rgba(255, 77, 54, 0.6)';
      ctx.fill();
    }
  }]);

  return currentCirle;
}(Circle); //?????requestAnimationFrame??setTimeout


window.requestAnimationFrame = window.requestAnimationFrame || window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame || window.msRequestAnimationFrame;
var canvas = document.getElementById('canvas');
var ctx = canvas.getContext('2d');
var w = canvas.width = canvas.offsetWidth;
var h = canvas.height = canvas.offsetHeight;
var circles = [];
var current_circle = new currentCirle(0, 0);

var draw = function draw() {
  ctx.clearRect(0, 0, w, h);

  for (var i = 0; i < circles.length; i++) {
    circles[i].move(w, h);
    circles[i].drawCircle(ctx);

    for (j = i + 1; j < circles.length; j++) {
      circles[i].drawLine(ctx, circles[j]);
    }
  }

  if (current_circle.x) {
    current_circle.drawCircle(ctx);

    for (var k = 1; k < circles.length; k++) {
      current_circle.drawLine(ctx, circles[k]);
    }
  }

  requestAnimationFrame(draw);
};

var init = function init(num) {
  for (var i = 0; i < num; i++) {
    circles.push(new Circle(Math.random() * w, Math.random() * h));
  }

  draw();
};

window.addEventListener('load', init(60));

window.onmousemove = function (e) {
  e = e || window.event;
  current_circle.x = e.clientX;
  current_circle.y = e.clientY;
};

window.onmouseout = function () {
  current_circle.x = null;
  current_circle.y = null;
};