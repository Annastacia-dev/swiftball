var t="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;var n={};(function(t,n){n()})(n,(function(){function b(t,n){return"undefined"==typeof n?n={autoBom:!1}:"object"!=typeof n&&(console.warn("Deprecated: Expected third argument to be a object"),n={autoBom:!n}),n.autoBom&&/^\s*(?:text\/\S*|application\/xml|\S*\/\S*\+xml)\s*;.*charset\s*=\s*utf-8/i.test(t.type)?new Blob(["\ufeff",t],{type:t.type}):t}function c(t,n,o){var a=new XMLHttpRequest;a.open("GET",t),a.responseType="blob",a.onload=function(){i(a.response,n,o)},a.onerror=function(){console.error("could not download file")},a.send()}function d(t){var n=new XMLHttpRequest;n.open("HEAD",t,!1);try{n.send()}catch(t){}return 200<=n.status&&299>=n.status}function e(t){try{t.dispatchEvent(new MouseEvent("click"))}catch(o){var n=document.createEvent("MouseEvents");n.initMouseEvent("click",!0,!0,window,0,0,0,80,20,!1,!1,!1,!1,0,null),t.dispatchEvent(n)}}var o="object"==typeof window&&window.window===window?window:"object"==typeof self&&self.self===self?self:"object"==typeof t&&t.global===t?t:void 0,a=o.navigator&&/Macintosh/.test(navigator.userAgent)&&/AppleWebKit/.test(navigator.userAgent)&&!/Safari/.test(navigator.userAgent),i=o.saveAs||("object"!=typeof window||window!==o?function(){}:"download"in HTMLAnchorElement.prototype&&!a?function(t,n,a){var i=o.URL||o.webkitURL,r=document.createElement("a");n=n||t.name||"download",r.download=n,r.rel="noopener","string"==typeof t?(r.href=t,r.origin===location.origin?e(r):d(r.href)?c(t,n,a):e(r,r.target="_blank")):(r.href=i.createObjectURL(t),setTimeout((function(){i.revokeObjectURL(r.href)}),4e4),setTimeout((function(){e(r)}),0))}:"msSaveOrOpenBlob"in navigator?function(t,n,o){if(n=n||t.name||"download","string"!=typeof t)navigator.msSaveOrOpenBlob(b(t,o),n);else if(d(t))c(t,n,o);else{var a=document.createElement("a");a.href=t,a.target="_blank",setTimeout((function(){e(a)}))}}:function(n,i,r,s){if(s=s||open("","_blank"),s&&(s.document.title=s.document.body.innerText="downloading..."),"string"==typeof n)return c(n,i,r);var l="application/octet-stream"===n.type,f=/constructor/i.test(o.HTMLElement)||o.safari,u=/CriOS\/[\d]+/.test(navigator.userAgent);if((u||l&&f||a)&&"undefined"!=typeof FileReader){var p=new FileReader;p.onloadend=function(){var n=p.result;n=u?n:n.replace(/^data:[^;]*;/,"data:attachment/file;"),s?s.location.href=n:t.location=n,s=null},p.readAsDataURL(n)}else{var v=o.URL||o.webkitURL,w=v.createObjectURL(n);s?s.location=w:location.href=w,s=null,setTimeout((function(){v.revokeObjectURL(w)}),4e4)}});o.saveAs=i.saveAs=i,n=i}));var o=n;export default o;
