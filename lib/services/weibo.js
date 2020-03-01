// 微博接口中转层
window.coov = {
	postData(id, data) {
		if (data instanceof Promise) {
			data.then(d => coovjs.postMessage(JSON.stringify({
				type: 'weiboApi',
				data: { response: d, id: id }
			})))
		} else {
			coovjs.postMessage(JSON.stringify({
				type: 'weiboApi',
				data: { response: data, id: id }
			}))
		}
	},
	fetch(url, options) {
		return fetch(url, options).then(res => res.json());
	},
	objToSearch(obj) {
		if (!obj) return '';
		return Object.keys(obj).map(k => `${k}=${obj[k]}`).join('&')
	},
	handleWeibo(statuses) {
		const div = document.createElement('div')
		const text = statuses.text;
		div.innerHTML = text;
		statuses.text = Array.from(div.childNodes).map(node => {
			const obj = {
				type: '',//emoji|img|video|address|tag|br|text|link|fullText
				url: '',
				content: ''
			}
			switch (node.nodeName) {
				case '#text':
					obj.type = 'text';
					obj.content = node.wholeText;
					break;
				case 'BR':
					obj.type = 'br';
					break;
				case 'SPAN':
					obj.type = 'emoji';
					obj.url = node.children[0].src;
					break;
				case 'A':
					obj.type = 'link';//tag|address|user|img|video|fullText
					if (/^#.+#$/.test(node.innerText)) obj.type = 'tag';
					else if (/^@.+/.test(node.innerText)) obj.type = 'user'
					else if (node.innerText === '全文') obj.type = 'fullText';
					else if (node.childNodes[0].nodeName === 'SPAN') {
						if (node.innerText === '查看图片') obj.type = 'img';
						else if (/^https?:\/\/video\.weibo\.com/.test(node.href)) obj.type = 'video';
						else if (/^http:\/\/weibo\.com\/p\//.test(node.href)) obj.type = 'address'
					}
					obj.content = node.innerText;
					obj.url = node.href;
					break;
				default:
					break;
			}
			return obj;
		});
		if (statuses.retweeted_status) window.coov.handleWeibo(statuses.retweeted_status);
	},
	getWeibos(data) {
		return window.coov.fetch('/feed/friends?' + window.coov.objToSearch(data))
			.then(res => {
				const statuses = res.data.statuses;
				statuses.forEach(window.coov.handleWeibo);
				return res;
			});
	}
}

window.coov.postData(0);
