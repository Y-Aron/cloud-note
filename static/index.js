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