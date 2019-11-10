function goTop() {
	var o = document.documentElement.scrollTop || document.body.scrollTop, e = Math.floor(o / 20);
	(function () {
		o -= e, o > -e && (0 == document.documentElement.scrollTop ? document.body.scrollTop = o : document.documentElement.scrollTop = o, setTimeout(arguments.callee, 20))
	})()
}
window.$docsify = {
  name: '在线笔记',
  repo: 'https://github.com/Y-Aron/cloud-note',
  loadSidebar: true,
  auto2top: true,
  subMaxLevel: 6,
  themeable: {
    readyTransition: true,
    responsiveTables: true
  }
}
// var key = 'CACHE_TAIL'
// var tail = ""
// if (window.sessionStorage && window.sessionStorage.getItem(key)) {
//   tail = window.sessionStorage.getItem(key)
// } else {
//   tail = "?v=" + Math.random().toString().slice(-6);
//   window.sessionStorage.setItem(key, tail)
// }
// var scriptStr = "<script src=\"https://cdn.bootcss.com/docsify/4.9.4/docsify.min.js" + tail + "\"><\/script>\n"
//     + "<script src=\"https://cdn.jsdelivr.net/npm/docsify-themeable@0" + tail + "\"><\/script>"
// document.write(scriptStr)