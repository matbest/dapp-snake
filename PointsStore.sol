<!DOCTYPE html>
<!-- saved from url=(0085)https://remix.ethereum.org/#optimize=false&version=soljson-v0.4.21+commit.dfe3193c.js -->
<html class="gr__remix_ethereum_org"><script>(function(){function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s}return e})()({1:[function(_dereq_,module,exports){
(function (process,global){
"use strict";cleanContextForImports(),_dereq_("web3/dist/web3.min.js");var log=_dereq_("loglevel"),LocalMessageDuplexStream=_dereq_("post-message-stream"),setupDappAutoReload=_dereq_("./lib/auto-reload.js"),MetamaskInpageProvider=_dereq_("./lib/inpage-provider.js");restoreContextAfterImports();var METAMASK_DEBUG=process.env.METAMASK_DEBUG;window.log=log,log.setDefaultLevel(METAMASK_DEBUG?"debug":"warn");var metamaskStream=new LocalMessageDuplexStream({name:"inpage",target:"contentscript"}),inpageProvider=new MetamaskInpageProvider(metamaskStream);if(void 0!==window.web3)throw new Error("MetaMask detected another web3.\n     MetaMask will not work reliably with another web3 extension.\n     This usually happens if you have two MetaMasks installed,\n     or MetaMask and another web3 extension. Please remove one\n     and try again.");var web3=new Web3(inpageProvider);web3.setProvider=function(){log.debug("MetaMask - overrode web3.setProvider")},log.debug("MetaMask - injected web3"),setupDappAutoReload(web3,inpageProvider.publicConfigStore),inpageProvider.publicConfigStore.subscribe(function(e){web3.eth.defaultAccount=e.selectedAddress});var __define;function cleanContextForImports(){__define=global.define;try{global.define=void 0}catch(e){console.warn("MetaMask - global.define could not be deleted.")}}function restoreContextAfterImports(){try{global.define=__define}catch(e){console.warn("MetaMask - global.define could not be overwritten.")}}

}).call(this,_dereq_('_process'),typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})

},{"./lib/auto-reload.js":2,"./lib/inpage-provider.js":3,"_process":21,"loglevel":111,"post-message-stream":116,"web3/dist/web3.min.js":139}],2:[function(_dereq_,module,exports){
(function (global){
"use strict";module.exports=setupDappAutoReload;function setupDappAutoReload(e,t){var o=!1,r=!1,i=void 0,n=void 0;global.web3=new Proxy(e,{get:function(e,t){return o||"currentProvider"===t||(console.warn("MetaMask: web3 will be deprecated in the near future in favor of the ethereumProvider \nhttps://github.com/MetaMask/faq/blob/master/detecting_metamask.md#web3-deprecation"),o=!0),i=Date.now(),e[t]},set:function(e,t,o){e[t]=o}}),t.subscribe(function(e){if(!r){var t=e.networkVersion;if(n){if(i&&t!==n){r=!0;Date.now()-i>500?triggerReset():setTimeout(triggerReset,500)}}else n=t}})}function triggerReset(){global.location.reload()}

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})

},{}],3:[function(_dereq_,module,exports){
"use strict";var pump=_dereq_("pump"),RpcEngine=_dereq_("json-rpc-engine"),createIdRemapMiddleware=_dereq_("json-rpc-engine/src/idRemapMiddleware"),createStreamMiddleware=_dereq_("json-rpc-middleware-stream"),LocalStorageStore=_dereq_("obs-store"),asStream=_dereq_("obs-store/lib/asStream"),ObjectMultiplex=_dereq_("obj-multiplex");module.exports=MetamaskInpageProvider;function MetamaskInpageProvider(e){var t=this.mux=new ObjectMultiplex;pump(e,t,e,function(e){return logStreamDisconnectWarning("MetaMask",e)}),this.publicConfigStore=new LocalStorageStore({storageKey:"MetaMask-Config"}),pump(t.createStream("publicConfig"),asStream(this.publicConfigStore),function(e){return logStreamDisconnectWarning("MetaMask PublicConfigStore",e)}),t.ignoreStream("phishing");var r=createStreamMiddleware();pump(r.stream,t.createStream("provider"),r.stream,function(e){return logStreamDisconnectWarning("MetaMask RpcProvider",e)});var a=new RpcEngine;a.push(createIdRemapMiddleware()),a.push(r),this.rpcEngine=a}MetamaskInpageProvider.prototype.sendAsync=function(e,t){this.rpcEngine.handle(e,t)},MetamaskInpageProvider.prototype.send=function(e){var t=void 0,r=null;switch(e.method){case"eth_accounts":r=(t=this.publicConfigStore.getState().selectedAddress)?[t]:[];break;case"eth_coinbase":r=(t=this.publicConfigStore.getState().selectedAddress)||null;break;case"eth_uninstallFilter":this.sendAsync(e,noop),r=!0;break;case"net_version":r=this.publicConfigStore.getState().networkVersion||null;break;default:var a="The MetaMask Web3 object does not support synchronous methods like "+e.method+" without a callback parameter. See https://github.com/MetaMask/faq/blob/master/DEVELOPERS.md#dizzy-all-async---think-of-metamask-as-a-light-client for details.";throw new Error(a)}return{id:e.id,jsonrpc:e.jsonrpc,result:r}},MetamaskInpageProvider.prototype.isConnected=function(){return!0},MetamaskInpageProvider.prototype.isMetaMask=!0;function logStreamDisconnectWarning(e,t){var r="MetamaskInpageProvider - lost connection to "+e;t&&(r+="\n"+t.stack),console.warn(r)}function noop(){}

},{"json-rpc-engine":109,"json-rpc-engine/src/idRemapMiddleware":108,"json-rpc-middleware-stream":110,"obj-multiplex":112,"obs-store":113,"obs-store/lib/asStream":114,"pump":118}],4:[function(_dereq_,module,exports){
(function (process,global){
!function(n,t){"object"==typeof exports&&"undefined"!=typeof module?t(exports):"function"==typeof define&&define.amd?define(["exports"],t):t(n.async=n.async||{})}(this,function(n){"use strict";function t(n,t){t|=0;for(var r=Math.max(n.length-t,0),e=Array(r),i=0;i<r;i++)e[i]=n[t+i];return e}var r=function(n){var r=t(arguments,1);return function(){var e=t(arguments);return n.apply(null,r.concat(e))}},e=function(n){return function(){var r=t(arguments),e=r.pop();n.call(this,r,e)}};function i(n){var t=typeof n;return null!=n&&("object"==t||"function"==t)}var u="function"==typeof setImmediate&&setImmediate,o="object"==typeof process&&"function"==typeof process.nextTick;function c(n){setTimeout(n,0)}function a(n){return function(r){var e=t(arguments,1);n(function(){r.apply(null,e)})}}var f=a(u?setImmediate:o?process.nextTick:c);function l(n){return e(function(t,r){var e;try{e=n.apply(this,t)}catch(n){return r(n)}i(e)&&"function"==typeof e.then?e.then(function(n){s(r,null,n)},function(n){s(r,n.message?n:new Error(n))}):r(null,e)})}function s(n,t,r){try{n(t,r)}catch(n){f(p,n)}}function p(n){throw n}var v="function"==typeof Symbol;function h(n){return v&&"AsyncFunction"===n[Symbol.toStringTag]}function y(n){return h(n)?l(n):n}function d(n){return function(r){var i=t(arguments,1),u=e(function(t,e){var i=this;return n(r,function(n,r){y(n).apply(i,t.concat(r))},e)});return i.length?u.apply(this,i):u}}var m="object"==typeof global&&global&&global.Object===Object&&global,g="object"==typeof self&&self&&self.Object===Object&&self,b=m||g||Function("return this")(),j=b.Symbol,S=Object.prototype,k=S.hasOwnProperty,L=S.toString,O=j?j.toStringTag:void 0;var w=Object.prototype.toString;var x="[object Null]",E="[object Undefined]",A=j?j.toStringTag:void 0;function T(n){return null==n?void 0===n?E:x:A&&A in Object(n)?function(n){var t=k.call(n,O),r=n[O];try{n[O]=void 0;var e=!0}catch(n){}var i=L.call(n);return e&&(t?n[O]=r:delete n[O]),i}(n):(t=n,w.call(t));var t}var B="[object AsyncFunction]",F="[object Function]",I="[object GeneratorFunction]",_="[object Proxy]";var M=9007199254740991;function U(n){return"number"==typeof n&&n>-1&&n%1==0&&n<=M}function z(n){return null!=n&&U(n.length)&&!function(n){if(!i(n))return!1;var t=T(n);return t==F||t==I||t==B||t==_}(n)}var P={};function V(){}function q(n){return function(){if(null!==n){var t=n;n=null,t.apply(this,arguments)}}}var D="function"==typeof Symbol&&Symbol.iterator,R=function(n){return D&&n[D]&&n[D]()};function C(n){return null!=n&&"object"==typeof n}var $="[object Arguments]";function W(n){return C(n)&&T(n)==$}var N=Object.prototype,Q=N.hasOwnProperty,G=N.propertyIsEnumerable,H=W(function(){return arguments}())?W:function(n){return C(n)&&Q.call(n,"callee")&&!G.call(n,"callee")},J=Array.isArray;var K="object"==typeof n&&n&&!n.nodeType&&n,X=K&&"object"==typeof module&&module&&!module.nodeType&&module,Y=X&&X.exports===K?b.Buffer:void 0,Z=(Y?Y.isBuffer:void 0)||function(){return!1},nn=9007199254740991,tn=/^(?:0|[1-9]\d*)$/;var rn={};rn["[object Float32Array]"]=rn["[object Float64Array]"]=rn["[object Int8Array]"]=rn["[object Int16Array]"]=rn["[object Int32Array]"]=rn["[object Uint8Array]"]=rn["[object Uint8ClampedArray]"]=rn["[object Uint16Array]"]=rn["[object Uint32Array]"]=!0,rn["[object Arguments]"]=rn["[object Array]"]=rn["[object ArrayBuffer]"]=rn["[object Boolean]"]=rn["[object DataView]"]=rn["[object Date]"]=rn["[object Error]"]=rn["[object Function]"]=rn["[object Map]"]=rn["[object Number]"]=rn["[object Object]"]=rn["[object RegExp]"]=rn["[object Set]"]=rn["[object String]"]=rn["[object WeakMap]"]=!1;var en,un="object"==typeof n&&n&&!n.nodeType&&n,on=un&&"object"==typeof module&&module&&!module.nodeType&&module,cn=on&&on.exports===un&&m.process,an=function(){try{return cn&&cn.binding&&cn.binding("util")}catch(n){}}(),fn=an&&an.isTypedArray,ln=fn?(en=fn,function(n){return en(n)}):function(n){return C(n)&&U(n.length)&&!!rn[T(n)]},sn=Object.prototype.hasOwnProperty;function pn(n,t){var r=J(n),e=!r&&H(n),i=!r&&!e&&Z(n),u=!r&&!e&&!i&&ln(n),o=r||e||i||u,c=o?function(n,t){for(var r=-1,e=Array(n);++r<n;)e[r]=t(r);return e}(n.length,String):[],a=c.length;for(var f in n)!t&&!sn.call(n,f)||o&&("length"==f||i&&("offset"==f||"parent"==f)||u&&("buffer"==f||"byteLength"==f||"byteOffset"==f)||(l=f,s=a,(s=null==s?nn:s)&&("number"==typeof l||tn.test(l))&&l>-1&&l%1==0&&l<s))||c.push(f);var l,s;return c}var vn=Object.prototype;var hn,yn,dn=(hn=Object.keys,yn=Object,function(n){return hn(yn(n))}),mn=Object.prototype.hasOwnProperty;function gn(n){if(!function(n){var t=n&&n.constructor;return n===("function"==typeof t&&t.prototype||vn)}(n))return dn(n);var t=[];for(var r in Object(n))mn.call(n,r)&&"constructor"!=r&&t.push(r);return t}function bn(n){return z(n)?pn(n):gn(n)}function jn(n){if(z(n))return function(n){var t=-1,r=n.length;return function(){return++t<r?{value:n[t],key:t}:null}}(n);var t=R(n);return t?function(n){var t=-1;return function(){var r=n.next();return r.done?null:(t++,{value:r.value,key:t})}}(t):function(n){var t=bn(n),r=-1,e=t.length;return function(){var i=t[++r];return r<e?{value:n[i],key:i}:null}}(n)}function Sn(n){return function(){if(null===n)throw new Error("Callback was already called.");var t=n;n=null,t.apply(this,arguments)}}function kn(n){return function(t,r,e){if(e=q(e||V),n<=0||!t)return e(null);var i=jn(t),u=!1,o=0;function c(n,t){if(o-=1,n)u=!0,e(n);else{if(t===P||u&&o<=0)return u=!0,e(null);a()}}function a(){for(;o<n&&!u;){var t=i();if(null===t)return u=!0,void(o<=0&&e(null));o+=1,r(t.value,t.key,Sn(c))}}a()}}function Ln(n,t,r,e){kn(t)(n,y(r),e)}function On(n,t){return function(r,e,i){return n(r,t,e,i)}}function wn(n,t,r){r=q(r||V);var e=0,i=0,u=n.length;0===u&&r(null);function o(n,t){n?r(n):++i!==u&&t!==P||r(null)}for(;e<u;e++)t(n[e],e,Sn(o))}var xn=On(Ln,1/0),En=function(n,t,r){(z(n)?wn:xn)(n,y(t),r)};function An(n){return function(t,r,e){return n(En,t,y(r),e)}}function Tn(n,t,r,e){e=e||V,t=t||[];var i=[],u=0,o=y(r);n(t,function(n,t,r){var e=u++;o(n,function(n,t){i[e]=t,r(n)})},function(n){e(n,i)})}var Bn=An(Tn),Fn=d(Bn);function In(n){return function(t,r,e,i){return n(kn(r),t,y(e),i)}}var _n=In(Tn),Mn=On(_n,1),Un=d(Mn);function zn(n,t){for(var r=-1,e=null==n?0:n.length;++r<e&&!1!==t(n[r],r,n););return n}var Pn,Vn=(Pn=void 0,function(n,t,r){for(var e=-1,i=Object(n),u=r(n),o=u.length;o--;){var c=u[Pn?o:++e];if(!1===t(i[c],c,i))break}return n});function qn(n,t){return n&&Vn(n,t,bn)}function Dn(n){return n!=n}function Rn(n,t,r){return t==t?function(n,t,r){for(var e=r-1,i=n.length;++e<i;)if(n[e]===t)return e;return-1}(n,t,r):function(n,t,r,e){for(var i=n.length,u=r+(e?1:-1);e?u--:++u<i;)if(t(n[u],u,n))return u;return-1}(n,Dn,r)}var Cn=function(n,r,e){"function"==typeof r&&(e=r,r=null),e=q(e||V);var i=bn(n).length;if(!i)return e(null);r||(r=i);var u={},o=0,c=!1,a=Object.create(null),f=[],l=[],s={};qn(n,function(t,r){if(!J(t))return p(r,[t]),void l.push(r);var e=t.slice(0,t.length-1),i=e.length;if(0===i)return p(r,t),void l.push(r);s[r]=i,zn(e,function(u){if(!n[u])throw new Error("async.auto task `"+r+"` has a non-existent dependency `"+u+"` in "+e.join(", "));!function(n,t){var r=a[n];r||(r=a[n]=[]);r.push(t)}(u,function(){0===--i&&p(r,t)})})}),function(){var n,t=0;for(;l.length;)n=l.pop(),t++,zn(h(n),function(n){0==--s[n]&&l.push(n)});if(t!==i)throw new Error("async.auto cannot execute tasks due to a recursive dependency")}(),v();function p(n,r){f.push(function(){!function(n,r){if(c)return;var i=Sn(function(r,i){if(o--,arguments.length>2&&(i=t(arguments,1)),r){var f={};qn(u,function(n,t){f[t]=n}),f[n]=i,c=!0,a=Object.create(null),e(r,f)}else u[n]=i,zn(a[n]||[],function(n){n()}),v()});o++;var f=y(r[r.length-1]);r.length>1?f(u,i):f(i)}(n,r)})}function v(){if(0===f.length&&0===o)return e(null,u);for(;f.length&&o<r;){f.shift()()}}function h(t){var r=[];return qn(n,function(n,e){J(n)&&Rn(n,t,0)>=0&&r.push(e)}),r}};function $n(n,t){for(var r=-1,e=null==n?0:n.length,i=Array(e);++r<e;)i[r]=t(n[r],r,n);return i}var Wn="[object Symbol]";var Nn=1/0,Qn=j?j.prototype:void 0,Gn=Qn?Qn.toString:void 0;function Hn(n){if("string"==typeof n)return n;if(J(n))return $n(n,Hn)+"";if("symbol"==typeof(t=n)||C(t)&&T(t)==Wn)return Gn?Gn.call(n):"";var t,r=n+"";return"0"==r&&1/n==-Nn?"-0":r}function Jn(n,t,r){var e=n.length;return r=void 0===r?e:r,!t&&r>=e?n:function(n,t,r){var e=-1,i=n.length;t<0&&(t=-t>i?0:i+t),(r=r>i?i:r)<0&&(r+=i),i=t>r?0:r-t>>>0,t>>>=0;for(var u=Array(i);++e<i;)u[e]=n[e+t];return u}(n,t,r)}var Kn=RegExp("[\\u200d\\ud800-\\udfff\\u0300-\\u036f\\ufe20-\\ufe2f\\u20d0-\\u20ff\\ufe0e\\ufe0f]");var Xn="[\\ud800-\\udfff]",Yn="[\\u0300-\\u036f\\ufe20-\\ufe2f\\u20d0-\\u20ff]",Zn="\\ud83c[\\udffb-\\udfff]",nt="[^\\ud800-\\udfff]",tt="(?:\\ud83c[\\udde6-\\uddff]){2}",rt="[\\ud800-\\udbff][\\udc00-\\udfff]",et="(?:"+Yn+"|"+Zn+")"+"?",it="[\\ufe0e\\ufe0f]?"+et+("(?:\\u200d(?:"+[nt,tt,rt].join("|")+")[\\ufe0e\\ufe0f]?"+et+")*"),ut="(?:"+[nt+Yn+"?",Yn,tt,rt,Xn].join("|")+")",ot=RegExp(Zn+"(?="+Zn+")|"+ut+it,"g");function ct(n){return t=n,Kn.test(t)?n.match(ot)||[]:n.split("");var t}var at=/^\s+|\s+$/g;function ft(n,t,r){var e;if((n=null==(e=n)?"":Hn(e))&&(r||void 0===t))return n.replace(at,"");if(!n||!(t=Hn(t)))return n;var i=ct(n),u=ct(t);return Jn(i,function(n,t){for(var r=-1,e=n.length;++r<e&&Rn(t,n[r],0)>-1;);return r}(i,u),function(n,t){for(var r=n.length;r--&&Rn(t,n[r],0)>-1;);return r}(i,u)+1).join("")}var lt=/^(?:async\s+)?(function)?\s*[^\(]*\(\s*([^\)]*)\)/m,st=/,/,pt=/(=.+)?(\s*)$/,vt=/((\/\/.*$)|(\/\*[\s\S]*?\*\/))/gm;function ht(n,t){var r={};qn(n,function(n,t){var e,i=h(n),u=!i&&1===n.length||i&&0===n.length;if(J(n))e=n.slice(0,-1),n=n[n.length-1],r[t]=e.concat(e.length>0?c:n);else if(u)r[t]=n;else{if(e=o=(o=(o=(o=(o=n).toString().replace(vt,"")).match(lt)[2].replace(" ",""))?o.split(st):[]).map(function(n){return ft(n.replace(pt,""))}),0===n.length&&!i&&0===e.length)throw new Error("autoInject task functions require explicit parameters.");i||e.pop(),r[t]=e.concat(c)}var o;function c(t,r){var i=$n(e,function(n){return t[n]});i.push(r),y(n).apply(null,i)}}),Cn(r,t)}function yt(){this.head=this.tail=null,this.length=0}function dt(n,t){n.length=1,n.head=n.tail=t}yt.prototype.removeLink=function(n){return n.prev?n.prev.next=n.next:this.head=n.next,n.next?n.next.prev=n.prev:this.tail=n.prev,n.prev=n.next=null,this.length-=1,n},yt.prototype.empty=function(){for(;this.head;)this.shift();return this},yt.prototype.insertAfter=function(n,t){t.prev=n,t.next=n.next,n.next?n.next.prev=t:this.tail=t,n.next=t,this.length+=1},yt.prototype.insertBefore=function(n,t){t.prev=n.prev,t.next=n,n.prev?n.prev.next=t:this.head=t,n.prev=t,this.length+=1},yt.prototype.unshift=function(n){this.head?this.insertBefore(this.head,n):dt(this,n)},yt.prototype.push=function(n){this.tail?this.insertAfter(this.tail,n):dt(this,n)},yt.prototype.shift=function(){return this.head&&this.removeLink(this.head)},yt.prototype.pop=function(){return this.tail&&this.removeLink(this.tail)},yt.prototype.toArray=function(){for(var n=Array(this.length),t=this.head,r=0;r<this.length;r++)n[r]=t.data,t=t.next;return n},yt.prototype.remove=function(n){for(var t=this.head;t;){var r=t.next;n(t)&&this.removeLink(t),t=r}return this};function mt(n,t,r){if(null==t)t=1;else if(0===t)throw new Error("Concurrency must not be zero");var e=y(n),i=0,u=[],o=!1;function c(n,t,r){if(null!=r&&"function"!=typeof r)throw new Error("task callback must be a function");if(s.started=!0,J(n)||(n=[n]),0===n.length&&s.idle())return f(function(){s.drain()});for(var e=0,i=n.length;e<i;e++){var u={data:n[e],callback:r||V};t?s._tasks.unshift(u):s._tasks.push(u)}o||(o=!0,f(function(){o=!1,s.process()}))}function a(n){return function(t){i-=1;for(var r=0,e=n.length;r<e;r++){var o=n[r],c=Rn(u,o,0);0===c?u.shift():c>0&&u.splice(c,1),o.callback.apply(o,arguments),null!=t&&s.error(t,o.data)}i<=s.concurrency-s.buffer&&s.unsaturated(),s.idle()&&s.drain(),s.process()}}var l=!1,s={_tasks:new yt,concurrency:t,payload:r,saturated:V,unsaturated:V,buffer:t/4,empty:V,drain:V,error:V,started:!1,paused:!1,push:function(n,t){c(n,!1,t)},kill:function(){s.drain=V,s._tasks.empty()},unshift:function(n,t){c(n,!0,t)},remove:function(n){s._tasks.remove(n)},process:function(){if(!l){for(l=!0;!s.paused&&i<s.concurrency&&s._tasks.length;){var n=[],t=[],r=s._tasks.length;s.payload&&(r=Math.min(r,s.payload));for(var o=0;o<r;o++){var c=s._tasks.shift();n.push(c),u.push(c),t.push(c.data)}i+=1,0===s._tasks.length&&s.empty(),i===s.concurrency&&s.saturated();var f=Sn(a(n));e(t,f)}l=!1}},length:function(){return s._tasks.length},running:function(){return i},workersList:function(){return u},idle:function(){return s._tasks.length+i===0},pause:function(){s.paused=!0},resume:function(){!1!==s.paused&&(s.paused=!1,f(s.process))}};return s}function gt(n,t){return mt(n,1,t)}var bt=On(Ln,1);function jt(n,t,r,e){e=q(e||V);var i=y(r);bt(n,function(n,r,e){i(t,n,function(n,r){t=r,e(n)})},function(n){e(n,t)})}function St(){var n=$n(arguments,y);return function(){var r=t(arguments),e=this,i=r[r.length-1];"function"==typeof i?r.pop():i=V,jt(n,r,function(n,r,i){r.apply(e,n.concat(function(n){var r=t(arguments,1);i(n,r)}))},function(n,t){i.apply(e,[n].concat(t))})}}var kt=function(){return St.apply(null,t(arguments).reverse())},Lt=Array.prototype.concat,Ot=function(n,r,e,i){i=i||V;var u=y(e);_n(n,r,function(n,r){u(n,function(n){return n?r(n):r(null,t(arguments,1))})},function(n,t){for(var r=[],e=0;e<t.length;e++)t[e]&&(r=Lt.apply(r,t[e]));return i(n,r)})},wt=On(Ot,1/0),xt=On(Ot,1),Et=function(){var n=t(arguments),r=[null].concat(n);return function(){return arguments[arguments.length-1].apply(this,r)}};function At(n){return n}function Tt(n,t){return function(r,e,i,u){u=u||V;var o,c=!1;r(e,function(r,e,u){i(r,function(e,i){e?u(e):n(i)&&!o?(c=!0,o=t(!0,r),u(null,P)):u()})},function(n){n?u(n):u(null,c?o:t(!1))})}}function Bt(n,t){return t}var Ft=An(Tt(At,Bt)),It=In(Tt(At,Bt)),_t=On(It,1);function Mt(n){return function(r){var e=t(arguments,1);e.push(function(r){var e=t(arguments,1);"object"==typeof console&&(r?console.error&&console.error(r):console[n]&&zn(e,function(t){console[n](t)}))}),y(r).apply(null,e)}}var Ut=Mt("dir");function zt(n,r,e){e=Sn(e||V);var i=y(n),u=y(r);function o(n){if(n)return e(n);var r=t(arguments,1);r.push(c),u.apply(this,r)}function c(n,t){return n?e(n):t?void i(o):e(null)}c(null,!0)}function Pt(n,r,e){e=Sn(e||V);var i=y(n),u=function(n){if(n)return e(n);var o=t(arguments,1);if(r.apply(this,o))return i(u);e.apply(null,[null].concat(o))};i(u)}function Vt(n,t,r){Pt(n,function(){return!t.apply(this,arguments)},r)}function qt(n,t,r){r=Sn(r||V);var e=y(t),i=y(n);function u(n){if(n)return r(n);i(o)}function o(n,t){return n?r(n):t?void e(u):r(null)}i(o)}function Dt(n){return function(t,r,e){return n(t,e)}}function Rt(n,t,r){En(n,Dt(y(t)),r)}function Ct(n,t,r,e){kn(t)(n,Dt(y(r)),e)}var $t=On(Ct,1);function Wt(n){return h(n)?n:e(function(t,r){var e=!0;t.push(function(){var n=arguments;e?f(function(){r.apply(null,n)}):r.apply(null,n)}),n.apply(this,t),e=!1})}function Nt(n){return!n}var Qt=An(Tt(Nt,Nt)),Gt=In(Tt(Nt,Nt)),Ht=On(Gt,1);function Jt(n){return function(t){return null==t?void 0:t[n]}}function Kt(n,t,r,e){var i=new Array(t.length);n(t,function(n,t,e){r(n,function(n,r){i[t]=!!r,e(n)})},function(n){if(n)return e(n);for(var r=[],u=0;u<t.length;u++)i[u]&&r.push(t[u]);e(null,r)})}function Xt(n,t,r,e){var i=[];n(t,function(n,t,e){r(n,function(r,u){r?e(r):(u&&i.push({index:t,value:n}),e())})},function(n){n?e(n):e(null,$n(i.sort(function(n,t){return n.index-t.index}),Jt("value")))})}function Yt(n,t,r,e){(z(t)?Kt:Xt)(n,t,y(r),e||V)}var Zt=An(Yt),nr=In(Yt),tr=On(nr,1);function rr(n,t){var r=Sn(t||V),e=y(Wt(n));!function n(t){if(t)return r(t);e(n)}()}var er=function(n,t,r,e){e=e||V;var i=y(r);_n(n,t,function(n,t){i(n,function(r,e){return r?t(r):t(null,{key:e,val:n})})},function(n,t){for(var r={},i=Object.prototype.hasOwnProperty,u=0;u<t.length;u++)if(t[u]){var o=t[u].key,c=t[u].val;i.call(r,o)?r[o].push(c):r[o]=[c]}return e(n,r)})},ir=On(er,1/0),ur=On(er,1),or=Mt("log");function cr(n,t,r,e){e=q(e||V);var i={},u=y(r);Ln(n,t,function(n,t,r){u(n,t,function(n,e){if(n)return r(n);i[t]=e,r()})},function(n){e(n,i)})}var ar=On(cr,1/0),fr=On(cr,1);function lr(n,t){return t in n}function sr(n,r){var i=Object.create(null),u=Object.create(null);r=r||At;var o=y(n),c=e(function(n,e){var c=r.apply(null,n);lr(i,c)?f(function(){e.apply(null,i[c])}):lr(u,c)?u[c].push(e):(u[c]=[e],o.apply(null,n.concat(function(){var n=t(arguments);i[c]=n;var r=u[c];delete u[c];for(var e=0,o=r.length;e<o;e++)r[e].apply(null,n)})))});return c.memo=i,c.unmemoized=n,c}var pr=a(o?process.nextTick:u?setImmediate:c);function vr(n,r,e){e=e||V;var i=z(r)?[]:{};n(r,function(n,r,e){y(n)(function(n,u){arguments.length>2&&(u=t(arguments,1)),i[r]=u,e(n)})},function(n){e(n,i)})}function hr(n,t){vr(En,n,t)}function yr(n,t,r){vr(kn(t),n,r)}var dr=function(n,t){var r=y(n);return mt(function(n,t){r(n[0],t)},t,1)},mr=function(n,t){var r=dr(n,t);return r.push=function(n,t,e){if(null==e&&(e=V),"function"!=typeof e)throw new Error("task callback must be a function");if(r.started=!0,J(n)||(n=[n]),0===n.length)return f(function(){r.drain()});t=t||0;for(var i=r._tasks.head;i&&t>=i.priority;)i=i.next;for(var u=0,o=n.length;u<o;u++){var c={data:n[u],priority:t,callback:e};i?r._tasks.insertBefore(i,c):r._tasks.push(c)}f(r.process)},delete r.unshift,r};function gr(n,t){if(t=q(t||V),!J(n))return t(new TypeError("First argument to race must be an array of functions"));if(!n.length)return t();for(var r=0,e=n.length;r<e;r++)y(n[r])(t)}function br(n,r,e,i){jt(t(n).reverse(),r,e,i)}function jr(n){var r=y(n);return e(function(n,e){return n.push(function(n,r){if(n)e(null,{error:n});else{var i;i=arguments.length<=2?r:t(arguments,1),e(null,{value:i})}}),r.apply(this,n)})}function Sr(n){var t;return J(n)?t=$n(n,jr):(t={},qn(n,function(n,r){t[r]=jr.call(this,n)})),t}function kr(n,t,r,e){Yt(n,t,function(n,t){r(n,function(n,r){t(n,!r)})},e)}var Lr=An(kr),Or=In(kr),wr=On(Or,1);function xr(n){return function(){return n}}function Er(n,t,r){var e=5,i=0,u={times:e,intervalFunc:xr(i)};if(arguments.length<3&&"function"==typeof n?(r=t||V,t=n):(!function(n,t){if("object"==typeof t)n.times=+t.times||e,n.intervalFunc="function"==typeof t.interval?t.interval:xr(+t.interval||i),n.errorFilter=t.errorFilter;else{if("number"!=typeof t&&"string"!=typeof t)throw new Error("Invalid arguments for async.retry");n.times=+t||e}}(u,n),r=r||V),"function"!=typeof t)throw new Error("Invalid arguments for async.retry");var o=y(t),c=1;!function n(){o(function(t){t&&c++<u.times&&("function"!=typeof u.errorFilter||u.errorFilter(t))?setTimeout(n,u.intervalFunc(c)):r.apply(null,arguments)})}()}var Ar=function(n,t){t||(t=n,n=null);var r=y(t);return e(function(t,e){function i(n){r.apply(null,t.concat(n))}n?Er(n,i,e):Er(i,e)})};function Tr(n,t){vr(bt,n,t)}var Br=An(Tt(Boolean,At)),Fr=In(Tt(Boolean,At)),Ir=On(Fr,1);function _r(n,t,r){var e=y(t);Bn(n,function(n,t){e(n,function(r,e){if(r)return t(r);t(null,{value:n,criteria:e})})},function(n,t){if(n)return r(n);r(null,$n(t.sort(i),Jt("value")))});function i(n,t){var r=n.criteria,e=t.criteria;return r<e?-1:r>e?1:0}}function Mr(n,t,r){var i=y(n);return e(function(e,u){var o,c=!1;e.push(function(){c||(u.apply(null,arguments),clearTimeout(o))}),o=setTimeout(function(){var t=n.name||"anonymous",e=new Error('Callback function "'+t+'" timed out.');e.code="ETIMEDOUT",r&&(e.info=r),c=!0,u(e)},t),i.apply(null,e)})}var Ur=Math.ceil,zr=Math.max;function Pr(n,t,r,e){var i=y(r);_n(function(n,t,r,e){for(var i=-1,u=zr(Ur((t-n)/(r||1)),0),o=Array(u);u--;)o[e?u:++i]=n,n+=r;return o}(0,n,1),t,i,e)}var Vr=On(Pr,1/0),qr=On(Pr,1);function Dr(n,t,r,e){arguments.length<=3&&(e=r,r=t,t=J(n)?[]:{}),e=q(e||V);var i=y(r);En(n,function(n,r,e){i(t,n,r,e)},function(n){e(n,t)})}function Rr(n,r){var e,i=null;r=r||V,$t(n,function(n,r){y(n)(function(n,u){e=arguments.length>2?t(arguments,1):u,i=n,r(!n)})},function(){r(i,e)})}function Cr(n){return function(){return(n.unmemoized||n).apply(null,arguments)}}function $r(n,r,e){e=Sn(e||V);var i=y(r);if(!n())return e(null);var u=function(r){if(r)return e(r);if(n())return i(u);var o=t(arguments,1);e.apply(null,[null].concat(o))};i(u)}function Wr(n,t,r){$r(function(){return!n.apply(this,arguments)},t,r)}var Nr=function(n,r){if(r=q(r||V),!J(n))return r(new Error("First argument to waterfall must be an array of functions"));if(!n.length)return r();var e=0;function i(t){var r=y(n[e++]);t.push(Sn(u)),r.apply(null,t)}function u(u){if(u||e===n.length)return r.apply(null,arguments);i(t(arguments,1))}i([])},Qr={apply:r,applyEach:Fn,applyEachSeries:Un,asyncify:l,auto:Cn,autoInject:ht,cargo:gt,compose:kt,concat:wt,concatLimit:Ot,concatSeries:xt,constant:Et,detect:Ft,detectLimit:It,detectSeries:_t,dir:Ut,doDuring:zt,doUntil:Vt,doWhilst:Pt,during:qt,each:Rt,eachLimit:Ct,eachOf:En,eachOfLimit:Ln,eachOfSeries:bt,eachSeries:$t,ensureAsync:Wt,every:Qt,everyLimit:Gt,everySeries:Ht,filter:Zt,filterLimit:nr,filterSeries:tr,forever:rr,groupBy:ir,groupByLimit:er,groupBySeries:ur,log:or,map:Bn,mapLimit:_n,mapSeries:Mn,mapValues:ar,mapValuesLimit:cr,mapValuesSeries:fr,memoize:sr,nextTick:pr,parallel:hr,parallelLimit:yr,priorityQueue:mr,queue:dr,race:gr,reduce:jt,reduceRight:br,reflect:jr,reflectAll:Sr,reject:Lr,rejectLimit:Or,rejectSeries:wr,retry:Er,retryable:Ar,seq:St,series:Tr,setImmediate:f,some:Br,someLimit:Fr,someSeries:Ir,sortBy:_r,timeout:Mr,times:Vr,timesLimit:Pr,timesSeries:qr,transform:Dr,tryEach:Rr,unmemoize:Cr,until:Wr,waterfall:Nr,whilst:$r,all:Qt,allLimit:Gt,allSeries:Ht,any:Br,anyLimit:Fr,anySeries:Ir,find:Ft,findLimit:It,findSeries:_t,forEach:Rt,forEachSeries:$t,forEachLimit:Ct,forEachOf:En,forEachOfSeries:bt,forEachOfLimit:Ln,inject:jt,foldl:jt,foldr:br,select:Zt,selectLimit:nr,selectSeries:tr,wrapSync:l};n.default=Qr,n.apply=r,n.applyEach=Fn,n.applyEachSeries=Un,n.asyncify=l,n.auto=Cn,n.autoInject=ht,n.cargo=gt,n.compose=kt,n.concat=wt,n.concatLimit=Ot,n.concatSeries=xt,n.constant=Et,n.detect=Ft,n.detectLimit=It,n.detectSeries=_t,n.dir=Ut,n.doDuring=zt,n.doUntil=Vt,n.doWhilst=Pt,n.during=qt,n.each=Rt,n.eachLimit=Ct,n.eachOf=En,n.eachOfLimit=Ln,n.eachOfSeries=bt,n.eachSeries=$t,n.ensureAsync=Wt,n.every=Qt,n.everyLimit=Gt,n.everySeries=Ht,n.filter=Zt,n.filterLimit=nr,n.filterSeries=tr,n.forever=rr,n.groupBy=ir,n.groupByLimit=er,n.groupBySeries=ur,n.log=or,n.map=Bn,n.mapLimit=_n,n.mapSeries=Mn,n.mapValues=ar,n.mapValuesLimit=cr,n.mapValuesSeries=fr,n.memoize=sr,n.nextTick=pr,n.parallel=hr,n.parallelLimit=yr,n.priorityQueue=mr,n.queue=dr,n.race=gr,n.reduce=jt,n.reduceRight=br,n.reflect=jr,n.reflectAll=Sr,n.reject=Lr,n.rejectLimit=Or,n.rejectSeries=wr,n.retry=Er,n.retryable=Ar,n.seq=St,n.series=Tr,n.setImmediate=f,n.some=Br,n.someLimit=Fr,n.someSeries=Ir,n.sortBy=_r,n.timeout=Mr,n.times=Vr,n.timesLimit=Pr,n.timesSeries=qr,n.transform=Dr,n.tryEach=Rr,n.unmemoize=Cr,n.until=Wr,n.waterfall=Nr,n.whilst=$r,n.all=Qt,n.allLimit=Gt,n.allSeries=Ht,n.any=Br,n.anyLimit=Fr,n.anySeries=Ir,n.find=Ft,n.findLimit=It,n.findSeries=_t,n.forEach=Rt,n.forEachSeries=$t,n.forEachLimit=Ct,n.forEachOf=En,n.forEachOfSeries=bt,n.forEachOfLimit=Ln,n.inject=jt,n.foldl=jt,n.foldr=br,n.select=Zt,n.selectLimit=nr,n.selectSeries=tr,n.wrapSync=l,Object.defineProperty(n,"__esModule",{value:!0})});

}).call(this,_dereq_('_process'),typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})

},{"_process":21}],5:[function(_dereq_,module,exports){
module.exports={default:_dereq_("core-js/library/fn/json/stringify"),__esModule:!0};

},{"core-js/library/fn/json/stringify":23}],6:[function(_dereq_,module,exports){
module.exports={default:_dereq_("core-js/library/fn/object/assign"),__esModule:!0};

},{"core-js/library/fn/object/assign":24}],7:[function(_dereq_,module,exports){
module.exports={default:_dereq_("core-js/library/fn/object/create"),__esModule:!0};

},{"core-js/library/fn/object/create":25}],8:[function(_dereq_,module,exports){
module.exports={default:_dereq_("core-js/library/fn/object/define-property"),__esModule:!0};

},{"core-js/library/fn/object/define-property":26}],9:[function(_dereq_,module,exports){
module.exports={default:_dereq_("core-js/library/fn/object/get-prototype-of"),__esModule:!0};

},{"core-js/library/fn/object/get-prototype-of":27}],10:[function(_dereq_,module,exports){
module.exports={default:_dereq_("core-js/library/fn/object/set-prototype-of"),__esModule:!0};

},{"core-js/library/fn/object/set-prototype-of":28}],11:[function(_dereq_,module,exports){
module.exports={default:_dereq_("core-js/library/fn/symbol"),__esModule:!0};

},{"core-js/library/fn/symbol":29}],12:[function(_dereq_,module,exports){
module.exports={default:_dereq_("core-js/library/fn/symbol/iterator"),__esModule:!0};

},{"core-js/library/fn/symbol/iterator":30}],13:[function(_dereq_,module,exports){
"use strict";exports.__esModule=!0,exports.default=function(t,e){if(!(t instanceof e))throw new TypeError("Cannot call a class as a function")};

},{}],14:[function(_dereq_,module,exports){
"use strict";exports.__esModule=!0;var _defineProperty=_dereq_("../core-js/object/define-property"),_defineProperty2=_interopRequireDefault(_defineProperty);function _interopRequireDefault(e){return e&&e.__esModule?e:{default:e}}exports.default=function(){function e(e,r){for(var t=0;t<r.length;t++){var n=r[t];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),(0,_defineProperty2.default)(e,n.key,n)}}return function(r,t,n){return t&&e(r.prototype,t),n&&e(r,n),r}}();

},{"../core-js/object/define-property":8}],15:[function(_dereq_,module,exports){
"use strict";exports.__esModule=!0;var _setPrototypeOf=_dereq_("../core-js/object/set-prototype-of"),_setPrototypeOf2=_interopRequireDefault(_setPrototypeOf),_create=_dereq_("../core-js/object/create"),_create2=_interopRequireDefault(_create),_typeof2=_dereq_("../helpers/typeof"),_typeof3=_interopRequireDefault(_typeof2);function _interopRequireDefault(e){return e&&e.__esModule?e:{default:e}}exports.default=function(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function, not "+(void 0===t?"undefined":(0,_typeof3.default)(t)));e.prototype=(0,_create2.default)(t&&t.prototype,{constructor:{value:e,enumerable:!1,writable:!0,configurable:!0}}),t&&(_setPrototypeOf2.default?(0,_setPrototypeOf2.default)(e,t):e.__proto__=t)};

},{"../core-js/object/create":7,"../core-js/object/set-prototype-of":10,"../helpers/typeof":17}],16:[function(_dereq_,module,exports){
"use strict";exports.__esModule=!0;var _typeof2=_dereq_("../helpers/typeof"),_typeof3=_interopRequireDefault(_typeof2);function _interopRequireDefault(e){return e&&e.__esModule?e:{default:e}}exports.default=function(e,t){if(!e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return!t||"object"!==(void 0===t?"undefined":(0,_typeof3.default)(t))&&"function"!=typeof t?e:t};

},{"../helpers/typeof":17}],17:[function(_dereq_,module,exports){
"use strict";exports.__esModule=!0;var _iterator=_dereq_("../core-js/symbol/iterator"),_iterator2=_interopRequireDefault(_iterator),_symbol=_dereq_("../core-js/symbol"),_symbol2=_interopRequireDefault(_symbol),_typeof="function"==typeof _symbol2.default&&"symbol"==typeof _iterator2.default?function(t){return typeof t}:function(t){return t&&"function"==typeof _symbol2.default&&t.constructor===_symbol2.default&&t!==_symbol2.default.prototype?"symbol":typeof t};function _interopRequireDefault(t){return t&&t.__esModule?t:{default:t}}exports.default="function"==typeof _symbol2.default&&"symbol"===_typeof(_iterator2.default)?function(t){return void 0===t?"undefined":_typeof(t)}:function(t){return t&&"function"==typeof _symbol2.default&&t.constructor===_symbol2.default&&t!==_symbol2.default.prototype?"symbol":void 0===t?"undefined":_typeof(t)};

},{"../core-js/symbol":11,"../core-js/symbol/iterator":12}],18:[function(_dereq_,module,exports){
"use strict";exports.byteLength=byteLength,exports.toByteArray=toByteArray,exports.fromByteArray=fromByteArray;for(var lookup=[],revLookup=[],Arr="undefined"!=typeof Uint8Array?Uint8Array:Array,code="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",i=0,len=code.length;i<len;++i)lookup[i]=code[i],revLookup[code.charCodeAt(i)]=i;revLookup["-".charCodeAt(0)]=62,revLookup["_".charCodeAt(0)]=63;function placeHoldersCount(o){var r=o.length;if(r%4>0)throw new Error("Invalid string. Length must be a multiple of 4");return"="===o[r-2]?2:"="===o[r-1]?1:0}function byteLength(o){return 3*o.length/4-placeHoldersCount(o)}function toByteArray(o){var r,e,t,u,n,p=o.length;u=placeHoldersCount(o),n=new Arr(3*p/4-u),e=u>0?p-4:p;var a=0;for(r=0;r<e;r+=4)t=revLookup[o.charCodeAt(r)]<<18|revLookup[o.charCodeAt(r+1)]<<12|revLookup[o.charCodeAt(r+2)]<<6|revLookup[o.charCodeAt(r+3)],n[a++]=t>>16&255,n[a++]=t>>8&255,n[a++]=255&t;return 2===u?(t=revLookup[o.charCodeAt(r)]<<2|revLookup[o.charCodeAt(r+1)]>>4,n[a++]=255&t):1===u&&(t=revLookup[o.charCodeAt(r)]<<10|revLookup[o.charCodeAt(r+1)]<<4|revLookup[o.charCodeAt(r+2)]>>2,n[a++]=t>>8&255,n[a++]=255&t),n}function tripletToBase64(o){return lookup[o>>18&63]+lookup[o>>12&63]+lookup[o>>6&63]+lookup[63&o]}function encodeChunk(o,r,e){for(var t,u=[],n=r;n<e;n+=3)t=(o[n]<<16)+(o[n+1]<<8)+o[n+2],u.push(tripletToBase64(t));return u.join("")}function fromByteArray(o){for(var r,e=o.length,t=e%3,u="",n=[],p=0,a=e-t;p<a;p+=16383)n.push(encodeChunk(o,p,p+16383>a?a:p+16383));return 1===t?(r=o[e-1],u+=lookup[r>>2],u+=lookup[r<<4&63],u+="=="):2===t&&(r=(o[e-2]<<8)+o[e-1],u+=lookup[r>>10],u+=lookup[r>>4&63],u+=lookup[r<<2&63],u+="="),n.push(u),n.join("")}

},{}],19:[function(_dereq_,module,exports){

},{}],20:[function(_dereq_,module,exports){
var objectCreate=Object.create||objectCreatePolyfill,objectKeys=Object.keys||objectKeysPolyfill,bind=Function.prototype.bind||functionBindPolyfill;function EventEmitter(){this._events&&Object.prototype.hasOwnProperty.call(this,"_events")||(this._events=objectCreate(null),this._eventsCount=0),this._maxListeners=this._maxListeners||void 0}module.exports=EventEmitter,EventEmitter.EventEmitter=EventEmitter,EventEmitter.prototype._events=void 0,EventEmitter.prototype._maxListeners=void 0;var hasDefineProperty,defaultMaxListeners=10;try{var o={};Object.defineProperty&&Object.defineProperty(o,"x",{value:0}),hasDefineProperty=0===o.x}catch(e){hasDefineProperty=!1}hasDefineProperty?Object.defineProperty(EventEmitter,"defaultMaxListeners",{enumerable:!0,get:function(){return defaultMaxListeners},set:function(e){if("number"!=typeof e||e<0||e!=e)throw new TypeError('"defaultMaxListeners" must be a positive number');defaultMaxListeners=e}}):EventEmitter.defaultMaxListeners=defaultMaxListeners,EventEmitter.prototype.setMaxListeners=function(e){if("number"!=typeof e||e<0||isNaN(e))throw new TypeError('"n" argument must be a positive number');return this._maxListeners=e,this};function $getMaxListeners(e){return void 0===e._maxListeners?EventEmitter.defaultMaxListeners:e._maxListeners}EventEmitter.prototype.getMaxListeners=function(){return $getMaxListeners(this)};function emitNone(e,t,n){if(t)e.call(n);else for(var r=e.length,i=arrayClone(e,r),s=0;s<r;++s)i[s].call(n)}function emitOne(e,t,n,r){if(t)e.call(n,r);else for(var i=e.length,s=arrayClone(e,i),o=0;o<i;++o)s[o].call(n,r)}function emitTwo(e,t,n,r,i){if(t)e.call(n,r,i);else for(var s=e.length,o=arrayClone(e,s),a=0;a<s;++a)o[a].call(n,r,i)}function emitThree(e,t,n,r,i,s){if(t)e.call(n,r,i,s);else for(var o=e.length,a=arrayClone(e,o),l=0;l<o;++l)a[l].call(n,r,i,s)}function emitMany(e,t,n,r){if(t)e.apply(n,r);else for(var i=e.length,s=arrayClone(e,i),o=0;o<i;++o)s[o].apply(n,r)}EventEmitter.prototype.emit=function(e){var t,n,r,i,s,o,a="error"===e;if(o=this._events)a=a&&null==o.error;else if(!a)return!1;if(a){if(arguments.length>1&&(t=arguments[1]),t instanceof Error)throw t;var l=new Error('Unhandled "error" event. ('+t+")");throw l.context=t,l}if(!(n=o[e]))return!1;var u="function"==typeof n;switch(r=arguments.length){case 1:emitNone(n,u,this);break;case 2:emitOne(n,u,this,arguments[1]);break;case 3:emitTwo(n,u,this,arguments[1],arguments[2]);break;case 4:emitThree(n,u,this,arguments[1],arguments[2],arguments[3]);break;default:for(i=new Array(r-1),s=1;s<r;s++)i[s-1]=arguments[s];emitMany(n,u,this,i)}return!0};function _addListener(e,t,n,r){var i,s,o;if("function"!=typeof n)throw new TypeError('"listener" argument must be a function');if((s=e._events)?(s.newListener&&(e.emit("newListener",t,n.listener?n.listener:n),s=e._events),o=s[t]):(s=e._events=objectCreate(null),e._eventsCount=0),o){if("function"==typeof o?o=s[t]=r?[n,o]:[o,n]:r?o.unshift(n):o.push(n),!o.warned&&(i=$getMaxListeners(e))&&i>0&&o.length>i){o.warned=!0;var a=new Error("Possible EventEmitter memory leak detected. "+o.length+' "'+String(t)+'" listeners added. Use emitter.setMaxListeners() to increase limit.');a.name="MaxListenersExceededWarning",a.emitter=e,a.type=t,a.count=o.length,"object"==typeof console&&console.warn&&console.warn("%s: %s",a.name,a.message)}}else o=s[t]=n,++e._eventsCount;return e}EventEmitter.prototype.addListener=function(e,t){return _addListener(this,e,t,!1)},EventEmitter.prototype.on=EventEmitter.prototype.addListener,EventEmitter.prototype.prependListener=function(e,t){return _addListener(this,e,t,!0)};function onceWrapper(){if(!this.fired)switch(this.target.removeListener(this.type,this.wrapFn),this.fired=!0,arguments.length){case 0:return this.listener.call(this.target);case 1:return this.listener.call(this.target,arguments[0]);case 2:return this.listener.call(this.target,arguments[0],arguments[1]);case 3:return this.listener.call(this.target,arguments[0],arguments[1],arguments[2]);default:for(var e=new Array(arguments.length),t=0;t<e.length;++t)e[t]=arguments[t];this.listener.apply(this.target,e)}}function _onceWrap(e,t,n){var r={fired:!1,wrapFn:void 0,target:e,type:t,listener:n},i=bind.call(onceWrapper,r);return i.listener=n,r.wrapFn=i,i}EventEmitter.prototype.once=function(e,t){if("function"!=typeof t)throw new TypeError('"listener" argument must be a function');return this.on(e,_onceWrap(this,e,t)),this},EventEmitter.prototype.prependOnceListener=function(e,t){if("function"!=typeof t)throw new TypeError('"listener" argument must be a function');return this.prependListener(e,_onceWrap(this,e,t)),this},EventEmitter.prototype.removeListener=function(e,t){var n,r,i,s,o;if("function"!=typeof t)throw new TypeError('"listener" argument must be a function');if(!(r=this._events))return this;if(!(n=r[e]))return this;if(n===t||n.listener===t)0==--this._eventsCount?this._events=objectCreate(null):(delete r[e],r.removeListener&&this.emit("removeListener",e,n.listener||t));else if("function"!=typeof n){for(i=-1,s=n.length-1;s>=0;s--)if(n[s]===t||n[s].listener===t){o=n[s].listener,i=s;break}if(i<0)return this;0===i?n.shift():spliceOne(n,i),1===n.length&&(r[e]=n[0]),r.removeListener&&this.emit("removeListener",e,o||t)}return this},EventEmitter.prototype.removeAllListeners=function(e){var t,n,r;if(!(n=this._events))return this;if(!n.removeListener)return 0===arguments.length?(this._events=objectCreate(null),this._eventsCount=0):n[e]&&(0==--this._eventsCount?this._events=objectCreate(null):delete n[e]),this;if(0===arguments.length){var i,s=objectKeys(n);for(r=0;r<s.length;++r)"removeListener"!==(i=s[r])&&this.removeAllListeners(i);return this.removeAllListeners("removeListener"),this._events=objectCreate(null),this._eventsCount=0,this}if("function"==typeof(t=n[e]))this.removeListener(e,t);else if(t)for(r=t.length-1;r>=0;r--)this.removeListener(e,t[r]);return this},EventEmitter.prototype.listeners=function(e){var t,n=this._events;return n&&(t=n[e])?"function"==typeof t?[t.listener||t]:unwrapListeners(t):[]},EventEmitter.listenerCount=function(e,t){return"function"==typeof e.listenerCount?e.listenerCount(t):listenerCount.call(e,t)},EventEmitter.prototype.listenerCount=listenerCount;function listenerCount(e){var t=this._events;if(t){var n=t[e];if("function"==typeof n)return 1;if(n)return n.length}return 0}EventEmitter.prototype.eventNames=function(){return this._eventsCount>0?Reflect.ownKeys(this._events):[]};function spliceOne(e,t){for(var n=t,r=n+1,i=e.length;r<i;n+=1,r+=1)e[n]=e[r];e.pop()}function arrayClone(e,t){for(var n=new Array(t),r=0;r<t;++r)n[r]=e[r];return n}function unwrapListeners(e){for(var t=new Array(e.length),n=0;n<t.length;++n)t[n]=e[n].listener||e[n];return t}function objectCreatePolyfill(e){var t=function(){};return t.prototype=e,new t}function objectKeysPolyfill(e){var t=[];for(var n in e)Object.prototype.hasOwnProperty.call(e,n)&&t.push(n);return n}function functionBindPolyfill(e){var t=this;return function(){return t.apply(e,arguments)}}

},{}],21:[function(_dereq_,module,exports){
var cachedSetTimeout,cachedClearTimeout,process=module.exports={};function defaultSetTimout(){throw new Error("setTimeout has not been defined")}function defaultClearTimeout(){throw new Error("clearTimeout has not been defined")}!function(){try{cachedSetTimeout="function"==typeof setTimeout?setTimeout:defaultSetTimout}catch(e){cachedSetTimeout=defaultSetTimout}try{cachedClearTimeout="function"==typeof clearTimeout?clearTimeout:defaultClearTimeout}catch(e){cachedClearTimeout=defaultClearTimeout}}();function runTimeout(e){if(cachedSetTimeout===setTimeout)return setTimeout(e,0);if((cachedSetTimeout===defaultSetTimout||!cachedSetTimeout)&&setTimeout)return cachedSetTimeout=setTimeout,setTimeout(e,0);try{return cachedSetTimeout(e,0)}catch(t){try{return cachedSetTimeout.call(null,e,0)}catch(t){return cachedSetTimeout.call(this,e,0)}}}function runClearTimeout(e){if(cachedClearTimeout===clearTimeout)return clearTimeout(e);if((cachedClearTimeout===defaultClearTimeout||!cachedClearTimeout)&&clearTimeout)return cachedClearTimeout=clearTimeout,clearTimeout(e);try{return cachedClearTimeout(e)}catch(t){try{return cachedClearTimeout.call(null,e)}catch(t){return cachedClearTimeout.call(this,e)}}}var currentQueue,queue=[],draining=!1,queueIndex=-1;function cleanUpNextTick(){draining&&currentQueue&&(draining=!1,currentQueue.length?queue=currentQueue.concat(queue):queueIndex=-1,queue.length&&drainQueue())}function drainQueue(){if(!draining){var e=runTimeout(cleanUpNextTick);draining=!0;for(var t=queue.length;t;){for(currentQueue=queue,queue=[];++queueIndex<t;)currentQueue&&currentQueue[queueIndex].run();queueIndex=-1,t=queue.length}currentQueue=null,draining=!1,runClearTimeout(e)}}process.nextTick=function(e){var t=new Array(arguments.length-1);if(arguments.length>1)for(var r=1;r<arguments.length;r++)t[r-1]=arguments[r];queue.push(new Item(e,t)),1!==queue.length||draining||runTimeout(drainQueue)};function Item(e,t){this.fun=e,this.array=t}Item.prototype.run=function(){this.fun.apply(null,this.array)},process.title="browser",process.browser=!0,process.env={},process.argv=[],process.version="",process.versions={};function noop(){}process.on=noop,process.addListener=noop,process.once=noop,process.off=noop,process.removeListener=noop,process.removeAllListeners=noop,process.emit=noop,process.prependListener=noop,process.prependOnceListener=noop,process.listeners=function(e){return[]},process.binding=function(e){throw new Error("process.binding is not supported")},process.cwd=function(){return"/"},process.chdir=function(e){throw new Error("process.chdir is not supported")},process.umask=function(){return 0};

},{}],22:[function(_dereq_,module,exports){
"use strict";var base64=_dereq_("base64-js"),ieee754=_dereq_("ieee754");exports.Buffer=Buffer,exports.SlowBuffer=SlowBuffer,exports.INSPECT_MAX_BYTES=50;var K_MAX_LENGTH=2147483647;exports.kMaxLength=K_MAX_LENGTH,Buffer.TYPED_ARRAY_SUPPORT=typedArraySupport(),Buffer.TYPED_ARRAY_SUPPORT||"undefined"==typeof console||"function"!=typeof console.error||console.error("This browser lacks typed array (Uint8Array) support which is required by `buffer` v5.x. Use `buffer` v4.x if you require old browser support.");function typedArraySupport(){try{var e=new Uint8Array(1);return e.__proto__={__proto__:Uint8Array.prototype,foo:function(){return 42}},42===e.foo()}catch(e){return!1}}Object.defineProperty(Buffer.prototype,"parent",{get:function(){if(this instanceof Buffer)return this.buffer}}),Object.defineProperty(Buffer.prototype,"offset",{get:function(){if(this instanceof Buffer)return this.byteOffset}});function createBuffer(e){if(e>K_MAX_LENGTH)throw new RangeError("Invalid typed array length");var t=new Uint8Array(e);return t.__proto__=Buffer.prototype,t}function Buffer(e,t,r){if("number"==typeof e){if("string"==typeof t)throw new Error("If encoding is specified then the first argument must be a string");return allocUnsafe(e)}return from(e,t,r)}"undefined"!=typeof Symbol&&Symbol.species&&Buffer[Symbol.species]===Buffer&&Object.defineProperty(Buffer,Symbol.species,{value:null,configurable:!0,enumerable:!1,writable:!1}),Buffer.poolSize=8192;function from(e,t,r){if("number"==typeof e)throw new TypeError('"value" argument must not be a number');return isArrayBuffer(e)||e&&isArrayBuffer(e.buffer)?fromArrayBuffer(e,t,r):"string"==typeof e?fromString(e,t):fromObject(e)}Buffer.from=function(e,t,r){return from(e,t,r)},Buffer.prototype.__proto__=Uint8Array.prototype,Buffer.__proto__=Uint8Array;function assertSize(e){if("number"!=typeof e)throw new TypeError('"size" argument must be of type number');if(e<0)throw new RangeError('"size" argument must not be negative')}function alloc(e,t,r){return assertSize(e),e<=0?createBuffer(e):void 0!==t?"string"==typeof r?createBuffer(e).fill(t,r):createBuffer(e).fill(t):createBuffer(e)}Buffer.alloc=function(e,t,r){return alloc(e,t,r)};function allocUnsafe(e){return assertSize(e),createBuffer(e<0?0:0|checked(e))}Buffer.allocUnsafe=function(e){return allocUnsafe(e)},Buffer.allocUnsafeSlow=function(e){return allocUnsafe(e)};function fromString(e,t){if("string"==typeof t&&""!==t||(t="utf8"),!Buffer.isEncoding(t))throw new TypeError("Unknown encoding: "+t);var r=0|byteLength(e,t),n=createBuffer(r),f=n.write(e,t);return f!==r&&(n=n.slice(0,f)),n}function fromArrayLike(e){for(var t=e.length<0?0:0|checked(e.length),r=createBuffer(t),n=0;n<t;n+=1)r[n]=255&e[n];return r}function fromArrayBuffer(e,t,r){if(t<0||e.byteLength<t)throw new RangeError('"offset" is outside of buffer bounds');if(e.byteLength<t+(r||0))throw new RangeError('"length" is outside of buffer bounds');var n;return(n=void 0===t&&void 0===r?new Uint8Array(e):void 0===r?new Uint8Array(e,t):new Uint8Array(e,t,r)).__proto__=Buffer.prototype,n}function fromObject(e){if(Buffer.isBuffer(e)){var t=0|checked(e.length),r=createBuffer(t);return 0===r.length?r:(e.copy(r,0,0,t),r)}if(e){if(ArrayBuffer.isView(e)||"length"in e)return"number"!=typeof e.length||numberIsNaN(e.length)?createBuffer(0):fromArrayLike(e);if("Buffer"===e.type&&Array.isArray(e.data))return fromArrayLike(e.data)}throw new TypeError("The first argument must be one of type string, Buffer, ArrayBuffer, Array, or Array-like Object.")}function checked(e){if(e>=K_MAX_LENGTH)throw new RangeError("Attempt to allocate Buffer larger than maximum size: 0x"+K_MAX_LENGTH.toString(16)+" bytes");return 0|e}function SlowBuffer(e){return+e!=e&&(e=0),Buffer.alloc(+e)}Buffer.isBuffer=function(e){return null!=e&&!0===e._isBuffer},Buffer.compare=function(e,t){if(!Buffer.isBuffer(e)||!Buffer.isBuffer(t))throw new TypeError("Arguments must be Buffers");if(e===t)return 0;for(var r=e.length,n=t.length,f=0,i=Math.min(r,n);f<i;++f)if(e[f]!==t[f]){r=e[f],n=t[f];break}return r<n?-1:n<r?1:0},Buffer.isEncoding=function(e){switch(String(e).toLowerCase()){case"hex":case"utf8":case"utf-8":case"ascii":case"latin1":case"binary":case"base64":case"ucs2":case"ucs-2":case"utf16le":case"utf-16le":return!0;default:return!1}},Buffer.concat=function(e,t){if(!Array.isArray(e))throw new TypeError('"list" argument must be an Array of Buffers');if(0===e.length)return Buffer.alloc(0);var r;if(void 0===t)for(t=0,r=0;r<e.length;++r)t+=e[r].length;var n=Buffer.allocUnsafe(t),f=0;for(r=0;r<e.length;++r){var i=e[r];if(ArrayBuffer.isView(i)&&(i=Buffer.from(i)),!Buffer.isBuffer(i))throw new TypeError('"list" argument must be an Array of Buffers');i.copy(n,f),f+=i.length}return n};function byteLength(e,t){if(Buffer.isBuffer(e))return e.length;if(ArrayBuffer.isView(e)||isArrayBuffer(e))return e.byteLength;"string"!=typeof e&&(e=""+e);var r=e.length;if(0===r)return 0;for(var n=!1;;)switch(t){case"ascii":case"latin1":case"binary":return r;case"utf8":case"utf-8":case void 0:return utf8ToBytes(e).length;case"ucs2":case"ucs-2":case"utf16le":case"utf-16le":return 2*r;case"hex":return r>>>1;case"base64":return base64ToBytes(e).length;default:if(n)return utf8ToBytes(e).length;t=(""+t).toLowerCase(),n=!0}}Buffer.byteLength=byteLength;function slowToString(e,t,r){var n=!1;if((void 0===t||t<0)&&(t=0),t>this.length)return"";if((void 0===r||r>this.length)&&(r=this.length),r<=0)return"";if((r>>>=0)<=(t>>>=0))return"";for(e||(e="utf8");;)switch(e){case"hex":return hexSlice(this,t,r);case"utf8":case"utf-8":return utf8Slice(this,t,r);case"ascii":return asciiSlice(this,t,r);case"latin1":case"binary":return latin1Slice(this,t,r);case"base64":return base64Slice(this,t,r);case"ucs2":case"ucs-2":case"utf16le":case"utf-16le":return utf16leSlice(this,t,r);default:if(n)throw new TypeError("Unknown encoding: "+e);e=(e+"").toLowerCase(),n=!0}}Buffer.prototype._isBuffer=!0;function swap(e,t,r){var n=e[t];e[t]=e[r],e[r]=n}Buffer.prototype.swap16=function(){var e=this.length;if(e%2!=0)throw new RangeError("Buffer size must be a multiple of 16-bits");for(var t=0;t<e;t+=2)swap(this,t,t+1);return this},Buffer.prototype.swap32=function(){var e=this.length;if(e%4!=0)throw new RangeError("Buffer size must be a multiple of 32-bits");for(var t=0;t<e;t+=4)swap(this,t,t+3),swap(this,t+1,t+2);return this},Buffer.prototype.swap64=function(){var e=this.length;if(e%8!=0)throw new RangeError("Buffer size must be a multiple of 64-bits");for(var t=0;t<e;t+=8)swap(this,t,t+7),swap(this,t+1,t+6),swap(this,t+2,t+5),swap(this,t+3,t+4);return this},Buffer.prototype.toString=function(){var e=this.length;return 0===e?"":0===arguments.length?utf8Slice(this,0,e):slowToString.apply(this,arguments)},Buffer.prototype.toLocaleString=Buffer.prototype.toString,Buffer.prototype.equals=function(e){if(!Buffer.isBuffer(e))throw new TypeError("Argument must be a Buffer");return this===e||0===Buffer.compare(this,e)},Buffer.prototype.inspect=function(){var e="",t=exports.INSPECT_MAX_BYTES;return this.length>0&&(e=this.toString("hex",0,t).match(/.{2}/g).join(" "),this.length>t&&(e+=" ... ")),"<Buffer "+e+">"},Buffer.prototype.compare=function(e,t,r,n,f){if(!Buffer.isBuffer(e))throw new TypeError("Argument must be a Buffer");if(void 0===t&&(t=0),void 0===r&&(r=e?e.length:0),void 0===n&&(n=0),void 0===f&&(f=this.length),t<0||r>e.length||n<0||f>this.length)throw new RangeError("out of range index");if(n>=f&&t>=r)return 0;if(n>=f)return-1;if(t>=r)return 1;if(t>>>=0,r>>>=0,n>>>=0,f>>>=0,this===e)return 0;for(var i=f-n,o=r-t,u=Math.min(i,o),s=this.slice(n,f),a=e.slice(t,r),h=0;h<u;++h)if(s[h]!==a[h]){i=s[h],o=a[h];break}return i<o?-1:o<i?1:0};function bidirectionalIndexOf(e,t,r,n,f){if(0===e.length)return-1;if("string"==typeof r?(n=r,r=0):r>2147483647?r=2147483647:r<-2147483648&&(r=-2147483648),numberIsNaN(r=+r)&&(r=f?0:e.length-1),r<0&&(r=e.length+r),r>=e.length){if(f)return-1;r=e.length-1}else if(r<0){if(!f)return-1;r=0}if("string"==typeof t&&(t=Buffer.from(t,n)),Buffer.isBuffer(t))return 0===t.length?-1:arrayIndexOf(e,t,r,n,f);if("number"==typeof t)return t&=255,"function"==typeof Uint8Array.prototype.indexOf?f?Uint8Array.prototype.indexOf.call(e,t,r):Uint8Array.prototype.lastIndexOf.call(e,t,r):arrayIndexOf(e,[t],r,n,f);throw new TypeError("val must be string, number or Buffer")}function arrayIndexOf(e,t,r,n,f){var i=1,o=e.length,u=t.length;if(void 0!==n&&("ucs2"===(n=String(n).toLowerCase())||"ucs-2"===n||"utf16le"===n||"utf-16le"===n)){if(e.length<2||t.length<2)return-1;i=2,o/=2,u/=2,r/=2}function s(e,t){return 1===i?e[t]:e.readUInt16BE(t*i)}var a;if(f){var h=-1;for(a=r;a<o;a++)if(s(e,a)===s(t,-1===h?0:a-h)){if(-1===h&&(h=a),a-h+1===u)return h*i}else-1!==h&&(a-=a-h),h=-1}else for(r+u>o&&(r=o-u),a=r;a>=0;a--){for(var c=!0,l=0;l<u;l++)if(s(e,a+l)!==s(t,l)){c=!1;break}if(c)return a}return-1}Buffer.prototype.includes=function(e,t,r){return-1!==this.indexOf(e,t,r)},Buffer.prototype.indexOf=function(e,t,r){return bidirectionalIndexOf(this,e,t,r,!0)},Buffer.prototype.lastIndexOf=function(e,t,r){return bidirectionalIndexOf(this,e,t,r,!1)};function hexWrite(e,t,r,n){r=Number(r)||0;var f=e.length-r;n?(n=Number(n))>f&&(n=f):n=f;var i=t.length;n>i/2&&(n=i/2);for(var o=0;o<n;++o){var u=parseInt(t.substr(2*o,2),16);if(numberIsNaN(u))return o;e[r+o]=u}return o}function utf8Write(e,t,r,n){return blitBuffer(utf8ToBytes(t,e.length-r),e,r,n)}function asciiWrite(e,t,r,n){return blitBuffer(asciiToBytes(t),e,r,n)}function latin1Write(e,t,r,n){return asciiWrite(e,t,r,n)}function base64Write(e,t,r,n){return blitBuffer(base64ToBytes(t),e,r,n)}function ucs2Write(e,t,r,n){return blitBuffer(utf16leToBytes(t,e.length-r),e,r,n)}Buffer.prototype.write=function(e,t,r,n){if(void 0===t)n="utf8",r=this.length,t=0;else if(void 0===r&&"string"==typeof t)n=t,r=this.length,t=0;else{if(!isFinite(t))throw new Error("Buffer.write(string, encoding, offset[, length]) is no longer supported");t>>>=0,isFinite(r)?(r>>>=0,void 0===n&&(n="utf8")):(n=r,r=void 0)}var f=this.length-t;if((void 0===r||r>f)&&(r=f),e.length>0&&(r<0||t<0)||t>this.length)throw new RangeError("Attempt to write outside buffer bounds");n||(n="utf8");for(var i=!1;;)switch(n){case"hex":return hexWrite(this,e,t,r);case"utf8":case"utf-8":return utf8Write(this,e,t,r);case"ascii":return asciiWrite(this,e,t,r);case"latin1":case"binary":return latin1Write(this,e,t,r);case"base64":return base64Write(this,e,t,r);case"ucs2":case"ucs-2":case"utf16le":case"utf-16le":return ucs2Write(this,e,t,r);default:if(i)throw new TypeError("Unknown encoding: "+n);n=(""+n).toLowerCase(),i=!0}},Buffer.prototype.toJSON=function(){return{type:"Buffer",data:Array.prototype.slice.call(this._arr||this,0)}};function base64Slice(e,t,r){return 0===t&&r===e.length?base64.fromByteArray(e):base64.fromByteArray(e.slice(t,r))}function utf8Slice(e,t,r){r=Math.min(e.length,r);for(var n=[],f=t;f<r;){var i=e[f],o=null,u=i>239?4:i>223?3:i>191?2:1;if(f+u<=r){var s,a,h,c;switch(u){case 1:i<128&&(o=i);break;case 2:128==(192&(s=e[f+1]))&&(c=(31&i)<<6|63&s)>127&&(o=c);break;case 3:s=e[f+1],a=e[f+2],128==(192&s)&&128==(192&a)&&(c=(15&i)<<12|(63&s)<<6|63&a)>2047&&(c<55296||c>57343)&&(o=c);break;case 4:s=e[f+1],a=e[f+2],h=e[f+3],128==(192&s)&&128==(192&a)&&128==(192&h)&&(c=(15&i)<<18|(63&s)<<12|(63&a)<<6|63&h)>65535&&c<1114112&&(o=c)}}null===o?(o=65533,u=1):o>65535&&(o-=65536,n.push(o>>>10&1023|55296),o=56320|1023&o),n.push(o),f+=u}return decodeCodePointsArray(n)}var MAX_ARGUMENTS_LENGTH=4096;function decodeCodePointsArray(e){var t=e.length;if(t<=MAX_ARGUMENTS_LENGTH)return String.fromCharCode.apply(String,e);for(var r="",n=0;n<t;)r+=String.fromCharCode.apply(String,e.slice(n,n+=MAX_ARGUMENTS_LENGTH));return r}function asciiSlice(e,t,r){var n="";r=Math.min(e.length,r);for(var f=t;f<r;++f)n+=String.fromCharCode(127&e[f]);return n}function latin1Slice(e,t,r){var n="";r=Math.min(e.length,r);for(var f=t;f<r;++f)n+=String.fromCharCode(e[f]);return n}function hexSlice(e,t,r){var n=e.length;(!t||t<0)&&(t=0),(!r||r<0||r>n)&&(r=n);for(var f="",i=t;i<r;++i)f+=toHex(e[i]);return f}function utf16leSlice(e,t,r){for(var n=e.slice(t,r),f="",i=0;i<n.length;i+=2)f+=String.fromCharCode(n[i]+256*n[i+1]);return f}Buffer.prototype.slice=function(e,t){var r=this.length;e=~~e,t=void 0===t?r:~~t,e<0?(e+=r)<0&&(e=0):e>r&&(e=r),t<0?(t+=r)<0&&(t=0):t>r&&(t=r),t<e&&(t=e);var n=this.subarray(e,t);return n.__proto__=Buffer.prototype,n};function checkOffset(e,t,r){if(e%1!=0||e<0)throw new RangeError("offset is not uint");if(e+t>r)throw new RangeError("Trying to access beyond buffer length")}Buffer.prototype.readUIntLE=function(e,t,r){e>>>=0,t>>>=0,r||checkOffset(e,t,this.length);for(var n=this[e],f=1,i=0;++i<t&&(f*=256);)n+=this[e+i]*f;return n},Buffer.prototype.readUIntBE=function(e,t,r){e>>>=0,t>>>=0,r||checkOffset(e,t,this.length);for(var n=this[e+--t],f=1;t>0&&(f*=256);)n+=this[e+--t]*f;return n},Buffer.prototype.readUInt8=function(e,t){return e>>>=0,t||checkOffset(e,1,this.length),this[e]},Buffer.prototype.readUInt16LE=function(e,t){return e>>>=0,t||checkOffset(e,2,this.length),this[e]|this[e+1]<<8},Buffer.prototype.readUInt16BE=function(e,t){return e>>>=0,t||checkOffset(e,2,this.length),this[e]<<8|this[e+1]},Buffer.prototype.readUInt32LE=function(e,t){return e>>>=0,t||checkOffset(e,4,this.length),(this[e]|this[e+1]<<8|this[e+2]<<16)+16777216*this[e+3]},Buffer.prototype.readUInt32BE=function(e,t){return e>>>=0,t||checkOffset(e,4,this.length),16777216*this[e]+(this[e+1]<<16|this[e+2]<<8|this[e+3])},Buffer.prototype.readIntLE=function(e,t,r){e>>>=0,t>>>=0,r||checkOffset(e,t,this.length);for(var n=this[e],f=1,i=0;++i<t&&(f*=256);)n+=this[e+i]*f;return n>=(f*=128)&&(n-=Math.pow(2,8*t)),n},Buffer.prototype.readIntBE=function(e,t,r){e>>>=0,t>>>=0,r||checkOffset(e,t,this.length);for(var n=t,f=1,i=this[e+--n];n>0&&(f*=256);)i+=this[e+--n]*f;return i>=(f*=128)&&(i-=Math.pow(2,8*t)),i},Buffer.prototype.readInt8=function(e,t){return e>>>=0,t||checkOffset(e,1,this.length),128&this[e]?-1*(255-this[e]+1):this[e]},Buffer.prototype.readInt16LE=function(e,t){e>>>=0,t||checkOffset(e,2,this.length);var r=this[e]|this[e+1]<<8;return 32768&r?4294901760|r:r},Buffer.prototype.readInt16BE=function(e,t){e>>>=0,t||checkOffset(e,2,this.length);var r=this[e+1]|this[e]<<8;return 32768&r?4294901760|r:r},Buffer.prototype.readInt32LE=function(e,t){return e>>>=0,t||checkOffset(e,4,this.length),this[e]|this[e+1]<<8|this[e+2]<<16|this[e+3]<<24},Buffer.prototype.readInt32BE=function(e,t){return e>>>=0,t||checkOffset(e,4,this.length),this[e]<<24|this[e+1]<<16|this[e+2]<<8|this[e+3]},Buffer.prototype.readFloatLE=function(e,t){return e>>>=0,t||checkOffset(e,4,this.length),ieee754.read(this,e,!0,23,4)},Buffer.prototype.readFloatBE=function(e,t){return e>>>=0,t||checkOffset(e,4,this.length),ieee754.read(this,e,!1,23,4)},Buffer.prototype.readDoubleLE=function(e,t){return e>>>=0,t||checkOffset(e,8,this.length),ieee754.read(this,e,!0,52,8)},Buffer.prototype.readDoubleBE=function(e,t){return e>>>=0,t||checkOffset(e,8,this.length),ieee754.read(this,e,!1,52,8)};function checkInt(e,t,r,n,f,i){if(!Buffer.isBuffer(e))throw new TypeError('"buffer" argument must be a Buffer instance');if(t>f||t<i)throw new RangeError('"value" argument is out of bounds');if(r+n>e.length)throw new RangeError("Index out of range")}Buffer.prototype.writeUIntLE=function(e,t,r,n){if(e=+e,t>>>=0,r>>>=0,!n){checkInt(this,e,t,r,Math.pow(2,8*r)-1,0)}var f=1,i=0;for(this[t]=255&e;++i<r&&(f*=256);)this[t+i]=e/f&255;return t+r},Buffer.prototype.writeUIntBE=function(e,t,r,n){if(e=+e,t>>>=0,r>>>=0,!n){checkInt(this,e,t,r,Math.pow(2,8*r)-1,0)}var f=r-1,i=1;for(this[t+f]=255&e;--f>=0&&(i*=256);)this[t+f]=e/i&255;return t+r},Buffer.prototype.writeUInt8=function(e,t,r){return e=+e,t>>>=0,r||checkInt(this,e,t,1,255,0),this[t]=255&e,t+1},Buffer.prototype.writeUInt16LE=function(e,t,r){return e=+e,t>>>=0,r||checkInt(this,e,t,2,65535,0),this[t]=255&e,this[t+1]=e>>>8,t+2},Buffer.prototype.writeUInt16BE=function(e,t,r){return e=+e,t>>>=0,r||checkInt(this,e,t,2,65535,0),this[t]=e>>>8,this[t+1]=255&e,t+2},Buffer.prototype.writeUInt32LE=function(e,t,r){return e=+e,t>>>=0,r||checkInt(this,e,t,4,4294967295,0),this[t+3]=e>>>24,this[t+2]=e>>>16,this[t+1]=e>>>8,this[t]=255&e,t+4},Buffer.prototype.writeUInt32BE=function(e,t,r){return e=+e,t>>>=0,r||checkInt(this,e,t,4,4294967295,0),this[t]=e>>>24,this[t+1]=e>>>16,this[t+2]=e>>>8,this[t+3]=255&e,t+4},Buffer.prototype.writeIntLE=function(e,t,r,n){if(e=+e,t>>>=0,!n){var f=Math.pow(2,8*r-1);checkInt(this,e,t,r,f-1,-f)}var i=0,o=1,u=0;for(this[t]=255&e;++i<r&&(o*=256);)e<0&&0===u&&0!==this[t+i-1]&&(u=1),this[t+i]=(e/o>>0)-u&255;return t+r},Buffer.prototype.writeIntBE=function(e,t,r,n){if(e=+e,t>>>=0,!n){var f=Math.pow(2,8*r-1);checkInt(this,e,t,r,f-1,-f)}var i=r-1,o=1,u=0;for(this[t+i]=255&e;--i>=0&&(o*=256);)e<0&&0===u&&0!==this[t+i+1]&&(u=1),this[t+i]=(e/o>>0)-u&255;return t+r},Buffer.prototype.writeInt8=function(e,t,r){return e=+e,t>>>=0,r||checkInt(this,e,t,1,127,-128),e<0&&(e=255+e+1),this[t]=255&e,t+1},Buffer.prototype.writeInt16LE=function(e,t,r){return e=+e,t>>>=0,r||checkInt(this,e,t,2,32767,-32768),this[t]=255&e,this[t+1]=e>>>8,t+2},Buffer.prototype.writeInt16BE=function(e,t,r){return e=+e,t>>>=0,r||checkInt(this,e,t,2,32767,-32768),this[t]=e>>>8,this[t+1]=255&e,t+2},Buffer.prototype.writeInt32LE=function(e,t,r){return e=+e,t>>>=0,r||checkInt(this,e,t,4,2147483647,-2147483648),this[t]=255&e,this[t+1]=e>>>8,this[t+2]=e>>>16,this[t+3]=e>>>24,t+4},Buffer.prototype.writeInt32BE=function(e,t,r){return e=+e,t>>>=0,r||checkInt(this,e,t,4,2147483647,-2147483648),e<0&&(e=4294967295+e+1),this[t]=e>>>24,this[t+1]=e>>>16,this[t+2]=e>>>8,this[t+3]=255&e,t+4};function checkIEEE754(e,t,r,n,f,i){if(r+n>e.length)throw new RangeError("Index out of range");if(r<0)throw new RangeError("Index out of range")}function writeFloat(e,t,r,n,f){return t=+t,r>>>=0,f||checkIEEE754(e,t,r,4,3.4028234663852886e38,-3.4028234663852886e38),ieee754.write(e,t,r,n,23,4),r+4}Buffer.prototype.writeFloatLE=function(e,t,r){return writeFloat(this,e,t,!0,r)},Buffer.prototype.writeFloatBE=function(e,t,r){return writeFloat(this,e,t,!1,r)};function writeDouble(e,t,r,n,f){return t=+t,r>>>=0,f||checkIEEE754(e,t,r,8,1.7976931348623157e308,-1.7976931348623157e308),ieee754.write(e,t,r,n,52,8),r+8}Buffer.prototype.writeDoubleLE=function(e,t,r){return writeDouble(this,e,t,!0,r)},Buffer.prototype.writeDoubleBE=function(e,t,r){return writeDouble(this,e,t,!1,r)},Buffer.prototype.copy=function(e,t,r,n){if(!Buffer.isBuffer(e))throw new TypeError("argument should be a Buffer");if(r||(r=0),n||0===n||(n=this.length),t>=e.length&&(t=e.length),t||(t=0),n>0&&n<r&&(n=r),n===r)return 0;if(0===e.length||0===this.length)return 0;if(t<0)throw new RangeError("targetStart out of bounds");if(r<0||r>=this.length)throw new RangeError("Index out of range");if(n<0)throw new RangeError("sourceEnd out of bounds");n>this.length&&(n=this.length),e.length-t<n-r&&(n=e.length-t+r);var f=n-r;if(this===e&&"function"==typeof Uint8Array.prototype.copyWithin)this.copyWithin(t,r,n);else if(this===e&&r<t&&t<n)for(var i=f-1;i>=0;--i)e[i+t]=this[i+r];else Uint8Array.prototype.set.call(e,this.subarray(r,n),t);return f},Buffer.prototype.fill=function(e,t,r,n){if("string"==typeof e){if("string"==typeof t?(n=t,t=0,r=this.length):"string"==typeof r&&(n=r,r=this.length),void 0!==n&&"string"!=typeof n)throw new TypeError("encoding must be a string");if("string"==typeof n&&!Buffer.isEncoding(n))throw new TypeError("Unknown encoding: "+n);if(1===e.length){var f=e.charCodeAt(0);("utf8"===n&&f<128||"latin1"===n)&&(e=f)}}else"number"==typeof e&&(e&=255);if(t<0||this.length<t||this.length<r)throw new RangeError("Out of range index");if(r<=t)return this;t>>>=0,r=void 0===r?this.length:r>>>0,e||(e=0);var i;if("number"==typeof e)for(i=t;i<r;++i)this[i]=e;else{var o=Buffer.isBuffer(e)?e:new Buffer(e,n),u=o.length;if(0===u)throw new TypeError('The value "'+e+'" is invalid for argument "value"');for(i=0;i<r-t;++i)this[i+t]=o[i%u]}return this};var INVALID_BASE64_RE=/[^+/0-9A-Za-z-_]/g;function base64clean(e){if((e=(e=e.split("=")[0]).trim().replace(INVALID_BASE64_RE,"")).length<2)return"";for(;e.length%4!=0;)e+="=";return e}function toHex(e){return e<16?"0"+e.toString(16):e.toString(16)}function utf8ToBytes(e,t){t=t||1/0;for(var r,n=e.length,f=null,i=[],o=0;o<n;++o){if((r=e.charCodeAt(o))>55295&&r<57344){if(!f){if(r>56319){(t-=3)>-1&&i.push(239,191,189);continue}if(o+1===n){(t-=3)>-1&&i.push(239,191,189);continue}f=r;continue}if(r<56320){(t-=3)>-1&&i.push(239,191,189),f=r;continue}r=65536+(f-55296<<10|r-56320)}else f&&(t-=3)>-1&&i.push(239,191,189);if(f=null,r<128){if((t-=1)<0)break;i.push(r)}else if(r<2048){if((t-=2)<0)break;i.push(r>>6|192,63&r|128)}else if(r<65536){if((t-=3)<0)break;i.push(r>>12|224,r>>6&63|128,63&r|128)}else{if(!(r<1114112))throw new Error("Invalid code point");if((t-=4)<0)break;i.push(r>>18|240,r>>12&63|128,r>>6&63|128,63&r|128)}}return i}function asciiToBytes(e){for(var t=[],r=0;r<e.length;++r)t.push(255&e.charCodeAt(r));return t}function utf16leToBytes(e,t){for(var r,n,f,i=[],o=0;o<e.length&&!((t-=2)<0);++o)n=(r=e.charCodeAt(o))>>8,f=r%256,i.push(f),i.push(n);return i}function base64ToBytes(e){return base64.toByteArray(base64clean(e))}function blitBuffer(e,t,r,n){for(var f=0;f<n&&!(f+r>=t.length||f>=e.length);++f)t[f+r]=e[f];return f}function isArrayBuffer(e){return e instanceof ArrayBuffer||null!=e&&null!=e.constructor&&"ArrayBuffer"===e.constructor.name&&"number"==typeof e.byteLength}function numberIsNaN(e){return e!=e}

},{"base64-js":18,"ieee754":103}],23:[function(_dereq_,module,exports){
var core=_dereq_("../../modules/_core"),$JSON=core.JSON||(core.JSON={stringify:JSON.stringify});module.exports=function(r){return $JSON.stringify.apply($JSON,arguments)};

},{"../../modules/_core":36}],24:[function(_dereq_,module,exports){
_dereq_("../../modules/es6.object.assign"),module.exports=_dereq_("../../modules/_core").Object.assign;

},{"../../modules/_core":36,"../../modules/es6.object.assign":90}],25:[function(_dereq_,module,exports){
_dereq_("../../modules/es6.object.create");var $Object=_dereq_("../../modules/_core").Object;module.exports=function(e,r){return $Object.create(e,r)};

},{"../../modules/_core":36,"../../modules/es6.object.create":91}],26:[function(_dereq_,module,exports){
_dereq_("../../modules/es6.object.define-property");var $Object=_dereq_("../../modules/_core").Object;module.exports=function(e,r,o){return $Object.defineProperty(e,r,o)};

},{"../../modules/_core":36,"../../modules/es6.object.define-property":92}],27:[function(_dereq_,module,exports){
_dereq_("../../modules/es6.object.get-prototype-of"),module.exports=_dereq_("../../modules/_core").Object.getPrototypeOf;

},{"../../modules/_core":36,"../../modules/es6.object.get-prototype-of":93}],28:[function(_dereq_,module,exports){
_dereq_("../../modules/es6.object.set-prototype-of"),module.exports=_dereq_("../../modules/_core").Object.setPrototypeOf;

},{"../../modules/_core":36,"../../modules/es6.object.set-prototype-of":94}],29:[function(_dereq_,module,exports){
_dereq_("../../modules/es6.symbol"),_dereq_("../../modules/es6.object.to-string"),_dereq_("../../modules/es7.symbol.async-iterator"),_dereq_("../../modules/es7.symbol.observable"),module.exports=_dereq_("../../modules/_core").Symbol;

},{"../../modules/_core":36,"../../modules/es6.object.to-string":95,"../../modules/es6.symbol":97,"../../modules/es7.symbol.async-iterator":98,"../../modules/es7.symbol.observable":99}],30:[function(_dereq_,module,exports){
_dereq_("../../modules/es6.string.iterator"),_dereq_("../../modules/web.dom.iterable"),module.exports=_dereq_("../../modules/_wks-ext").f("iterator");

},{"../../modules/_wks-ext":87,"../../modules/es6.string.iterator":96,"../../modules/web.dom.iterable":100}],31:[function(_dereq_,module,exports){
module.exports=function(o){if("function"!=typeof o)throw TypeError(o+" is not a function!");return o};

},{}],32:[function(_dereq_,module,exports){
module.exports=function(){};

},{}],33:[function(_dereq_,module,exports){
var isObject=_dereq_("./_is-object");module.exports=function(e){if(!isObject(e))throw TypeError(e+" is not an object!");return e};

},{"./_is-object":52}],34:[function(_dereq_,module,exports){
var toIObject=_dereq_("./_to-iobject"),toLength=_dereq_("./_to-length"),toAbsoluteIndex=_dereq_("./_to-absolute-index");module.exports=function(e){return function(t,o,r){var n,u=toIObject(t),i=toLength(u.length),f=toAbsoluteIndex(r,i);if(e&&o!=o){for(;i>f;)if((n=u[f++])!=n)return!0}else for(;i>f;f++)if((e||f in u)&&u[f]===o)return e||f||0;return!e&&-1}};

},{"./_to-absolute-index":79,"./_to-iobject":81,"./_to-length":82}],35:[function(_dereq_,module,exports){
var toString={}.toString;module.exports=function(t){return toString.call(t).slice(8,-1)};

},{}],36:[function(_dereq_,module,exports){
var core=module.exports={version:"2.5.3"};"number"==typeof __e&&(__e=core);

},{}],37:[function(_dereq_,module,exports){
var aFunction=_dereq_("./_a-function");module.exports=function(n,r,t){if(aFunction(n),void 0===r)return n;switch(t){case 1:return function(t){return n.call(r,t)};case 2:return function(t,u){return n.call(r,t,u)};case 3:return function(t,u,e){return n.call(r,t,u,e)}}return function(){return n.apply(r,arguments)}};

},{"./_a-function":31}],38:[function(_dereq_,module,exports){
module.exports=function(o){if(void 0==o)throw TypeError("Can't call method on  "+o);return o};

},{}],39:[function(_dereq_,module,exports){
module.exports=!_dereq_("./_fails")(function(){return 7!=Object.defineProperty({},"a",{get:function(){return 7}}).a});

},{"./_fails":44}],40:[function(_dereq_,module,exports){
var isObject=_dereq_("./_is-object"),document=_dereq_("./_global").document,is=isObject(document)&&isObject(document.createElement);module.exports=function(e){return is?document.createElement(e):{}};

},{"./_global":45,"./_is-object":52}],41:[function(_dereq_,module,exports){
module.exports="constructor,hasOwnProperty,isPrototypeOf,propertyIsEnumerable,toLocaleString,toString,valueOf".split(",");

},{}],42:[function(_dereq_,module,exports){
var getKeys=_dereq_("./_object-keys"),gOPS=_dereq_("./_object-gops"),pIE=_dereq_("./_object-pie");module.exports=function(e){var r=getKeys(e),t=gOPS.f;if(t)for(var o,u=t(e),g=pIE.f,i=0;u.length>i;)g.call(e,o=u[i++])&&r.push(o);return r};

},{"./_object-gops":66,"./_object-keys":69,"./_object-pie":70}],43:[function(_dereq_,module,exports){
var global=_dereq_("./_global"),core=_dereq_("./_core"),ctx=_dereq_("./_ctx"),hide=_dereq_("./_hide"),PROTOTYPE="prototype",$export=function(e,r,t){var o,n,p,i=e&$export.F,x=e&$export.G,c=e&$export.S,l=e&$export.P,u=e&$export.B,a=e&$export.W,$=x?core:core[r]||(core[r]={}),P=$[PROTOTYPE],f=x?global:c?global[r]:(global[r]||{})[PROTOTYPE];x&&(t=r);for(o in t)(n=!i&&f&&void 0!==f[o])&&o in $||(p=n?f[o]:t[o],$[o]=x&&"function"!=typeof f[o]?t[o]:u&&n?ctx(p,global):a&&f[o]==p?function(e){var r=function(r,t,o){if(this instanceof e){switch(arguments.length){case 0:return new e;case 1:return new e(r);case 2:return new e(r,t)}return new e(r,t,o)}return e.apply(this,arguments)};return r[PROTOTYPE]=e[PROTOTYPE],r}(p):l&&"function"==typeof p?ctx(Function.call,p):p,l&&(($.virtual||($.virtual={}))[o]=p,e&$export.R&&P&&!P[o]&&hide(P,o,p)))};$export.F=1,$export.G=2,$export.S=4,$export.P=8,$export.B=16,$export.W=32,$export.U=64,$export.R=128,module.exports=$export;

},{"./_core":36,"./_ctx":37,"./_global":45,"./_hide":47}],44:[function(_dereq_,module,exports){
module.exports=function(r){try{return!!r()}catch(r){return!0}};

},{}],45:[function(_dereq_,module,exports){
var global=module.exports="undefined"!=typeof window&&window.Math==Math?window:"undefined"!=typeof self&&self.Math==Math?self:Function("return this")();"number"==typeof __g&&(__g=global);

},{}],46:[function(_dereq_,module,exports){
var hasOwnProperty={}.hasOwnProperty;module.exports=function(r,e){return hasOwnProperty.call(r,e)};

},{}],47:[function(_dereq_,module,exports){
var dP=_dereq_("./_object-dp"),createDesc=_dereq_("./_property-desc");module.exports=_dereq_("./_descriptors")?function(e,r,t){return dP.f(e,r,createDesc(1,t))}:function(e,r,t){return e[r]=t,e};

},{"./_descriptors":39,"./_object-dp":61,"./_property-desc":72}],48:[function(_dereq_,module,exports){
var document=_dereq_("./_global").document;module.exports=document&&document.documentElement;

},{"./_global":45}],49:[function(_dereq_,module,exports){
module.exports=!_dereq_("./_descriptors")&&!_dereq_("./_fails")(function(){return 7!=Object.defineProperty(_dereq_("./_dom-create")("div"),"a",{get:function(){return 7}}).a});

},{"./_descriptors":39,"./_dom-create":40,"./_fails":44}],50:[function(_dereq_,module,exports){
var cof=_dereq_("./_cof");module.exports=Object("z").propertyIsEnumerable(0)?Object:function(e){return"String"==cof(e)?e.split(""):Object(e)};

},{"./_cof":35}],51:[function(_dereq_,module,exports){
var cof=_dereq_("./_cof");module.exports=Array.isArray||function(r){return"Array"==cof(r)};

},{"./_cof":35}],52:[function(_dereq_,module,exports){
module.exports=function(o){return"object"==typeof o?null!==o:"function"==typeof o};

},{}],53:[function(_dereq_,module,exports){
"use strict";var create=_dereq_("./_object-create"),descriptor=_dereq_("./_property-desc"),setToStringTag=_dereq_("./_set-to-string-tag"),IteratorPrototype={};_dereq_("./_hide")(IteratorPrototype,_dereq_("./_wks")("iterator"),function(){return this}),module.exports=function(r,t,e){r.prototype=create(IteratorPrototype,{next:descriptor(1,e)}),setToStringTag(r,t+" Iterator")};

},{"./_hide":47,"./_object-create":60,"./_property-desc":72,"./_set-to-string-tag":75,"./_wks":88}],54:[function(_dereq_,module,exports){
"use strict";var LIBRARY=_dereq_("./_library"),$export=_dereq_("./_export"),redefine=_dereq_("./_redefine"),hide=_dereq_("./_hide"),has=_dereq_("./_has"),Iterators=_dereq_("./_iterators"),$iterCreate=_dereq_("./_iter-create"),setToStringTag=_dereq_("./_set-to-string-tag"),getPrototypeOf=_dereq_("./_object-gpo"),ITERATOR=_dereq_("./_wks")("iterator"),BUGGY=!([].keys&&"next"in[].keys()),FF_ITERATOR="@@iterator",KEYS="keys",VALUES="values",returnThis=function(){return this};module.exports=function(e,r,t,i,n,o,s){$iterCreate(t,r,i);var u,a,T,R=function(e){if(!BUGGY&&e in f)return f[e];switch(e){case KEYS:case VALUES:return function(){return new t(this,e)}}return function(){return new t(this,e)}},A=r+" Iterator",E=n==VALUES,c=!1,f=e.prototype,h=f[ITERATOR]||f[FF_ITERATOR]||n&&f[n],I=!BUGGY&&h||R(n),p=n?E?R("entries"):I:void 0,_="Array"==r?f.entries||h:h;if(_&&(T=getPrototypeOf(_.call(new e)))!==Object.prototype&&T.next&&(setToStringTag(T,A,!0),LIBRARY||has(T,ITERATOR)||hide(T,ITERATOR,returnThis)),E&&h&&h.name!==VALUES&&(c=!0,I=function(){return h.call(this)}),LIBRARY&&!s||!BUGGY&&!c&&f[ITERATOR]||hide(f,ITERATOR,I),Iterators[r]=I,Iterators[A]=returnThis,n)if(u={values:E?I:R(VALUES),keys:o?I:R(KEYS),entries:p},s)for(a in u)a in f||redefine(f,a,u[a]);else $export($export.P+$export.F*(BUGGY||c),r,u);return u};

},{"./_export":43,"./_has":46,"./_hide":47,"./_iter-create":53,"./_iterators":56,"./_library":57,"./_object-gpo":67,"./_redefine":73,"./_set-to-string-tag":75,"./_wks":88}],55:[function(_dereq_,module,exports){
module.exports=function(e,n){return{value:n,done:!!e}};

},{}],56:[function(_dereq_,module,exports){
module.exports={};

},{}],57:[function(_dereq_,module,exports){
module.exports=!0;

},{}],58:[function(_dereq_,module,exports){
var META=_dereq_("./_uid")("meta"),isObject=_dereq_("./_is-object"),has=_dereq_("./_has"),setDesc=_dereq_("./_object-dp").f,id=0,isExtensible=Object.isExtensible||function(){return!0},FREEZE=!_dereq_("./_fails")(function(){return isExtensible(Object.preventExtensions({}))}),setMeta=function(e){setDesc(e,META,{value:{i:"O"+ ++id,w:{}}})},fastKey=function(e,t){if(!isObject(e))return"symbol"==typeof e?e:("string"==typeof e?"S":"P")+e;if(!has(e,META)){if(!isExtensible(e))return"F";if(!t)return"E";setMeta(e)}return e[META].i},getWeak=function(e,t){if(!has(e,META)){if(!isExtensible(e))return!0;if(!t)return!1;setMeta(e)}return e[META].w},onFreeze=function(e){return FREEZE&&meta.NEED&&isExtensible(e)&&!has(e,META)&&setMeta(e),e},meta=module.exports={KEY:META,NEED:!1,fastKey:fastKey,getWeak:getWeak,onFreeze:onFreeze};

},{"./_fails":44,"./_has":46,"./_is-object":52,"./_object-dp":61,"./_uid":85}],59:[function(_dereq_,module,exports){
"use strict";var getKeys=_dereq_("./_object-keys"),gOPS=_dereq_("./_object-gops"),pIE=_dereq_("./_object-pie"),toObject=_dereq_("./_to-object"),IObject=_dereq_("./_iobject"),$assign=Object.assign;module.exports=!$assign||_dereq_("./_fails")(function(){var e={},t={},r=Symbol(),s="abcdefghijklmnopqrst";return e[r]=7,s.split("").forEach(function(e){t[e]=e}),7!=$assign({},e)[r]||Object.keys($assign({},t)).join("")!=s})?function(e,t){for(var r=toObject(e),s=arguments.length,i=1,o=gOPS.f,c=pIE.f;s>i;)for(var n,a=IObject(arguments[i++]),g=o?getKeys(a).concat(o(a)):getKeys(a),b=g.length,j=0;b>j;)c.call(a,n=g[j++])&&(r[n]=a[n]);return r}:$assign;

},{"./_fails":44,"./_iobject":50,"./_object-gops":66,"./_object-keys":69,"./_object-pie":70,"./_to-object":83}],60:[function(_dereq_,module,exports){
var anObject=_dereq_("./_an-object"),dPs=_dereq_("./_object-dps"),enumBugKeys=_dereq_("./_enum-bug-keys"),IE_PROTO=_dereq_("./_shared-key")("IE_PROTO"),Empty=function(){},PROTOTYPE="prototype",createDict=function(){var e,t=_dereq_("./_dom-create")("iframe"),r=enumBugKeys.length;for(t.style.display="none",_dereq_("./_html").appendChild(t),t.src="javascript:",(e=t.contentWindow.document).open(),e.write("<script>document.F=Object<\/script>"),e.close(),createDict=e.F;r--;)delete createDict[PROTOTYPE][enumBugKeys[r]];return createDict()};module.exports=Object.create||function(e,t){var r;return null!==e?(Empty[PROTOTYPE]=anObject(e),r=new Empty,Empty[PROTOTYPE]=null,r[IE_PROTO]=e):r=createDict(),void 0===t?r:dPs(r,t)};

},{"./_an-object":33,"./_dom-create":40,"./_enum-bug-keys":41,"./_html":48,"./_object-dps":62,"./_shared-key":76}],61:[function(_dereq_,module,exports){
var anObject=_dereq_("./_an-object"),IE8_DOM_DEFINE=_dereq_("./_ie8-dom-define"),toPrimitive=_dereq_("./_to-primitive"),dP=Object.defineProperty;exports.f=_dereq_("./_descriptors")?Object.defineProperty:function(e,r,t){if(anObject(e),r=toPrimitive(r,!0),anObject(t),IE8_DOM_DEFINE)try{return dP(e,r,t)}catch(e){}if("get"in t||"set"in t)throw TypeError("Accessors not supported!");return"value"in t&&(e[r]=t.value),e};

},{"./_an-object":33,"./_descriptors":39,"./_ie8-dom-define":49,"./_to-primitive":84}],62:[function(_dereq_,module,exports){
var dP=_dereq_("./_object-dp"),anObject=_dereq_("./_an-object"),getKeys=_dereq_("./_object-keys");module.exports=_dereq_("./_descriptors")?Object.defineProperties:function(e,r){anObject(e);for(var t,o=getKeys(r),c=o.length,i=0;c>i;)dP.f(e,t=o[i++],r[t]);return e};

},{"./_an-object":33,"./_descriptors":39,"./_object-dp":61,"./_object-keys":69}],63:[function(_dereq_,module,exports){
var pIE=_dereq_("./_object-pie"),createDesc=_dereq_("./_property-desc"),toIObject=_dereq_("./_to-iobject"),toPrimitive=_dereq_("./_to-primitive"),has=_dereq_("./_has"),IE8_DOM_DEFINE=_dereq_("./_ie8-dom-define"),gOPD=Object.getOwnPropertyDescriptor;exports.f=_dereq_("./_descriptors")?gOPD:function(e,r){if(e=toIObject(e),r=toPrimitive(r,!0),IE8_DOM_DEFINE)try{return gOPD(e,r)}catch(e){}if(has(e,r))return createDesc(!pIE.f.call(e,r),e[r])};

},{"./_descriptors":39,"./_has":46,"./_ie8-dom-define":49,"./_object-pie":70,"./_property-desc":72,"./_to-iobject":81,"./_to-primitive":84}],64:[function(_dereq_,module,exports){
var toIObject=_dereq_("./_to-iobject"),gOPN=_dereq_("./_object-gopn").f,toString={}.toString,windowNames="object"==typeof window&&window&&Object.getOwnPropertyNames?Object.getOwnPropertyNames(window):[],getWindowNames=function(e){try{return gOPN(e)}catch(e){return windowNames.slice()}};module.exports.f=function(e){return windowNames&&"[object Window]"==toString.call(e)?getWindowNames(e):gOPN(toIObject(e))};

},{"./_object-gopn":65,"./_to-iobject":81}],65:[function(_dereq_,module,exports){
var $keys=_dereq_("./_object-keys-internal"),hiddenKeys=_dereq_("./_enum-bug-keys").concat("length","prototype");exports.f=Object.getOwnPropertyNames||function(e){return $keys(e,hiddenKeys)};

},{"./_enum-bug-keys":41,"./_object-keys-internal":68}],66:[function(_dereq_,module,exports){
exports.f=Object.getOwnPropertySymbols;

},{}],67:[function(_dereq_,module,exports){
var has=_dereq_("./_has"),toObject=_dereq_("./_to-object"),IE_PROTO=_dereq_("./_shared-key")("IE_PROTO"),ObjectProto=Object.prototype;module.exports=Object.getPrototypeOf||function(t){return t=toObject(t),has(t,IE_PROTO)?t[IE_PROTO]:"function"==typeof t.constructor&&t instanceof t.constructor?t.constructor.prototype:t instanceof Object?ObjectProto:null};

},{"./_has":46,"./_shared-key":76,"./_to-object":83}],68:[function(_dereq_,module,exports){
var has=_dereq_("./_has"),toIObject=_dereq_("./_to-iobject"),arrayIndexOf=_dereq_("./_array-includes")(!1),IE_PROTO=_dereq_("./_shared-key")("IE_PROTO");module.exports=function(r,e){var a,t=toIObject(r),u=0,O=[];for(a in t)a!=IE_PROTO&&has(t,a)&&O.push(a);for(;e.length>u;)has(t,a=e[u++])&&(~arrayIndexOf(O,a)||O.push(a));return O};

},{"./_array-includes":34,"./_has":46,"./_shared-key":76,"./_to-iobject":81}],69:[function(_dereq_,module,exports){
var $keys=_dereq_("./_object-keys-internal"),enumBugKeys=_dereq_("./_enum-bug-keys");module.exports=Object.keys||function(e){return $keys(e,enumBugKeys)};

},{"./_enum-bug-keys":41,"./_object-keys-internal":68}],70:[function(_dereq_,module,exports){
exports.f={}.propertyIsEnumerable;

},{}],71:[function(_dereq_,module,exports){
var $export=_dereq_("./_export"),core=_dereq_("./_core"),fails=_dereq_("./_fails");module.exports=function(e,r){var o=(core.Object||{})[e]||Object[e],t={};t[e]=r(o),$export($export.S+$export.F*fails(function(){o(1)}),"Object",t)};

},{"./_core":36,"./_export":43,"./_fails":44}],72:[function(_dereq_,module,exports){
module.exports=function(e,r){return{enumerable:!(1&e),configurable:!(2&e),writable:!(4&e),value:r}};

},{}],73:[function(_dereq_,module,exports){
module.exports=_dereq_("./_hide");

},{"./_hide":47}],74:[function(_dereq_,module,exports){
var isObject=_dereq_("./_is-object"),anObject=_dereq_("./_an-object"),check=function(t,e){if(anObject(t),!isObject(e)&&null!==e)throw TypeError(e+": can't set as prototype!")};module.exports={set:Object.setPrototypeOf||("__proto__"in{}?function(t,e,c){try{(c=_dereq_("./_ctx")(Function.call,_dereq_("./_object-gopd").f(Object.prototype,"__proto__").set,2))(t,[]),e=!(t instanceof Array)}catch(t){e=!0}return function(t,r){return check(t,r),e?t.__proto__=r:c(t,r),t}}({},!1):void 0),check:check};

},{"./_an-object":33,"./_ctx":37,"./_is-object":52,"./_object-gopd":63}],75:[function(_dereq_,module,exports){
var def=_dereq_("./_object-dp").f,has=_dereq_("./_has"),TAG=_dereq_("./_wks")("toStringTag");module.exports=function(e,r,o){e&&!has(e=o?e:e.prototype,TAG)&&def(e,TAG,{configurable:!0,value:r})};

},{"./_has":46,"./_object-dp":61,"./_wks":88}],76:[function(_dereq_,module,exports){
var shared=_dereq_("./_shared")("keys"),uid=_dereq_("./_uid");module.exports=function(e){return shared[e]||(shared[e]=uid(e))};

},{"./_shared":77,"./_uid":85}],77:[function(_dereq_,module,exports){
var global=_dereq_("./_global"),SHARED="__core-js_shared__",store=global[SHARED]||(global[SHARED]={});module.exports=function(o){return store[o]||(store[o]={})};

},{"./_global":45}],78:[function(_dereq_,module,exports){
var toInteger=_dereq_("./_to-integer"),defined=_dereq_("./_defined");module.exports=function(e){return function(r,t){var n,i,d=String(defined(r)),o=toInteger(t),u=d.length;return o<0||o>=u?e?"":void 0:(n=d.charCodeAt(o))<55296||n>56319||o+1===u||(i=d.charCodeAt(o+1))<56320||i>57343?e?d.charAt(o):n:e?d.slice(o,o+2):i-56320+(n-55296<<10)+65536}};

},{"./_defined":38,"./_to-integer":80}],79:[function(_dereq_,module,exports){
var toInteger=_dereq_("./_to-integer"),max=Math.max,min=Math.min;module.exports=function(e,t){return(e=toInteger(e))<0?max(e+t,0):min(e,t)};

},{"./_to-integer":80}],80:[function(_dereq_,module,exports){
var ceil=Math.ceil,floor=Math.floor;module.exports=function(o){return isNaN(o=+o)?0:(o>0?floor:ceil)(o)};

},{}],81:[function(_dereq_,module,exports){
var IObject=_dereq_("./_iobject"),defined=_dereq_("./_defined");module.exports=function(e){return IObject(defined(e))};

},{"./_defined":38,"./_iobject":50}],82:[function(_dereq_,module,exports){
var toInteger=_dereq_("./_to-integer"),min=Math.min;module.exports=function(e){return e>0?min(toInteger(e),9007199254740991):0};

},{"./_to-integer":80}],83:[function(_dereq_,module,exports){
var defined=_dereq_("./_defined");module.exports=function(e){return Object(defined(e))};

},{"./_defined":38}],84:[function(_dereq_,module,exports){
var isObject=_dereq_("./_is-object");module.exports=function(t,e){if(!isObject(t))return t;var r,i;if(e&&"function"==typeof(r=t.toString)&&!isObject(i=r.call(t)))return i;if("function"==typeof(r=t.valueOf)&&!isObject(i=r.call(t)))return i;if(!e&&"function"==typeof(r=t.toString)&&!isObject(i=r.call(t)))return i;throw TypeError("Can't convert object to primitive value")};

},{"./_is-object":52}],85:[function(_dereq_,module,exports){
var id=0,px=Math.random();module.exports=function(o){return"Symbol(".concat(void 0===o?"":o,")_",(++id+px).toString(36))};

},{}],86:[function(_dereq_,module,exports){
var global=_dereq_("./_global"),core=_dereq_("./_core"),LIBRARY=_dereq_("./_library"),wksExt=_dereq_("./_wks-ext"),defineProperty=_dereq_("./_object-dp").f;module.exports=function(e){var r=core.Symbol||(core.Symbol=LIBRARY?{}:global.Symbol||{});"_"==e.charAt(0)||e in r||defineProperty(r,e,{value:wksExt.f(e)})};

},{"./_core":36,"./_global":45,"./_library":57,"./_object-dp":61,"./_wks-ext":87}],87:[function(_dereq_,module,exports){
exports.f=_dereq_("./_wks");

},{"./_wks":88}],88:[function(_dereq_,module,exports){
var store=_dereq_("./_shared")("wks"),uid=_dereq_("./_uid"),Symbol=_dereq_("./_global").Symbol,USE_SYMBOL="function"==typeof Symbol,$exports=module.exports=function(o){return store[o]||(store[o]=USE_SYMBOL&&Symbol[o]||(USE_SYMBOL?Symbol:uid)("Symbol."+o))};$exports.store=store;

},{"./_global":45,"./_shared":77,"./_uid":85}],89:[function(_dereq_,module,exports){
"use strict";var addToUnscopables=_dereq_("./_add-to-unscopables"),step=_dereq_("./_iter-step"),Iterators=_dereq_("./_iterators"),toIObject=_dereq_("./_to-iobject");module.exports=_dereq_("./_iter-define")(Array,"Array",function(e,t){this._t=toIObject(e),this._i=0,this._k=t},function(){var e=this._t,t=this._k,s=this._i++;return!e||s>=e.length?(this._t=void 0,step(1)):step(0,"keys"==t?s:"values"==t?e[s]:[s,e[s]])},"values"),Iterators.Arguments=Iterators.Array,addToUnscopables("keys"),addToUnscopables("values"),addToUnscopables("entries");

},{"./_add-to-unscopables":32,"./_iter-define":54,"./_iter-step":55,"./_iterators":56,"./_to-iobject":81}],90:[function(_dereq_,module,exports){
var $export=_dereq_("./_export");$export($export.S+$export.F,"Object",{assign:_dereq_("./_object-assign")});

},{"./_export":43,"./_object-assign":59}],91:[function(_dereq_,module,exports){
var $export=_dereq_("./_export");$export($export.S,"Object",{create:_dereq_("./_object-create")});

},{"./_export":43,"./_object-create":60}],92:[function(_dereq_,module,exports){
var $export=_dereq_("./_export");$export($export.S+$export.F*!_dereq_("./_descriptors"),"Object",{defineProperty:_dereq_("./_object-dp").f});

},{"./_descriptors":39,"./_export":43,"./_object-dp":61}],93:[function(_dereq_,module,exports){
var toObject=_dereq_("./_to-object"),$getPrototypeOf=_dereq_("./_object-gpo");_dereq_("./_object-sap")("getPrototypeOf",function(){return function(t){return $getPrototypeOf(toObject(t))}});

},{"./_object-gpo":67,"./_object-sap":71,"./_to-object":83}],94:[function(_dereq_,module,exports){
var $export=_dereq_("./_export");$export($export.S,"Object",{setPrototypeOf:_dereq_("./_set-proto").set});

},{"./_export":43,"./_set-proto":74}],95:[function(_dereq_,module,exports){

},{}],96:[function(_dereq_,module,exports){
"use strict";var $at=_dereq_("./_string-at")(!0);_dereq_("./_iter-define")(String,"String",function(t){this._t=String(t),this._i=0},function(){var t,i=this._t,e=this._i;return e>=i.length?{value:void 0,done:!0}:(t=$at(i,e),this._i+=t.length,{value:t,done:!1})});

},{"./_iter-define":54,"./_string-at":78}],97:[function(_dereq_,module,exports){
"use strict";var global=_dereq_("./_global"),has=_dereq_("./_has"),DESCRIPTORS=_dereq_("./_descriptors"),$export=_dereq_("./_export"),redefine=_dereq_("./_redefine"),META=_dereq_("./_meta").KEY,$fails=_dereq_("./_fails"),shared=_dereq_("./_shared"),setToStringTag=_dereq_("./_set-to-string-tag"),uid=_dereq_("./_uid"),wks=_dereq_("./_wks"),wksExt=_dereq_("./_wks-ext"),wksDefine=_dereq_("./_wks-define"),enumKeys=_dereq_("./_enum-keys"),isArray=_dereq_("./_is-array"),anObject=_dereq_("./_an-object"),isObject=_dereq_("./_is-object"),toIObject=_dereq_("./_to-iobject"),toPrimitive=_dereq_("./_to-primitive"),createDesc=_dereq_("./_property-desc"),_create=_dereq_("./_object-create"),gOPNExt=_dereq_("./_object-gopn-ext"),$GOPD=_dereq_("./_object-gopd"),$DP=_dereq_("./_object-dp"),$keys=_dereq_("./_object-keys"),gOPD=$GOPD.f,dP=$DP.f,gOPN=gOPNExt.f,$Symbol=global.Symbol,$JSON=global.JSON,_stringify=$JSON&&$JSON.stringify,PROTOTYPE="prototype",HIDDEN=wks("_hidden"),TO_PRIMITIVE=wks("toPrimitive"),isEnum={}.propertyIsEnumerable,SymbolRegistry=shared("symbol-registry"),AllSymbols=shared("symbols"),OPSymbols=shared("op-symbols"),ObjectProto=Object[PROTOTYPE],USE_NATIVE="function"==typeof $Symbol,QObject=global.QObject,setter=!QObject||!QObject[PROTOTYPE]||!QObject[PROTOTYPE].findChild,setSymbolDesc=DESCRIPTORS&&$fails(function(){return 7!=_create(dP({},"a",{get:function(){return dP(this,"a",{value:7}).a}})).a})?function(e,r,t){var o=gOPD(ObjectProto,r);o&&delete ObjectProto[r],dP(e,r,t),o&&e!==ObjectProto&&dP(ObjectProto,r,o)}:dP,wrap=function(e){var r=AllSymbols[e]=_create($Symbol[PROTOTYPE]);return r._k=e,r},isSymbol=USE_NATIVE&&"symbol"==typeof $Symbol.iterator?function(e){return"symbol"==typeof e}:function(e){return e instanceof $Symbol},$defineProperty=function(e,r,t){return e===ObjectProto&&$defineProperty(OPSymbols,r,t),anObject(e),r=toPrimitive(r,!0),anObject(t),has(AllSymbols,r)?(t.enumerable?(has(e,HIDDEN)&&e[HIDDEN][r]&&(e[HIDDEN][r]=!1),t=_create(t,{enumerable:createDesc(0,!1)})):(has(e,HIDDEN)||dP(e,HIDDEN,createDesc(1,{})),e[HIDDEN][r]=!0),setSymbolDesc(e,r,t)):dP(e,r,t)},$defineProperties=function(e,r){anObject(e);for(var t,o=enumKeys(r=toIObject(r)),i=0,s=o.length;s>i;)$defineProperty(e,t=o[i++],r[t]);return e},$create=function(e,r){return void 0===r?_create(e):$defineProperties(_create(e),r)},$propertyIsEnumerable=function(e){var r=isEnum.call(this,e=toPrimitive(e,!0));return!(this===ObjectProto&&has(AllSymbols,e)&&!has(OPSymbols,e))&&(!(r||!has(this,e)||!has(AllSymbols,e)||has(this,HIDDEN)&&this[HIDDEN][e])||r)},$getOwnPropertyDescriptor=function(e,r){if(e=toIObject(e),r=toPrimitive(r,!0),e!==ObjectProto||!has(AllSymbols,r)||has(OPSymbols,r)){var t=gOPD(e,r);return!t||!has(AllSymbols,r)||has(e,HIDDEN)&&e[HIDDEN][r]||(t.enumerable=!0),t}},$getOwnPropertyNames=function(e){for(var r,t=gOPN(toIObject(e)),o=[],i=0;t.length>i;)has(AllSymbols,r=t[i++])||r==HIDDEN||r==META||o.push(r);return o},$getOwnPropertySymbols=function(e){for(var r,t=e===ObjectProto,o=gOPN(t?OPSymbols:toIObject(e)),i=[],s=0;o.length>s;)!has(AllSymbols,r=o[s++])||t&&!has(ObjectProto,r)||i.push(AllSymbols[r]);return i};USE_NATIVE||(redefine(($Symbol=function(){if(this instanceof $Symbol)throw TypeError("Symbol is not a constructor!");var e=uid(arguments.length>0?arguments[0]:void 0),r=function(t){this===ObjectProto&&r.call(OPSymbols,t),has(this,HIDDEN)&&has(this[HIDDEN],e)&&(this[HIDDEN][e]=!1),setSymbolDesc(this,e,createDesc(1,t))};return DESCRIPTORS&&setter&&setSymbolDesc(ObjectProto,e,{configurable:!0,set:r}),wrap(e)})[PROTOTYPE],"toString",function(){return this._k}),$GOPD.f=$getOwnPropertyDescriptor,$DP.f=$defineProperty,_dereq_("./_object-gopn").f=gOPNExt.f=$getOwnPropertyNames,_dereq_("./_object-pie").f=$propertyIsEnumerable,_dereq_("./_object-gops").f=$getOwnPropertySymbols,DESCRIPTORS&&!_dereq_("./_library")&&redefine(ObjectProto,"propertyIsEnumerable",$propertyIsEnumerable,!0),wksExt.f=function(e){return wrap(wks(e))}),$export($export.G+$export.W+$export.F*!USE_NATIVE,{Symbol:$Symbol});for(var es6Symbols="hasInstance,isConcatSpreadable,iterator,match,replace,search,species,split,toPrimitive,toStringTag,unscopables".split(","),j=0;es6Symbols.length>j;)wks(es6Symbols[j++]);for(var wellKnownSymbols=$keys(wks.store),k=0;wellKnownSymbols.length>k;)wksDefine(wellKnownSymbols[k++]);$export($export.S+$export.F*!USE_NATIVE,"Symbol",{for:function(e){return has(SymbolRegistry,e+="")?SymbolRegistry[e]:SymbolRegistry[e]=$Symbol(e)},keyFor:function(e){if(!isSymbol(e))throw TypeError(e+" is not a symbol!");for(var r in SymbolRegistry)if(SymbolRegistry[r]===e)return r},useSetter:function(){setter=!0},useSimple:function(){setter=!1}}),$export($export.S+$export.F*!USE_NATIVE,"Object",{create:$create,defineProperty:$defineProperty,defineProperties:$defineProperties,getOwnPropertyDescriptor:$getOwnPropertyDescriptor,getOwnPropertyNames:$getOwnPropertyNames,getOwnPropertySymbols:$getOwnPropertySymbols}),$JSON&&$export($export.S+$export.F*(!USE_NATIVE||$fails(function(){var e=$Symbol();return"[null]"!=_stringify([e])||"{}"!=_stringify({a:e})||"{}"!=_stringify(Object(e))})),"JSON",{stringify:function(e){for(var r,t,o=[e],i=1;arguments.length>i;)o.push(arguments[i++]);if(t=r=o[1],(isObject(r)||void 0!==e)&&!isSymbol(e))return isArray(r)||(r=function(e,r){if("function"==typeof t&&(r=t.call(this,e,r)),!isSymbol(r))return r}),o[1]=r,_stringify.apply($JSON,o)}}),$Symbol[PROTOTYPE][TO_PRIMITIVE]||_dereq_("./_hide")($Symbol[PROTOTYPE],TO_PRIMITIVE,$Symbol[PROTOTYPE].valueOf),setToStringTag($Symbol,"Symbol"),setToStringTag(Math,"Math",!0),setToStringTag(global.JSON,"JSON",!0);

},{"./_an-object":33,"./_descriptors":39,"./_enum-keys":42,"./_export":43,"./_fails":44,"./_global":45,"./_has":46,"./_hide":47,"./_is-array":51,"./_is-object":52,"./_library":57,"./_meta":58,"./_object-create":60,"./_object-dp":61,"./_object-gopd":63,"./_object-gopn":65,"./_object-gopn-ext":64,"./_object-gops":66,"./_object-keys":69,"./_object-pie":70,"./_property-desc":72,"./_redefine":73,"./_set-to-string-tag":75,"./_shared":77,"./_to-iobject":81,"./_to-primitive":84,"./_uid":85,"./_wks":88,"./_wks-define":86,"./_wks-ext":87}],98:[function(_dereq_,module,exports){
_dereq_("./_wks-define")("asyncIterator");

},{"./_wks-define":86}],99:[function(_dereq_,module,exports){
_dereq_("./_wks-define")("observable");

},{"./_wks-define":86}],100:[function(_dereq_,module,exports){
_dereq_("./es6.array.iterator");for(var global=_dereq_("./_global"),hide=_dereq_("./_hide"),Iterators=_dereq_("./_iterators"),TO_STRING_TAG=_dereq_("./_wks")("toStringTag"),DOMIterables="CSSRuleList,CSSStyleDeclaration,CSSValueList,ClientRectList,DOMRectList,DOMStringList,DOMTokenList,DataTransferItemList,FileList,HTMLAllCollection,HTMLCollection,HTMLFormElement,HTMLSelectElement,MediaList,MimeTypeArray,NamedNodeMap,NodeList,PaintRequestList,Plugin,PluginArray,SVGLengthList,SVGNumberList,SVGPathSegList,SVGPointList,SVGStringList,SVGTransformList,SourceBufferList,StyleSheetList,TextTrackCueList,TextTrackList,TouchList".split(","),i=0;i<DOMIterables.length;i++){var NAME=DOMIterables[i],Collection=global[NAME],proto=Collection&&Collection.prototype;proto&&!proto[TO_STRING_TAG]&&hide(proto,TO_STRING_TAG,NAME),Iterators[NAME]=Iterators.Array}

},{"./_global":45,"./_hide":47,"./_iterators":56,"./_wks":88,"./es6.array.iterator":89}],101:[function(_dereq_,module,exports){
(function (Buffer){
function isArray(r){return Array.isArray?Array.isArray(r):"[object Array]"===objectToString(r)}exports.isArray=isArray;function isBoolean(r){return"boolean"==typeof r}exports.isBoolean=isBoolean;function isNull(r){return null===r}exports.isNull=isNull;function isNullOrUndefined(r){return null==r}exports.isNullOrUndefined=isNullOrUndefined;function isNumber(r){return"number"==typeof r}exports.isNumber=isNumber;function isString(r){return"string"==typeof r}exports.isString=isString;function isSymbol(r){return"symbol"==typeof r}exports.isSymbol=isSymbol;function isUndefined(r){return void 0===r}exports.isUndefined=isUndefined;function isRegExp(r){return"[object RegExp]"===objectToString(r)}exports.isRegExp=isRegExp;function isObject(r){return"object"==typeof r&&null!==r}exports.isObject=isObject;function isDate(r){return"[object Date]"===objectToString(r)}exports.isDate=isDate;function isError(r){return"[object Error]"===objectToString(r)||r instanceof Error}exports.isError=isError;function isFunction(r){return"function"==typeof r}exports.isFunction=isFunction;function isPrimitive(r){return null===r||"boolean"==typeof r||"number"==typeof r||"string"==typeof r||"symbol"==typeof r||void 0===r}exports.isPrimitive=isPrimitive,exports.isBuffer=Buffer.isBuffer;function objectToString(r){return Object.prototype.toString.call(r)}

}).call(this,{"isBuffer":_dereq_("../../is-buffer/index.js")})

},{"../../is-buffer/index.js":105}],102:[function(_dereq_,module,exports){
var once=_dereq_("once"),noop=function(){},isRequest=function(e){return e.setHeader&&"function"==typeof e.abort},isChildProcess=function(e){return e.stdio&&Array.isArray(e.stdio)&&3===e.stdio.length},eos=function(e,r,n){if("function"==typeof r)return eos(e,null,r);r||(r={}),n=once(n||noop);var o=e._writableState,t=e._readableState,i=r.readable||!1!==r.readable&&e.readable,s=r.writable||!1!==r.writable&&e.writable,l=function(){e.writable||c()},c=function(){s=!1,i||n.call(e)},a=function(){i=!1,s||n.call(e)},u=function(r){n.call(e,r?new Error("exited with error code: "+r):null)},d=function(){return(!i||t&&t.ended)&&(!s||o&&o.ended)?void 0:n.call(e,new Error("premature close"))},f=function(){e.req.on("finish",c)};return isRequest(e)?(e.on("complete",c),e.on("abort",d),e.req?f():e.on("request",f)):s&&!o&&(e.on("end",l),e.on("close",l)),isChildProcess(e)&&e.on("exit",u),e.on("end",a),e.on("finish",c),!1!==r.error&&e.on("error",n),e.on("close",d),function(){e.removeListener("complete",c),e.removeListener("abort",d),e.removeListener("request",f),e.req&&e.req.removeListener("finish",c),e.removeListener("end",l),e.removeListener("close",l),e.removeListener("finish",c),e.removeListener("exit",u),e.removeListener("end",a),e.removeListener("error",n),e.removeListener("close",d)}};module.exports=eos;

},{"once":115}],103:[function(_dereq_,module,exports){
exports.read=function(a,o,t,r,h){var M,p,w=8*h-r-1,f=(1<<w)-1,e=f>>1,i=-7,N=t?h-1:0,n=t?-1:1,s=a[o+N];for(N+=n,M=s&(1<<-i)-1,s>>=-i,i+=w;i>0;M=256*M+a[o+N],N+=n,i-=8);for(p=M&(1<<-i)-1,M>>=-i,i+=r;i>0;p=256*p+a[o+N],N+=n,i-=8);if(0===M)M=1-e;else{if(M===f)return p?NaN:1/0*(s?-1:1);p+=Math.pow(2,r),M-=e}return(s?-1:1)*p*Math.pow(2,M-r)},exports.write=function(a,o,t,r,h,M){var p,w,f,e=8*M-h-1,i=(1<<e)-1,N=i>>1,n=23===h?Math.pow(2,-24)-Math.pow(2,-77):0,s=r?0:M-1,u=r?1:-1,l=o<0||0===o&&1/o<0?1:0;for(o=Math.abs(o),isNaN(o)||o===1/0?(w=isNaN(o)?1:0,p=i):(p=Math.floor(Math.log(o)/Math.LN2),o*(f=Math.pow(2,-p))<1&&(p--,f*=2),(o+=p+N>=1?n/f:n*Math.pow(2,1-N))*f>=2&&(p++,f/=2),p+N>=i?(w=0,p=i):p+N>=1?(w=(o*f-1)*Math.pow(2,h),p+=N):(w=o*Math.pow(2,N-1)*Math.pow(2,h),p=0));h>=8;a[t+s]=255&w,s+=u,w/=256,h-=8);for(p=p<<h|w,e+=h;e>0;a[t+s]=255&p,s+=u,p/=256,e-=8);a[t+s-u]|=128*l};

},{}],104:[function(_dereq_,module,exports){
"function"==typeof Object.create?module.exports=function(t,e){t.super_=e,t.prototype=Object.create(e.prototype,{constructor:{value:t,enumerable:!1,writable:!0,configurable:!0}})}:module.exports=function(t,e){t.super_=e;var o=function(){};o.prototype=e.prototype,t.prototype=new o,t.prototype.constructor=t};

},{}],105:[function(_dereq_,module,exports){
module.exports=function(f){return null!=f&&(isBuffer(f)||isSlowBuffer(f)||!!f._isBuffer)};function isBuffer(f){return!!f.constructor&&"function"==typeof f.constructor.isBuffer&&f.constructor.isBuffer(f)}function isSlowBuffer(f){return"function"==typeof f.readFloatLE&&"function"==typeof f.slice&&isBuffer(f.slice(0,0))}

},{}],106:[function(_dereq_,module,exports){
var toString={}.toString;module.exports=Array.isArray||function(r){return"[object Array]"==toString.call(r)};

},{}],107:[function(_dereq_,module,exports){
"use strict";var MAX=4294967295,idCounter=Math.floor(Math.random()*MAX);module.exports=getUniqueId;function getUniqueId(){return idCounter=(idCounter+1)%MAX}

},{}],108:[function(_dereq_,module,exports){
"use strict";var getUniqueId=_dereq_("./getUniqueId");module.exports=createIdRemapMiddleware;function createIdRemapMiddleware(){return function(e,d,i,r){var t=e.id,n=getUniqueId();e.id=n,d.id=n,i(function(i){e.id=t,d.id=t,i()})}}

},{"./getUniqueId":107}],109:[function(_dereq_,module,exports){
"use strict";var _stringify=_dereq_("babel-runtime/core-js/json/stringify"),_stringify2=_interopRequireDefault(_stringify),_classCallCheck2=_dereq_("babel-runtime/helpers/classCallCheck"),_classCallCheck3=_interopRequireDefault(_classCallCheck2),_createClass2=_dereq_("babel-runtime/helpers/createClass"),_createClass3=_interopRequireDefault(_createClass2);function _interopRequireDefault(e){return e&&e.__esModule?e:{default:e}}var async=_dereq_("async"),RpcEngine=function(){function e(){(0,_classCallCheck3.default)(this,e),this._middleware=[]}return(0,_createClass3.default)(e,[{key:"push",value:function(e){this._middleware.push(e)}},{key:"handle",value:function(e,r){Array.isArray(e)?async.map(e,this._handle.bind(this),r):this._handle(e,r)}},{key:"_handle",value:function(e,r){var n={id:e.id,jsonrpc:e.jsonrpc};this._runMiddleware(e,n,function(e){r(e,n)})}},{key:"_runMiddleware",value:function(e,r,n){var i=this;async.waterfall([function(n){return i._runMiddlewareDown(e,r,n)},function(n,i){var t=n.isComplete,a=n.returnHandlers;if(!("result"in r||"error"in r)){var u=(0,_stringify2.default)(e,null,2),s="JsonRpcEngine - response has no error or result for request:\n"+u;return i(new Error(s))}if(!t){var l=(0,_stringify2.default)(e,null,2),c="JsonRpcEngine - nothing ended request:\n"+l;return i(new Error(c))}return i(null,a)},function(e,r){return i._runReturnHandlersUp(e,r)}],n)}},{key:"_runMiddlewareDown",value:function(e,r,n){var i=[],t=!1;async.mapSeries(this._middleware,function(n,a){if(t)return a();n(e,r,function(e){i.push(e),a()},function(e){if(e)return a(e);t=!0,a()})},function(e){if(e)return r.error={code:e.code||-32603,message:e.stack},n(e,r);var a=i.filter(Boolean).reverse();n(null,{isComplete:t,returnHandlers:a})})}},{key:"_runReturnHandlersUp",value:function(e,r){async.eachSeries(e,function(e,r){return e(r)},r)}}]),e}();module.exports=RpcEngine;

},{"async":4,"babel-runtime/core-js/json/stringify":5,"babel-runtime/helpers/classCallCheck":13,"babel-runtime/helpers/createClass":14}],110:[function(_dereq_,module,exports){
const DuplexStream=_dereq_("readable-stream").Duplex;module.exports=createStreamMiddleware;function createStreamMiddleware(){const e={},r=new DuplexStream({objectMode:!0,read:function(){return!1},write:function(r,t,n){const d=e[r.id];d||n(new Error(`StreamMiddleware - Unknown response id ${r.id}`));delete e[r.id],Object.assign(d.res,r),setTimeout(d.end),n()}}),t=(t,n,d,a)=>{r.push(t),e[t.id]={req:t,res:n,next:d,end:a}};return t.stream=r,t}

},{"readable-stream":129}],111:[function(_dereq_,module,exports){
!function(e,o){"use strict";"function"==typeof define&&define.amd?define(o):"object"==typeof module&&module.exports?module.exports=o():e.log=o()}(this,function(){"use strict";var e=function(){},o="undefined",t=["trace","debug","info","warn","error"];function n(e,o){var t=e[o];if("function"==typeof t.bind)return t.bind(e);try{return Function.prototype.bind.call(t,e)}catch(o){return function(){return Function.prototype.apply.apply(t,[e,arguments])}}}function l(o,n){for(var l=0;l<t.length;l++){var i=t[l];this[i]=l<o?e:this.methodFactory(i,o,n)}this.log=this.debug}function i(t,i,r){return"debug"===(c=t)&&(c="log"),typeof console!==o&&(void 0!==console[c]?n(console,c):void 0!==console.log?n(console,"log"):e)||function(e,t,n){return function(){typeof console!==o&&(l.call(this,t,n),this[e].apply(this,arguments))}}.apply(this,arguments);var c}function r(e,n,r){var c,u=this,f="loglevel";e&&(f+=":"+e);function a(){var e;if(typeof window!==o){try{e=window.localStorage[f]}catch(e){}if(typeof e===o)try{var t=window.document.cookie,n=t.indexOf(encodeURIComponent(f)+"=");-1!==n&&(e=/^([^;]+)/.exec(t.slice(n))[1])}catch(e){}return void 0===u.levels[e]&&(e=void 0),e}}u.name=e,u.levels={TRACE:0,DEBUG:1,INFO:2,WARN:3,ERROR:4,SILENT:5},u.methodFactory=r||i,u.getLevel=function(){return c},u.setLevel=function(n,i){if("string"==typeof n&&void 0!==u.levels[n.toUpperCase()]&&(n=u.levels[n.toUpperCase()]),!("number"==typeof n&&n>=0&&n<=u.levels.SILENT))throw"log.setLevel() called with invalid level: "+n;if(c=n,!1!==i&&function(e){var n=(t[e]||"silent").toUpperCase();if(typeof window!==o){try{return void(window.localStorage[f]=n)}catch(e){}try{window.document.cookie=encodeURIComponent(f)+"="+n+";"}catch(e){}}}(n),l.call(u,n,e),typeof console===o&&n<u.levels.SILENT)return"No console available for logging"},u.setDefaultLevel=function(e){a()||u.setLevel(e,!1)},u.enableAll=function(e){u.setLevel(u.levels.TRACE,e)},u.disableAll=function(e){u.setLevel(u.levels.SILENT,e)};var s=a();null==s&&(s=null==n?"WARN":n),u.setLevel(s,!1)}var c=new r,u={};c.getLogger=function(e){if("string"!=typeof e||""===e)throw new TypeError("You must supply a name when creating a logger.");var o=u[e];return o||(o=u[e]=new r(e,c.getLevel(),c.methodFactory)),o};var f=typeof window!==o?window.log:void 0;return c.noConflict=function(){return typeof window!==o&&window.log===c&&(window.log=f),c},c.getLoggers=function(){return u},c});

},{}],112:[function(_dereq_,module,exports){
const{Duplex:Duplex}=_dereq_("readable-stream"),endOfStream=_dereq_("end-of-stream"),once=_dereq_("once"),noop=()=>{},IGNORE_SUBSTREAM={};class ObjectMultiplex extends Duplex{constructor(e={}){const t=Object.assign({},e,{objectMode:!0});super(t),this._substreams={}}createStream(e){if(!e)throw new Error("ObjectMultiplex - name must not be empty");if(this._substreams[e])throw new Error('ObjectMultiplex - Substream for name "${name}" already exists');const t=new Substream({parent:this,name:e});return this._substreams[e]=t,anyStreamEnd(this,e=>{t.destroy(e)}),t}ignoreStream(e){if(!e)throw new Error("ObjectMultiplex - name must not be empty");if(this._substreams[e])throw new Error('ObjectMultiplex - Substream for name "${name}" already exists');this._substreams[e]=IGNORE_SUBSTREAM}_read(){}_write(e,t,r){const s=e.name,a=e.data;if(!s)return console.warn(`ObjectMultiplex - malformed chunk without name "${e}"`),r();const n=this._substreams[s];if(!n)return console.warn(`ObjectMultiplex - orphaned data for stream "${s}"`),r();n!==IGNORE_SUBSTREAM&&n.push(a),r()}}class Substream extends Duplex{constructor({parent:e,name:t}){super({objectMode:!0}),this._parent=e,this._name=t}_read(){}_write(e,t,r){this._parent.push({name:this._name,data:e}),r()}}module.exports=ObjectMultiplex;function anyStreamEnd(e,t){const r=once(t);endOfStream(e,{readable:!1},r),endOfStream(e,{writable:!1},r)}

},{"end-of-stream":102,"once":115,"readable-stream":129}],113:[function(_dereq_,module,exports){
"use strict";var _assign=_dereq_("babel-runtime/core-js/object/assign"),_assign2=_interopRequireDefault(_assign),_typeof2=_dereq_("babel-runtime/helpers/typeof"),_typeof3=_interopRequireDefault(_typeof2),_getPrototypeOf=_dereq_("babel-runtime/core-js/object/get-prototype-of"),_getPrototypeOf2=_interopRequireDefault(_getPrototypeOf),_classCallCheck2=_dereq_("babel-runtime/helpers/classCallCheck"),_classCallCheck3=_interopRequireDefault(_classCallCheck2),_createClass2=_dereq_("babel-runtime/helpers/createClass"),_createClass3=_interopRequireDefault(_createClass2),_possibleConstructorReturn2=_dereq_("babel-runtime/helpers/possibleConstructorReturn"),_possibleConstructorReturn3=_interopRequireDefault(_possibleConstructorReturn2),_inherits2=_dereq_("babel-runtime/helpers/inherits"),_inherits3=_interopRequireDefault(_inherits2);function _interopRequireDefault(e){return e&&e.__esModule?e:{default:e}}var extend=_dereq_("xtend"),EventEmitter=_dereq_("events"),ObservableStore=function(e){(0,_inherits3.default)(t,e);function t(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};(0,_classCallCheck3.default)(this,t);var r=(0,_possibleConstructorReturn3.default)(this,(t.__proto__||(0,_getPrototypeOf2.default)(t)).call(this));return r._state=e,r}return(0,_createClass3.default)(t,[{key:"getState",value:function(){return this._getState()}},{key:"putState",value:function(e){this._putState(e),this.emit("update",e)}},{key:"updateState",value:function(e){if(e&&"object"===(void 0===e?"undefined":(0,_typeof3.default)(e))){var t=this.getState(),r=(0,_assign2.default)({},t,e);this.putState(r)}else this.putState(e)}},{key:"subscribe",value:function(e){this.on("update",e)}},{key:"unsubscribe",value:function(e){this.removeListener("update",e)}},{key:"_getState",value:function(){return this._state}},{key:"_putState",value:function(e){this._state=e}}]),t}(EventEmitter);module.exports=ObservableStore;

},{"babel-runtime/core-js/object/assign":6,"babel-runtime/core-js/object/get-prototype-of":9,"babel-runtime/helpers/classCallCheck":13,"babel-runtime/helpers/createClass":14,"babel-runtime/helpers/inherits":15,"babel-runtime/helpers/possibleConstructorReturn":16,"babel-runtime/helpers/typeof":17,"events":20,"xtend":141}],114:[function(_dereq_,module,exports){
"use strict";var _getPrototypeOf=_dereq_("babel-runtime/core-js/object/get-prototype-of"),_getPrototypeOf2=_interopRequireDefault(_getPrototypeOf),_classCallCheck2=_dereq_("babel-runtime/helpers/classCallCheck"),_classCallCheck3=_interopRequireDefault(_classCallCheck2),_createClass2=_dereq_("babel-runtime/helpers/createClass"),_createClass3=_interopRequireDefault(_createClass2),_possibleConstructorReturn2=_dereq_("babel-runtime/helpers/possibleConstructorReturn"),_possibleConstructorReturn3=_interopRequireDefault(_possibleConstructorReturn2),_inherits2=_dereq_("babel-runtime/helpers/inherits"),_inherits3=_interopRequireDefault(_inherits2);function _interopRequireDefault(e){return e&&e.__esModule?e:{default:e}}var DuplexStream=_dereq_("stream").Duplex;module.exports=asStream;function asStream(e){return new ObsStoreStream(e)}var ObsStoreStream=function(e){(0,_inherits3.default)(t,e);function t(e){(0,_classCallCheck3.default)(this,t);var r=(0,_possibleConstructorReturn3.default)(this,(t.__proto__||(0,_getPrototypeOf2.default)(t)).call(this,{objectMode:!0}));return r.resume(),r.obsStore=e,r.obsStore.subscribe(function(e){return r.push(e)}),r}return(0,_createClass3.default)(t,[{key:"pipe",value:function(e,t){var r=DuplexStream.prototype.pipe.call(this,e,t);return e.write(this.obsStore.getState()),r}},{key:"_write",value:function(e,t,r){this.obsStore.putState(e),r()}},{key:"_read",value:function(e){}}]),t}(DuplexStream);

},{"babel-runtime/core-js/object/get-prototype-of":9,"babel-runtime/helpers/classCallCheck":13,"babel-runtime/helpers/createClass":14,"babel-runtime/helpers/inherits":15,"babel-runtime/helpers/possibleConstructorReturn":16,"stream":133}],115:[function(_dereq_,module,exports){
var wrappy=_dereq_("wrappy");module.exports=wrappy(once),module.exports.strict=wrappy(onceStrict),once.proto=once(function(){Object.defineProperty(Function.prototype,"once",{value:function(){return once(this)},configurable:!0}),Object.defineProperty(Function.prototype,"onceStrict",{value:function(){return onceStrict(this)},configurable:!0})});function once(e){var r=function(){return r.called?r.value:(r.called=!0,r.value=e.apply(this,arguments))};return r.called=!1,r}function onceStrict(e){var r=function(){if(r.called)throw new Error(r.onceError);return r.called=!0,r.value=e.apply(this,arguments)},n=e.name||"Function wrapped with `once`";return r.onceError=n+" shouldn't be called more than once",r.called=!1,r}

},{"wrappy":140}],116:[function(_dereq_,module,exports){
const DuplexStream=_dereq_("readable-stream").Duplex,inherits=_dereq_("util").inherits;module.exports=PostMessageStream,inherits(PostMessageStream,DuplexStream);function PostMessageStream(t){DuplexStream.call(this,{objectMode:!0}),this._name=t.name,this._target=t.target,this._targetWindow=t.targetWindow||window,this._origin=t.targetWindow?"*":location.origin,this._init=!1,this._haveSyn=!1,window.addEventListener("message",this._onMessage.bind(this),!1),this._write("SYN",null,noop),this.cork()}PostMessageStream.prototype._onMessage=function(t){var e=t.data;if(("*"===this._origin||t.origin===this._origin)&&t.source===this._targetWindow&&"object"==typeof e&&e.target===this._name&&e.data)if(this._init)try{this.push(e.data)}catch(t){this.emit("error",t)}else"SYN"===e.data?(this._haveSyn=!0,this._write("ACK",null,noop)):"ACK"===e.data&&(this._init=!0,this._haveSyn||this._write("ACK",null,noop),this.uncork())},PostMessageStream.prototype._read=noop,PostMessageStream.prototype._write=function(t,e,i){var s={target:this._target,data:t};this._targetWindow.postMessage(s,this._origin),i()};function noop(){}

},{"readable-stream":129,"util":138}],117:[function(_dereq_,module,exports){
(function (process){
"use strict";!process.version||0===process.version.indexOf("v0.")||0===process.version.indexOf("v1.")&&0!==process.version.indexOf("v1.8.")?module.exports=nextTick:module.exports=process.nextTick;function nextTick(e,n,c,r){if("function"!=typeof e)throw new TypeError('"callback" argument must be a function');var s,t,o=arguments.length;switch(o){case 0:case 1:return process.nextTick(e);case 2:return process.nextTick(function(){e.call(null,n)});case 3:return process.nextTick(function(){e.call(null,n,c)});case 4:return process.nextTick(function(){e.call(null,n,c,r)});default:for(s=new Array(o-1),t=0;t<s.length;)s[t++]=arguments[t];return process.nextTick(function(){e.apply(null,s)})}}

}).call(this,_dereq_('_process'))

},{"_process":21}],118:[function(_dereq_,module,exports){
(function (process){
var once=_dereq_("once"),eos=_dereq_("end-of-stream"),fs=_dereq_("fs"),noop=function(){},ancient=/^v?\.0/.test(process.version),isFn=function(e){return"function"==typeof e},isFS=function(e){return!!ancient&&(!!fs&&((e instanceof(fs.ReadStream||noop)||e instanceof(fs.WriteStream||noop))&&isFn(e.close)))},isRequest=function(e){return e.setHeader&&isFn(e.abort)},destroyer=function(e,r,n,o){o=once(o);var t=!1;e.on("close",function(){t=!0}),eos(e,{readable:r,writable:n},function(e){if(e)return o(e);t=!0,o()});var i=!1;return function(r){if(!t&&!i)return i=!0,isFS(e)?e.close(noop):isRequest(e)?e.abort():isFn(e.destroy)?e.destroy():void o(r||new Error("stream was destroyed"))}},call=function(e){e()},pipe=function(e,r){return e.pipe(r)},pump=function(){var e=Array.prototype.slice.call(arguments),r=isFn(e[e.length-1]||noop)&&e.pop()||noop;if(Array.isArray(e[0])&&(e=e[0]),e.length<2)throw new Error("pump requires two streams per minimum");var n,o=e.map(function(t,i){var s=i<e.length-1;return destroyer(t,s,i>0,function(e){n||(n=e),e&&o.forEach(call),s||(o.forEach(call),r(n))})});return e.reduce(pipe)};module.exports=pump;

}).call(this,_dereq_('_process'))

},{"_process":21,"end-of-stream":102,"fs":19,"once":115}],119:[function(_dereq_,module,exports){
module.exports=_dereq_("./lib/_stream_duplex.js");

},{"./lib/_stream_duplex.js":120}],120:[function(_dereq_,module,exports){
"use strict";var processNextTick=_dereq_("process-nextick-args"),objectKeys=Object.keys||function(e){var t=[];for(var r in e)t.push(r);return t};module.exports=Duplex;var util=_dereq_("core-util-is");util.inherits=_dereq_("inherits");var Readable=_dereq_("./_stream_readable"),Writable=_dereq_("./_stream_writable");util.inherits(Duplex,Readable);for(var keys=objectKeys(Writable.prototype),v=0;v<keys.length;v++){var method=keys[v];Duplex.prototype[method]||(Duplex.prototype[method]=Writable.prototype[method])}function Duplex(e){if(!(this instanceof Duplex))return new Duplex(e);Readable.call(this,e),Writable.call(this,e),e&&!1===e.readable&&(this.readable=!1),e&&!1===e.writable&&(this.writable=!1),this.allowHalfOpen=!0,e&&!1===e.allowHalfOpen&&(this.allowHalfOpen=!1),this.once("end",onend)}function onend(){this.allowHalfOpen||this._writableState.ended||processNextTick(onEndNT,this)}function onEndNT(e){e.end()}Object.defineProperty(Duplex.prototype,"destroyed",{get:function(){return void 0!==this._readableState&&void 0!==this._writableState&&(this._readableState.destroyed&&this._writableState.destroyed)},set:function(e){void 0!==this._readableState&&void 0!==this._writableState&&(this._readableState.destroyed=e,this._writableState.destroyed=e)}}),Duplex.prototype._destroy=function(e,t){this.push(null),this.end(),processNextTick(t,e)};function forEach(e,t){for(var r=0,i=e.length;r<i;r++)t(e[r],r)}

},{"./_stream_readable":122,"./_stream_writable":124,"core-util-is":101,"inherits":104,"process-nextick-args":117}],121:[function(_dereq_,module,exports){
"use strict";module.exports=PassThrough;var Transform=_dereq_("./_stream_transform"),util=_dereq_("core-util-is");util.inherits=_dereq_("inherits"),util.inherits(PassThrough,Transform);function PassThrough(r){if(!(this instanceof PassThrough))return new PassThrough(r);Transform.call(this,r)}PassThrough.prototype._transform=function(r,s,i){i(null,r)};

},{"./_stream_transform":123,"core-util-is":101,"inherits":104}],122:[function(_dereq_,module,exports){
(function (process,global){
"use strict";var processNextTick=_dereq_("process-nextick-args");module.exports=Readable;var Duplex,isArray=_dereq_("isarray");Readable.ReadableState=ReadableState;var EE=_dereq_("events").EventEmitter,EElistenerCount=function(e,t){return e.listeners(t).length},Stream=_dereq_("./internal/streams/stream"),Buffer=_dereq_("safe-buffer").Buffer,OurUint8Array=global.Uint8Array||function(){};function _uint8ArrayToBuffer(e){return Buffer.from(e)}function _isUint8Array(e){return Buffer.isBuffer(e)||e instanceof OurUint8Array}var util=_dereq_("core-util-is");util.inherits=_dereq_("inherits");var debugUtil=_dereq_("util"),debug=void 0;debug=debugUtil&&debugUtil.debuglog?debugUtil.debuglog("stream"):function(){};var StringDecoder,BufferList=_dereq_("./internal/streams/BufferList"),destroyImpl=_dereq_("./internal/streams/destroy");util.inherits(Readable,Stream);var kProxyEvents=["error","close","destroy","pause","resume"];function prependListener(e,t,r){if("function"==typeof e.prependListener)return e.prependListener(t,r);e._events&&e._events[t]?isArray(e._events[t])?e._events[t].unshift(r):e._events[t]=[r,e._events[t]]:e.on(t,r)}function ReadableState(e,t){Duplex=Duplex||_dereq_("./_stream_duplex"),e=e||{},this.objectMode=!!e.objectMode,t instanceof Duplex&&(this.objectMode=this.objectMode||!!e.readableObjectMode);var r=e.highWaterMark,n=this.objectMode?16:16384;this.highWaterMark=r||0===r?r:n,this.highWaterMark=Math.floor(this.highWaterMark),this.buffer=new BufferList,this.length=0,this.pipes=null,this.pipesCount=0,this.flowing=null,this.ended=!1,this.endEmitted=!1,this.reading=!1,this.sync=!0,this.needReadable=!1,this.emittedReadable=!1,this.readableListening=!1,this.resumeScheduled=!1,this.destroyed=!1,this.defaultEncoding=e.defaultEncoding||"utf8",this.awaitDrain=0,this.readingMore=!1,this.decoder=null,this.encoding=null,e.encoding&&(StringDecoder||(StringDecoder=_dereq_("string_decoder/").StringDecoder),this.decoder=new StringDecoder(e.encoding),this.encoding=e.encoding)}function Readable(e){if(Duplex=Duplex||_dereq_("./_stream_duplex"),!(this instanceof Readable))return new Readable(e);this._readableState=new ReadableState(e,this),this.readable=!0,e&&("function"==typeof e.read&&(this._read=e.read),"function"==typeof e.destroy&&(this._destroy=e.destroy)),Stream.call(this)}Object.defineProperty(Readable.prototype,"destroyed",{get:function(){return void 0!==this._readableState&&this._readableState.destroyed},set:function(e){this._readableState&&(this._readableState.destroyed=e)}}),Readable.prototype.destroy=destroyImpl.destroy,Readable.prototype._undestroy=destroyImpl.undestroy,Readable.prototype._destroy=function(e,t){this.push(null),t(e)},Readable.prototype.push=function(e,t){var r,n=this._readableState;return n.objectMode?r=!0:"string"==typeof e&&((t=t||n.defaultEncoding)!==n.encoding&&(e=Buffer.from(e,t),t=""),r=!0),readableAddChunk(this,e,t,!1,r)},Readable.prototype.unshift=function(e){return readableAddChunk(this,e,null,!0,!1)};function readableAddChunk(e,t,r,n,a){var i=e._readableState;if(null===t)i.reading=!1,onEofChunk(e,i);else{var d;a||(d=chunkInvalid(i,t)),d?e.emit("error",d):i.objectMode||t&&t.length>0?("string"==typeof t||i.objectMode||Object.getPrototypeOf(t)===Buffer.prototype||(t=_uint8ArrayToBuffer(t)),n?i.endEmitted?e.emit("error",new Error("stream.unshift() after end event")):addChunk(e,i,t,!0):i.ended?e.emit("error",new Error("stream.push() after EOF")):(i.reading=!1,i.decoder&&!r?(t=i.decoder.write(t),i.objectMode||0!==t.length?addChunk(e,i,t,!1):maybeReadMore(e,i)):addChunk(e,i,t,!1))):n||(i.reading=!1)}return needMoreData(i)}function addChunk(e,t,r,n){t.flowing&&0===t.length&&!t.sync?(e.emit("data",r),e.read(0)):(t.length+=t.objectMode?1:r.length,n?t.buffer.unshift(r):t.buffer.push(r),t.needReadable&&emitReadable(e)),maybeReadMore(e,t)}function chunkInvalid(e,t){var r;return _isUint8Array(t)||"string"==typeof t||void 0===t||e.objectMode||(r=new TypeError("Invalid non-string/buffer chunk")),r}function needMoreData(e){return!e.ended&&(e.needReadable||e.length<e.highWaterMark||0===e.length)}Readable.prototype.isPaused=function(){return!1===this._readableState.flowing},Readable.prototype.setEncoding=function(e){return StringDecoder||(StringDecoder=_dereq_("string_decoder/").StringDecoder),this._readableState.decoder=new StringDecoder(e),this._readableState.encoding=e,this};var MAX_HWM=8388608;function computeNewHighWaterMark(e){return e>=MAX_HWM?e=MAX_HWM:(e--,e|=e>>>1,e|=e>>>2,e|=e>>>4,e|=e>>>8,e|=e>>>16,e++),e}function howMuchToRead(e,t){return e<=0||0===t.length&&t.ended?0:t.objectMode?1:e!=e?t.flowing&&t.length?t.buffer.head.data.length:t.length:(e>t.highWaterMark&&(t.highWaterMark=computeNewHighWaterMark(e)),e<=t.length?e:t.ended?t.length:(t.needReadable=!0,0))}Readable.prototype.read=function(e){debug("read",e),e=parseInt(e,10);var t=this._readableState,r=e;if(0!==e&&(t.emittedReadable=!1),0===e&&t.needReadable&&(t.length>=t.highWaterMark||t.ended))return debug("read: emitReadable",t.length,t.ended),0===t.length&&t.ended?endReadable(this):emitReadable(this),null;if(0===(e=howMuchToRead(e,t))&&t.ended)return 0===t.length&&endReadable(this),null;var n=t.needReadable;debug("need readable",n),(0===t.length||t.length-e<t.highWaterMark)&&debug("length less than watermark",n=!0),t.ended||t.reading?debug("reading or ended",n=!1):n&&(debug("do read"),t.reading=!0,t.sync=!0,0===t.length&&(t.needReadable=!0),this._read(t.highWaterMark),t.sync=!1,t.reading||(e=howMuchToRead(r,t)));var a;return null===(a=e>0?fromList(e,t):null)?(t.needReadable=!0,e=0):t.length-=e,0===t.length&&(t.ended||(t.needReadable=!0),r!==e&&t.ended&&endReadable(this)),null!==a&&this.emit("data",a),a};function onEofChunk(e,t){if(!t.ended){if(t.decoder){var r=t.decoder.end();r&&r.length&&(t.buffer.push(r),t.length+=t.objectMode?1:r.length)}t.ended=!0,emitReadable(e)}}function emitReadable(e){var t=e._readableState;t.needReadable=!1,t.emittedReadable||(debug("emitReadable",t.flowing),t.emittedReadable=!0,t.sync?processNextTick(emitReadable_,e):emitReadable_(e))}function emitReadable_(e){debug("emit readable"),e.emit("readable"),flow(e)}function maybeReadMore(e,t){t.readingMore||(t.readingMore=!0,processNextTick(maybeReadMore_,e,t))}function maybeReadMore_(e,t){for(var r=t.length;!t.reading&&!t.flowing&&!t.ended&&t.length<t.highWaterMark&&(debug("maybeReadMore read 0"),e.read(0),r!==t.length);)r=t.length;t.readingMore=!1}Readable.prototype._read=function(e){this.emit("error",new Error("_read() is not implemented"))},Readable.prototype.pipe=function(e,t){var r=this,n=this._readableState;switch(n.pipesCount){case 0:n.pipes=e;break;case 1:n.pipes=[n.pipes,e];break;default:n.pipes.push(e)}n.pipesCount+=1,debug("pipe count=%d opts=%j",n.pipesCount,t);var a=(!t||!1!==t.end)&&e!==process.stdout&&e!==process.stderr?d:c;n.endEmitted?processNextTick(a):r.once("end",a),e.on("unpipe",i);function i(t,a){debug("onunpipe"),t===r&&a&&!1===a.hasUnpiped&&(a.hasUnpiped=!0,debug("cleanup"),e.removeListener("close",f),e.removeListener("finish",p),e.removeListener("drain",o),e.removeListener("error",h),e.removeListener("unpipe",i),r.removeListener("end",d),r.removeListener("end",c),r.removeListener("data",l),u=!0,!n.awaitDrain||e._writableState&&!e._writableState.needDrain||o())}function d(){debug("onend"),e.end()}var o=pipeOnDrain(r);e.on("drain",o);var u=!1;var s=!1;r.on("data",l);function l(t){debug("ondata"),s=!1;!1!==e.write(t)||s||((1===n.pipesCount&&n.pipes===e||n.pipesCount>1&&-1!==indexOf(n.pipes,e))&&!u&&(debug("false write response, pause",r._readableState.awaitDrain),r._readableState.awaitDrain++,s=!0),r.pause())}function h(t){debug("onerror",t),c(),e.removeListener("error",h),0===EElistenerCount(e,"error")&&e.emit("error",t)}prependListener(e,"error",h);function f(){e.removeListener("finish",p),c()}e.once("close",f);function p(){debug("onfinish"),e.removeListener("close",f),c()}e.once("finish",p);function c(){debug("unpipe"),r.unpipe(e)}return e.emit("pipe",r),n.flowing||(debug("pipe resume"),r.resume()),e};function pipeOnDrain(e){return function(){var t=e._readableState;debug("pipeOnDrain",t.awaitDrain),t.awaitDrain&&t.awaitDrain--,0===t.awaitDrain&&EElistenerCount(e,"data")&&(t.flowing=!0,flow(e))}}Readable.prototype.unpipe=function(e){var t=this._readableState,r={hasUnpiped:!1};if(0===t.pipesCount)return this;if(1===t.pipesCount)return e&&e!==t.pipes?this:(e||(e=t.pipes),t.pipes=null,t.pipesCount=0,t.flowing=!1,e&&e.emit("unpipe",this,r),this);if(!e){var n=t.pipes,a=t.pipesCount;t.pipes=null,t.pipesCount=0,t.flowing=!1;for(var i=0;i<a;i++)n[i].emit("unpipe",this,r);return this}var d=indexOf(t.pipes,e);return-1===d?this:(t.pipes.splice(d,1),t.pipesCount-=1,1===t.pipesCount&&(t.pipes=t.pipes[0]),e.emit("unpipe",this,r),this)},Readable.prototype.on=function(e,t){var r=Stream.prototype.on.call(this,e,t);if("data"===e)!1!==this._readableState.flowing&&this.resume();else if("readable"===e){var n=this._readableState;n.endEmitted||n.readableListening||(n.readableListening=n.needReadable=!0,n.emittedReadable=!1,n.reading?n.length&&emitReadable(this):processNextTick(nReadingNextTick,this))}return r},Readable.prototype.addListener=Readable.prototype.on;function nReadingNextTick(e){debug("readable nexttick read 0"),e.read(0)}Readable.prototype.resume=function(){var e=this._readableState;return e.flowing||(debug("resume"),e.flowing=!0,resume(this,e)),this};function resume(e,t){t.resumeScheduled||(t.resumeScheduled=!0,processNextTick(resume_,e,t))}function resume_(e,t){t.reading||(debug("resume read 0"),e.read(0)),t.resumeScheduled=!1,t.awaitDrain=0,e.emit("resume"),flow(e),t.flowing&&!t.reading&&e.read(0)}Readable.prototype.pause=function(){return debug("call pause flowing=%j",this._readableState.flowing),!1!==this._readableState.flowing&&(debug("pause"),this._readableState.flowing=!1,this.emit("pause")),this};function flow(e){var t=e._readableState;for(debug("flow",t.flowing);t.flowing&&null!==e.read(););}Readable.prototype.wrap=function(e){var t=this._readableState,r=!1,n=this;e.on("end",function(){if(debug("wrapped end"),t.decoder&&!t.ended){var e=t.decoder.end();e&&e.length&&n.push(e)}n.push(null)}),e.on("data",function(a){if(debug("wrapped data"),t.decoder&&(a=t.decoder.write(a)),(!t.objectMode||null!==a&&void 0!==a)&&(t.objectMode||a&&a.length)){n.push(a)||(r=!0,e.pause())}});for(var a in e)void 0===this[a]&&"function"==typeof e[a]&&(this[a]=function(t){return function(){return e[t].apply(e,arguments)}}(a));for(var i=0;i<kProxyEvents.length;i++)e.on(kProxyEvents[i],n.emit.bind(n,kProxyEvents[i]));return n._read=function(t){debug("wrapped _read",t),r&&(r=!1,e.resume())},n},Readable._fromList=fromList;function fromList(e,t){if(0===t.length)return null;var r;return t.objectMode?r=t.buffer.shift():!e||e>=t.length?(r=t.decoder?t.buffer.join(""):1===t.buffer.length?t.buffer.head.data:t.buffer.concat(t.length),t.buffer.clear()):r=fromListPartial(e,t.buffer,t.decoder),r}function fromListPartial(e,t,r){var n;return e<t.head.data.length?(n=t.head.data.slice(0,e),t.head.data=t.head.data.slice(e)):n=e===t.head.data.length?t.shift():r?copyFromBufferString(e,t):copyFromBuffer(e,t),n}function copyFromBufferString(e,t){var r=t.head,n=1,a=r.data;for(e-=a.length;r=r.next;){var i=r.data,d=e>i.length?i.length:e;if(d===i.length?a+=i:a+=i.slice(0,e),0===(e-=d)){d===i.length?(++n,r.next?t.head=r.next:t.head=t.tail=null):(t.head=r,r.data=i.slice(d));break}++n}return t.length-=n,a}function copyFromBuffer(e,t){var r=Buffer.allocUnsafe(e),n=t.head,a=1;for(n.data.copy(r),e-=n.data.length;n=n.next;){var i=n.data,d=e>i.length?i.length:e;if(i.copy(r,r.length-e,0,d),0===(e-=d)){d===i.length?(++a,n.next?t.head=n.next:t.head=t.tail=null):(t.head=n,n.data=i.slice(d));break}++a}return t.length-=a,r}function endReadable(e){var t=e._readableState;if(t.length>0)throw new Error('"endReadable()" called on non-empty stream');t.endEmitted||(t.ended=!0,processNextTick(endReadableNT,t,e))}function endReadableNT(e,t){e.endEmitted||0!==e.length||(e.endEmitted=!0,t.readable=!1,t.emit("end"))}function forEach(e,t){for(var r=0,n=e.length;r<n;r++)t(e[r],r)}function indexOf(e,t){for(var r=0,n=e.length;r<n;r++)if(e[r]===t)return r;return-1}

}).call(this,_dereq_('_process'),typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})

},{"./_stream_duplex":120,"./internal/streams/BufferList":125,"./internal/streams/destroy":126,"./internal/streams/stream":127,"_process":21,"core-util-is":101,"events":20,"inherits":104,"isarray":106,"process-nextick-args":117,"safe-buffer":132,"string_decoder/":134,"util":19}],123:[function(_dereq_,module,exports){
"use strict";module.exports=Transform;var Duplex=_dereq_("./_stream_duplex"),util=_dereq_("core-util-is");util.inherits=_dereq_("inherits"),util.inherits(Transform,Duplex);function TransformState(r){this.afterTransform=function(t,n){return afterTransform(r,t,n)},this.needTransform=!1,this.transforming=!1,this.writecb=null,this.writechunk=null,this.writeencoding=null}function afterTransform(r,t,n){var e=r._transformState;e.transforming=!1;var i=e.writecb;if(!i)return r.emit("error",new Error("write callback called multiple times"));e.writechunk=null,e.writecb=null,null!==n&&void 0!==n&&r.push(n),i(t);var a=r._readableState;a.reading=!1,(a.needReadable||a.length<a.highWaterMark)&&r._read(a.highWaterMark)}function Transform(r){if(!(this instanceof Transform))return new Transform(r);Duplex.call(this,r),this._transformState=new TransformState(this);var t=this;this._readableState.needReadable=!0,this._readableState.sync=!1,r&&("function"==typeof r.transform&&(this._transform=r.transform),"function"==typeof r.flush&&(this._flush=r.flush)),this.once("prefinish",function(){"function"==typeof this._flush?this._flush(function(r,n){done(t,r,n)}):done(t)})}Transform.prototype.push=function(r,t){return this._transformState.needTransform=!1,Duplex.prototype.push.call(this,r,t)},Transform.prototype._transform=function(r,t,n){throw new Error("_transform() is not implemented")},Transform.prototype._write=function(r,t,n){var e=this._transformState;if(e.writecb=n,e.writechunk=r,e.writeencoding=t,!e.transforming){var i=this._readableState;(e.needTransform||i.needReadable||i.length<i.highWaterMark)&&this._read(i.highWaterMark)}},Transform.prototype._read=function(r){var t=this._transformState;null!==t.writechunk&&t.writecb&&!t.transforming?(t.transforming=!0,this._transform(t.writechunk,t.writeencoding,t.afterTransform)):t.needTransform=!0},Transform.prototype._destroy=function(r,t){var n=this;Duplex.prototype._destroy.call(this,r,function(r){t(r),n.emit("close")})};function done(r,t,n){if(t)return r.emit("error",t);null!==n&&void 0!==n&&r.push(n);var e=r._writableState,i=r._transformState;if(e.length)throw new Error("Calling transform done when ws.length != 0");if(i.transforming)throw new Error("Calling transform done when still transforming");return r.push(null)}

},{"./_stream_duplex":120,"core-util-is":101,"inherits":104}],124:[function(_dereq_,module,exports){
(function (process,global){
"use strict";var processNextTick=_dereq_("process-nextick-args");module.exports=Writable;function WriteReq(e,t,r){this.chunk=e,this.encoding=t,this.callback=r,this.next=null}function CorkedRequest(e){var t=this;this.next=null,this.entry=null,this.finish=function(){onCorkedFinish(t,e)}}var Duplex,asyncWrite=!process.browser&&["v0.10","v0.9."].indexOf(process.version.slice(0,5))>-1?setImmediate:processNextTick;Writable.WritableState=WritableState;var util=_dereq_("core-util-is");util.inherits=_dereq_("inherits");var internalUtil={deprecate:_dereq_("util-deprecate")},Stream=_dereq_("./internal/streams/stream"),Buffer=_dereq_("safe-buffer").Buffer,OurUint8Array=global.Uint8Array||function(){};function _uint8ArrayToBuffer(e){return Buffer.from(e)}function _isUint8Array(e){return Buffer.isBuffer(e)||e instanceof OurUint8Array}var destroyImpl=_dereq_("./internal/streams/destroy");util.inherits(Writable,Stream);function nop(){}function WritableState(e,t){Duplex=Duplex||_dereq_("./_stream_duplex"),e=e||{},this.objectMode=!!e.objectMode,t instanceof Duplex&&(this.objectMode=this.objectMode||!!e.writableObjectMode);var r=e.highWaterMark,i=this.objectMode?16:16384;this.highWaterMark=r||0===r?r:i,this.highWaterMark=Math.floor(this.highWaterMark),this.finalCalled=!1,this.needDrain=!1,this.ending=!1,this.ended=!1,this.finished=!1,this.destroyed=!1;var n=!1===e.decodeStrings;this.decodeStrings=!n,this.defaultEncoding=e.defaultEncoding||"utf8",this.length=0,this.writing=!1,this.corked=0,this.sync=!0,this.bufferProcessing=!1,this.onwrite=function(e){onwrite(t,e)},this.writecb=null,this.writelen=0,this.bufferedRequest=null,this.lastBufferedRequest=null,this.pendingcb=0,this.prefinished=!1,this.errorEmitted=!1,this.bufferedRequestCount=0,this.corkedRequestsFree=new CorkedRequest(this)}WritableState.prototype.getBuffer=function(){for(var e=this.bufferedRequest,t=[];e;)t.push(e),e=e.next;return t},function(){try{Object.defineProperty(WritableState.prototype,"buffer",{get:internalUtil.deprecate(function(){return this.getBuffer()},"_writableState.buffer is deprecated. Use _writableState.getBuffer instead.","DEP0003")})}catch(e){}}();var realHasInstance;"function"==typeof Symbol&&Symbol.hasInstance&&"function"==typeof Function.prototype[Symbol.hasInstance]?(realHasInstance=Function.prototype[Symbol.hasInstance],Object.defineProperty(Writable,Symbol.hasInstance,{value:function(e){return!!realHasInstance.call(this,e)||e&&e._writableState instanceof WritableState}})):realHasInstance=function(e){return e instanceof this};function Writable(e){if(Duplex=Duplex||_dereq_("./_stream_duplex"),!(realHasInstance.call(Writable,this)||this instanceof Duplex))return new Writable(e);this._writableState=new WritableState(e,this),this.writable=!0,e&&("function"==typeof e.write&&(this._write=e.write),"function"==typeof e.writev&&(this._writev=e.writev),"function"==typeof e.destroy&&(this._destroy=e.destroy),"function"==typeof e.final&&(this._final=e.final)),Stream.call(this)}Writable.prototype.pipe=function(){this.emit("error",new Error("Cannot pipe, not readable"))};function writeAfterEnd(e,t){var r=new Error("write after end");e.emit("error",r),processNextTick(t,r)}function validChunk(e,t,r,i){var n=!0,o=!1;return null===r?o=new TypeError("May not write null values to stream"):"string"==typeof r||void 0===r||t.objectMode||(o=new TypeError("Invalid non-string/buffer chunk")),o&&(e.emit("error",o),processNextTick(i,o),n=!1),n}Writable.prototype.write=function(e,t,r){var i=this._writableState,n=!1,o=_isUint8Array(e)&&!i.objectMode;return o&&!Buffer.isBuffer(e)&&(e=_uint8ArrayToBuffer(e)),"function"==typeof t&&(r=t,t=null),o?t="buffer":t||(t=i.defaultEncoding),"function"!=typeof r&&(r=nop),i.ended?writeAfterEnd(this,r):(o||validChunk(this,i,e,r))&&(i.pendingcb++,n=writeOrBuffer(this,i,o,e,t,r)),n},Writable.prototype.cork=function(){this._writableState.corked++},Writable.prototype.uncork=function(){var e=this._writableState;e.corked&&(e.corked--,e.writing||e.corked||e.finished||e.bufferProcessing||!e.bufferedRequest||clearBuffer(this,e))},Writable.prototype.setDefaultEncoding=function(e){if("string"==typeof e&&(e=e.toLowerCase()),!(["hex","utf8","utf-8","ascii","binary","base64","ucs2","ucs-2","utf16le","utf-16le","raw"].indexOf((e+"").toLowerCase())>-1))throw new TypeError("Unknown encoding: "+e);return this._writableState.defaultEncoding=e,this};function decodeChunk(e,t,r){return e.objectMode||!1===e.decodeStrings||"string"!=typeof t||(t=Buffer.from(t,r)),t}function writeOrBuffer(e,t,r,i,n,o){if(!r){var s=decodeChunk(t,i,n);i!==s&&(r=!0,n="buffer",i=s)}var a=t.objectMode?1:i.length;t.length+=a;var f=t.length<t.highWaterMark;if(f||(t.needDrain=!0),t.writing||t.corked){var u=t.lastBufferedRequest;t.lastBufferedRequest={chunk:i,encoding:n,isBuf:r,callback:o,next:null},u?u.next=t.lastBufferedRequest:t.bufferedRequest=t.lastBufferedRequest,t.bufferedRequestCount+=1}else doWrite(e,t,!1,a,i,n,o);return f}function doWrite(e,t,r,i,n,o,s){t.writelen=i,t.writecb=s,t.writing=!0,t.sync=!0,r?e._writev(n,t.onwrite):e._write(n,o,t.onwrite),t.sync=!1}function onwriteError(e,t,r,i,n){--t.pendingcb,r?(processNextTick(n,i),processNextTick(finishMaybe,e,t),e._writableState.errorEmitted=!0,e.emit("error",i)):(n(i),e._writableState.errorEmitted=!0,e.emit("error",i),finishMaybe(e,t))}function onwriteStateUpdate(e){e.writing=!1,e.writecb=null,e.length-=e.writelen,e.writelen=0}function onwrite(e,t){var r=e._writableState,i=r.sync,n=r.writecb;if(onwriteStateUpdate(r),t)onwriteError(e,r,i,t,n);else{var o=needFinish(r);o||r.corked||r.bufferProcessing||!r.bufferedRequest||clearBuffer(e,r),i?asyncWrite(afterWrite,e,r,o,n):afterWrite(e,r,o,n)}}function afterWrite(e,t,r,i){r||onwriteDrain(e,t),t.pendingcb--,i(),finishMaybe(e,t)}function onwriteDrain(e,t){0===t.length&&t.needDrain&&(t.needDrain=!1,e.emit("drain"))}function clearBuffer(e,t){t.bufferProcessing=!0;var r=t.bufferedRequest;if(e._writev&&r&&r.next){var i=t.bufferedRequestCount,n=new Array(i),o=t.corkedRequestsFree;o.entry=r;for(var s=0,a=!0;r;)n[s]=r,r.isBuf||(a=!1),r=r.next,s+=1;n.allBuffers=a,doWrite(e,t,!0,t.length,n,"",o.finish),t.pendingcb++,t.lastBufferedRequest=null,o.next?(t.corkedRequestsFree=o.next,o.next=null):t.corkedRequestsFree=new CorkedRequest(t)}else{for(;r;){var f=r.chunk,u=r.encoding,l=r.callback;if(doWrite(e,t,!1,t.objectMode?1:f.length,f,u,l),r=r.next,t.writing)break}null===r&&(t.lastBufferedRequest=null)}t.bufferedRequestCount=0,t.bufferedRequest=r,t.bufferProcessing=!1}Writable.prototype._write=function(e,t,r){r(new Error("_write() is not implemented"))},Writable.prototype._writev=null,Writable.prototype.end=function(e,t,r){var i=this._writableState;"function"==typeof e?(r=e,e=null,t=null):"function"==typeof t&&(r=t,t=null),null!==e&&void 0!==e&&this.write(e,t),i.corked&&(i.corked=1,this.uncork()),i.ending||i.finished||endWritable(this,i,r)};function needFinish(e){return e.ending&&0===e.length&&null===e.bufferedRequest&&!e.finished&&!e.writing}function callFinal(e,t){e._final(function(r){t.pendingcb--,r&&e.emit("error",r),t.prefinished=!0,e.emit("prefinish"),finishMaybe(e,t)})}function prefinish(e,t){t.prefinished||t.finalCalled||("function"==typeof e._final?(t.pendingcb++,t.finalCalled=!0,processNextTick(callFinal,e,t)):(t.prefinished=!0,e.emit("prefinish")))}function finishMaybe(e,t){var r=needFinish(t);return r&&(prefinish(e,t),0===t.pendingcb&&(t.finished=!0,e.emit("finish"))),r}function endWritable(e,t,r){t.ending=!0,finishMaybe(e,t),r&&(t.finished?processNextTick(r):e.once("finish",r)),t.ended=!0,e.writable=!1}function onCorkedFinish(e,t,r){var i=e.entry;for(e.entry=null;i;){var n=i.callback;t.pendingcb--,n(r),i=i.next}t.corkedRequestsFree?t.corkedRequestsFree.next=e:t.corkedRequestsFree=e}Object.defineProperty(Writable.prototype,"destroyed",{get:function(){return void 0!==this._writableState&&this._writableState.destroyed},set:function(e){this._writableState&&(this._writableState.destroyed=e)}}),Writable.prototype.destroy=destroyImpl.destroy,Writable.prototype._undestroy=destroyImpl.undestroy,Writable.prototype._destroy=function(e,t){this.end(),t(e)};

}).call(this,_dereq_('_process'),typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})

},{"./_stream_duplex":120,"./internal/streams/destroy":126,"./internal/streams/stream":127,"_process":21,"core-util-is":101,"inherits":104,"process-nextick-args":117,"safe-buffer":132,"util-deprecate":135}],125:[function(_dereq_,module,exports){
"use strict";function _classCallCheck(t,e){if(!(t instanceof e))throw new TypeError("Cannot call a class as a function")}var Buffer=_dereq_("safe-buffer").Buffer;function copyBuffer(t,e,h){t.copy(e,h)}module.exports=function(){function t(){_classCallCheck(this,t),this.head=null,this.tail=null,this.length=0}return t.prototype.push=function(t){var e={data:t,next:null};this.length>0?this.tail.next=e:this.head=e,this.tail=e,++this.length},t.prototype.unshift=function(t){var e={data:t,next:this.head};0===this.length&&(this.tail=e),this.head=e,++this.length},t.prototype.shift=function(){if(0!==this.length){var t=this.head.data;return 1===this.length?this.head=this.tail=null:this.head=this.head.next,--this.length,t}},t.prototype.clear=function(){this.head=this.tail=null,this.length=0},t.prototype.join=function(t){if(0===this.length)return"";for(var e=this.head,h=""+e.data;e=e.next;)h+=t+e.data;return h},t.prototype.concat=function(t){if(0===this.length)return Buffer.alloc(0);if(1===this.length)return this.head.data;for(var e=Buffer.allocUnsafe(t>>>0),h=this.head,n=0;h;)copyBuffer(h.data,e,n),n+=h.data.length,h=h.next;return e},t}();

},{"safe-buffer":132}],126:[function(_dereq_,module,exports){
"use strict";var processNextTick=_dereq_("process-nextick-args");function destroy(t,e){var r=this,i=this._readableState&&this._readableState.destroyed,a=this._writableState&&this._writableState.destroyed;i||a?e?e(t):!t||this._writableState&&this._writableState.errorEmitted||processNextTick(emitErrorNT,this,t):(this._readableState&&(this._readableState.destroyed=!0),this._writableState&&(this._writableState.destroyed=!0),this._destroy(t||null,function(t){!e&&t?(processNextTick(emitErrorNT,r,t),r._writableState&&(r._writableState.errorEmitted=!0)):e&&e(t)}))}function undestroy(){this._readableState&&(this._readableState.destroyed=!1,this._readableState.reading=!1,this._readableState.ended=!1,this._readableState.endEmitted=!1),this._writableState&&(this._writableState.destroyed=!1,this._writableState.ended=!1,this._writableState.ending=!1,this._writableState.finished=!1,this._writableState.errorEmitted=!1)}function emitErrorNT(t,e){t.emit("error",e)}module.exports={destroy:destroy,undestroy:undestroy};

},{"process-nextick-args":117}],127:[function(_dereq_,module,exports){
module.exports=_dereq_("events").EventEmitter;

},{"events":20}],128:[function(_dereq_,module,exports){
module.exports=_dereq_("./readable").PassThrough;

},{"./readable":129}],129:[function(_dereq_,module,exports){
exports=module.exports=_dereq_("./lib/_stream_readable.js"),exports.Stream=exports,exports.Readable=exports,exports.Writable=_dereq_("./lib/_stream_writable.js"),exports.Duplex=_dereq_("./lib/_stream_duplex.js"),exports.Transform=_dereq_("./lib/_stream_transform.js"),exports.PassThrough=_dereq_("./lib/_stream_passthrough.js");

},{"./lib/_stream_duplex.js":120,"./lib/_stream_passthrough.js":121,"./lib/_stream_readable.js":122,"./lib/_stream_transform.js":123,"./lib/_stream_writable.js":124}],130:[function(_dereq_,module,exports){
module.exports=_dereq_("./readable").Transform;

},{"./readable":129}],131:[function(_dereq_,module,exports){
module.exports=_dereq_("./lib/_stream_writable.js");

},{"./lib/_stream_writable.js":124}],132:[function(_dereq_,module,exports){
var buffer=_dereq_("buffer"),Buffer=buffer.Buffer;function copyProps(f,r){for(var e in f)r[e]=f[e]}Buffer.from&&Buffer.alloc&&Buffer.allocUnsafe&&Buffer.allocUnsafeSlow?module.exports=buffer:(copyProps(buffer,exports),exports.Buffer=SafeBuffer);function SafeBuffer(f,r,e){return Buffer(f,r,e)}copyProps(Buffer,SafeBuffer),SafeBuffer.from=function(f,r,e){if("number"==typeof f)throw new TypeError("Argument must not be a number");return Buffer(f,r,e)},SafeBuffer.alloc=function(f,r,e){if("number"!=typeof f)throw new TypeError("Argument must be a number");var u=Buffer(f);return void 0!==r?"string"==typeof e?u.fill(r,e):u.fill(r):u.fill(0),u},SafeBuffer.allocUnsafe=function(f){if("number"!=typeof f)throw new TypeError("Argument must be a number");return Buffer(f)},SafeBuffer.allocUnsafeSlow=function(f){if("number"!=typeof f)throw new TypeError("Argument must be a number");return buffer.SlowBuffer(f)};

},{"buffer":22}],133:[function(_dereq_,module,exports){
module.exports=Stream;var EE=_dereq_("events").EventEmitter,inherits=_dereq_("inherits");inherits(Stream,EE),Stream.Readable=_dereq_("readable-stream/readable.js"),Stream.Writable=_dereq_("readable-stream/writable.js"),Stream.Duplex=_dereq_("readable-stream/duplex.js"),Stream.Transform=_dereq_("readable-stream/transform.js"),Stream.PassThrough=_dereq_("readable-stream/passthrough.js"),Stream.Stream=Stream;function Stream(){EE.call(this)}Stream.prototype.pipe=function(e,r){var t=this;function n(r){e.writable&&!1===e.write(r)&&t.pause&&t.pause()}t.on("data",n);function a(){t.readable&&t.resume&&t.resume()}e.on("drain",a),e._isStdio||r&&!1===r.end||(t.on("end",i),t.on("close",s));var o=!1;function i(){o||(o=!0,e.end())}function s(){o||(o=!0,"function"==typeof e.destroy&&e.destroy())}function m(e){if(u(),0===EE.listenerCount(this,"error"))throw e}t.on("error",m),e.on("error",m);function u(){t.removeListener("data",n),e.removeListener("drain",a),t.removeListener("end",i),t.removeListener("close",s),t.removeListener("error",m),e.removeListener("error",m),t.removeListener("end",u),t.removeListener("close",u),e.removeListener("close",u)}return t.on("end",u),t.on("close",u),e.on("close",u),e.emit("pipe",t),e};

},{"events":20,"inherits":104,"readable-stream/duplex.js":119,"readable-stream/passthrough.js":128,"readable-stream/readable.js":129,"readable-stream/transform.js":130,"readable-stream/writable.js":131}],134:[function(_dereq_,module,exports){
"use strict";var Buffer=_dereq_("safe-buffer").Buffer,isEncoding=Buffer.isEncoding||function(t){switch((t=""+t)&&t.toLowerCase()){case"hex":case"utf8":case"utf-8":case"ascii":case"binary":case"base64":case"ucs2":case"ucs-2":case"utf16le":case"utf-16le":case"raw":return!0;default:return!1}};function _normalizeEncoding(t){if(!t)return"utf8";for(var e;;)switch(t){case"utf8":case"utf-8":return"utf8";case"ucs2":case"ucs-2":case"utf16le":case"utf-16le":return"utf16le";case"latin1":case"binary":return"latin1";case"base64":case"ascii":case"hex":return t;default:if(e)return;t=(""+t).toLowerCase(),e=!0}}function normalizeEncoding(t){var e=_normalizeEncoding(t);if("string"!=typeof e&&(Buffer.isEncoding===isEncoding||!isEncoding(t)))throw new Error("Unknown encoding: "+t);return e||t}exports.StringDecoder=StringDecoder;function StringDecoder(t){this.encoding=normalizeEncoding(t);var e;switch(this.encoding){case"utf16le":this.text=utf16Text,this.end=utf16End,e=4;break;case"utf8":this.fillLast=utf8FillLast,e=4;break;case"base64":this.text=base64Text,this.end=base64End,e=3;break;default:return this.write=simpleWrite,void(this.end=simpleEnd)}this.lastNeed=0,this.lastTotal=0,this.lastChar=Buffer.allocUnsafe(e)}StringDecoder.prototype.write=function(t){if(0===t.length)return"";var e,s;if(this.lastNeed){if(void 0===(e=this.fillLast(t)))return"";s=this.lastNeed,this.lastNeed=0}else s=0;return s<t.length?e?e+this.text(t,s):this.text(t,s):e||""},StringDecoder.prototype.end=utf8End,StringDecoder.prototype.text=utf8Text,StringDecoder.prototype.fillLast=function(t){if(this.lastNeed<=t.length)return t.copy(this.lastChar,this.lastTotal-this.lastNeed,0,this.lastNeed),this.lastChar.toString(this.encoding,0,this.lastTotal);t.copy(this.lastChar,this.lastTotal-this.lastNeed,0,t.length),this.lastNeed-=t.length};function utf8CheckByte(t){return t<=127?0:t>>5==6?2:t>>4==14?3:t>>3==30?4:-1}function utf8CheckIncomplete(t,e,s){var i=e.length-1;if(i<s)return 0;var a=utf8CheckByte(e[i]);return a>=0?(a>0&&(t.lastNeed=a-1),a):--i<s?0:(a=utf8CheckByte(e[i]))>=0?(a>0&&(t.lastNeed=a-2),a):--i<s?0:(a=utf8CheckByte(e[i]))>=0?(a>0&&(2===a?a=0:t.lastNeed=a-3),a):0}function utf8CheckExtraBytes(t,e,s){if(128!=(192&e[0]))return t.lastNeed=0,"�".repeat(s);if(t.lastNeed>1&&e.length>1){if(128!=(192&e[1]))return t.lastNeed=1,"�".repeat(s+1);if(t.lastNeed>2&&e.length>2&&128!=(192&e[2]))return t.lastNeed=2,"�".repeat(s+2)}}function utf8FillLast(t){var e=this.lastTotal-this.lastNeed,s=utf8CheckExtraBytes(this,t,e);return void 0!==s?s:this.lastNeed<=t.length?(t.copy(this.lastChar,e,0,this.lastNeed),this.lastChar.toString(this.encoding,0,this.lastTotal)):(t.copy(this.lastChar,e,0,t.length),void(this.lastNeed-=t.length))}function utf8Text(t,e){var s=utf8CheckIncomplete(this,t,e);if(!this.lastNeed)return t.toString("utf8",e);this.lastTotal=s;var i=t.length-(s-this.lastNeed);return t.copy(this.lastChar,0,i),t.toString("utf8",e,i)}function utf8End(t){var e=t&&t.length?this.write(t):"";return this.lastNeed?e+"�".repeat(this.lastTotal-this.lastNeed):e}function utf16Text(t,e){if((t.length-e)%2==0){var s=t.toString("utf16le",e);if(s){var i=s.charCodeAt(s.length-1);if(i>=55296&&i<=56319)return this.lastNeed=2,this.lastTotal=4,this.lastChar[0]=t[t.length-2],this.lastChar[1]=t[t.length-1],s.slice(0,-1)}return s}return this.lastNeed=1,this.lastTotal=2,this.lastChar[0]=t[t.length-1],t.toString("utf16le",e,t.length-1)}function utf16End(t){var e=t&&t.length?this.write(t):"";if(this.lastNeed){var s=this.lastTotal-this.lastNeed;return e+this.lastChar.toString("utf16le",0,s)}return e}function base64Text(t,e){var s=(t.length-e)%3;return 0===s?t.toString("base64",e):(this.lastNeed=3-s,this.lastTotal=3,1===s?this.lastChar[0]=t[t.length-1]:(this.lastChar[0]=t[t.length-2],this.lastChar[1]=t[t.length-1]),t.toString("base64",e,t.length-s))}function base64End(t){var e=t&&t.length?this.write(t):"";return this.lastNeed?e+this.lastChar.toString("base64",0,3-this.lastNeed):e}function simpleWrite(t){return t.toString(this.encoding)}function simpleEnd(t){return t&&t.length?this.write(t):""}

},{"safe-buffer":132}],135:[function(_dereq_,module,exports){
(function (global){
module.exports=deprecate;function deprecate(r,e){if(config("noDeprecation"))return r;var o=!1;return function(){if(!o){if(config("throwDeprecation"))throw new Error(e);config("traceDeprecation")?console.trace(e):console.warn(e),o=!0}return r.apply(this,arguments)}}function config(r){try{if(!global.localStorage)return!1}catch(r){return!1}var e=global.localStorage[r];return null!=e&&"true"===String(e).toLowerCase()}

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})

},{}],136:[function(_dereq_,module,exports){
"function"==typeof Object.create?module.exports=function(t,e){t.super_=e,t.prototype=Object.create(e.prototype,{constructor:{value:t,enumerable:!1,writable:!0,configurable:!0}})}:module.exports=function(t,e){t.super_=e;var o=function(){};o.prototype=e.prototype,t.prototype=new o,t.prototype.constructor=t};

},{}],137:[function(_dereq_,module,exports){
module.exports=function(o){return o&&"object"==typeof o&&"function"==typeof o.copy&&"function"==typeof o.fill&&"function"==typeof o.readUInt8};

},{}],138:[function(_dereq_,module,exports){
(function (process,global){
var formatRegExp=/%[sdj%]/g;exports.format=function(e){if(!isString(e)){for(var r=[],t=0;t<arguments.length;t++)r.push(inspect(arguments[t]));return r.join(" ")}t=1;for(var n=arguments,i=n.length,o=String(e).replace(formatRegExp,function(e){if("%%"===e)return"%";if(t>=i)return e;switch(e){case"%s":return String(n[t++]);case"%d":return Number(n[t++]);case"%j":try{return JSON.stringify(n[t++])}catch(e){return"[Circular]"}default:return e}}),s=n[t];t<i;s=n[++t])isNull(s)||!isObject(s)?o+=" "+s:o+=" "+inspect(s);return o},exports.deprecate=function(e,r){if(isUndefined(global.process))return function(){return exports.deprecate(e,r).apply(this,arguments)};if(!0===process.noDeprecation)return e;var t=!1;return function(){if(!t){if(process.throwDeprecation)throw new Error(r);process.traceDeprecation?console.trace(r):console.error(r),t=!0}return e.apply(this,arguments)}};var debugEnviron,debugs={};exports.debuglog=function(e){if(isUndefined(debugEnviron)&&(debugEnviron=process.env.NODE_DEBUG||""),e=e.toUpperCase(),!debugs[e])if(new RegExp("\\b"+e+"\\b","i").test(debugEnviron)){var r=process.pid;debugs[e]=function(){var t=exports.format.apply(exports,arguments);console.error("%s %d: %s",e,r,t)}}else debugs[e]=function(){};return debugs[e]};function inspect(e,r){var t={seen:[],stylize:stylizeNoColor};return arguments.length>=3&&(t.depth=arguments[2]),arguments.length>=4&&(t.colors=arguments[3]),isBoolean(r)?t.showHidden=r:r&&exports._extend(t,r),isUndefined(t.showHidden)&&(t.showHidden=!1),isUndefined(t.depth)&&(t.depth=2),isUndefined(t.colors)&&(t.colors=!1),isUndefined(t.customInspect)&&(t.customInspect=!0),t.colors&&(t.stylize=stylizeWithColor),formatValue(t,e,t.depth)}exports.inspect=inspect,inspect.colors={bold:[1,22],italic:[3,23],underline:[4,24],inverse:[7,27],white:[37,39],grey:[90,39],black:[30,39],blue:[34,39],cyan:[36,39],green:[32,39],magenta:[35,39],red:[31,39],yellow:[33,39]},inspect.styles={special:"cyan",number:"yellow",boolean:"yellow",undefined:"grey",null:"bold",string:"green",date:"magenta",regexp:"red"};function stylizeWithColor(e,r){var t=inspect.styles[r];return t?"["+inspect.colors[t][0]+"m"+e+"["+inspect.colors[t][1]+"m":e}function stylizeNoColor(e,r){return e}function arrayToHash(e){var r={};return e.forEach(function(e,t){r[e]=!0}),r}function formatValue(e,r,t){if(e.customInspect&&r&&isFunction(r.inspect)&&r.inspect!==exports.inspect&&(!r.constructor||r.constructor.prototype!==r)){var n=r.inspect(t,e);return isString(n)||(n=formatValue(e,n,t)),n}var i=formatPrimitive(e,r);if(i)return i;var o=Object.keys(r),s=arrayToHash(o);if(e.showHidden&&(o=Object.getOwnPropertyNames(r)),isError(r)&&(o.indexOf("message")>=0||o.indexOf("description")>=0))return formatError(r);if(0===o.length){if(isFunction(r)){var u=r.name?": "+r.name:"";return e.stylize("[Function"+u+"]","special")}if(isRegExp(r))return e.stylize(RegExp.prototype.toString.call(r),"regexp");if(isDate(r))return e.stylize(Date.prototype.toString.call(r),"date");if(isError(r))return formatError(r)}var c="",a=!1,l=["{","}"];if(isArray(r)&&(a=!0,l=["[","]"]),isFunction(r)){c=" [Function"+(r.name?": "+r.name:"")+"]"}if(isRegExp(r)&&(c=" "+RegExp.prototype.toString.call(r)),isDate(r)&&(c=" "+Date.prototype.toUTCString.call(r)),isError(r)&&(c=" "+formatError(r)),0===o.length&&(!a||0==r.length))return l[0]+c+l[1];if(t<0)return isRegExp(r)?e.stylize(RegExp.prototype.toString.call(r),"regexp"):e.stylize("[Object]","special");e.seen.push(r);var p;return p=a?formatArray(e,r,t,s,o):o.map(function(n){return formatProperty(e,r,t,s,n,a)}),e.seen.pop(),reduceToSingleString(p,c,l)}function formatPrimitive(e,r){if(isUndefined(r))return e.stylize("undefined","undefined");if(isString(r)){var t="'"+JSON.stringify(r).replace(/^"|"$/g,"").replace(/'/g,"\\'").replace(/\\"/g,'"')+"'";return e.stylize(t,"string")}return isNumber(r)?e.stylize(""+r,"number"):isBoolean(r)?e.stylize(""+r,"boolean"):isNull(r)?e.stylize("null","null"):void 0}function formatError(e){return"["+Error.prototype.toString.call(e)+"]"}function formatArray(e,r,t,n,i){for(var o=[],s=0,u=r.length;s<u;++s)hasOwnProperty(r,String(s))?o.push(formatProperty(e,r,t,n,String(s),!0)):o.push("");return i.forEach(function(i){i.match(/^\d+$/)||o.push(formatProperty(e,r,t,n,i,!0))}),o}function formatProperty(e,r,t,n,i,o){var s,u,c;if((c=Object.getOwnPropertyDescriptor(r,i)||{value:r[i]}).get?u=c.set?e.stylize("[Getter/Setter]","special"):e.stylize("[Getter]","special"):c.set&&(u=e.stylize("[Setter]","special")),hasOwnProperty(n,i)||(s="["+i+"]"),u||(e.seen.indexOf(c.value)<0?(u=isNull(t)?formatValue(e,c.value,null):formatValue(e,c.value,t-1)).indexOf("\n")>-1&&(u=o?u.split("\n").map(function(e){return"  "+e}).join("\n").substr(2):"\n"+u.split("\n").map(function(e){return"   "+e}).join("\n")):u=e.stylize("[Circular]","special")),isUndefined(s)){if(o&&i.match(/^\d+$/))return u;(s=JSON.stringify(""+i)).match(/^"([a-zA-Z_][a-zA-Z_0-9]*)"$/)?(s=s.substr(1,s.length-2),s=e.stylize(s,"name")):(s=s.replace(/'/g,"\\'").replace(/\\"/g,'"').replace(/(^"|"$)/g,"'"),s=e.stylize(s,"string"))}return s+": "+u}function reduceToSingleString(e,r,t){return e.reduce(function(e,r){return 0,r.indexOf("\n")>=0&&0,e+r.replace(/\u001b\[\d\d?m/g,"").length+1},0)>60?t[0]+(""===r?"":r+"\n ")+" "+e.join(",\n  ")+" "+t[1]:t[0]+r+" "+e.join(", ")+" "+t[1]}function isArray(e){return Array.isArray(e)}exports.isArray=isArray;function isBoolean(e){return"boolean"==typeof e}exports.isBoolean=isBoolean;function isNull(e){return null===e}exports.isNull=isNull;function isNullOrUndefined(e){return null==e}exports.isNullOrUndefined=isNullOrUndefined;function isNumber(e){return"number"==typeof e}exports.isNumber=isNumber;function isString(e){return"string"==typeof e}exports.isString=isString;function isSymbol(e){return"symbol"==typeof e}exports.isSymbol=isSymbol;function isUndefined(e){return void 0===e}exports.isUndefined=isUndefined;function isRegExp(e){return isObject(e)&&"[object RegExp]"===objectToString(e)}exports.isRegExp=isRegExp;function isObject(e){return"object"==typeof e&&null!==e}exports.isObject=isObject;function isDate(e){return isObject(e)&&"[object Date]"===objectToString(e)}exports.isDate=isDate;function isError(e){return isObject(e)&&("[object Error]"===objectToString(e)||e instanceof Error)}exports.isError=isError;function isFunction(e){return"function"==typeof e}exports.isFunction=isFunction;function isPrimitive(e){return null===e||"boolean"==typeof e||"number"==typeof e||"string"==typeof e||"symbol"==typeof e||void 0===e}exports.isPrimitive=isPrimitive,exports.isBuffer=_dereq_("./support/isBuffer");function objectToString(e){return Object.prototype.toString.call(e)}function pad(e){return e<10?"0"+e.toString(10):e.toString(10)}var months=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];function timestamp(){var e=new Date,r=[pad(e.getHours()),pad(e.getMinutes()),pad(e.getSeconds())].join(":");return[e.getDate(),months[e.getMonth()],r].join(" ")}exports.log=function(){console.log("%s - %s",timestamp(),exports.format.apply(exports,arguments))},exports.inherits=_dereq_("inherits"),exports._extend=function(e,r){if(!r||!isObject(r))return e;for(var t=Object.keys(r),n=t.length;n--;)e[t[n]]=r[t[n]];return e};function hasOwnProperty(e,r){return Object.prototype.hasOwnProperty.call(e,r)}

}).call(this,_dereq_('_process'),typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})

},{"./support/isBuffer":137,"_process":21,"inherits":136}],139:[function(_dereq_,module,exports){
(function (global,Buffer){
_dereq_=function t(e,r,n){function o(a,s){if(!r[a]){if(!e[a]){var c="function"==typeof _dereq_&&_dereq_;if(!s&&c)return c(a,!0);if(i)return i(a,!0);var u=new Error("Cannot find module '"+a+"'");throw u.code="MODULE_NOT_FOUND",u}var f=r[a]={exports:{}};e[a][0].call(f.exports,function(t){return o(e[a][1][t]||t)},f,f.exports,t,e,r,n)}return r[a].exports}for(var i="function"==typeof _dereq_&&_dereq_,a=0;a<n.length;a++)o(n[a]);return o}({1:[function(t,e,r){e.exports=[{constant:!0,inputs:[{name:"_owner",type:"address"}],name:"name",outputs:[{name:"o_name",type:"bytes32"}],type:"function"},{constant:!0,inputs:[{name:"_name",type:"bytes32"}],name:"owner",outputs:[{name:"",type:"address"}],type:"function"},{constant:!0,inputs:[{name:"_name",type:"bytes32"}],name:"content",outputs:[{name:"",type:"bytes32"}],type:"function"},{constant:!0,inputs:[{name:"_name",type:"bytes32"}],name:"addr",outputs:[{name:"",type:"address"}],type:"function"},{constant:!1,inputs:[{name:"_name",type:"bytes32"}],name:"reserve",outputs:[],type:"function"},{constant:!0,inputs:[{name:"_name",type:"bytes32"}],name:"subRegistrar",outputs:[{name:"",type:"address"}],type:"function"},{constant:!1,inputs:[{name:"_name",type:"bytes32"},{name:"_newOwner",type:"address"}],name:"transfer",outputs:[],type:"function"},{constant:!1,inputs:[{name:"_name",type:"bytes32"},{name:"_registrar",type:"address"}],name:"setSubRegistrar",outputs:[],type:"function"},{constant:!1,inputs:[],name:"Registrar",outputs:[],type:"function"},{constant:!1,inputs:[{name:"_name",type:"bytes32"},{name:"_a",type:"address"},{name:"_primary",type:"bool"}],name:"setAddress",outputs:[],type:"function"},{constant:!1,inputs:[{name:"_name",type:"bytes32"},{name:"_content",type:"bytes32"}],name:"setContent",outputs:[],type:"function"},{constant:!1,inputs:[{name:"_name",type:"bytes32"}],name:"disown",outputs:[],type:"function"},{anonymous:!1,inputs:[{indexed:!0,name:"_name",type:"bytes32"},{indexed:!1,name:"_winner",type:"address"}],name:"AuctionEnded",type:"event"},{anonymous:!1,inputs:[{indexed:!0,name:"_name",type:"bytes32"},{indexed:!1,name:"_bidder",type:"address"},{indexed:!1,name:"_value",type:"uint256"}],name:"NewBid",type:"event"},{anonymous:!1,inputs:[{indexed:!0,name:"name",type:"bytes32"}],name:"Changed",type:"event"},{anonymous:!1,inputs:[{indexed:!0,name:"name",type:"bytes32"},{indexed:!0,name:"addr",type:"address"}],name:"PrimaryChanged",type:"event"}]},{}],2:[function(t,e,r){e.exports=[{constant:!0,inputs:[{name:"_name",type:"bytes32"}],name:"owner",outputs:[{name:"",type:"address"}],type:"function"},{constant:!1,inputs:[{name:"_name",type:"bytes32"},{name:"_refund",type:"address"}],name:"disown",outputs:[],type:"function"},{constant:!0,inputs:[{name:"_name",type:"bytes32"}],name:"addr",outputs:[{name:"",type:"address"}],type:"function"},{constant:!1,inputs:[{name:"_name",type:"bytes32"}],name:"reserve",outputs:[],type:"function"},{constant:!1,inputs:[{name:"_name",type:"bytes32"},{name:"_newOwner",type:"address"}],name:"transfer",outputs:[],type:"function"},{constant:!1,inputs:[{name:"_name",type:"bytes32"},{name:"_a",type:"address"}],name:"setAddr",outputs:[],type:"function"},{anonymous:!1,inputs:[{indexed:!0,name:"name",type:"bytes32"}],name:"Changed",type:"event"}]},{}],3:[function(t,e,r){e.exports=[{constant:!1,inputs:[{name:"from",type:"bytes32"},{name:"to",type:"address"},{name:"value",type:"uint256"}],name:"transfer",outputs:[],type:"function"},{constant:!1,inputs:[{name:"from",type:"bytes32"},{name:"to",type:"address"},{name:"indirectId",type:"bytes32"},{name:"value",type:"uint256"}],name:"icapTransfer",outputs:[],type:"function"},{constant:!1,inputs:[{name:"to",type:"bytes32"}],name:"deposit",outputs:[],payable:!0,type:"function"},{anonymous:!1,inputs:[{indexed:!0,name:"from",type:"address"},{indexed:!1,name:"value",type:"uint256"}],name:"AnonymousDeposit",type:"event"},{anonymous:!1,inputs:[{indexed:!0,name:"from",type:"address"},{indexed:!0,name:"to",type:"bytes32"},{indexed:!1,name:"value",type:"uint256"}],name:"Deposit",type:"event"},{anonymous:!1,inputs:[{indexed:!0,name:"from",type:"bytes32"},{indexed:!0,name:"to",type:"address"},{indexed:!1,name:"value",type:"uint256"}],name:"Transfer",type:"event"},{anonymous:!1,inputs:[{indexed:!0,name:"from",type:"bytes32"},{indexed:!0,name:"to",type:"address"},{indexed:!1,name:"indirectId",type:"bytes32"},{indexed:!1,name:"value",type:"uint256"}],name:"IcapTransfer",type:"event"}]},{}],4:[function(t,e,r){var n=t("./formatters"),o=t("./type"),i=function(){this._inputFormatter=n.formatInputInt,this._outputFormatter=n.formatOutputAddress};(i.prototype=new o({})).constructor=i,i.prototype.isType=function(t){return!!t.match(/address(\[([0-9]*)\])?/)},e.exports=i},{"./formatters":9,"./type":14}],5:[function(t,e,r){var n=t("./formatters"),o=t("./type"),i=function(){this._inputFormatter=n.formatInputBool,this._outputFormatter=n.formatOutputBool};(i.prototype=new o({})).constructor=i,i.prototype.isType=function(t){return!!t.match(/^bool(\[([0-9]*)\])*$/)},e.exports=i},{"./formatters":9,"./type":14}],6:[function(t,e,r){var n=t("./formatters"),o=t("./type"),i=function(){this._inputFormatter=n.formatInputBytes,this._outputFormatter=n.formatOutputBytes};(i.prototype=new o({})).constructor=i,i.prototype.isType=function(t){return!!t.match(/^bytes([0-9]{1,})(\[([0-9]*)\])*$/)},e.exports=i},{"./formatters":9,"./type":14}],7:[function(t,e,r){var n=t("./formatters"),o=t("./address"),i=t("./bool"),a=t("./int"),s=t("./uint"),c=t("./dynamicbytes"),u=t("./string"),f=t("./real"),l=t("./ureal"),p=t("./bytes"),h=function(t,e){return t.isDynamicType(e)||t.isDynamicArray(e)},d=function(t){this._types=t};d.prototype._requireType=function(t){var e=this._types.filter(function(e){return e.isType(t)})[0];if(!e)throw Error("invalid solidity type!: "+t);return e},d.prototype.encodeParam=function(t,e){return this.encodeParams([t],[e])},d.prototype.encodeParams=function(t,e){var r=this.getSolidityTypes(t),n=r.map(function(r,n){return r.encode(e[n],t[n])}),o=r.reduce(function(e,n,o){var i=n.staticPartLength(t[o]),a=32*Math.floor((i+31)/32);return e+(h(r[o],t[o])?32:a)},0);return this.encodeMultiWithOffset(t,r,n,o)},d.prototype.encodeMultiWithOffset=function(t,e,r,o){var i="",a=this;return t.forEach(function(s,c){if(h(e[c],t[c])){i+=n.formatInputInt(o).encode();var u=a.encodeWithOffset(t[c],e[c],r[c],o);o+=u.length/2}else i+=a.encodeWithOffset(t[c],e[c],r[c],o)}),t.forEach(function(n,s){if(h(e[s],t[s])){var c=a.encodeWithOffset(t[s],e[s],r[s],o);o+=c.length/2,i+=c}}),i},d.prototype.encodeWithOffset=function(t,e,r,o){var i=e.isDynamicArray(t)?1:e.isStaticArray(t)?2:3;if(3!==i){var a=e.nestedName(t),s=e.staticPartLength(a),c=1===i?r[0]:"";if(e.isDynamicArray(a))for(var u=1===i?2:0,f=0;f<r.length;f++)1===i?u+=+r[f-1][0]||0:2===i&&(u+=+(r[f-1]||[])[0]||0),c+=n.formatInputInt(o+f*s+32*u).encode();for(var l=1===i?r.length-1:r.length,p=0;p<l;p++){var h=c/2;1===i?c+=this.encodeWithOffset(a,e,r[p+1],o+h):2===i&&(c+=this.encodeWithOffset(a,e,r[p],o+h))}return c}return r},d.prototype.decodeParam=function(t,e){return this.decodeParams([t],e)[0]},d.prototype.decodeParams=function(t,e){var r=this.getSolidityTypes(t),n=this.getOffsets(t,r);return r.map(function(r,o){return r.decode(e,n[o],t[o],o)})},d.prototype.getOffsets=function(t,e){for(var r=e.map(function(e,r){return e.staticPartLength(t[r])}),n=1;n<r.length;n++)r[n]+=r[n-1];return r.map(function(r,n){return r-e[n].staticPartLength(t[n])})},d.prototype.getSolidityTypes=function(t){var e=this;return t.map(function(t){return e._requireType(t)})};var m=new d([new o,new i,new a,new s,new c,new p,new u,new f,new l]);e.exports=m},{"./address":4,"./bool":5,"./bytes":6,"./dynamicbytes":8,"./formatters":9,"./int":10,"./real":12,"./string":13,"./uint":15,"./ureal":16}],8:[function(t,e,r){var n=t("./formatters"),o=t("./type"),i=function(){this._inputFormatter=n.formatInputDynamicBytes,this._outputFormatter=n.formatOutputDynamicBytes};(i.prototype=new o({})).constructor=i,i.prototype.isType=function(t){return!!t.match(/^bytes(\[([0-9]*)\])*$/)},i.prototype.isDynamicType=function(){return!0},e.exports=i},{"./formatters":9,"./type":14}],9:[function(t,e,r){var n=t("bignumber.js"),o=t("../utils/utils"),i=t("../utils/config"),a=t("./param"),s=function(t){n.config(i.ETH_BIGNUMBER_ROUNDING_MODE);var e=o.padLeft(o.toTwosComplement(t).toString(16),64);return new a(e)},c=function(t){var e=t.staticPart()||"0";return"1"===new n(e.substr(0,1),16).toString(2).substr(0,1)?new n(e,16).minus(new n("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",16)).minus(1):new n(e,16)},u=function(t){var e=t.staticPart()||"0";return new n(e,16)};e.exports={formatInputInt:s,formatInputBytes:function(t){var e=o.toHex(t).substr(2),r=Math.floor((e.length+63)/64);return e=o.padRight(e,64*r),new a(e)},formatInputDynamicBytes:function(t){var e=o.toHex(t).substr(2),r=e.length/2,n=Math.floor((e.length+63)/64);return e=o.padRight(e,64*n),new a(s(r).value+e)},formatInputString:function(t){var e=o.fromUtf8(t).substr(2),r=e.length/2,n=Math.floor((e.length+63)/64);return e=o.padRight(e,64*n),new a(s(r).value+e)},formatInputBool:function(t){return new a("000000000000000000000000000000000000000000000000000000000000000"+(t?"1":"0"))},formatInputReal:function(t){return s(new n(t).times(new n(2).pow(128)))},formatOutputInt:c,formatOutputUInt:u,formatOutputReal:function(t){return c(t).dividedBy(new n(2).pow(128))},formatOutputUReal:function(t){return u(t).dividedBy(new n(2).pow(128))},formatOutputBool:function(t){return"0000000000000000000000000000000000000000000000000000000000000001"===t.staticPart()},formatOutputBytes:function(t,e){var r=e.match(/^bytes([0-9]*)/),n=parseInt(r[1]);return"0x"+t.staticPart().slice(0,2*n)},formatOutputDynamicBytes:function(t){var e=2*new n(t.dynamicPart().slice(0,64),16).toNumber();return"0x"+t.dynamicPart().substr(64,e)},formatOutputString:function(t){var e=2*new n(t.dynamicPart().slice(0,64),16).toNumber();return o.toUtf8(t.dynamicPart().substr(64,e))},formatOutputAddress:function(t){var e=t.staticPart();return"0x"+e.slice(e.length-40,e.length)}}},{"../utils/config":18,"../utils/utils":20,"./param":11,"bignumber.js":"bignumber.js"}],10:[function(t,e,r){var n=t("./formatters"),o=t("./type"),i=function(){this._inputFormatter=n.formatInputInt,this._outputFormatter=n.formatOutputInt};(i.prototype=new o({})).constructor=i,i.prototype.isType=function(t){return!!t.match(/^int([0-9]*)?(\[([0-9]*)\])*$/)},e.exports=i},{"./formatters":9,"./type":14}],11:[function(t,e,r){var n=t("../utils/utils"),o=function(t,e){this.value=t||"",this.offset=e};o.prototype.dynamicPartLength=function(){return this.dynamicPart().length/2},o.prototype.withOffset=function(t){return new o(this.value,t)},o.prototype.combine=function(t){return new o(this.value+t.value)},o.prototype.isDynamic=function(){return void 0!==this.offset},o.prototype.offsetAsBytes=function(){return this.isDynamic()?n.padLeft(n.toTwosComplement(this.offset).toString(16),64):""},o.prototype.staticPart=function(){return this.isDynamic()?this.offsetAsBytes():this.value},o.prototype.dynamicPart=function(){return this.isDynamic()?this.value:""},o.prototype.encode=function(){return this.staticPart()+this.dynamicPart()},o.encodeList=function(t){var e=32*t.length,r=t.map(function(t){if(!t.isDynamic())return t;var r=e;return e+=t.dynamicPartLength(),t.withOffset(r)});return r.reduce(function(t,e){return t+e.dynamicPart()},r.reduce(function(t,e){return t+e.staticPart()},""))},e.exports=o},{"../utils/utils":20}],12:[function(t,e,r){var n=t("./formatters"),o=t("./type"),i=function(){this._inputFormatter=n.formatInputReal,this._outputFormatter=n.formatOutputReal};(i.prototype=new o({})).constructor=i,i.prototype.isType=function(t){return!!t.match(/real([0-9]*)?(\[([0-9]*)\])?/)},e.exports=i},{"./formatters":9,"./type":14}],13:[function(t,e,r){var n=t("./formatters"),o=t("./type"),i=function(){this._inputFormatter=n.formatInputString,this._outputFormatter=n.formatOutputString};(i.prototype=new o({})).constructor=i,i.prototype.isType=function(t){return!!t.match(/^string(\[([0-9]*)\])*$/)},i.prototype.isDynamicType=function(){return!0},e.exports=i},{"./formatters":9,"./type":14}],14:[function(t,e,r){var n=t("./formatters"),o=t("./param"),i=function(t){this._inputFormatter=t.inputFormatter,this._outputFormatter=t.outputFormatter};i.prototype.isType=function(t){throw"this method should be overrwritten for type "+t},i.prototype.staticPartLength=function(t){return(this.nestedTypes(t)||["[1]"]).map(function(t){return parseInt(t.slice(1,-1),10)||1}).reduce(function(t,e){return t*e},32)},i.prototype.isDynamicArray=function(t){var e=this.nestedTypes(t);return!!e&&!e[e.length-1].match(/[0-9]{1,}/g)},i.prototype.isStaticArray=function(t){var e=this.nestedTypes(t);return!!e&&!!e[e.length-1].match(/[0-9]{1,}/g)},i.prototype.staticArrayLength=function(t){var e=this.nestedTypes(t);return e?parseInt(e[e.length-1].match(/[0-9]{1,}/g)||1):1},i.prototype.nestedName=function(t){var e=this.nestedTypes(t);return e?t.substr(0,t.length-e[e.length-1].length):t},i.prototype.isDynamicType=function(){return!1},i.prototype.nestedTypes=function(t){return t.match(/(\[[0-9]*\])/g)},i.prototype.encode=function(t,e){var r=this;return this.isDynamicArray(e)?function(){var o=t.length,i=r.nestedName(e),a=[];return a.push(n.formatInputInt(o).encode()),t.forEach(function(t){a.push(r.encode(t,i))}),a}():this.isStaticArray(e)?function(){for(var n=r.staticArrayLength(e),o=r.nestedName(e),i=[],a=0;a<n;a++)i.push(r.encode(t[a],o));return i}():this._inputFormatter(t,e).encode()},i.prototype.decode=function(t,e,r){var n=this;if(this.isDynamicArray(r))return function(){for(var o=parseInt("0x"+t.substr(2*e,64)),i=parseInt("0x"+t.substr(2*o,64)),a=o+32,s=n.nestedName(r),c=n.staticPartLength(s),u=32*Math.floor((c+31)/32),f=[],l=0;l<i*u;l+=u)f.push(n.decode(t,a+l,s));return f}();if(this.isStaticArray(r))return function(){for(var o=n.staticArrayLength(r),i=e,a=n.nestedName(r),s=n.staticPartLength(a),c=32*Math.floor((s+31)/32),u=[],f=0;f<o*c;f+=c)u.push(n.decode(t,i+f,a));return u}();if(this.isDynamicType(r))return function(){var i=parseInt("0x"+t.substr(2*e,64)),a=parseInt("0x"+t.substr(2*i,64)),s=Math.floor((a+31)/32),c=new o(t.substr(2*i,64*(1+s)),0);return n._outputFormatter(c,r)}();var i=this.staticPartLength(r),a=new o(t.substr(2*e,2*i));return this._outputFormatter(a,r)},e.exports=i},{"./formatters":9,"./param":11}],15:[function(t,e,r){var n=t("./formatters"),o=t("./type"),i=function(){this._inputFormatter=n.formatInputInt,this._outputFormatter=n.formatOutputUInt};(i.prototype=new o({})).constructor=i,i.prototype.isType=function(t){return!!t.match(/^uint([0-9]*)?(\[([0-9]*)\])*$/)},e.exports=i},{"./formatters":9,"./type":14}],16:[function(t,e,r){var n=t("./formatters"),o=t("./type"),i=function(){this._inputFormatter=n.formatInputReal,this._outputFormatter=n.formatOutputUReal};(i.prototype=new o({})).constructor=i,i.prototype.isType=function(t){return!!t.match(/^ureal([0-9]*)?(\[([0-9]*)\])*$/)},e.exports=i},{"./formatters":9,"./type":14}],17:[function(t,e,r){"use strict";"undefined"==typeof XMLHttpRequest?r.XMLHttpRequest={}:r.XMLHttpRequest=XMLHttpRequest},{}],18:[function(t,e,r){var n=t("bignumber.js");e.exports={ETH_PADDING:32,ETH_SIGNATURE_LENGTH:4,ETH_UNITS:["wei","kwei","Mwei","Gwei","szabo","finney","femtoether","picoether","nanoether","microether","milliether","nano","micro","milli","ether","grand","Mether","Gether","Tether","Pether","Eether","Zether","Yether","Nether","Dether","Vether","Uether"],ETH_BIGNUMBER_ROUNDING_MODE:{ROUNDING_MODE:n.ROUND_DOWN},ETH_POLLING_TIMEOUT:500,defaultBlock:"latest",defaultAccount:void 0}},{"bignumber.js":"bignumber.js"}],19:[function(t,e,r){var n=t("crypto-js"),o=t("crypto-js/sha3");e.exports=function(t,e){return e&&"hex"===e.encoding&&(t.length>2&&"0x"===t.substr(0,2)&&(t=t.substr(2)),t=n.enc.Hex.parse(t)),o(t,{outputLength:256}).toString()}},{"crypto-js":59,"crypto-js/sha3":80}],20:[function(t,e,r){var n=t("bignumber.js"),o=t("./sha3.js"),i=t("utf8"),a={noether:"0",wei:"1",kwei:"1000",Kwei:"1000",babbage:"1000",femtoether:"1000",mwei:"1000000",Mwei:"1000000",lovelace:"1000000",picoether:"1000000",gwei:"1000000000",Gwei:"1000000000",shannon:"1000000000",nanoether:"1000000000",nano:"1000000000",szabo:"1000000000000",microether:"1000000000000",micro:"1000000000000",finney:"1000000000000000",milliether:"1000000000000000",milli:"1000000000000000",ether:"1000000000000000000",kether:"1000000000000000000000",grand:"1000000000000000000000",mether:"1000000000000000000000000",gether:"1000000000000000000000000000",tether:"1000000000000000000000000000000"},s=function(t,e,r){return new Array(e-t.length+1).join(r||"0")+t},c=function(t){t=i.encode(t);for(var e="",r=0;r<t.length;r++){var n=t.charCodeAt(r);if(0===n)break;var o=n.toString(16);e+=o.length<2?"0"+o:o}return"0x"+e},u=function(t){for(var e="",r=0;r<t.length;r++){var n=t.charCodeAt(r).toString(16);e+=n.length<2?"0"+n:n}return"0x"+e},f=function(t){var e=h(t),r=e.toString(16);return e.lessThan(0)?"-0x"+r.substr(1):"0x"+r},l=function(t){if(v(t))return f(+t);if(y(t))return f(t);if("object"==typeof t)return c(JSON.stringify(t));if(g(t)){if(0===t.indexOf("-0x"))return f(t);if(0===t.indexOf("0x"))return t;if(!isFinite(t))return u(t)}return f(t)},p=function(t){t=t?t.toLowerCase():"ether";var e=a[t];if(void 0===e)throw new Error("This unit doesn't exists, please use the one of the following units"+JSON.stringify(a,null,2));return new n(e,10)},h=function(t){return y(t=t||0)?t:!g(t)||0!==t.indexOf("0x")&&0!==t.indexOf("-0x")?new n(t.toString(10),10):new n(t.replace("0x",""),16)},d=function(t){return/^0x[0-9a-f]{40}$/i.test(t)},m=function(t){t=t.replace("0x","");for(var e=o(t.toLowerCase()),r=0;r<40;r++)if(parseInt(e[r],16)>7&&t[r].toUpperCase()!==t[r]||parseInt(e[r],16)<=7&&t[r].toLowerCase()!==t[r])return!1;return!0},y=function(t){return t instanceof n||t&&t.constructor&&"BigNumber"===t.constructor.name},g=function(t){return"string"==typeof t||t&&t.constructor&&"String"===t.constructor.name},v=function(t){return"boolean"==typeof t};e.exports={padLeft:s,padRight:function(t,e,r){return t+new Array(e-t.length+1).join(r||"0")},toHex:l,toDecimal:function(t){return h(t).toNumber()},fromDecimal:f,toUtf8:function(t){var e="",r=0,n=t.length;for("0x"===t.substring(0,2)&&(r=2);r<n;r+=2){var o=parseInt(t.substr(r,2),16);if(0===o)break;e+=String.fromCharCode(o)}return i.decode(e)},toAscii:function(t){var e="",r=0,n=t.length;for("0x"===t.substring(0,2)&&(r=2);r<n;r+=2){var o=parseInt(t.substr(r,2),16);e+=String.fromCharCode(o)}return e},fromUtf8:c,fromAscii:u,transformToFullName:function(t){if(-1!==t.name.indexOf("("))return t.name;var e=t.inputs.map(function(t){return t.type}).join();return t.name+"("+e+")"},extractDisplayName:function(t){var e=t.indexOf("(");return-1!==e?t.substr(0,e):t},extractTypeName:function(t){var e=t.indexOf("(");return-1!==e?t.substr(e+1,t.length-1-(e+1)).replace(" ",""):""},toWei:function(t,e){var r=h(t).times(p(e));return y(t)?r:r.toString(10)},fromWei:function(t,e){var r=h(t).dividedBy(p(e));return y(t)?r:r.toString(10)},toBigNumber:h,toTwosComplement:function(t){var e=h(t).round();return e.lessThan(0)?new n("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",16).plus(e).plus(1):e},toAddress:function(t){return d(t)?t:/^[0-9a-f]{40}$/.test(t)?"0x"+t:"0x"+s(l(t).substr(2),40)},isBigNumber:y,isStrictAddress:d,isAddress:function(t){return!!/^(0x)?[0-9a-f]{40}$/i.test(t)&&(!(!/^(0x)?[0-9a-f]{40}$/.test(t)&&!/^(0x)?[0-9A-F]{40}$/.test(t))||m(t))},isChecksumAddress:m,toChecksumAddress:function(t){if(void 0===t)return"";t=t.toLowerCase().replace("0x","");for(var e=o(t),r="0x",n=0;n<t.length;n++)parseInt(e[n],16)>7?r+=t[n].toUpperCase():r+=t[n];return r},isFunction:function(t){return"function"==typeof t},isString:g,isObject:function(t){return null!==t&&!Array.isArray(t)&&"object"==typeof t},isBoolean:v,isArray:function(t){return Array.isArray(t)},isJson:function(t){try{return!!JSON.parse(t)}catch(t){return!1}},isBloom:function(t){return!(!/^(0x)?[0-9a-f]{512}$/i.test(t)||!/^(0x)?[0-9a-f]{512}$/.test(t)&&!/^(0x)?[0-9A-F]{512}$/.test(t))},isTopic:function(t){return!(!/^(0x)?[0-9a-f]{64}$/i.test(t)||!/^(0x)?[0-9a-f]{64}$/.test(t)&&!/^(0x)?[0-9A-F]{64}$/.test(t))}}},{"./sha3.js":19,"bignumber.js":"bignumber.js",utf8:85}],21:[function(t,e,r){e.exports={version:"0.20.3"}},{}],22:[function(t,e,r){function n(t){this._requestManager=new o(t),this.currentProvider=t,this.eth=new a(this),this.db=new s(this),this.shh=new c(this),this.net=new u(this),this.personal=new f(this),this.bzz=new l(this),this.settings=new p,this.version={api:h.version},this.providers={HttpProvider:b,IpcProvider:_},this._extend=y(this),this._extend({properties:x()})}var o=t("./web3/requestmanager"),i=t("./web3/iban"),a=t("./web3/methods/eth"),s=t("./web3/methods/db"),c=t("./web3/methods/shh"),u=t("./web3/methods/net"),f=t("./web3/methods/personal"),l=t("./web3/methods/swarm"),p=t("./web3/settings"),h=t("./version.json"),d=t("./utils/utils"),m=t("./utils/sha3"),y=t("./web3/extend"),g=t("./web3/batch"),v=t("./web3/property"),b=t("./web3/httpprovider"),_=t("./web3/ipcprovider"),w=t("bignumber.js");n.providers={HttpProvider:b,IpcProvider:_},n.prototype.setProvider=function(t){this._requestManager.setProvider(t),this.currentProvider=t},n.prototype.reset=function(t){this._requestManager.reset(t),this.settings=new p},n.prototype.BigNumber=w,n.prototype.toHex=d.toHex,n.prototype.toAscii=d.toAscii,n.prototype.toUtf8=d.toUtf8,n.prototype.fromAscii=d.fromAscii,n.prototype.fromUtf8=d.fromUtf8,n.prototype.toDecimal=d.toDecimal,n.prototype.fromDecimal=d.fromDecimal,n.prototype.toBigNumber=d.toBigNumber,n.prototype.toWei=d.toWei,n.prototype.fromWei=d.fromWei,n.prototype.isAddress=d.isAddress,n.prototype.isChecksumAddress=d.isChecksumAddress,n.prototype.toChecksumAddress=d.toChecksumAddress,n.prototype.isIBAN=d.isIBAN,n.prototype.padLeft=d.padLeft,n.prototype.padRight=d.padRight,n.prototype.sha3=function(t,e){return"0x"+m(t,e)},n.prototype.fromICAP=function(t){return new i(t).address()};var x=function(){return[new v({name:"version.node",getter:"web3_clientVersion"}),new v({name:"version.network",getter:"net_version",inputFormatter:d.toDecimal}),new v({name:"version.ethereum",getter:"eth_protocolVersion",inputFormatter:d.toDecimal}),new v({name:"version.whisper",getter:"shh_version",inputFormatter:d.toDecimal})]};n.prototype.isConnected=function(){return this.currentProvider&&this.currentProvider.isConnected()},n.prototype.createBatch=function(){return new g(this)},e.exports=n},{"./utils/sha3":19,"./utils/utils":20,"./version.json":21,"./web3/batch":24,"./web3/extend":28,"./web3/httpprovider":32,"./web3/iban":33,"./web3/ipcprovider":34,"./web3/methods/db":37,"./web3/methods/eth":38,"./web3/methods/net":39,"./web3/methods/personal":40,"./web3/methods/shh":41,"./web3/methods/swarm":42,"./web3/property":45,"./web3/requestmanager":46,"./web3/settings":47,"bignumber.js":"bignumber.js"}],23:[function(t,e,r){var n=t("../utils/sha3"),o=t("./event"),i=t("./formatters"),a=t("../utils/utils"),s=t("./filter"),c=t("./methods/watches"),u=function(t,e,r){this._requestManager=t,this._json=e,this._address=r};u.prototype.encode=function(t){t=t||{};var e={};return["fromBlock","toBlock"].filter(function(e){return void 0!==t[e]}).forEach(function(r){e[r]=i.inputBlockNumberFormatter(t[r])}),e.address=this._address,e},u.prototype.decode=function(t){t.data=t.data||"",t.topics=t.topics||[];var e=t.topics[0].slice(2),r=this._json.filter(function(t){return e===n(a.transformToFullName(t))})[0];return r?new o(this._requestManager,r,this._address).decode(t):(console.warn("cannot find event for log"),t)},u.prototype.execute=function(t,e){a.isFunction(arguments[arguments.length-1])&&(e=arguments[arguments.length-1],1===arguments.length&&(t=null));var r=this.encode(t),n=this.decode.bind(this);return new s(r,"eth",this._requestManager,c.eth(),n,e)},u.prototype.attachToContract=function(t){var e=this.execute.bind(this);t.allEvents=e},e.exports=u},{"../utils/sha3":19,"../utils/utils":20,"./event":27,"./filter":29,"./formatters":30,"./methods/watches":43}],24:[function(t,e,r){var n=t("./jsonrpc"),o=t("./errors"),i=function(t){this.requestManager=t._requestManager,this.requests=[]};i.prototype.add=function(t){this.requests.push(t)},i.prototype.execute=function(){var t=this.requests;this.requestManager.sendBatch(t,function(e,r){r=r||[],t.map(function(t,e){return r[e]||{}}).forEach(function(e,r){if(t[r].callback){if(!n.isValidResponse(e))return t[r].callback(o.InvalidResponse(e));t[r].callback(null,t[r].format?t[r].format(e.result):e.result)}})})},e.exports=i},{"./errors":26,"./jsonrpc":35}],25:[function(t,e,r){var n=t("../utils/utils"),o=t("../solidity/coder"),i=t("./event"),a=t("./function"),s=t("./allevents"),c=function(t,e){return t.filter(function(t){return"constructor"===t.type&&t.inputs.length===e.length}).map(function(t){return t.inputs.map(function(t){return t.type})}).map(function(t){return o.encodeParams(t,e)})[0]||""},u=function(t){t.abi.filter(function(t){return"function"===t.type}).map(function(e){return new a(t._eth,e,t.address)}).forEach(function(e){e.attachToContract(t)})},f=function(t){var e=t.abi.filter(function(t){return"event"===t.type});new s(t._eth._requestManager,e,t.address).attachToContract(t),e.map(function(e){return new i(t._eth._requestManager,e,t.address)}).forEach(function(e){e.attachToContract(t)})},l=function(t,e){var r=0,n=!1,o=t._eth.filter("latest",function(i){if(!i&&!n)if(++r>50){if(o.stopWatching(function(){}),n=!0,!e)throw new Error("Contract transaction couldn't be found after 50 blocks");e(new Error("Contract transaction couldn't be found after 50 blocks"))}else t._eth.getTransactionReceipt(t.transactionHash,function(r,i){i&&!n&&t._eth.getCode(i.contractAddress,function(r,a){if(!n&&a)if(o.stopWatching(function(){}),n=!0,a.length>3)t.address=i.contractAddress,u(t),f(t),e&&e(null,t);else{if(!e)throw new Error("The contract code couldn't be stored, please check your gas amount.");e(new Error("The contract code couldn't be stored, please check your gas amount."))}})})})},p=function(t,e){this.eth=t,this.abi=e,this.new=function(){var t,r=new h(this.eth,this.abi),o={},i=Array.prototype.slice.call(arguments);n.isFunction(i[i.length-1])&&(t=i.pop());var a=i[i.length-1];if(n.isObject(a)&&!n.isArray(a)&&(o=i.pop()),o.value>0&&!(e.filter(function(t){return"constructor"===t.type&&t.inputs.length===i.length})[0]||{}).payable)throw new Error("Cannot send value to non-payable constructor");var s=c(this.abi,i);if(o.data+=s,t)this.eth.sendTransaction(o,function(e,n){e?t(e):(r.transactionHash=n,t(null,r),l(r,t))});else{var u=this.eth.sendTransaction(o);r.transactionHash=u,l(r)}return r},this.new.getData=this.getData.bind(this)};p.prototype.at=function(t,e){var r=new h(this.eth,this.abi,t);return u(r),f(r),e&&e(null,r),r},p.prototype.getData=function(){var t={},e=Array.prototype.slice.call(arguments),r=e[e.length-1];n.isObject(r)&&!n.isArray(r)&&(t=e.pop());var o=c(this.abi,e);return t.data+=o,t.data};var h=function(t,e,r){this._eth=t,this.transactionHash=null,this.address=r,this.abi=e};e.exports=p},{"../solidity/coder":7,"../utils/utils":20,"./allevents":23,"./event":27,"./function":31}],26:[function(t,e,r){e.exports={InvalidNumberOfSolidityArgs:function(){return new Error("Invalid number of arguments to Solidity function")},InvalidNumberOfRPCParams:function(){return new Error("Invalid number of input parameters to RPC method")},InvalidConnection:function(t){return new Error("CONNECTION ERROR: Couldn't connect to node "+t+".")},InvalidProvider:function(){return new Error("Provider not set or invalid")},InvalidResponse:function(t){var e=t&&t.error&&t.error.message?t.error.message:"Invalid JSON RPC response: "+JSON.stringify(t);return new Error(e)},ConnectionTimeout:function(t){return new Error("CONNECTION TIMEOUT: timeout of "+t+" ms achived")}}},{}],27:[function(t,e,r){var n=t("../utils/utils"),o=t("../solidity/coder"),i=t("./formatters"),a=t("../utils/sha3"),s=t("./filter"),c=t("./methods/watches"),u=function(t,e,r){this._requestManager=t,this._params=e.inputs,this._name=n.transformToFullName(e),this._address=r,this._anonymous=e.anonymous};u.prototype.types=function(t){return this._params.filter(function(e){return e.indexed===t}).map(function(t){return t.type})},u.prototype.displayName=function(){return n.extractDisplayName(this._name)},u.prototype.typeName=function(){return n.extractTypeName(this._name)},u.prototype.signature=function(){return a(this._name)},u.prototype.encode=function(t,e){t=t||{},e=e||{};var r={};["fromBlock","toBlock"].filter(function(t){return void 0!==e[t]}).forEach(function(t){r[t]=i.inputBlockNumberFormatter(e[t])}),r.topics=[],r.address=this._address,this._anonymous||r.topics.push("0x"+this.signature());var a=this._params.filter(function(t){return!0===t.indexed}).map(function(e){var r=t[e.name];return void 0===r||null===r?null:n.isArray(r)?r.map(function(t){return"0x"+o.encodeParam(e.type,t)}):"0x"+o.encodeParam(e.type,r)});return r.topics=r.topics.concat(a),r},u.prototype.decode=function(t){t.data=t.data||"",t.topics=t.topics||[];var e=(this._anonymous?t.topics:t.topics.slice(1)).map(function(t){return t.slice(2)}).join(""),r=o.decodeParams(this.types(!0),e),n=t.data.slice(2),a=o.decodeParams(this.types(!1),n),s=i.outputLogFormatter(t);return s.event=this.displayName(),s.address=t.address,s.args=this._params.reduce(function(t,e){return t[e.name]=e.indexed?r.shift():a.shift(),t},{}),delete s.data,delete s.topics,s},u.prototype.execute=function(t,e,r){n.isFunction(arguments[arguments.length-1])&&(r=arguments[arguments.length-1],2===arguments.length&&(e=null),1===arguments.length&&(e=null,t={}));var o=this.encode(t,e),i=this.decode.bind(this);return new s(o,"eth",this._requestManager,c.eth(),i,r)},u.prototype.attachToContract=function(t){var e=this.execute.bind(this),r=this.displayName();t[r]||(t[r]=e),t[r][this.typeName()]=this.execute.bind(this,t)},e.exports=u},{"../solidity/coder":7,"../utils/sha3":19,"../utils/utils":20,"./filter":29,"./formatters":30,"./methods/watches":43}],28:[function(t,e,r){var n=t("./formatters"),o=t("./../utils/utils"),i=t("./method"),a=t("./property");e.exports=function(t){var e=function(e){var r;e.property?(t[e.property]||(t[e.property]={}),r=t[e.property]):r=t,e.methods&&e.methods.forEach(function(e){e.attachToObject(r),e.setRequestManager(t._requestManager)}),e.properties&&e.properties.forEach(function(e){e.attachToObject(r),e.setRequestManager(t._requestManager)})};return e.formatters=n,e.utils=o,e.Method=i,e.Property=a,e}},{"./../utils/utils":20,"./formatters":30,"./method":36,"./property":45}],29:[function(t,e,r){var n=t("./formatters"),o=t("../utils/utils"),i=function(t){return null===t||void 0===t?null:0===(t=String(t)).indexOf("0x")?t:o.fromUtf8(t)},a=function(t,e){o.isString(t.options)||t.get(function(t,r){t&&e(t),o.isArray(r)&&r.forEach(function(t){e(null,t)})})},s=function(t){t.requestManager.startPolling({method:t.implementation.poll.call,params:[t.filterId]},t.filterId,function(e,r){if(e)return t.callbacks.forEach(function(t){t(e)});o.isArray(r)&&r.forEach(function(e){e=t.formatter?t.formatter(e):e,t.callbacks.forEach(function(t){t(null,e)})})},t.stopWatching.bind(t))},c=function(t,e,r,c,u,f,l){var p=this,h={};return c.forEach(function(t){t.setRequestManager(r),t.attachToObject(h)}),this.requestManager=r,this.options=function(t,e){if(o.isString(t))return t;switch(t=t||{},e){case"eth":return t.topics=t.topics||[],t.topics=t.topics.map(function(t){return o.isArray(t)?t.map(i):i(t)}),{topics:t.topics,from:t.from,to:t.to,address:t.address,fromBlock:n.inputBlockNumberFormatter(t.fromBlock),toBlock:n.inputBlockNumberFormatter(t.toBlock)};case"shh":return t}}(t,e),this.implementation=h,this.filterId=null,this.callbacks=[],this.getLogsCallbacks=[],this.pollFilters=[],this.formatter=u,this.implementation.newFilter(this.options,function(t,e){if(t)p.callbacks.forEach(function(e){e(t)}),"function"==typeof l&&l(t);else if(p.filterId=e,p.getLogsCallbacks.forEach(function(t){p.get(t)}),p.getLogsCallbacks=[],p.callbacks.forEach(function(t){a(p,t)}),p.callbacks.length>0&&s(p),"function"==typeof f)return p.watch(f)}),this};c.prototype.watch=function(t){return this.callbacks.push(t),this.filterId&&(a(this,t),s(this)),this},c.prototype.stopWatching=function(t){if(this.requestManager.stopPolling(this.filterId),this.callbacks=[],!t)return this.implementation.uninstallFilter(this.filterId);this.implementation.uninstallFilter(this.filterId,t)},c.prototype.get=function(t){var e=this;if(!o.isFunction(t)){if(null===this.filterId)throw new Error("Filter ID Error: filter().get() can't be chained synchronous, please provide a callback for the get() method.");return this.implementation.getLogs(this.filterId).map(function(t){return e.formatter?e.formatter(t):t})}return null===this.filterId?this.getLogsCallbacks.push(t):this.implementation.getLogs(this.filterId,function(r,n){r?t(r):t(null,n.map(function(t){return e.formatter?e.formatter(t):t}))}),this},e.exports=c},{"../utils/utils":20,"./formatters":30}],30:[function(t,e,r){"use strict";var n=t("../utils/utils"),o=t("../utils/config"),i=t("./iban"),a=function(t){if(void 0!==t)return"latest"===t||"pending"===t||"earliest"===t?t:n.toHex(t)},s=function(t){return null!==t.blockNumber&&(t.blockNumber=n.toDecimal(t.blockNumber)),null!==t.transactionIndex&&(t.transactionIndex=n.toDecimal(t.transactionIndex)),t.nonce=n.toDecimal(t.nonce),t.gas=n.toDecimal(t.gas),t.gasPrice=n.toBigNumber(t.gasPrice),t.value=n.toBigNumber(t.value),t},c=function(t){return t.blockNumber&&(t.blockNumber=n.toDecimal(t.blockNumber)),t.transactionIndex&&(t.transactionIndex=n.toDecimal(t.transactionIndex)),t.logIndex&&(t.logIndex=n.toDecimal(t.logIndex)),t},u=function(t){var e=new i(t);if(e.isValid()&&e.isDirect())return"0x"+e.address();if(n.isStrictAddress(t))return t;if(n.isAddress(t))return"0x"+t;throw new Error("invalid address")};e.exports={inputDefaultBlockNumberFormatter:function(t){return void 0===t?o.defaultBlock:a(t)},inputBlockNumberFormatter:a,inputCallFormatter:function(t){return t.from=t.from||o.defaultAccount,t.from&&(t.from=u(t.from)),t.to&&(t.to=u(t.to)),["gasPrice","gas","value","nonce"].filter(function(e){return void 0!==t[e]}).forEach(function(e){t[e]=n.fromDecimal(t[e])}),t},inputTransactionFormatter:function(t){return t.from=t.from||o.defaultAccount,t.from=u(t.from),t.to&&(t.to=u(t.to)),["gasPrice","gas","value","nonce"].filter(function(e){return void 0!==t[e]}).forEach(function(e){t[e]=n.fromDecimal(t[e])}),t},inputAddressFormatter:u,inputPostFormatter:function(t){return t.ttl=n.fromDecimal(t.ttl),t.workToProve=n.fromDecimal(t.workToProve),t.priority=n.fromDecimal(t.priority),n.isArray(t.topics)||(t.topics=t.topics?[t.topics]:[]),t.topics=t.topics.map(function(t){return 0===t.indexOf("0x")?t:n.fromUtf8(t)}),t},outputBigNumberFormatter:function(t){return n.toBigNumber(t)},outputTransactionFormatter:s,outputTransactionReceiptFormatter:function(t){return null!==t.blockNumber&&(t.blockNumber=n.toDecimal(t.blockNumber)),null!==t.transactionIndex&&(t.transactionIndex=n.toDecimal(t.transactionIndex)),t.cumulativeGasUsed=n.toDecimal(t.cumulativeGasUsed),t.gasUsed=n.toDecimal(t.gasUsed),n.isArray(t.logs)&&(t.logs=t.logs.map(function(t){return c(t)})),t},outputBlockFormatter:function(t){return t.gasLimit=n.toDecimal(t.gasLimit),t.gasUsed=n.toDecimal(t.gasUsed),t.size=n.toDecimal(t.size),t.timestamp=n.toDecimal(t.timestamp),null!==t.number&&(t.number=n.toDecimal(t.number)),t.difficulty=n.toBigNumber(t.difficulty),t.totalDifficulty=n.toBigNumber(t.totalDifficulty),n.isArray(t.transactions)&&t.transactions.forEach(function(t){if(!n.isString(t))return s(t)}),t},outputLogFormatter:c,outputPostFormatter:function(t){return t.expiry=n.toDecimal(t.expiry),t.sent=n.toDecimal(t.sent),t.ttl=n.toDecimal(t.ttl),t.workProved=n.toDecimal(t.workProved),t.topics||(t.topics=[]),t.topics=t.topics.map(function(t){return n.toAscii(t)}),t},outputSyncingFormatter:function(t){return t?(t.startingBlock=n.toDecimal(t.startingBlock),t.currentBlock=n.toDecimal(t.currentBlock),t.highestBlock=n.toDecimal(t.highestBlock),t.knownStates&&(t.knownStates=n.toDecimal(t.knownStates),t.pulledStates=n.toDecimal(t.pulledStates)),t):t}}},{"../utils/config":18,"../utils/utils":20,"./iban":33}],31:[function(t,e,r){var n=t("../solidity/coder"),o=t("../utils/utils"),i=t("./errors"),a=t("./formatters"),s=t("../utils/sha3"),c=function(t,e,r){this._eth=t,this._inputTypes=e.inputs.map(function(t){return t.type}),this._outputTypes=e.outputs.map(function(t){return t.type}),this._constant=e.constant,this._payable=e.payable,this._name=o.transformToFullName(e),this._address=r};c.prototype.extractCallback=function(t){if(o.isFunction(t[t.length-1]))return t.pop()},c.prototype.extractDefaultBlock=function(t){if(t.length>this._inputTypes.length&&!o.isObject(t[t.length-1]))return a.inputDefaultBlockNumberFormatter(t.pop())},c.prototype.validateArgs=function(t){if(t.filter(function(t){return!(!0===o.isObject(t)&&!1===o.isArray(t)&&!1===o.isBigNumber(t))}).length!==this._inputTypes.length)throw i.InvalidNumberOfSolidityArgs()},c.prototype.toPayload=function(t){var e={};return t.length>this._inputTypes.length&&o.isObject(t[t.length-1])&&(e=t[t.length-1]),this.validateArgs(t),e.to=this._address,e.data="0x"+this.signature()+n.encodeParams(this._inputTypes,t),e},c.prototype.signature=function(){return s(this._name).slice(0,8)},c.prototype.unpackOutput=function(t){if(t){t=t.length>=2?t.slice(2):t;var e=n.decodeParams(this._outputTypes,t);return 1===e.length?e[0]:e}},c.prototype.call=function(){var t=Array.prototype.slice.call(arguments).filter(function(t){return void 0!==t}),e=this.extractCallback(t),r=this.extractDefaultBlock(t),n=this.toPayload(t);if(!e){var o=this._eth.call(n,r);return this.unpackOutput(o)}var i=this;this._eth.call(n,r,function(t,r){if(t)return e(t,null);var n=null;try{n=i.unpackOutput(r)}catch(e){t=e}e(t,n)})},c.prototype.sendTransaction=function(){var t=Array.prototype.slice.call(arguments).filter(function(t){return void 0!==t}),e=this.extractCallback(t),r=this.toPayload(t);if(r.value>0&&!this._payable)throw new Error("Cannot send value to non-payable function");if(!e)return this._eth.sendTransaction(r);this._eth.sendTransaction(r,e)},c.prototype.estimateGas=function(){var t=Array.prototype.slice.call(arguments),e=this.extractCallback(t),r=this.toPayload(t);if(!e)return this._eth.estimateGas(r);this._eth.estimateGas(r,e)},c.prototype.getData=function(){var t=Array.prototype.slice.call(arguments);return this.toPayload(t).data},c.prototype.displayName=function(){return o.extractDisplayName(this._name)},c.prototype.typeName=function(){return o.extractTypeName(this._name)},c.prototype.request=function(){var t=Array.prototype.slice.call(arguments),e=this.extractCallback(t),r=this.toPayload(t),n=this.unpackOutput.bind(this);return{method:this._constant?"eth_call":"eth_sendTransaction",callback:e,params:[r],format:n}},c.prototype.execute=function(){return this._constant?this.call.apply(this,Array.prototype.slice.call(arguments)):this.sendTransaction.apply(this,Array.prototype.slice.call(arguments))},c.prototype.attachToContract=function(t){var e=this.execute.bind(this);e.request=this.request.bind(this),e.call=this.call.bind(this),e.sendTransaction=this.sendTransaction.bind(this),e.estimateGas=this.estimateGas.bind(this),e.getData=this.getData.bind(this);var r=this.displayName();t[r]||(t[r]=e),t[r][this.typeName()]=e},e.exports=c},{"../solidity/coder":7,"../utils/sha3":19,"../utils/utils":20,"./errors":26,"./formatters":30}],32:[function(t,e,r){var n=t("./errors");"undefined"!=typeof window&&window.XMLHttpRequest?XMLHttpRequest=window.XMLHttpRequest:XMLHttpRequest=t("xmlhttprequest").XMLHttpRequest;var o=t("xhr2"),i=function(t,e,r,n,o){this.host=t||"http://localhost:8545",this.timeout=e||0,this.user=r,this.password=n,this.headers=o};i.prototype.prepareRequest=function(t){var e;if(t?(e=new o).timeout=this.timeout:e=new XMLHttpRequest,e.open("POST",this.host,t),this.user&&this.password){var r="Basic "+new Buffer(this.user+":"+this.password).toString("base64");e.setRequestHeader("Authorization",r)}return e.setRequestHeader("Content-Type","application/json"),this.headers&&this.headers.forEach(function(t){e.setRequestHeader(t.name,t.value)}),e},i.prototype.send=function(t){var e=this.prepareRequest(!1);try{e.send(JSON.stringify(t))}catch(t){throw n.InvalidConnection(this.host)}var r=e.responseText;try{r=JSON.parse(r)}catch(t){throw n.InvalidResponse(e.responseText)}return r},i.prototype.sendAsync=function(t,e){var r=this.prepareRequest(!0);r.onreadystatechange=function(){if(4===r.readyState&&1!==r.timeout){var t=r.responseText,o=null;try{t=JSON.parse(t)}catch(t){o=n.InvalidResponse(r.responseText)}e(o,t)}},r.ontimeout=function(){e(n.ConnectionTimeout(this.timeout))};try{r.send(JSON.stringify(t))}catch(t){e(n.InvalidConnection(this.host))}},i.prototype.isConnected=function(){try{return this.send({id:9999999999,jsonrpc:"2.0",method:"net_listening",params:[]}),!0}catch(t){return!1}},e.exports=i},{"./errors":26,xhr2:86,xmlhttprequest:17}],33:[function(t,e,r){var n=t("bignumber.js"),o=function(t,e){for(var r=t;r.length<2*e;)r="0"+r;return r},i=function(t){var e="A".charCodeAt(0),r="Z".charCodeAt(0);return(t=(t=t.toUpperCase()).substr(4)+t.substr(0,4)).split("").map(function(t){var n=t.charCodeAt(0);return n>=e&&n<=r?n-e+10:t}).join("")},a=function(t){for(var e,r=t;r.length>2;)e=r.slice(0,9),r=parseInt(e,10)%97+r.slice(e.length);return parseInt(r,10)%97},s=function(t){this._iban=t};s.fromAddress=function(t){var e=new n(t,16).toString(36),r=o(e,15);return s.fromBban(r.toUpperCase())},s.fromBban=function(t){var e=("0"+(98-a(i("XE00"+t)))).slice(-2);return new s("XE"+e+t)},s.createIndirect=function(t){return s.fromBban("ETH"+t.institution+t.identifier)},s.isValid=function(t){return new s(t).isValid()},s.prototype.isValid=function(){return/^XE[0-9]{2}(ETH[0-9A-Z]{13}|[0-9A-Z]{30,31})$/.test(this._iban)&&1===a(i(this._iban))},s.prototype.isDirect=function(){return 34===this._iban.length||35===this._iban.length},s.prototype.isIndirect=function(){return 20===this._iban.length},s.prototype.checksum=function(){return this._iban.substr(2,2)},s.prototype.institution=function(){return this.isIndirect()?this._iban.substr(7,4):""},s.prototype.client=function(){return this.isIndirect()?this._iban.substr(11):""},s.prototype.address=function(){if(this.isDirect()){var t=this._iban.substr(4),e=new n(t,36);return o(e.toString(16),20)}return""},s.prototype.toString=function(){return this._iban},e.exports=s},{"bignumber.js":"bignumber.js"}],34:[function(t,e,r){"use strict";var n=t("../utils/utils"),o=t("./errors"),i=function(t,e){var r=this;this.responseCallbacks={},this.path=t,this.connection=e.connect({path:this.path}),this.connection.on("error",function(t){console.error("IPC Connection Error",t),r._timeout()}),this.connection.on("end",function(){r._timeout()}),this.connection.on("data",function(t){r._parseResponse(t.toString()).forEach(function(t){var e=null;n.isArray(t)?t.forEach(function(t){r.responseCallbacks[t.id]&&(e=t.id)}):e=t.id,r.responseCallbacks[e]&&(r.responseCallbacks[e](null,t),delete r.responseCallbacks[e])})})};i.prototype._parseResponse=function(t){var e=this,r=[];return t.replace(/\}[\n\r]?\{/g,"}|--|{").replace(/\}\][\n\r]?\[\{/g,"}]|--|[{").replace(/\}[\n\r]?\[\{/g,"}|--|[{").replace(/\}\][\n\r]?\{/g,"}]|--|{").split("|--|").forEach(function(t){e.lastChunk&&(t=e.lastChunk+t);var n=null;try{n=JSON.parse(t)}catch(r){return e.lastChunk=t,clearTimeout(e.lastChunkTimeout),void(e.lastChunkTimeout=setTimeout(function(){throw e._timeout(),o.InvalidResponse(t)},15e3))}clearTimeout(e.lastChunkTimeout),e.lastChunk=null,n&&r.push(n)}),r},i.prototype._addResponseCallback=function(t,e){var r=t.id||t[0].id,n=t.method||t[0].method;this.responseCallbacks[r]=e,this.responseCallbacks[r].method=n},i.prototype._timeout=function(){for(var t in this.responseCallbacks)this.responseCallbacks.hasOwnProperty(t)&&(this.responseCallbacks[t](o.InvalidConnection("on IPC")),delete this.responseCallbacks[t])},i.prototype.isConnected=function(){return this.connection.writable||this.connection.connect({path:this.path}),!!this.connection.writable},i.prototype.send=function(t){if(this.connection.writeSync){var e;this.connection.writable||this.connection.connect({path:this.path});var r=this.connection.writeSync(JSON.stringify(t));try{e=JSON.parse(r)}catch(t){throw o.InvalidResponse(r)}return e}throw new Error('You tried to send "'+t.method+'" synchronously. Synchronous requests are not supported by the IPC provider.')},i.prototype.sendAsync=function(t,e){this.connection.writable||this.connection.connect({path:this.path}),this.connection.write(JSON.stringify(t)),this._addResponseCallback(t,e)},e.exports=i},{"../utils/utils":20,"./errors":26}],35:[function(t,e,r){var n={messageId:0};n.toPayload=function(t,e){return t||console.error("jsonrpc method should be specified!"),n.messageId++,{jsonrpc:"2.0",id:n.messageId,method:t,params:e||[]}},n.isValidResponse=function(t){function e(t){return!!t&&!t.error&&"2.0"===t.jsonrpc&&"number"==typeof t.id&&void 0!==t.result}return Array.isArray(t)?t.every(e):e(t)},n.toBatchPayload=function(t){return t.map(function(t){return n.toPayload(t.method,t.params)})},e.exports=n},{}],36:[function(t,e,r){var n=t("../utils/utils"),o=t("./errors"),i=function(t){this.name=t.name,this.call=t.call,this.params=t.params||0,this.inputFormatter=t.inputFormatter,this.outputFormatter=t.outputFormatter,this.requestManager=null};i.prototype.setRequestManager=function(t){this.requestManager=t},i.prototype.getCall=function(t){return n.isFunction(this.call)?this.call(t):this.call},i.prototype.extractCallback=function(t){if(n.isFunction(t[t.length-1]))return t.pop()},i.prototype.validateArgs=function(t){if(t.length!==this.params)throw o.InvalidNumberOfRPCParams()},i.prototype.formatInput=function(t){return this.inputFormatter?this.inputFormatter.map(function(e,r){return e?e(t[r]):t[r]}):t},i.prototype.formatOutput=function(t){return this.outputFormatter&&t?this.outputFormatter(t):t},i.prototype.toPayload=function(t){var e=this.getCall(t),r=this.extractCallback(t),n=this.formatInput(t);return this.validateArgs(n),{method:e,params:n,callback:r}},i.prototype.attachToObject=function(t){var e=this.buildCall();e.call=this.call;var r=this.name.split(".");r.length>1?(t[r[0]]=t[r[0]]||{},t[r[0]][r[1]]=e):t[r[0]]=e},i.prototype.buildCall=function(){var t=this,e=function(){var e=t.toPayload(Array.prototype.slice.call(arguments));return e.callback?t.requestManager.sendAsync(e,function(r,n){e.callback(r,t.formatOutput(n))}):t.formatOutput(t.requestManager.send(e))};return e.request=this.request.bind(this),e},i.prototype.request=function(){var t=this.toPayload(Array.prototype.slice.call(arguments));return t.format=this.formatOutput.bind(this),t},e.exports=i},{"../utils/utils":20,"./errors":26}],37:[function(t,e,r){var n=t("../method");e.exports=function(t){this._requestManager=t._requestManager;var e=this;[new n({name:"putString",call:"db_putString",params:3}),new n({name:"getString",call:"db_getString",params:2}),new n({name:"putHex",call:"db_putHex",params:3}),new n({name:"getHex",call:"db_getHex",params:2})].forEach(function(r){r.attachToObject(e),r.setRequestManager(t._requestManager)})}},{"../method":36}],38:[function(t,e,r){"use strict";function n(t){this._requestManager=t._requestManager;var e=this;w().forEach(function(t){t.attachToObject(e),t.setRequestManager(e._requestManager)}),x().forEach(function(t){t.attachToObject(e),t.setRequestManager(e._requestManager)}),this.iban=d,this.sendIBANTransaction=m.bind(null,this)}var o=t("../formatters"),i=t("../../utils/utils"),a=t("../method"),s=t("../property"),c=t("../../utils/config"),u=t("../contract"),f=t("./watches"),l=t("../filter"),p=t("../syncing"),h=t("../namereg"),d=t("../iban"),m=t("../transfer"),y=function(t){return i.isString(t[0])&&0===t[0].indexOf("0x")?"eth_getBlockByHash":"eth_getBlockByNumber"},g=function(t){return i.isString(t[0])&&0===t[0].indexOf("0x")?"eth_getTransactionByBlockHashAndIndex":"eth_getTransactionByBlockNumberAndIndex"},v=function(t){return i.isString(t[0])&&0===t[0].indexOf("0x")?"eth_getUncleByBlockHashAndIndex":"eth_getUncleByBlockNumberAndIndex"},b=function(t){return i.isString(t[0])&&0===t[0].indexOf("0x")?"eth_getBlockTransactionCountByHash":"eth_getBlockTransactionCountByNumber"},_=function(t){return i.isString(t[0])&&0===t[0].indexOf("0x")?"eth_getUncleCountByBlockHash":"eth_getUncleCountByBlockNumber"};Object.defineProperty(n.prototype,"defaultBlock",{get:function(){return c.defaultBlock},set:function(t){return c.defaultBlock=t,t}}),Object.defineProperty(n.prototype,"defaultAccount",{get:function(){return c.defaultAccount},set:function(t){return c.defaultAccount=t,t}});var w=function(){var t=new a({name:"getBalance",call:"eth_getBalance",params:2,inputFormatter:[o.inputAddressFormatter,o.inputDefaultBlockNumberFormatter],outputFormatter:o.outputBigNumberFormatter}),e=new a({name:"getStorageAt",call:"eth_getStorageAt",params:3,inputFormatter:[null,i.toHex,o.inputDefaultBlockNumberFormatter]}),r=new a({name:"getCode",call:"eth_getCode",params:2,inputFormatter:[o.inputAddressFormatter,o.inputDefaultBlockNumberFormatter]}),n=new a({name:"getBlock",call:y,params:2,inputFormatter:[o.inputBlockNumberFormatter,function(t){return!!t}],outputFormatter:o.outputBlockFormatter}),s=new a({name:"getUncle",call:v,params:2,inputFormatter:[o.inputBlockNumberFormatter,i.toHex],outputFormatter:o.outputBlockFormatter}),c=new a({name:"getCompilers",call:"eth_getCompilers",params:0}),u=new a({name:"getBlockTransactionCount",call:b,params:1,inputFormatter:[o.inputBlockNumberFormatter],outputFormatter:i.toDecimal}),f=new a({name:"getBlockUncleCount",call:_,params:1,inputFormatter:[o.inputBlockNumberFormatter],outputFormatter:i.toDecimal}),l=new a({name:"getTransaction",call:"eth_getTransactionByHash",params:1,outputFormatter:o.outputTransactionFormatter}),p=new a({name:"getTransactionFromBlock",call:g,params:2,inputFormatter:[o.inputBlockNumberFormatter,i.toHex],outputFormatter:o.outputTransactionFormatter}),h=new a({name:"getTransactionReceipt",call:"eth_getTransactionReceipt",params:1,outputFormatter:o.outputTransactionReceiptFormatter}),d=new a({name:"getTransactionCount",call:"eth_getTransactionCount",params:2,inputFormatter:[null,o.inputDefaultBlockNumberFormatter],outputFormatter:i.toDecimal}),m=new a({name:"sendRawTransaction",call:"eth_sendRawTransaction",params:1,inputFormatter:[null]}),w=new a({name:"sendTransaction",call:"eth_sendTransaction",params:1,inputFormatter:[o.inputTransactionFormatter]}),x=new a({name:"signTransaction",call:"eth_signTransaction",params:1,inputFormatter:[o.inputTransactionFormatter]}),k=new a({name:"sign",call:"eth_sign",params:2,inputFormatter:[o.inputAddressFormatter,null]});return[t,e,r,n,s,c,u,f,l,p,h,d,new a({name:"call",call:"eth_call",params:2,inputFormatter:[o.inputCallFormatter,o.inputDefaultBlockNumberFormatter]}),new a({name:"estimateGas",call:"eth_estimateGas",params:1,inputFormatter:[o.inputCallFormatter],outputFormatter:i.toDecimal}),m,x,w,k,new a({name:"compile.solidity",call:"eth_compileSolidity",params:1}),new a({name:"compile.lll",call:"eth_compileLLL",params:1}),new a({name:"compile.serpent",call:"eth_compileSerpent",params:1}),new a({name:"submitWork",call:"eth_submitWork",params:3}),new a({name:"getWork",call:"eth_getWork",params:0})]},x=function(){return[new s({name:"coinbase",getter:"eth_coinbase"}),new s({name:"mining",getter:"eth_mining"}),new s({name:"hashrate",getter:"eth_hashrate",outputFormatter:i.toDecimal}),new s({name:"syncing",getter:"eth_syncing",outputFormatter:o.outputSyncingFormatter}),new s({name:"gasPrice",getter:"eth_gasPrice",outputFormatter:o.outputBigNumberFormatter}),new s({name:"accounts",getter:"eth_accounts"}),new s({name:"blockNumber",getter:"eth_blockNumber",outputFormatter:i.toDecimal}),new s({name:"protocolVersion",getter:"eth_protocolVersion"})]};n.prototype.contract=function(t){return new u(this,t)},n.prototype.filter=function(t,e,r){return new l(t,"eth",this._requestManager,f.eth(),o.outputLogFormatter,e,r)},n.prototype.namereg=function(){return this.contract(h.global.abi).at(h.global.address)},n.prototype.icapNamereg=function(){return this.contract(h.icap.abi).at(h.icap.address)},n.prototype.isSyncing=function(t){return new p(this._requestManager,t)},e.exports=n},{"../../utils/config":18,"../../utils/utils":20,"../contract":25,"../filter":29,"../formatters":30,"../iban":33,"../method":36,"../namereg":44,"../property":45,"../syncing":48,"../transfer":49,"./watches":43}],39:[function(t,e,r){var n=t("../../utils/utils"),o=t("../property");e.exports=function(t){this._requestManager=t._requestManager;var e=this;[new o({name:"listening",getter:"net_listening"}),new o({name:"peerCount",getter:"net_peerCount",outputFormatter:n.toDecimal})].forEach(function(r){r.attachToObject(e),r.setRequestManager(t._requestManager)})}},{"../../utils/utils":20,"../property":45}],40:[function(t,e,r){"use strict";var n=t("../method"),o=t("../property"),i=t("../formatters");e.exports=function(t){this._requestManager=t._requestManager;var e=this;(function(){var t=new n({name:"newAccount",call:"personal_newAccount",params:1,inputFormatter:[null]}),e=new n({name:"importRawKey",call:"personal_importRawKey",params:2}),r=new n({name:"sign",call:"personal_sign",params:3,inputFormatter:[null,i.inputAddressFormatter,null]}),o=new n({name:"ecRecover",call:"personal_ecRecover",params:2});return[t,e,new n({name:"unlockAccount",call:"personal_unlockAccount",params:3,inputFormatter:[i.inputAddressFormatter,null,null]}),o,r,new n({name:"sendTransaction",call:"personal_sendTransaction",params:2,inputFormatter:[i.inputTransactionFormatter,null]}),new n({name:"lockAccount",call:"personal_lockAccount",params:1,inputFormatter:[i.inputAddressFormatter]})]})().forEach(function(t){t.attachToObject(e),t.setRequestManager(e._requestManager)}),[new o({name:"listAccounts",getter:"personal_listAccounts"})].forEach(function(t){t.attachToObject(e),t.setRequestManager(e._requestManager)})}},{"../formatters":30,"../method":36,"../property":45}],41:[function(t,e,r){var n=t("../method"),o=t("../filter"),i=t("./watches"),a=function(t){this._requestManager=t._requestManager;var e=this;s().forEach(function(t){t.attachToObject(e),t.setRequestManager(e._requestManager)})};a.prototype.newMessageFilter=function(t,e,r){return new o(t,"shh",this._requestManager,i.shh(),null,e,r)};var s=function(){return[new n({name:"version",call:"shh_version",params:0}),new n({name:"info",call:"shh_info",params:0}),new n({name:"setMaxMessageSize",call:"shh_setMaxMessageSize",params:1}),new n({name:"setMinPoW",call:"shh_setMinPoW",params:1}),new n({name:"markTrustedPeer",call:"shh_markTrustedPeer",params:1}),new n({name:"newKeyPair",call:"shh_newKeyPair",params:0}),new n({name:"addPrivateKey",call:"shh_addPrivateKey",params:1}),new n({name:"deleteKeyPair",call:"shh_deleteKeyPair",params:1}),new n({name:"hasKeyPair",call:"shh_hasKeyPair",params:1}),new n({name:"getPublicKey",call:"shh_getPublicKey",params:1}),new n({name:"getPrivateKey",call:"shh_getPrivateKey",params:1}),new n({name:"newSymKey",call:"shh_newSymKey",params:0}),new n({name:"addSymKey",call:"shh_addSymKey",params:1}),new n({name:"generateSymKeyFromPassword",call:"shh_generateSymKeyFromPassword",params:1}),new n({name:"hasSymKey",call:"shh_hasSymKey",params:1}),new n({name:"getSymKey",call:"shh_getSymKey",params:1}),new n({name:"deleteSymKey",call:"shh_deleteSymKey",params:1}),new n({name:"post",call:"shh_post",params:1,inputFormatter:[null]})]};e.exports=a},{"../filter":29,"../method":36,"./watches":43}],42:[function(t,e,r){"use strict";var n=t("../method"),o=t("../property");e.exports=function(t){this._requestManager=t._requestManager;var e=this;[new n({name:"blockNetworkRead",call:"bzz_blockNetworkRead",params:1,inputFormatter:[null]}),new n({name:"syncEnabled",call:"bzz_syncEnabled",params:1,inputFormatter:[null]}),new n({name:"swapEnabled",call:"bzz_swapEnabled",params:1,inputFormatter:[null]}),new n({name:"download",call:"bzz_download",params:2,inputFormatter:[null,null]}),new n({name:"upload",call:"bzz_upload",params:2,inputFormatter:[null,null]}),new n({name:"retrieve",call:"bzz_retrieve",params:1,inputFormatter:[null]}),new n({name:"store",call:"bzz_store",params:2,inputFormatter:[null,null]}),new n({name:"get",call:"bzz_get",params:1,inputFormatter:[null]}),new n({name:"put",call:"bzz_put",params:2,inputFormatter:[null,null]}),new n({name:"modify",call:"bzz_modify",params:4,inputFormatter:[null,null,null,null]})].forEach(function(t){t.attachToObject(e),t.setRequestManager(e._requestManager)}),[new o({name:"hive",getter:"bzz_hive"}),new o({name:"info",getter:"bzz_info"})].forEach(function(t){t.attachToObject(e),t.setRequestManager(e._requestManager)})}},{"../method":36,"../property":45}],43:[function(t,e,r){var n=t("../method");e.exports={eth:function(){return[new n({name:"newFilter",call:function(t){switch(t[0]){case"latest":return t.shift(),this.params=0,"eth_newBlockFilter";case"pending":return t.shift(),this.params=0,"eth_newPendingTransactionFilter";default:return"eth_newFilter"}},params:1}),new n({name:"uninstallFilter",call:"eth_uninstallFilter",params:1}),new n({name:"getLogs",call:"eth_getFilterLogs",params:1}),new n({name:"poll",call:"eth_getFilterChanges",params:1})]},shh:function(){return[new n({name:"newFilter",call:"shh_newMessageFilter",params:1}),new n({name:"uninstallFilter",call:"shh_deleteMessageFilter",params:1}),new n({name:"getLogs",call:"shh_getFilterMessages",params:1}),new n({name:"poll",call:"shh_getFilterMessages",params:1})]}}},{"../method":36}],44:[function(t,e,r){var n=t("../contracts/GlobalRegistrar.json"),o=t("../contracts/ICAPRegistrar.json");e.exports={global:{abi:n,address:"0xc6d9d2cd449a754c494264e1809c50e34d64562b"},icap:{abi:o,address:"0xa1a111bc074c9cfa781f0c38e63bd51c91b8af00"}}},{"../contracts/GlobalRegistrar.json":1,"../contracts/ICAPRegistrar.json":2}],45:[function(t,e,r){var n=t("../utils/utils"),o=function(t){this.name=t.name,this.getter=t.getter,this.setter=t.setter,this.outputFormatter=t.outputFormatter,this.inputFormatter=t.inputFormatter,this.requestManager=null};o.prototype.setRequestManager=function(t){this.requestManager=t},o.prototype.formatInput=function(t){return this.inputFormatter?this.inputFormatter(t):t},o.prototype.formatOutput=function(t){return this.outputFormatter&&null!==t&&void 0!==t?this.outputFormatter(t):t},o.prototype.extractCallback=function(t){if(n.isFunction(t[t.length-1]))return t.pop()},o.prototype.attachToObject=function(t){var e={get:this.buildGet(),enumerable:!0},r=this.name.split("."),n=r[0];r.length>1&&(t[r[0]]=t[r[0]]||{},t=t[r[0]],n=r[1]),Object.defineProperty(t,n,e),t[i(n)]=this.buildAsyncGet()};var i=function(t){return"get"+t.charAt(0).toUpperCase()+t.slice(1)};o.prototype.buildGet=function(){var t=this;return function(){return t.formatOutput(t.requestManager.send({method:t.getter}))}},o.prototype.buildAsyncGet=function(){var t=this,e=function(e){t.requestManager.sendAsync({method:t.getter},function(r,n){e(r,t.formatOutput(n))})};return e.request=this.request.bind(this),e},o.prototype.request=function(){var t={method:this.getter,params:[],callback:this.extractCallback(Array.prototype.slice.call(arguments))};return t.format=this.formatOutput.bind(this),t},e.exports=o},{"../utils/utils":20}],46:[function(t,e,r){var n=t("./jsonrpc"),o=t("../utils/utils"),i=t("../utils/config"),a=t("./errors"),s=function(t){this.provider=t,this.polls={},this.timeout=null};s.prototype.send=function(t){if(!this.provider)return console.error(a.InvalidProvider()),null;var e=n.toPayload(t.method,t.params),r=this.provider.send(e);if(!n.isValidResponse(r))throw a.InvalidResponse(r);return r.result},s.prototype.sendAsync=function(t,e){if(!this.provider)return e(a.InvalidProvider());var r=n.toPayload(t.method,t.params);this.provider.sendAsync(r,function(t,r){return t?e(t):n.isValidResponse(r)?void e(null,r.result):e(a.InvalidResponse(r))})},s.prototype.sendBatch=function(t,e){if(!this.provider)return e(a.InvalidProvider());var r=n.toBatchPayload(t);this.provider.sendAsync(r,function(t,r){return t?e(t):o.isArray(r)?void e(t,r):e(a.InvalidResponse(r))})},s.prototype.setProvider=function(t){this.provider=t},s.prototype.startPolling=function(t,e,r,n){this.polls[e]={data:t,id:e,callback:r,uninstall:n},this.timeout||this.poll()},s.prototype.stopPolling=function(t){delete this.polls[t],0===Object.keys(this.polls).length&&this.timeout&&(clearTimeout(this.timeout),this.timeout=null)},s.prototype.reset=function(t){for(var e in this.polls)t&&-1!==e.indexOf("syncPoll_")||(this.polls[e].uninstall(),delete this.polls[e]);0===Object.keys(this.polls).length&&this.timeout&&(clearTimeout(this.timeout),this.timeout=null)},s.prototype.poll=function(){if(this.timeout=setTimeout(this.poll.bind(this),i.ETH_POLLING_TIMEOUT),0!==Object.keys(this.polls).length)if(this.provider){var t=[],e=[];for(var r in this.polls)t.push(this.polls[r].data),e.push(r);if(0!==t.length){var s=n.toBatchPayload(t),c={};s.forEach(function(t,r){c[t.id]=e[r]});var u=this;this.provider.sendAsync(s,function(t,e){if(!t){if(!o.isArray(e))throw a.InvalidResponse(e);e.map(function(t){var e=c[t.id];return!!u.polls[e]&&(t.callback=u.polls[e].callback,t)}).filter(function(t){return!!t}).filter(function(t){var e=n.isValidResponse(t);return e||t.callback(a.InvalidResponse(t)),e}).forEach(function(t){t.callback(null,t.result)})}})}}else console.error(a.InvalidProvider())},e.exports=s},{"../utils/config":18,"../utils/utils":20,"./errors":26,"./jsonrpc":35}],47:[function(t,e,r){e.exports=function(){this.defaultBlock="latest",this.defaultAccount=void 0}},{}],48:[function(t,e,r){var n=t("./formatters"),o=t("../utils/utils"),i=1,a=function(t,e){return this.requestManager=t,this.pollId="syncPoll_"+i++,this.callbacks=[],this.addCallback(e),this.lastSyncState=!1,(r=this).requestManager.startPolling({method:"eth_syncing",params:[]},r.pollId,function(t,e){if(t)return r.callbacks.forEach(function(e){e(t)});o.isObject(e)&&e.startingBlock&&(e=n.outputSyncingFormatter(e)),r.callbacks.forEach(function(t){r.lastSyncState!==e&&(!r.lastSyncState&&o.isObject(e)&&t(null,!0),setTimeout(function(){t(null,e)},0),r.lastSyncState=e)})},r.stopWatching.bind(r)),this;var r};a.prototype.addCallback=function(t){return t&&this.callbacks.push(t),this},a.prototype.stopWatching=function(){this.requestManager.stopPolling(this.pollId),this.callbacks=[]},e.exports=a},{"../utils/utils":20,"./formatters":30}],49:[function(t,e,r){var n=t("./iban"),o=t("../contracts/SmartExchange.json"),i=function(t,e,r,n,i,a){var s=o;return t.contract(s).at(r).deposit(i,{from:e,value:n},a)};e.exports=function(t,e,r,o,a){var s=new n(r);if(!s.isValid())throw new Error("invalid iban address");if(s.isDirect())return c=t,u=e,f=s.address(),l=o,p=a,c.sendTransaction({address:f,from:u,value:l},p);var c,u,f,l,p;if(!a){var h=t.icapNamereg().addr(s.institution());return i(t,e,h,o,s.client())}t.icapNamereg().addr(s.institution(),function(r,n){return i(t,e,n,o,s.client(),a)})}},{"../contracts/SmartExchange.json":3,"./iban":33}],50:[function(t,e,r){},{}],51:[function(t,e,r){n=this,o=function(t){return function(){var e=t,r=e.lib.BlockCipher,n=e.algo,o=[],i=[],a=[],s=[],c=[],u=[],f=[],l=[],p=[],h=[];!function(){for(var t=[],e=0;e<256;e++)t[e]=e<128?e<<1:e<<1^283;var r=0,n=0;for(e=0;e<256;e++){var d=n^n<<1^n<<2^n<<3^n<<4;d=d>>>8^255&d^99,o[r]=d,i[d]=r;var m=t[r],y=t[m],g=t[y],v=257*t[d]^16843008*d;a[r]=v<<24|v>>>8,s[r]=v<<16|v>>>16,c[r]=v<<8|v>>>24,u[r]=v,v=16843009*g^65537*y^257*m^16843008*r,f[d]=v<<24|v>>>8,l[d]=v<<16|v>>>16,p[d]=v<<8|v>>>24,h[d]=v,r?(r=m^t[t[t[g^m]]],n^=t[t[n]]):r=n=1}}();var d=[0,1,2,4,8,16,32,64,128,27,54],m=n.AES=r.extend({_doReset:function(){if(!this._nRounds||this._keyPriorReset!==this._key){for(var t=this._keyPriorReset=this._key,e=t.words,r=t.sigBytes/4,n=4*((this._nRounds=r+6)+1),i=this._keySchedule=[],a=0;a<n;a++)if(a<r)i[a]=e[a];else{var s=i[a-1];a%r?r>6&&a%r==4&&(s=o[s>>>24]<<24|o[s>>>16&255]<<16|o[s>>>8&255]<<8|o[255&s]):(s=o[(s=s<<8|s>>>24)>>>24]<<24|o[s>>>16&255]<<16|o[s>>>8&255]<<8|o[255&s],s^=d[a/r|0]<<24),i[a]=i[a-r]^s}for(var c=this._invKeySchedule=[],u=0;u<n;u++)a=n-u,s=u%4?i[a]:i[a-4],c[u]=u<4||a<=4?s:f[o[s>>>24]]^l[o[s>>>16&255]]^p[o[s>>>8&255]]^h[o[255&s]]}},encryptBlock:function(t,e){this._doCryptBlock(t,e,this._keySchedule,a,s,c,u,o)},decryptBlock:function(t,e){var r=t[e+1];t[e+1]=t[e+3],t[e+3]=r,this._doCryptBlock(t,e,this._invKeySchedule,f,l,p,h,i),r=t[e+1],t[e+1]=t[e+3],t[e+3]=r},_doCryptBlock:function(t,e,r,n,o,i,a,s){for(var c=this._nRounds,u=t[e]^r[0],f=t[e+1]^r[1],l=t[e+2]^r[2],p=t[e+3]^r[3],h=4,d=1;d<c;d++){var m=n[u>>>24]^o[f>>>16&255]^i[l>>>8&255]^a[255&p]^r[h++],y=n[f>>>24]^o[l>>>16&255]^i[p>>>8&255]^a[255&u]^r[h++],g=n[l>>>24]^o[p>>>16&255]^i[u>>>8&255]^a[255&f]^r[h++],v=n[p>>>24]^o[u>>>16&255]^i[f>>>8&255]^a[255&l]^r[h++];u=m,f=y,l=g,p=v}m=(s[u>>>24]<<24|s[f>>>16&255]<<16|s[l>>>8&255]<<8|s[255&p])^r[h++],y=(s[f>>>24]<<24|s[l>>>16&255]<<16|s[p>>>8&255]<<8|s[255&u])^r[h++],g=(s[l>>>24]<<24|s[p>>>16&255]<<16|s[u>>>8&255]<<8|s[255&f])^r[h++],v=(s[p>>>24]<<24|s[u>>>16&255]<<16|s[f>>>8&255]<<8|s[255&l])^r[h++],t[e]=m,t[e+1]=y,t[e+2]=g,t[e+3]=v},keySize:8});e.AES=r._createHelper(m)}(),t.AES},"object"==typeof r?e.exports=r=o(t("./core"),t("./enc-base64"),t("./md5"),t("./evpkdf"),t("./cipher-core")):"function"==typeof define&&define.amd?define(["./core","./enc-base64","./md5","./evpkdf","./cipher-core"],o):o(n.CryptoJS);var n,o},{"./cipher-core":52,"./core":53,"./enc-base64":54,"./evpkdf":56,"./md5":61}],52:[function(t,e,r){n=this,o=function(t){t.lib.Cipher||function(e){var r=t,n=r.lib,o=n.Base,i=n.WordArray,a=n.BufferedBlockAlgorithm,s=r.enc,c=(s.Utf8,s.Base64),u=r.algo.EvpKDF,f=n.Cipher=a.extend({cfg:o.extend(),createEncryptor:function(t,e){return this.create(this._ENC_XFORM_MODE,t,e)},createDecryptor:function(t,e){return this.create(this._DEC_XFORM_MODE,t,e)},init:function(t,e,r){this.cfg=this.cfg.extend(r),this._xformMode=t,this._key=e,this.reset()},reset:function(){a.reset.call(this),this._doReset()},process:function(t){return this._append(t),this._process()},finalize:function(t){return t&&this._append(t),this._doFinalize()},keySize:4,ivSize:4,_ENC_XFORM_MODE:1,_DEC_XFORM_MODE:2,_createHelper:function(){function t(t){return"string"==typeof t?b:g}return function(e){return{encrypt:function(r,n,o){return t(n).encrypt(e,r,n,o)},decrypt:function(r,n,o){return t(n).decrypt(e,r,n,o)}}}}()}),l=(n.StreamCipher=f.extend({_doFinalize:function(){return this._process(!0)},blockSize:1}),r.mode={}),p=n.BlockCipherMode=o.extend({createEncryptor:function(t,e){return this.Encryptor.create(t,e)},createDecryptor:function(t,e){return this.Decryptor.create(t,e)},init:function(t,e){this._cipher=t,this._iv=e}}),h=l.CBC=function(){function t(t,r,n){var o=this._iv;if(o){var i=o;this._iv=e}else i=this._prevBlock;for(var a=0;a<n;a++)t[r+a]^=i[a]}var r=p.extend();return r.Encryptor=r.extend({processBlock:function(e,r){var n=this._cipher,o=n.blockSize;t.call(this,e,r,o),n.encryptBlock(e,r),this._prevBlock=e.slice(r,r+o)}}),r.Decryptor=r.extend({processBlock:function(e,r){var n=this._cipher,o=n.blockSize,i=e.slice(r,r+o);n.decryptBlock(e,r),t.call(this,e,r,o),this._prevBlock=i}}),r}(),d=(r.pad={}).Pkcs7={pad:function(t,e){for(var r=4*e,n=r-t.sigBytes%r,o=n<<24|n<<16|n<<8|n,a=[],s=0;s<n;s+=4)a.push(o);var c=i.create(a,n);t.concat(c)},unpad:function(t){var e=255&t.words[t.sigBytes-1>>>2];t.sigBytes-=e}},m=(n.BlockCipher=f.extend({cfg:f.cfg.extend({mode:h,padding:d}),reset:function(){f.reset.call(this);var t=this.cfg,e=t.iv,r=t.mode;if(this._xformMode==this._ENC_XFORM_MODE)var n=r.createEncryptor;else n=r.createDecryptor,this._minBufferSize=1;this._mode=n.call(r,this,e&&e.words)},_doProcessBlock:function(t,e){this._mode.processBlock(t,e)},_doFinalize:function(){var t=this.cfg.padding;if(this._xformMode==this._ENC_XFORM_MODE){t.pad(this._data,this.blockSize);var e=this._process(!0)}else e=this._process(!0),t.unpad(e);return e},blockSize:4}),n.CipherParams=o.extend({init:function(t){this.mixIn(t)},toString:function(t){return(t||this.formatter).stringify(this)}})),y=(r.format={}).OpenSSL={stringify:function(t){var e=t.ciphertext,r=t.salt;if(r)var n=i.create([1398893684,1701076831]).concat(r).concat(e);else n=e;return n.toString(c)},parse:function(t){var e=c.parse(t),r=e.words;if(1398893684==r[0]&&1701076831==r[1]){var n=i.create(r.slice(2,4));r.splice(0,4),e.sigBytes-=16}return m.create({ciphertext:e,salt:n})}},g=n.SerializableCipher=o.extend({cfg:o.extend({format:y}),encrypt:function(t,e,r,n){n=this.cfg.extend(n);var o=t.createEncryptor(r,n),i=o.finalize(e),a=o.cfg;return m.create({ciphertext:i,key:r,iv:a.iv,algorithm:t,mode:a.mode,padding:a.padding,blockSize:t.blockSize,formatter:n.format})},decrypt:function(t,e,r,n){return n=this.cfg.extend(n),e=this._parse(e,n.format),t.createDecryptor(r,n).finalize(e.ciphertext)},_parse:function(t,e){return"string"==typeof t?e.parse(t,this):t}}),v=(r.kdf={}).OpenSSL={execute:function(t,e,r,n){n||(n=i.random(8));var o=u.create({keySize:e+r}).compute(t,n),a=i.create(o.words.slice(e),4*r);return o.sigBytes=4*e,m.create({key:o,iv:a,salt:n})}},b=n.PasswordBasedCipher=g.extend({cfg:g.cfg.extend({kdf:v}),encrypt:function(t,e,r,n){var o=(n=this.cfg.extend(n)).kdf.execute(r,t.keySize,t.ivSize);n.iv=o.iv;var i=g.encrypt.call(this,t,e,o.key,n);return i.mixIn(o),i},decrypt:function(t,e,r,n){n=this.cfg.extend(n),e=this._parse(e,n.format);var o=n.kdf.execute(r,t.keySize,t.ivSize,e.salt);return n.iv=o.iv,g.decrypt.call(this,t,e,o.key,n)}})}()},"object"==typeof r?e.exports=r=o(t("./core")):"function"==typeof define&&define.amd?define(["./core"],o):o(n.CryptoJS);var n,o},{"./core":53}],53:[function(t,e,r){n=this,o=function(){var t=t||function(t,e){var r=Object.create||function(){function t(){}return function(e){var r;return t.prototype=e,r=new t,t.prototype=null,r}}(),n={},o=n.lib={},i=o.Base={extend:function(t){var e=r(this);return t&&e.mixIn(t),e.hasOwnProperty("init")&&this.init!==e.init||(e.init=function(){e.$super.init.apply(this,arguments)}),e.init.prototype=e,e.$super=this,e},create:function(){var t=this.extend();return t.init.apply(t,arguments),t},init:function(){},mixIn:function(t){for(var e in t)t.hasOwnProperty(e)&&(this[e]=t[e]);t.hasOwnProperty("toString")&&(this.toString=t.toString)},clone:function(){return this.init.prototype.extend(this)}},a=o.WordArray=i.extend({init:function(t,e){t=this.words=t||[],this.sigBytes=void 0!=e?e:4*t.length},toString:function(t){return(t||c).stringify(this)},concat:function(t){var e=this.words,r=t.words,n=this.sigBytes,o=t.sigBytes;if(this.clamp(),n%4)for(var i=0;i<o;i++){var a=r[i>>>2]>>>24-i%4*8&255;e[n+i>>>2]|=a<<24-(n+i)%4*8}else for(i=0;i<o;i+=4)e[n+i>>>2]=r[i>>>2];return this.sigBytes+=o,this},clamp:function(){var e=this.words,r=this.sigBytes;e[r>>>2]&=4294967295<<32-r%4*8,e.length=t.ceil(r/4)},clone:function(){var t=i.clone.call(this);return t.words=this.words.slice(0),t},random:function(e){for(var r,n=[],o=function(e){e=e;var r=987654321;return function(){var n=((r=36969*(65535&r)+(r>>16)&4294967295)<<16)+(e=18e3*(65535&e)+(e>>16)&4294967295)&4294967295;return n/=4294967296,(n+=.5)*(t.random()>.5?1:-1)}},i=0;i<e;i+=4){var s=o(4294967296*(r||t.random()));r=987654071*s(),n.push(4294967296*s()|0)}return new a.init(n,e)}}),s=n.enc={},c=s.Hex={stringify:function(t){for(var e=t.words,r=t.sigBytes,n=[],o=0;o<r;o++){var i=e[o>>>2]>>>24-o%4*8&255;n.push((i>>>4).toString(16)),n.push((15&i).toString(16))}return n.join("")},parse:function(t){for(var e=t.length,r=[],n=0;n<e;n+=2)r[n>>>3]|=parseInt(t.substr(n,2),16)<<24-n%8*4;return new a.init(r,e/2)}},u=s.Latin1={stringify:function(t){for(var e=t.words,r=t.sigBytes,n=[],o=0;o<r;o++){var i=e[o>>>2]>>>24-o%4*8&255;n.push(String.fromCharCode(i))}return n.join("")},parse:function(t){for(var e=t.length,r=[],n=0;n<e;n++)r[n>>>2]|=(255&t.charCodeAt(n))<<24-n%4*8;return new a.init(r,e)}},f=s.Utf8={stringify:function(t){try{return decodeURIComponent(escape(u.stringify(t)))}catch(t){throw new Error("Malformed UTF-8 data")}},parse:function(t){return u.parse(unescape(encodeURIComponent(t)))}},l=o.BufferedBlockAlgorithm=i.extend({reset:function(){this._data=new a.init,this._nDataBytes=0},_append:function(t){"string"==typeof t&&(t=f.parse(t)),this._data.concat(t),this._nDataBytes+=t.sigBytes},_process:function(e){var r=this._data,n=r.words,o=r.sigBytes,i=this.blockSize,s=o/(4*i),c=(s=e?t.ceil(s):t.max((0|s)-this._minBufferSize,0))*i,u=t.min(4*c,o);if(c){for(var f=0;f<c;f+=i)this._doProcessBlock(n,f);var l=n.splice(0,c);r.sigBytes-=u}return new a.init(l,u)},clone:function(){var t=i.clone.call(this);return t._data=this._data.clone(),t},_minBufferSize:0}),p=(o.Hasher=l.extend({cfg:i.extend(),init:function(t){this.cfg=this.cfg.extend(t),this.reset()},reset:function(){l.reset.call(this),this._doReset()},update:function(t){return this._append(t),this._process(),this},finalize:function(t){return t&&this._append(t),this._doFinalize()},blockSize:16,_createHelper:function(t){return function(e,r){return new t.init(r).finalize(e)}},_createHmacHelper:function(t){return function(e,r){return new p.HMAC.init(t,r).finalize(e)}}}),n.algo={});return n}(Math);return t},"object"==typeof r?e.exports=r=o():"function"==typeof define&&define.amd?define([],o):n.CryptoJS=o();var n,o},{}],54:[function(t,e,r){n=this,o=function(t){return function(){var e=t,r=e.lib.WordArray;e.enc.Base64={stringify:function(t){var e=t.words,r=t.sigBytes,n=this._map;t.clamp();for(var o=[],i=0;i<r;i+=3)for(var a=(e[i>>>2]>>>24-i%4*8&255)<<16|(e[i+1>>>2]>>>24-(i+1)%4*8&255)<<8|e[i+2>>>2]>>>24-(i+2)%4*8&255,s=0;s<4&&i+.75*s<r;s++)o.push(n.charAt(a>>>6*(3-s)&63));var c=n.charAt(64);if(c)for(;o.length%4;)o.push(c);return o.join("")},parse:function(t){var e=t.length,n=this._map,o=this._reverseMap;if(!o){o=this._reverseMap=[];for(var i=0;i<n.length;i++)o[n.charCodeAt(i)]=i}var a=n.charAt(64);if(a){var s=t.indexOf(a);-1!==s&&(e=s)}return function(t,e,n){for(var o=[],i=0,a=0;a<e;a++)if(a%4){var s=n[t.charCodeAt(a-1)]<<a%4*2,c=n[t.charCodeAt(a)]>>>6-a%4*2;o[i>>>2]|=(s|c)<<24-i%4*8,i++}return r.create(o,i)}(t,e,o)},_map:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="}}(),t.enc.Base64},"object"==typeof r?e.exports=r=o(t("./core")):"function"==typeof define&&define.amd?define(["./core"],o):o(n.CryptoJS);var n,o},{"./core":53}],55:[function(t,e,r){n=this,o=function(t){return function(){function e(t){return t<<8&4278255360|t>>>8&16711935}var r=t,n=r.lib.WordArray,o=r.enc;o.Utf16=o.Utf16BE={stringify:function(t){for(var e=t.words,r=t.sigBytes,n=[],o=0;o<r;o+=2){var i=e[o>>>2]>>>16-o%4*8&65535;n.push(String.fromCharCode(i))}return n.join("")},parse:function(t){for(var e=t.length,r=[],o=0;o<e;o++)r[o>>>1]|=t.charCodeAt(o)<<16-o%2*16;return n.create(r,2*e)}},o.Utf16LE={stringify:function(t){for(var r=t.words,n=t.sigBytes,o=[],i=0;i<n;i+=2){var a=e(r[i>>>2]>>>16-i%4*8&65535);o.push(String.fromCharCode(a))}return o.join("")},parse:function(t){for(var r=t.length,o=[],i=0;i<r;i++)o[i>>>1]|=e(t.charCodeAt(i)<<16-i%2*16);return n.create(o,2*r)}}}(),t.enc.Utf16},"object"==typeof r?e.exports=r=o(t("./core")):"function"==typeof define&&define.amd?define(["./core"],o):o(n.CryptoJS);var n,o},{"./core":53}],56:[function(t,e,r){n=this,o=function(t){return function(){var e=t,r=e.lib,n=r.Base,o=r.WordArray,i=e.algo,a=i.MD5,s=i.EvpKDF=n.extend({cfg:n.extend({keySize:4,hasher:a,iterations:1}),init:function(t){this.cfg=this.cfg.extend(t)},compute:function(t,e){for(var r=this.cfg,n=r.hasher.create(),i=o.create(),a=i.words,s=r.keySize,c=r.iterations;a.length<s;){u&&n.update(u);var u=n.update(t).finalize(e);n.reset();for(var f=1;f<c;f++)u=n.finalize(u),n.reset();i.concat(u)}return i.sigBytes=4*s,i}});e.EvpKDF=function(t,e,r){return s.create(r).compute(t,e)}}(),t.EvpKDF},"object"==typeof r?e.exports=r=o(t("./core"),t("./sha1"),t("./hmac")):"function"==typeof define&&define.amd?define(["./core","./sha1","./hmac"],o):o(n.CryptoJS);var n,o},{"./core":53,"./hmac":58,"./sha1":77}],57:[function(t,e,r){n=this,o=function(t){return function(e){var r=t,n=r.lib.CipherParams,o=r.enc.Hex;r.format.Hex={stringify:function(t){return t.ciphertext.toString(o)},parse:function(t){var e=o.parse(t);return n.create({ciphertext:e})}}}(),t.format.Hex},"object"==typeof r?e.exports=r=o(t("./core"),t("./cipher-core")):"function"==typeof define&&define.amd?define(["./core","./cipher-core"],o):o(n.CryptoJS);var n,o},{"./cipher-core":52,"./core":53}],58:[function(t,e,r){n=this,o=function(t){!function(){var e=t,r=e.lib.Base,n=e.enc.Utf8;e.algo.HMAC=r.extend({init:function(t,e){t=this._hasher=new t.init,"string"==typeof e&&(e=n.parse(e));var r=t.blockSize,o=4*r;e.sigBytes>o&&(e=t.finalize(e)),e.clamp();for(var i=this._oKey=e.clone(),a=this._iKey=e.clone(),s=i.words,c=a.words,u=0;u<r;u++)s[u]^=1549556828,c[u]^=909522486;i.sigBytes=a.sigBytes=o,this.reset()},reset:function(){var t=this._hasher;t.reset(),t.update(this._iKey)},update:function(t){return this._hasher.update(t),this},finalize:function(t){var e=this._hasher,r=e.finalize(t);return e.reset(),e.finalize(this._oKey.clone().concat(r))}})}()},"object"==typeof r?e.exports=r=o(t("./core")):"function"==typeof define&&define.amd?define(["./core"],o):o(n.CryptoJS);var n,o},{"./core":53}],59:[function(t,e,r){n=this,o=function(t){return t},"object"==typeof r?e.exports=r=o(t("./core"),t("./x64-core"),t("./lib-typedarrays"),t("./enc-utf16"),t("./enc-base64"),t("./md5"),t("./sha1"),t("./sha256"),t("./sha224"),t("./sha512"),t("./sha384"),t("./sha3"),t("./ripemd160"),t("./hmac"),t("./pbkdf2"),t("./evpkdf"),t("./cipher-core"),t("./mode-cfb"),t("./mode-ctr"),t("./mode-ctr-gladman"),t("./mode-ofb"),t("./mode-ecb"),t("./pad-ansix923"),t("./pad-iso10126"),t("./pad-iso97971"),t("./pad-zeropadding"),t("./pad-nopadding"),t("./format-hex"),t("./aes"),t("./tripledes"),t("./rc4"),t("./rabbit"),t("./rabbit-legacy")):"function"==typeof define&&define.amd?define(["./core","./x64-core","./lib-typedarrays","./enc-utf16","./enc-base64","./md5","./sha1","./sha256","./sha224","./sha512","./sha384","./sha3","./ripemd160","./hmac","./pbkdf2","./evpkdf","./cipher-core","./mode-cfb","./mode-ctr","./mode-ctr-gladman","./mode-ofb","./mode-ecb","./pad-ansix923","./pad-iso10126","./pad-iso97971","./pad-zeropadding","./pad-nopadding","./format-hex","./aes","./tripledes","./rc4","./rabbit","./rabbit-legacy"],o):n.CryptoJS=o(n.CryptoJS);var n,o},{"./aes":51,"./cipher-core":52,"./core":53,"./enc-base64":54,"./enc-utf16":55,"./evpkdf":56,"./format-hex":57,"./hmac":58,"./lib-typedarrays":60,"./md5":61,"./mode-cfb":62,"./mode-ctr":64,"./mode-ctr-gladman":63,"./mode-ecb":65,"./mode-ofb":66,"./pad-ansix923":67,"./pad-iso10126":68,"./pad-iso97971":69,"./pad-nopadding":70,"./pad-zeropadding":71,"./pbkdf2":72,"./rabbit":74,"./rabbit-legacy":73,"./rc4":75,"./ripemd160":76,"./sha1":77,"./sha224":78,"./sha256":79,"./sha3":80,"./sha384":81,"./sha512":82,"./tripledes":83,"./x64-core":84}],60:[function(t,e,r){n=this,o=function(t){return function(){if("function"==typeof ArrayBuffer){var e=t.lib.WordArray,r=e.init;(e.init=function(t){if(t instanceof ArrayBuffer&&(t=new Uint8Array(t)),(t instanceof Int8Array||"undefined"!=typeof Uint8ClampedArray&&t instanceof Uint8ClampedArray||t instanceof Int16Array||t instanceof Uint16Array||t instanceof Int32Array||t instanceof Uint32Array||t instanceof Float32Array||t instanceof Float64Array)&&(t=new Uint8Array(t.buffer,t.byteOffset,t.byteLength)),t instanceof Uint8Array){for(var e=t.byteLength,n=[],o=0;o<e;o++)n[o>>>2]|=t[o]<<24-o%4*8;r.call(this,n,e)}else r.apply(this,arguments)}).prototype=e}}(),t.lib.WordArray},"object"==typeof r?e.exports=r=o(t("./core")):"function"==typeof define&&define.amd?define(["./core"],o):o(n.CryptoJS);var n,o},{"./core":53}],61:[function(t,e,r){n=this,o=function(t){return function(e){function r(t,e,r,n,o,i,a){var s=t+(e&r|~e&n)+o+a;return(s<<i|s>>>32-i)+e}function n(t,e,r,n,o,i,a){var s=t+(e&n|r&~n)+o+a;return(s<<i|s>>>32-i)+e}function o(t,e,r,n,o,i,a){var s=t+(e^r^n)+o+a;return(s<<i|s>>>32-i)+e}function i(t,e,r,n,o,i,a){var s=t+(r^(e|~n))+o+a;return(s<<i|s>>>32-i)+e}var a=t,s=a.lib,c=s.WordArray,u=s.Hasher,f=a.algo,l=[];!function(){for(var t=0;t<64;t++)l[t]=4294967296*e.abs(e.sin(t+1))|0}();var p=f.MD5=u.extend({_doReset:function(){this._hash=new c.init([1732584193,4023233417,2562383102,271733878])},_doProcessBlock:function(t,e){for(var a=0;a<16;a++){var s=e+a,c=t[s];t[s]=16711935&(c<<8|c>>>24)|4278255360&(c<<24|c>>>8)}var u=this._hash.words,f=t[e+0],p=t[e+1],h=t[e+2],d=t[e+3],m=t[e+4],y=t[e+5],g=t[e+6],v=t[e+7],b=t[e+8],_=t[e+9],w=t[e+10],x=t[e+11],k=t[e+12],B=t[e+13],S=t[e+14],A=t[e+15],C=u[0],F=u[1],O=u[2],N=u[3];F=i(F=i(F=i(F=i(F=o(F=o(F=o(F=o(F=n(F=n(F=n(F=n(F=r(F=r(F=r(F=r(F,O=r(O,N=r(N,C=r(C,F,O,N,f,7,l[0]),F,O,p,12,l[1]),C,F,h,17,l[2]),N,C,d,22,l[3]),O=r(O,N=r(N,C=r(C,F,O,N,m,7,l[4]),F,O,y,12,l[5]),C,F,g,17,l[6]),N,C,v,22,l[7]),O=r(O,N=r(N,C=r(C,F,O,N,b,7,l[8]),F,O,_,12,l[9]),C,F,w,17,l[10]),N,C,x,22,l[11]),O=r(O,N=r(N,C=r(C,F,O,N,k,7,l[12]),F,O,B,12,l[13]),C,F,S,17,l[14]),N,C,A,22,l[15]),O=n(O,N=n(N,C=n(C,F,O,N,p,5,l[16]),F,O,g,9,l[17]),C,F,x,14,l[18]),N,C,f,20,l[19]),O=n(O,N=n(N,C=n(C,F,O,N,y,5,l[20]),F,O,w,9,l[21]),C,F,A,14,l[22]),N,C,m,20,l[23]),O=n(O,N=n(N,C=n(C,F,O,N,_,5,l[24]),F,O,S,9,l[25]),C,F,d,14,l[26]),N,C,b,20,l[27]),O=n(O,N=n(N,C=n(C,F,O,N,B,5,l[28]),F,O,h,9,l[29]),C,F,v,14,l[30]),N,C,k,20,l[31]),O=o(O,N=o(N,C=o(C,F,O,N,y,4,l[32]),F,O,b,11,l[33]),C,F,x,16,l[34]),N,C,S,23,l[35]),O=o(O,N=o(N,C=o(C,F,O,N,p,4,l[36]),F,O,m,11,l[37]),C,F,v,16,l[38]),N,C,w,23,l[39]),O=o(O,N=o(N,C=o(C,F,O,N,B,4,l[40]),F,O,f,11,l[41]),C,F,d,16,l[42]),N,C,g,23,l[43]),O=o(O,N=o(N,C=o(C,F,O,N,_,4,l[44]),F,O,k,11,l[45]),C,F,A,16,l[46]),N,C,h,23,l[47]),O=i(O,N=i(N,C=i(C,F,O,N,f,6,l[48]),F,O,v,10,l[49]),C,F,S,15,l[50]),N,C,y,21,l[51]),O=i(O,N=i(N,C=i(C,F,O,N,k,6,l[52]),F,O,d,10,l[53]),C,F,w,15,l[54]),N,C,p,21,l[55]),O=i(O,N=i(N,C=i(C,F,O,N,b,6,l[56]),F,O,A,10,l[57]),C,F,g,15,l[58]),N,C,B,21,l[59]),O=i(O,N=i(N,C=i(C,F,O,N,m,6,l[60]),F,O,x,10,l[61]),C,F,h,15,l[62]),N,C,_,21,l[63]),u[0]=u[0]+C|0,u[1]=u[1]+F|0,u[2]=u[2]+O|0,u[3]=u[3]+N|0},_doFinalize:function(){var t=this._data,r=t.words,n=8*this._nDataBytes,o=8*t.sigBytes;r[o>>>5]|=128<<24-o%32;var i=e.floor(n/4294967296),a=n;r[15+(o+64>>>9<<4)]=16711935&(i<<8|i>>>24)|4278255360&(i<<24|i>>>8),r[14+(o+64>>>9<<4)]=16711935&(a<<8|a>>>24)|4278255360&(a<<24|a>>>8),t.sigBytes=4*(r.length+1),this._process();for(var s=this._hash,c=s.words,u=0;u<4;u++){var f=c[u];c[u]=16711935&(f<<8|f>>>24)|4278255360&(f<<24|f>>>8)}return s},clone:function(){var t=u.clone.call(this);return t._hash=this._hash.clone(),t}});a.MD5=u._createHelper(p),a.HmacMD5=u._createHmacHelper(p)}(Math),t.MD5},"object"==typeof r?e.exports=r=o(t("./core")):"function"==typeof define&&define.amd?define(["./core"],o):o(n.CryptoJS);var n,o},{"./core":53}],62:[function(t,e,r){n=this,o=function(t){return t.mode.CFB=function(){function e(t,e,r,n){var o=this._iv;if(o){var i=o.slice(0);this._iv=void 0}else i=this._prevBlock;n.encryptBlock(i,0);for(var a=0;a<r;a++)t[e+a]^=i[a]}var r=t.lib.BlockCipherMode.extend();return r.Encryptor=r.extend({processBlock:function(t,r){var n=this._cipher,o=n.blockSize;e.call(this,t,r,o,n),this._prevBlock=t.slice(r,r+o)}}),r.Decryptor=r.extend({processBlock:function(t,r){var n=this._cipher,o=n.blockSize,i=t.slice(r,r+o);e.call(this,t,r,o,n),this._prevBlock=i}}),r}(),t.mode.CFB},"object"==typeof r?e.exports=r=o(t("./core"),t("./cipher-core")):"function"==typeof define&&define.amd?define(["./core","./cipher-core"],o):o(n.CryptoJS);var n,o},{"./cipher-core":52,"./core":53}],63:[function(t,e,r){n=this,o=function(t){return t.mode.CTRGladman=function(){function e(t){if(255==(t>>24&255)){var e=t>>16&255,r=t>>8&255,n=255&t;255===e?(e=0,255===r?(r=0,255===n?n=0:++n):++r):++e,t=0,t+=e<<16,t+=r<<8,t+=n}else t+=1<<24;return t}var r=t.lib.BlockCipherMode.extend(),n=r.Encryptor=r.extend({processBlock:function(t,r){var n=this._cipher,o=n.blockSize,i=this._iv,a=this._counter;i&&(a=this._counter=i.slice(0),this._iv=void 0),0===((s=a)[0]=e(s[0]))&&(s[1]=e(s[1]));var s,c=a.slice(0);n.encryptBlock(c,0);for(var u=0;u<o;u++)t[r+u]^=c[u]}});return r.Decryptor=n,r}(),t.mode.CTRGladman},"object"==typeof r?e.exports=r=o(t("./core"),t("./cipher-core")):"function"==typeof define&&define.amd?define(["./core","./cipher-core"],o):o(n.CryptoJS);var n,o},{"./cipher-core":52,"./core":53}],64:[function(t,e,r){n=this,o=function(t){return t.mode.CTR=function(){var e=t.lib.BlockCipherMode.extend(),r=e.Encryptor=e.extend({processBlock:function(t,e){var r=this._cipher,n=r.blockSize,o=this._iv,i=this._counter;o&&(i=this._counter=o.slice(0),this._iv=void 0);var a=i.slice(0);r.encryptBlock(a,0),i[n-1]=i[n-1]+1|0;for(var s=0;s<n;s++)t[e+s]^=a[s]}});return e.Decryptor=r,e}(),t.mode.CTR},"object"==typeof r?e.exports=r=o(t("./core"),t("./cipher-core")):"function"==typeof define&&define.amd?define(["./core","./cipher-core"],o):o(n.CryptoJS);var n,o},{"./cipher-core":52,"./core":53}],65:[function(t,e,r){n=this,o=function(t){return t.mode.ECB=function(){var e=t.lib.BlockCipherMode.extend();return e.Encryptor=e.extend({processBlock:function(t,e){this._cipher.encryptBlock(t,e)}}),e.Decryptor=e.extend({processBlock:function(t,e){this._cipher.decryptBlock(t,e)}}),e}(),t.mode.ECB},"object"==typeof r?e.exports=r=o(t("./core"),t("./cipher-core")):"function"==typeof define&&define.amd?define(["./core","./cipher-core"],o):o(n.CryptoJS);var n,o},{"./cipher-core":52,"./core":53}],66:[function(t,e,r){n=this,o=function(t){return t.mode.OFB=function(){var e=t.lib.BlockCipherMode.extend(),r=e.Encryptor=e.extend({processBlock:function(t,e){var r=this._cipher,n=r.blockSize,o=this._iv,i=this._keystream;o&&(i=this._keystream=o.slice(0),this._iv=void 0),r.encryptBlock(i,0);for(var a=0;a<n;a++)t[e+a]^=i[a]}});return e.Decryptor=r,e}(),t.mode.OFB},"object"==typeof r?e.exports=r=o(t("./core"),t("./cipher-core")):"function"==typeof define&&define.amd?define(["./core","./cipher-core"],o):o(n.CryptoJS);var n,o},{"./cipher-core":52,"./core":53}],67:[function(t,e,r){n=this,o=function(t){return t.pad.AnsiX923={pad:function(t,e){var r=t.sigBytes,n=4*e,o=n-r%n,i=r+o-1;t.clamp(),t.words[i>>>2]|=o<<24-i%4*8,t.sigBytes+=o},unpad:function(t){var e=255&t.words[t.sigBytes-1>>>2];t.sigBytes-=e}},t.pad.Ansix923},"object"==typeof r?e.exports=r=o(t("./core"),t("./cipher-core")):"function"==typeof define&&define.amd?define(["./core","./cipher-core"],o):o(n.CryptoJS);var n,o},{"./cipher-core":52,"./core":53}],68:[function(t,e,r){n=this,o=function(t){return t.pad.Iso10126={pad:function(e,r){var n=4*r,o=n-e.sigBytes%n;e.concat(t.lib.WordArray.random(o-1)).concat(t.lib.WordArray.create([o<<24],1))},unpad:function(t){var e=255&t.words[t.sigBytes-1>>>2];t.sigBytes-=e}},t.pad.Iso10126},"object"==typeof r?e.exports=r=o(t("./core"),t("./cipher-core")):"function"==typeof define&&define.amd?define(["./core","./cipher-core"],o):o(n.CryptoJS);var n,o},{"./cipher-core":52,"./core":53}],69:[function(t,e,r){n=this,o=function(t){return t.pad.Iso97971={pad:function(e,r){e.concat(t.lib.WordArray.create([2147483648],1)),t.pad.ZeroPadding.pad(e,r)},unpad:function(e){t.pad.ZeroPadding.unpad(e),e.sigBytes--}},t.pad.Iso97971},"object"==typeof r?e.exports=r=o(t("./core"),t("./cipher-core")):"function"==typeof define&&define.amd?define(["./core","./cipher-core"],o):o(n.CryptoJS);var n,o},{"./cipher-core":52,"./core":53}],70:[function(t,e,r){n=this,o=function(t){return t.pad.NoPadding={pad:function(){},unpad:function(){}},t.pad.NoPadding},"object"==typeof r?e.exports=r=o(t("./core"),t("./cipher-core")):"function"==typeof define&&define.amd?define(["./core","./cipher-core"],o):o(n.CryptoJS);var n,o},{"./cipher-core":52,"./core":53}],71:[function(t,e,r){n=this,o=function(t){return t.pad.ZeroPadding={pad:function(t,e){var r=4*e;t.clamp(),t.sigBytes+=r-(t.sigBytes%r||r)},unpad:function(t){for(var e=t.words,r=t.sigBytes-1;!(e[r>>>2]>>>24-r%4*8&255);)r--;t.sigBytes=r+1}},t.pad.ZeroPadding},"object"==typeof r?e.exports=r=o(t("./core"),t("./cipher-core")):"function"==typeof define&&define.amd?define(["./core","./cipher-core"],o):o(n.CryptoJS);var n,o},{"./cipher-core":52,"./core":53}],72:[function(t,e,r){n=this,o=function(t){return function(){var e=t,r=e.lib,n=r.Base,o=r.WordArray,i=e.algo,a=i.SHA1,s=i.HMAC,c=i.PBKDF2=n.extend({cfg:n.extend({keySize:4,hasher:a,iterations:1}),init:function(t){this.cfg=this.cfg.extend(t)},compute:function(t,e){for(var r=this.cfg,n=s.create(r.hasher,t),i=o.create(),a=o.create([1]),c=i.words,u=a.words,f=r.keySize,l=r.iterations;c.length<f;){var p=n.update(e).finalize(a);n.reset();for(var h=p.words,d=h.length,m=p,y=1;y<l;y++){m=n.finalize(m),n.reset();for(var g=m.words,v=0;v<d;v++)h[v]^=g[v]}i.concat(p),u[0]++}return i.sigBytes=4*f,i}});e.PBKDF2=function(t,e,r){return c.create(r).compute(t,e)}}(),t.PBKDF2},"object"==typeof r?e.exports=r=o(t("./core"),t("./sha1"),t("./hmac")):"function"==typeof define&&define.amd?define(["./core","./sha1","./hmac"],o):o(n.CryptoJS);var n,o},{"./core":53,"./hmac":58,"./sha1":77}],73:[function(t,e,r){n=this,o=function(t){return function(){function e(){for(var t=this._X,e=this._C,r=0;r<8;r++)i[r]=e[r];for(e[0]=e[0]+1295307597+this._b|0,e[1]=e[1]+3545052371+(e[0]>>>0<i[0]>>>0?1:0)|0,e[2]=e[2]+886263092+(e[1]>>>0<i[1]>>>0?1:0)|0,e[3]=e[3]+1295307597+(e[2]>>>0<i[2]>>>0?1:0)|0,e[4]=e[4]+3545052371+(e[3]>>>0<i[3]>>>0?1:0)|0,e[5]=e[5]+886263092+(e[4]>>>0<i[4]>>>0?1:0)|0,e[6]=e[6]+1295307597+(e[5]>>>0<i[5]>>>0?1:0)|0,e[7]=e[7]+3545052371+(e[6]>>>0<i[6]>>>0?1:0)|0,this._b=e[7]>>>0<i[7]>>>0?1:0,r=0;r<8;r++){var n=t[r]+e[r],o=65535&n,s=n>>>16,c=((o*o>>>17)+o*s>>>15)+s*s,u=((4294901760&n)*n|0)+((65535&n)*n|0);a[r]=c^u}t[0]=a[0]+(a[7]<<16|a[7]>>>16)+(a[6]<<16|a[6]>>>16)|0,t[1]=a[1]+(a[0]<<8|a[0]>>>24)+a[7]|0,t[2]=a[2]+(a[1]<<16|a[1]>>>16)+(a[0]<<16|a[0]>>>16)|0,t[3]=a[3]+(a[2]<<8|a[2]>>>24)+a[1]|0,t[4]=a[4]+(a[3]<<16|a[3]>>>16)+(a[2]<<16|a[2]>>>16)|0,t[5]=a[5]+(a[4]<<8|a[4]>>>24)+a[3]|0,t[6]=a[6]+(a[5]<<16|a[5]>>>16)+(a[4]<<16|a[4]>>>16)|0,t[7]=a[7]+(a[6]<<8|a[6]>>>24)+a[5]|0}var r=t,n=r.lib.StreamCipher,o=[],i=[],a=[],s=r.algo.RabbitLegacy=n.extend({_doReset:function(){var t=this._key.words,r=this.cfg.iv,n=this._X=[t[0],t[3]<<16|t[2]>>>16,t[1],t[0]<<16|t[3]>>>16,t[2],t[1]<<16|t[0]>>>16,t[3],t[2]<<16|t[1]>>>16],o=this._C=[t[2]<<16|t[2]>>>16,4294901760&t[0]|65535&t[1],t[3]<<16|t[3]>>>16,4294901760&t[1]|65535&t[2],t[0]<<16|t[0]>>>16,4294901760&t[2]|65535&t[3],t[1]<<16|t[1]>>>16,4294901760&t[3]|65535&t[0]];this._b=0;for(var i=0;i<4;i++)e.call(this);for(i=0;i<8;i++)o[i]^=n[i+4&7];if(r){var a=r.words,s=a[0],c=a[1],u=16711935&(s<<8|s>>>24)|4278255360&(s<<24|s>>>8),f=16711935&(c<<8|c>>>24)|4278255360&(c<<24|c>>>8),l=u>>>16|4294901760&f,p=f<<16|65535&u;for(o[0]^=u,o[1]^=l,o[2]^=f,o[3]^=p,o[4]^=u,o[5]^=l,o[6]^=f,o[7]^=p,i=0;i<4;i++)e.call(this)}},_doProcessBlock:function(t,r){var n=this._X;e.call(this),o[0]=n[0]^n[5]>>>16^n[3]<<16,o[1]=n[2]^n[7]>>>16^n[5]<<16,o[2]=n[4]^n[1]>>>16^n[7]<<16,o[3]=n[6]^n[3]>>>16^n[1]<<16;for(var i=0;i<4;i++)o[i]=16711935&(o[i]<<8|o[i]>>>24)|4278255360&(o[i]<<24|o[i]>>>8),t[r+i]^=o[i]},blockSize:4,ivSize:2});r.RabbitLegacy=n._createHelper(s)}(),t.RabbitLegacy},"object"==typeof r?e.exports=r=o(t("./core"),t("./enc-base64"),t("./md5"),t("./evpkdf"),t("./cipher-core")):"function"==typeof define&&define.amd?define(["./core","./enc-base64","./md5","./evpkdf","./cipher-core"],o):o(n.CryptoJS);var n,o},{"./cipher-core":52,"./core":53,"./enc-base64":54,"./evpkdf":56,"./md5":61}],74:[function(t,e,r){n=this,o=function(t){return function(){function e(){for(var t=this._X,e=this._C,r=0;r<8;r++)i[r]=e[r];for(e[0]=e[0]+1295307597+this._b|0,e[1]=e[1]+3545052371+(e[0]>>>0<i[0]>>>0?1:0)|0,e[2]=e[2]+886263092+(e[1]>>>0<i[1]>>>0?1:0)|0,e[3]=e[3]+1295307597+(e[2]>>>0<i[2]>>>0?1:0)|0,e[4]=e[4]+3545052371+(e[3]>>>0<i[3]>>>0?1:0)|0,e[5]=e[5]+886263092+(e[4]>>>0<i[4]>>>0?1:0)|0,e[6]=e[6]+1295307597+(e[5]>>>0<i[5]>>>0?1:0)|0,e[7]=e[7]+3545052371+(e[6]>>>0<i[6]>>>0?1:0)|0,this._b=e[7]>>>0<i[7]>>>0?1:0,r=0;r<8;r++){var n=t[r]+e[r],o=65535&n,s=n>>>16,c=((o*o>>>17)+o*s>>>15)+s*s,u=((4294901760&n)*n|0)+((65535&n)*n|0);a[r]=c^u}t[0]=a[0]+(a[7]<<16|a[7]>>>16)+(a[6]<<16|a[6]>>>16)|0,t[1]=a[1]+(a[0]<<8|a[0]>>>24)+a[7]|0,t[2]=a[2]+(a[1]<<16|a[1]>>>16)+(a[0]<<16|a[0]>>>16)|0,t[3]=a[3]+(a[2]<<8|a[2]>>>24)+a[1]|0,t[4]=a[4]+(a[3]<<16|a[3]>>>16)+(a[2]<<16|a[2]>>>16)|0,t[5]=a[5]+(a[4]<<8|a[4]>>>24)+a[3]|0,t[6]=a[6]+(a[5]<<16|a[5]>>>16)+(a[4]<<16|a[4]>>>16)|0,t[7]=a[7]+(a[6]<<8|a[6]>>>24)+a[5]|0}var r=t,n=r.lib.StreamCipher,o=[],i=[],a=[],s=r.algo.Rabbit=n.extend({_doReset:function(){for(var t=this._key.words,r=this.cfg.iv,n=0;n<4;n++)t[n]=16711935&(t[n]<<8|t[n]>>>24)|4278255360&(t[n]<<24|t[n]>>>8);var o=this._X=[t[0],t[3]<<16|t[2]>>>16,t[1],t[0]<<16|t[3]>>>16,t[2],t[1]<<16|t[0]>>>16,t[3],t[2]<<16|t[1]>>>16],i=this._C=[t[2]<<16|t[2]>>>16,4294901760&t[0]|65535&t[1],t[3]<<16|t[3]>>>16,4294901760&t[1]|65535&t[2],t[0]<<16|t[0]>>>16,4294901760&t[2]|65535&t[3],t[1]<<16|t[1]>>>16,4294901760&t[3]|65535&t[0]];for(this._b=0,n=0;n<4;n++)e.call(this);for(n=0;n<8;n++)i[n]^=o[n+4&7];if(r){var a=r.words,s=a[0],c=a[1],u=16711935&(s<<8|s>>>24)|4278255360&(s<<24|s>>>8),f=16711935&(c<<8|c>>>24)|4278255360&(c<<24|c>>>8),l=u>>>16|4294901760&f,p=f<<16|65535&u;for(i[0]^=u,i[1]^=l,i[2]^=f,i[3]^=p,i[4]^=u,i[5]^=l,i[6]^=f,i[7]^=p,n=0;n<4;n++)e.call(this)}},_doProcessBlock:function(t,r){var n=this._X;e.call(this),o[0]=n[0]^n[5]>>>16^n[3]<<16,o[1]=n[2]^n[7]>>>16^n[5]<<16,o[2]=n[4]^n[1]>>>16^n[7]<<16,o[3]=n[6]^n[3]>>>16^n[1]<<16;for(var i=0;i<4;i++)o[i]=16711935&(o[i]<<8|o[i]>>>24)|4278255360&(o[i]<<24|o[i]>>>8),t[r+i]^=o[i]},blockSize:4,ivSize:2});r.Rabbit=n._createHelper(s)}(),t.Rabbit},"object"==typeof r?e.exports=r=o(t("./core"),t("./enc-base64"),t("./md5"),t("./evpkdf"),t("./cipher-core")):"function"==typeof define&&define.amd?define(["./core","./enc-base64","./md5","./evpkdf","./cipher-core"],o):o(n.CryptoJS);var n,o},{"./cipher-core":52,"./core":53,"./enc-base64":54,"./evpkdf":56,"./md5":61}],75:[function(t,e,r){n=this,o=function(t){return function(){function e(){for(var t=this._S,e=this._i,r=this._j,n=0,o=0;o<4;o++){r=(r+t[e=(e+1)%256])%256;var i=t[e];t[e]=t[r],t[r]=i,n|=t[(t[e]+t[r])%256]<<24-8*o}return this._i=e,this._j=r,n}var r=t,n=r.lib.StreamCipher,o=r.algo,i=o.RC4=n.extend({_doReset:function(){for(var t=this._key,e=t.words,r=t.sigBytes,n=this._S=[],o=0;o<256;o++)n[o]=o;o=0;for(var i=0;o<256;o++){var a=o%r,s=e[a>>>2]>>>24-a%4*8&255;i=(i+n[o]+s)%256;var c=n[o];n[o]=n[i],n[i]=c}this._i=this._j=0},_doProcessBlock:function(t,r){t[r]^=e.call(this)},keySize:8,ivSize:0});r.RC4=n._createHelper(i);var a=o.RC4Drop=i.extend({cfg:i.cfg.extend({drop:192}),_doReset:function(){i._doReset.call(this);for(var t=this.cfg.drop;t>0;t--)e.call(this)}});r.RC4Drop=n._createHelper(a)}(),t.RC4},"object"==typeof r?e.exports=r=o(t("./core"),t("./enc-base64"),t("./md5"),t("./evpkdf"),t("./cipher-core")):"function"==typeof define&&define.amd?define(["./core","./enc-base64","./md5","./evpkdf","./cipher-core"],o):o(n.CryptoJS);var n,o},{"./cipher-core":52,"./core":53,"./enc-base64":54,"./evpkdf":56,"./md5":61}],76:[function(t,e,r){n=this,o=function(t){return function(e){function r(t,e,r){return t^e^r}function n(t,e,r){return t&e|~t&r}function o(t,e,r){return(t|~e)^r}function i(t,e,r){return t&r|e&~r}function a(t,e,r){return t^(e|~r)}function s(t,e){return t<<e|t>>>32-e}var c=t,u=c.lib,f=u.WordArray,l=u.Hasher,p=c.algo,h=f.create([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,7,4,13,1,10,6,15,3,12,0,9,5,2,14,11,8,3,10,14,4,9,15,8,1,2,7,0,6,13,11,5,12,1,9,11,10,0,8,12,4,13,3,7,15,14,5,6,2,4,0,5,9,7,12,2,10,14,1,3,8,11,6,15,13]),d=f.create([5,14,7,0,9,2,11,4,13,6,15,8,1,10,3,12,6,11,3,7,0,13,5,10,14,15,8,12,4,9,1,2,15,5,1,3,7,14,6,9,11,8,12,2,10,0,4,13,8,6,4,1,3,11,15,0,5,12,2,13,9,7,10,14,12,15,10,4,1,5,8,7,6,2,13,14,0,3,9,11]),m=f.create([11,14,15,12,5,8,7,9,11,13,14,15,6,7,9,8,7,6,8,13,11,9,7,15,7,12,15,9,11,7,13,12,11,13,6,7,14,9,13,15,14,8,13,6,5,12,7,5,11,12,14,15,14,15,9,8,9,14,5,6,8,6,5,12,9,15,5,11,6,8,13,12,5,12,13,14,11,8,5,6]),y=f.create([8,9,9,11,13,15,15,5,7,7,8,11,14,14,12,6,9,13,15,7,12,8,9,11,7,7,12,7,6,15,13,11,9,7,15,11,8,6,6,14,12,13,5,14,13,13,7,5,15,5,8,11,14,14,6,14,6,9,12,9,12,5,15,8,8,5,12,9,12,5,14,6,8,13,6,5,15,13,11,11]),g=f.create([0,1518500249,1859775393,2400959708,2840853838]),v=f.create([1352829926,1548603684,1836072691,2053994217,0]),b=p.RIPEMD160=l.extend({_doReset:function(){this._hash=f.create([1732584193,4023233417,2562383102,271733878,3285377520])},_doProcessBlock:function(t,e){for(var c=0;c<16;c++){var u=e+c,f=t[u];t[u]=16711935&(f<<8|f>>>24)|4278255360&(f<<24|f>>>8)}var l,p,b,_,w,x,k,B,S,A,C=this._hash.words,F=g.words,O=v.words,N=h.words,T=d.words,I=m.words,P=y.words;x=l=C[0],k=p=C[1],B=b=C[2],S=_=C[3],A=w=C[4];var D;for(c=0;c<80;c+=1)D=l+t[e+N[c]]|0,D+=c<16?r(p,b,_)+F[0]:c<32?n(p,b,_)+F[1]:c<48?o(p,b,_)+F[2]:c<64?i(p,b,_)+F[3]:a(p,b,_)+F[4],D=(D=s(D|=0,I[c]))+w|0,l=w,w=_,_=s(b,10),b=p,p=D,D=x+t[e+T[c]]|0,D+=c<16?a(k,B,S)+O[0]:c<32?i(k,B,S)+O[1]:c<48?o(k,B,S)+O[2]:c<64?n(k,B,S)+O[3]:r(k,B,S)+O[4],D=(D=s(D|=0,P[c]))+A|0,x=A,A=S,S=s(B,10),B=k,k=D;D=C[1]+b+S|0,C[1]=C[2]+_+A|0,C[2]=C[3]+w+x|0,C[3]=C[4]+l+k|0,C[4]=C[0]+p+B|0,C[0]=D},_doFinalize:function(){var t=this._data,e=t.words,r=8*this._nDataBytes,n=8*t.sigBytes;e[n>>>5]|=128<<24-n%32,e[14+(n+64>>>9<<4)]=16711935&(r<<8|r>>>24)|4278255360&(r<<24|r>>>8),t.sigBytes=4*(e.length+1),this._process();for(var o=this._hash,i=o.words,a=0;a<5;a++){var s=i[a];i[a]=16711935&(s<<8|s>>>24)|4278255360&(s<<24|s>>>8)}return o},clone:function(){var t=l.clone.call(this);return t._hash=this._hash.clone(),t}});c.RIPEMD160=l._createHelper(b),c.HmacRIPEMD160=l._createHmacHelper(b)}(Math),t.RIPEMD160},"object"==typeof r?e.exports=r=o(t("./core")):"function"==typeof define&&define.amd?define(["./core"],o):o(n.CryptoJS);var n,o},{"./core":53}],77:[function(t,e,r){n=this,o=function(t){return function(){var e=t,r=e.lib,n=r.WordArray,o=r.Hasher,i=[],a=e.algo.SHA1=o.extend({_doReset:function(){this._hash=new n.init([1732584193,4023233417,2562383102,271733878,3285377520])},_doProcessBlock:function(t,e){for(var r=this._hash.words,n=r[0],o=r[1],a=r[2],s=r[3],c=r[4],u=0;u<80;u++){if(u<16)i[u]=0|t[e+u];else{var f=i[u-3]^i[u-8]^i[u-14]^i[u-16];i[u]=f<<1|f>>>31}var l=(n<<5|n>>>27)+c+i[u];l+=u<20?1518500249+(o&a|~o&s):u<40?1859775393+(o^a^s):u<60?(o&a|o&s|a&s)-1894007588:(o^a^s)-899497514,c=s,s=a,a=o<<30|o>>>2,o=n,n=l}r[0]=r[0]+n|0,r[1]=r[1]+o|0,r[2]=r[2]+a|0,r[3]=r[3]+s|0,r[4]=r[4]+c|0},_doFinalize:function(){var t=this._data,e=t.words,r=8*this._nDataBytes,n=8*t.sigBytes;return e[n>>>5]|=128<<24-n%32,e[14+(n+64>>>9<<4)]=Math.floor(r/4294967296),e[15+(n+64>>>9<<4)]=r,t.sigBytes=4*e.length,this._process(),this._hash},clone:function(){var t=o.clone.call(this);return t._hash=this._hash.clone(),t}});e.SHA1=o._createHelper(a),e.HmacSHA1=o._createHmacHelper(a)}(),t.SHA1},"object"==typeof r?e.exports=r=o(t("./core")):"function"==typeof define&&define.amd?define(["./core"],o):o(n.CryptoJS);var n,o},{"./core":53}],78:[function(t,e,r){n=this,o=function(t){return function(){var e=t,r=e.lib.WordArray,n=e.algo,o=n.SHA256,i=n.SHA224=o.extend({_doReset:function(){this._hash=new r.init([3238371032,914150663,812702999,4144912697,4290775857,1750603025,1694076839,3204075428])},_doFinalize:function(){var t=o._doFinalize.call(this);return t.sigBytes-=4,t}});e.SHA224=o._createHelper(i),e.HmacSHA224=o._createHmacHelper(i)}(),t.SHA224},"object"==typeof r?e.exports=r=o(t("./core"),t("./sha256")):"function"==typeof define&&define.amd?define(["./core","./sha256"],o):o(n.CryptoJS);var n,o},{"./core":53,"./sha256":79}],79:[function(t,e,r){n=this,o=function(t){return function(e){var r=t,n=r.lib,o=n.WordArray,i=n.Hasher,a=r.algo,s=[],c=[];!function(){function t(t){for(var r=e.sqrt(t),n=2;n<=r;n++)if(!(t%n))return!1;return!0}function r(t){return 4294967296*(t-(0|t))|0}for(var n=2,o=0;o<64;)t(n)&&(o<8&&(s[o]=r(e.pow(n,.5))),c[o]=r(e.pow(n,1/3)),o++),n++}();var u=[],f=a.SHA256=i.extend({_doReset:function(){this._hash=new o.init(s.slice(0))},_doProcessBlock:function(t,e){for(var r=this._hash.words,n=r[0],o=r[1],i=r[2],a=r[3],s=r[4],f=r[5],l=r[6],p=r[7],h=0;h<64;h++){if(h<16)u[h]=0|t[e+h];else{var d=u[h-15],m=(d<<25|d>>>7)^(d<<14|d>>>18)^d>>>3,y=u[h-2],g=(y<<15|y>>>17)^(y<<13|y>>>19)^y>>>10;u[h]=m+u[h-7]+g+u[h-16]}var v=n&o^n&i^o&i,b=(n<<30|n>>>2)^(n<<19|n>>>13)^(n<<10|n>>>22),_=p+((s<<26|s>>>6)^(s<<21|s>>>11)^(s<<7|s>>>25))+(s&f^~s&l)+c[h]+u[h];p=l,l=f,f=s,s=a+_|0,a=i,i=o,o=n,n=_+(b+v)|0}r[0]=r[0]+n|0,r[1]=r[1]+o|0,r[2]=r[2]+i|0,r[3]=r[3]+a|0,r[4]=r[4]+s|0,r[5]=r[5]+f|0,r[6]=r[6]+l|0,r[7]=r[7]+p|0},_doFinalize:function(){var t=this._data,r=t.words,n=8*this._nDataBytes,o=8*t.sigBytes;return r[o>>>5]|=128<<24-o%32,r[14+(o+64>>>9<<4)]=e.floor(n/4294967296),r[15+(o+64>>>9<<4)]=n,t.sigBytes=4*r.length,this._process(),this._hash},clone:function(){var t=i.clone.call(this);return t._hash=this._hash.clone(),t}});r.SHA256=i._createHelper(f),r.HmacSHA256=i._createHmacHelper(f)}(Math),t.SHA256},"object"==typeof r?e.exports=r=o(t("./core")):"function"==typeof define&&define.amd?define(["./core"],o):o(n.CryptoJS);var n,o},{"./core":53}],80:[function(t,e,r){n=this,o=function(t){return function(e){var r=t,n=r.lib,o=n.WordArray,i=n.Hasher,a=r.x64.Word,s=r.algo,c=[],u=[],f=[];!function(){for(var t=1,e=0,r=0;r<24;r++){c[t+5*e]=(r+1)*(r+2)/2%64;var n=(2*t+3*e)%5;t=e%5,e=n}for(t=0;t<5;t++)for(e=0;e<5;e++)u[t+5*e]=e+(2*t+3*e)%5*5;for(var o=1,i=0;i<24;i++){for(var s=0,l=0,p=0;p<7;p++){if(1&o){var h=(1<<p)-1;h<32?l^=1<<h:s^=1<<h-32}128&o?o=o<<1^113:o<<=1}f[i]=a.create(s,l)}}();var l=[];!function(){for(var t=0;t<25;t++)l[t]=a.create()}();var p=s.SHA3=i.extend({cfg:i.cfg.extend({outputLength:512}),_doReset:function(){for(var t=this._state=[],e=0;e<25;e++)t[e]=new a.init;this.blockSize=(1600-2*this.cfg.outputLength)/32},_doProcessBlock:function(t,e){for(var r=this._state,n=this.blockSize/2,o=0;o<n;o++){var i=t[e+2*o],a=t[e+2*o+1];i=16711935&(i<<8|i>>>24)|4278255360&(i<<24|i>>>8),a=16711935&(a<<8|a>>>24)|4278255360&(a<<24|a>>>8),(F=r[o]).high^=a,F.low^=i}for(var s=0;s<24;s++){for(var p=0;p<5;p++){for(var h=0,d=0,m=0;m<5;m++)h^=(F=r[p+5*m]).high,d^=F.low;var y=l[p];y.high=h,y.low=d}for(p=0;p<5;p++){var g=l[(p+4)%5],v=l[(p+1)%5],b=v.high,_=v.low;for(h=g.high^(b<<1|_>>>31),d=g.low^(_<<1|b>>>31),m=0;m<5;m++)(F=r[p+5*m]).high^=h,F.low^=d}for(var w=1;w<25;w++){var x=(F=r[w]).high,k=F.low,B=c[w];B<32?(h=x<<B|k>>>32-B,d=k<<B|x>>>32-B):(h=k<<B-32|x>>>64-B,d=x<<B-32|k>>>64-B);var S=l[u[w]];S.high=h,S.low=d}var A=l[0],C=r[0];for(A.high=C.high,A.low=C.low,p=0;p<5;p++)for(m=0;m<5;m++){var F=r[w=p+5*m],O=l[w],N=l[(p+1)%5+5*m],T=l[(p+2)%5+5*m];F.high=O.high^~N.high&T.high,F.low=O.low^~N.low&T.low}F=r[0];var I=f[s];F.high^=I.high,F.low^=I.low}},_doFinalize:function(){var t=this._data,r=t.words,n=(this._nDataBytes,8*t.sigBytes),i=32*this.blockSize;r[n>>>5]|=1<<24-n%32,r[(e.ceil((n+1)/i)*i>>>5)-1]|=128,t.sigBytes=4*r.length,this._process();for(var a=this._state,s=this.cfg.outputLength/8,c=s/8,u=[],f=0;f<c;f++){var l=a[f],p=l.high,h=l.low;p=16711935&(p<<8|p>>>24)|4278255360&(p<<24|p>>>8),h=16711935&(h<<8|h>>>24)|4278255360&(h<<24|h>>>8),u.push(h),u.push(p)}return new o.init(u,s)},clone:function(){for(var t=i.clone.call(this),e=t._state=this._state.slice(0),r=0;r<25;r++)e[r]=e[r].clone();return t}});r.SHA3=i._createHelper(p),r.HmacSHA3=i._createHmacHelper(p)}(Math),t.SHA3},"object"==typeof r?e.exports=r=o(t("./core"),t("./x64-core")):"function"==typeof define&&define.amd?define(["./core","./x64-core"],o):o(n.CryptoJS);var n,o},{"./core":53,"./x64-core":84}],81:[function(t,e,r){n=this,o=function(t){return function(){var e=t,r=e.x64,n=r.Word,o=r.WordArray,i=e.algo,a=i.SHA512,s=i.SHA384=a.extend({_doReset:function(){this._hash=new o.init([new n.init(3418070365,3238371032),new n.init(1654270250,914150663),new n.init(2438529370,812702999),new n.init(355462360,4144912697),new n.init(1731405415,4290775857),new n.init(2394180231,1750603025),new n.init(3675008525,1694076839),new n.init(1203062813,3204075428)])},_doFinalize:function(){var t=a._doFinalize.call(this);return t.sigBytes-=16,t}});e.SHA384=a._createHelper(s),e.HmacSHA384=a._createHmacHelper(s)}(),t.SHA384},"object"==typeof r?e.exports=r=o(t("./core"),t("./x64-core"),t("./sha512")):"function"==typeof define&&define.amd?define(["./core","./x64-core","./sha512"],o):o(n.CryptoJS);var n,o},{"./core":53,"./sha512":82,"./x64-core":84}],82:[function(t,e,r){n=this,o=function(t){return function(){function e(){return i.create.apply(i,arguments)}var r=t,n=r.lib.Hasher,o=r.x64,i=o.Word,a=o.WordArray,s=r.algo,c=[e(1116352408,3609767458),e(1899447441,602891725),e(3049323471,3964484399),e(3921009573,2173295548),e(961987163,4081628472),e(1508970993,3053834265),e(2453635748,2937671579),e(2870763221,3664609560),e(3624381080,2734883394),e(310598401,1164996542),e(607225278,1323610764),e(1426881987,3590304994),e(1925078388,4068182383),e(2162078206,991336113),e(2614888103,633803317),e(3248222580,3479774868),e(3835390401,2666613458),e(4022224774,944711139),e(264347078,2341262773),e(604807628,2007800933),e(770255983,1495990901),e(1249150122,1856431235),e(1555081692,3175218132),e(1996064986,2198950837),e(2554220882,3999719339),e(2821834349,766784016),e(2952996808,2566594879),e(3210313671,3203337956),e(3336571891,1034457026),e(3584528711,2466948901),e(113926993,3758326383),e(338241895,168717936),e(666307205,1188179964),e(773529912,1546045734),e(1294757372,1522805485),e(1396182291,2643833823),e(1695183700,2343527390),e(1986661051,1014477480),e(2177026350,1206759142),e(2456956037,344077627),e(2730485921,1290863460),e(2820302411,3158454273),e(3259730800,3505952657),e(3345764771,106217008),e(3516065817,3606008344),e(3600352804,1432725776),e(4094571909,1467031594),e(275423344,851169720),e(430227734,3100823752),e(506948616,1363258195),e(659060556,3750685593),e(883997877,3785050280),e(958139571,3318307427),e(1322822218,3812723403),e(1537002063,2003034995),e(1747873779,3602036899),e(1955562222,1575990012),e(2024104815,1125592928),e(2227730452,2716904306),e(2361852424,442776044),e(2428436474,593698344),e(2756734187,3733110249),e(3204031479,2999351573),e(3329325298,3815920427),e(3391569614,3928383900),e(3515267271,566280711),e(3940187606,3454069534),e(4118630271,4000239992),e(116418474,1914138554),e(174292421,2731055270),e(289380356,3203993006),e(460393269,320620315),e(685471733,587496836),e(852142971,1086792851),e(1017036298,365543100),e(1126000580,2618297676),e(1288033470,3409855158),e(1501505948,4234509866),e(1607167915,987167468),e(1816402316,1246189591)],u=[];!function(){for(var t=0;t<80;t++)u[t]=e()}();var f=s.SHA512=n.extend({_doReset:function(){this._hash=new a.init([new i.init(1779033703,4089235720),new i.init(3144134277,2227873595),new i.init(1013904242,4271175723),new i.init(2773480762,1595750129),new i.init(1359893119,2917565137),new i.init(2600822924,725511199),new i.init(528734635,4215389547),new i.init(1541459225,327033209)])},_doProcessBlock:function(t,e){for(var r=this._hash.words,n=r[0],o=r[1],i=r[2],a=r[3],s=r[4],f=r[5],l=r[6],p=r[7],h=n.high,d=n.low,m=o.high,y=o.low,g=i.high,v=i.low,b=a.high,_=a.low,w=s.high,x=s.low,k=f.high,B=f.low,S=l.high,A=l.low,C=p.high,F=p.low,O=h,N=d,T=m,I=y,P=g,D=v,R=b,E=_,M=w,H=x,j=k,q=B,z=S,L=A,U=C,W=F,J=0;J<80;J++){var K=u[J];if(J<16)var G=K.high=0|t[e+2*J],X=K.low=0|t[e+2*J+1];else{var $=u[J-15],V=$.high,Z=$.low,Y=(V>>>1|Z<<31)^(V>>>8|Z<<24)^V>>>7,Q=(Z>>>1|V<<31)^(Z>>>8|V<<24)^(Z>>>7|V<<25),tt=u[J-2],et=tt.high,rt=tt.low,nt=(et>>>19|rt<<13)^(et<<3|rt>>>29)^et>>>6,ot=(rt>>>19|et<<13)^(rt<<3|et>>>29)^(rt>>>6|et<<26),it=u[J-7],at=it.high,st=it.low,ct=u[J-16],ut=ct.high,ft=ct.low;G=(G=(G=Y+at+((X=Q+st)>>>0<Q>>>0?1:0))+nt+((X+=ot)>>>0<ot>>>0?1:0))+ut+((X+=ft)>>>0<ft>>>0?1:0),K.high=G,K.low=X}var lt,pt=M&j^~M&z,ht=H&q^~H&L,dt=O&T^O&P^T&P,mt=N&I^N&D^I&D,yt=(O>>>28|N<<4)^(O<<30|N>>>2)^(O<<25|N>>>7),gt=(N>>>28|O<<4)^(N<<30|O>>>2)^(N<<25|O>>>7),vt=(M>>>14|H<<18)^(M>>>18|H<<14)^(M<<23|H>>>9),bt=(H>>>14|M<<18)^(H>>>18|M<<14)^(H<<23|M>>>9),_t=c[J],wt=_t.high,xt=_t.low,kt=U+vt+((lt=W+bt)>>>0<W>>>0?1:0),Bt=gt+mt;U=z,W=L,z=j,L=q,j=M,q=H,M=R+(kt=(kt=(kt=kt+pt+((lt+=ht)>>>0<ht>>>0?1:0))+wt+((lt+=xt)>>>0<xt>>>0?1:0))+G+((lt+=X)>>>0<X>>>0?1:0))+((H=E+lt|0)>>>0<E>>>0?1:0)|0,R=P,E=D,P=T,D=I,T=O,I=N,O=kt+(yt+dt+(Bt>>>0<gt>>>0?1:0))+((N=lt+Bt|0)>>>0<lt>>>0?1:0)|0}d=n.low=d+N,n.high=h+O+(d>>>0<N>>>0?1:0),y=o.low=y+I,o.high=m+T+(y>>>0<I>>>0?1:0),v=i.low=v+D,i.high=g+P+(v>>>0<D>>>0?1:0),_=a.low=_+E,a.high=b+R+(_>>>0<E>>>0?1:0),x=s.low=x+H,s.high=w+M+(x>>>0<H>>>0?1:0),B=f.low=B+q,f.high=k+j+(B>>>0<q>>>0?1:0),A=l.low=A+L,l.high=S+z+(A>>>0<L>>>0?1:0),F=p.low=F+W,p.high=C+U+(F>>>0<W>>>0?1:0)},_doFinalize:function(){var t=this._data,e=t.words,r=8*this._nDataBytes,n=8*t.sigBytes;return e[n>>>5]|=128<<24-n%32,e[30+(n+128>>>10<<5)]=Math.floor(r/4294967296),e[31+(n+128>>>10<<5)]=r,t.sigBytes=4*e.length,this._process(),this._hash.toX32()},clone:function(){var t=n.clone.call(this);return t._hash=this._hash.clone(),t},blockSize:32});r.SHA512=n._createHelper(f),r.HmacSHA512=n._createHmacHelper(f)}(),t.SHA512},"object"==typeof r?e.exports=r=o(t("./core"),t("./x64-core")):"function"==typeof define&&define.amd?define(["./core","./x64-core"],o):o(n.CryptoJS);var n,o},{"./core":53,"./x64-core":84}],83:[function(t,e,r){n=this,o=function(t){return function(){function e(t,e){var r=(this._lBlock>>>t^this._rBlock)&e;this._rBlock^=r,this._lBlock^=r<<t}function r(t,e){var r=(this._rBlock>>>t^this._lBlock)&e;this._lBlock^=r,this._rBlock^=r<<t}var n=t,o=n.lib,i=o.WordArray,a=o.BlockCipher,s=n.algo,c=[57,49,41,33,25,17,9,1,58,50,42,34,26,18,10,2,59,51,43,35,27,19,11,3,60,52,44,36,63,55,47,39,31,23,15,7,62,54,46,38,30,22,14,6,61,53,45,37,29,21,13,5,28,20,12,4],u=[14,17,11,24,1,5,3,28,15,6,21,10,23,19,12,4,26,8,16,7,27,20,13,2,41,52,31,37,47,55,30,40,51,45,33,48,44,49,39,56,34,53,46,42,50,36,29,32],f=[1,2,4,6,8,10,12,14,15,17,19,21,23,25,27,28],l=[{0:8421888,268435456:32768,536870912:8421378,805306368:2,1073741824:512,1342177280:8421890,1610612736:8389122,1879048192:8388608,2147483648:514,2415919104:8389120,2684354560:33280,2952790016:8421376,3221225472:32770,3489660928:8388610,3758096384:0,4026531840:33282,134217728:0,402653184:8421890,671088640:33282,939524096:32768,1207959552:8421888,1476395008:512,1744830464:8421378,2013265920:2,2281701376:8389120,2550136832:33280,2818572288:8421376,3087007744:8389122,3355443200:8388610,3623878656:32770,3892314112:514,4160749568:8388608,1:32768,268435457:2,536870913:8421888,805306369:8388608,1073741825:8421378,1342177281:33280,1610612737:512,1879048193:8389122,2147483649:8421890,2415919105:8421376,2684354561:8388610,2952790017:33282,3221225473:514,3489660929:8389120,3758096385:32770,4026531841:0,134217729:8421890,402653185:8421376,671088641:8388608,939524097:512,1207959553:32768,1476395009:8388610,1744830465:2,2013265921:33282,2281701377:32770,2550136833:8389122,2818572289:514,3087007745:8421888,3355443201:8389120,3623878657:0,3892314113:33280,4160749569:8421378},{0:1074282512,16777216:16384,33554432:524288,50331648:1074266128,67108864:1073741840,83886080:1074282496,100663296:1073758208,117440512:16,134217728:540672,150994944:1073758224,167772160:1073741824,184549376:540688,201326592:524304,218103808:0,234881024:16400,251658240:1074266112,8388608:1073758208,25165824:540688,41943040:16,58720256:1073758224,75497472:1074282512,92274688:1073741824,109051904:524288,125829120:1074266128,142606336:524304,159383552:0,176160768:16384,192937984:1074266112,209715200:1073741840,226492416:540672,243269632:1074282496,260046848:16400,268435456:0,285212672:1074266128,301989888:1073758224,318767104:1074282496,335544320:1074266112,352321536:16,369098752:540688,385875968:16384,402653184:16400,419430400:524288,436207616:524304,452984832:1073741840,469762048:540672,486539264:1073758208,503316480:1073741824,520093696:1074282512,276824064:540688,293601280:524288,310378496:1074266112,327155712:16384,343932928:1073758208,360710144:1074282512,377487360:16,394264576:1073741824,411041792:1074282496,427819008:1073741840,444596224:1073758224,461373440:524304,478150656:0,494927872:16400,511705088:1074266128,528482304:540672},{0:260,1048576:0,2097152:67109120,3145728:65796,4194304:65540,5242880:67108868,6291456:67174660,7340032:67174400,8388608:67108864,9437184:67174656,10485760:65792,11534336:67174404,12582912:67109124,13631488:65536,14680064:4,15728640:256,524288:67174656,1572864:67174404,2621440:0,3670016:67109120,4718592:67108868,5767168:65536,6815744:65540,7864320:260,8912896:4,9961472:256,11010048:67174400,12058624:65796,13107200:65792,14155776:67109124,15204352:67174660,16252928:67108864,16777216:67174656,17825792:65540,18874368:65536,19922944:67109120,20971520:256,22020096:67174660,23068672:67108868,24117248:0,25165824:67109124,26214400:67108864,27262976:4,28311552:65792,29360128:67174400,30408704:260,31457280:65796,32505856:67174404,17301504:67108864,18350080:260,19398656:67174656,20447232:0,21495808:65540,22544384:67109120,23592960:256,24641536:67174404,25690112:65536,26738688:67174660,27787264:65796,28835840:67108868,29884416:67109124,30932992:67174400,31981568:4,33030144:65792},{0:2151682048,65536:2147487808,131072:4198464,196608:2151677952,262144:0,327680:4198400,393216:2147483712,458752:4194368,524288:2147483648,589824:4194304,655360:64,720896:2147487744,786432:2151678016,851968:4160,917504:4096,983040:2151682112,32768:2147487808,98304:64,163840:2151678016,229376:2147487744,294912:4198400,360448:2151682112,425984:0,491520:2151677952,557056:4096,622592:2151682048,688128:4194304,753664:4160,819200:2147483648,884736:4194368,950272:4198464,1015808:2147483712,1048576:4194368,1114112:4198400,1179648:2147483712,1245184:0,1310720:4160,1376256:2151678016,1441792:2151682048,1507328:2147487808,1572864:2151682112,1638400:2147483648,1703936:2151677952,1769472:4198464,1835008:2147487744,1900544:4194304,1966080:64,2031616:4096,1081344:2151677952,1146880:2151682112,1212416:0,1277952:4198400,1343488:4194368,1409024:2147483648,1474560:2147487808,1540096:64,1605632:2147483712,1671168:4096,1736704:2147487744,1802240:2151678016,1867776:4160,1933312:2151682048,1998848:4194304,2064384:4198464},{0:128,4096:17039360,8192:262144,12288:536870912,16384:537133184,20480:16777344,24576:553648256,28672:262272,32768:16777216,36864:537133056,40960:536871040,45056:553910400,49152:553910272,53248:0,57344:17039488,61440:553648128,2048:17039488,6144:553648256,10240:128,14336:17039360,18432:262144,22528:537133184,26624:553910272,30720:536870912,34816:537133056,38912:0,43008:553910400,47104:16777344,51200:536871040,55296:553648128,59392:16777216,63488:262272,65536:262144,69632:128,73728:536870912,77824:553648256,81920:16777344,86016:553910272,90112:537133184,94208:16777216,98304:553910400,102400:553648128,106496:17039360,110592:537133056,114688:262272,118784:536871040,122880:0,126976:17039488,67584:553648256,71680:16777216,75776:17039360,79872:537133184,83968:536870912,88064:17039488,92160:128,96256:553910272,100352:262272,104448:553910400,108544:0,112640:553648128,116736:16777344,120832:262144,124928:537133056,129024:536871040},{0:268435464,256:8192,512:270532608,768:270540808,1024:268443648,1280:2097152,1536:2097160,1792:268435456,2048:0,2304:268443656,2560:2105344,2816:8,3072:270532616,3328:2105352,3584:8200,3840:270540800,128:270532608,384:270540808,640:8,896:2097152,1152:2105352,1408:268435464,1664:268443648,1920:8200,2176:2097160,2432:8192,2688:268443656,2944:270532616,3200:0,3456:270540800,3712:2105344,3968:268435456,4096:268443648,4352:270532616,4608:270540808,4864:8200,5120:2097152,5376:268435456,5632:268435464,5888:2105344,6144:2105352,6400:0,6656:8,6912:270532608,7168:8192,7424:268443656,7680:270540800,7936:2097160,4224:8,4480:2105344,4736:2097152,4992:268435464,5248:268443648,5504:8200,5760:270540808,6016:270532608,6272:270540800,6528:270532616,6784:8192,7040:2105352,7296:2097160,7552:0,7808:268435456,8064:268443656},{0:1048576,16:33555457,32:1024,48:1049601,64:34604033,80:0,96:1,112:34603009,128:33555456,144:1048577,160:33554433,176:34604032,192:34603008,208:1025,224:1049600,240:33554432,8:34603009,24:0,40:33555457,56:34604032,72:1048576,88:33554433,104:33554432,120:1025,136:1049601,152:33555456,168:34603008,184:1048577,200:1024,216:34604033,232:1,248:1049600,256:33554432,272:1048576,288:33555457,304:34603009,320:1048577,336:33555456,352:34604032,368:1049601,384:1025,400:34604033,416:1049600,432:1,448:0,464:34603008,480:33554433,496:1024,264:1049600,280:33555457,296:34603009,312:1,328:33554432,344:1048576,360:1025,376:34604032,392:33554433,408:34603008,424:0,440:34604033,456:1049601,472:1024,488:33555456,504:1048577},{0:134219808,1:131072,2:134217728,3:32,4:131104,5:134350880,6:134350848,7:2048,8:134348800,9:134219776,10:133120,11:134348832,12:2080,13:0,14:134217760,15:133152,2147483648:2048,2147483649:134350880,2147483650:134219808,2147483651:134217728,2147483652:134348800,2147483653:133120,2147483654:133152,2147483655:32,2147483656:134217760,2147483657:2080,2147483658:131104,2147483659:134350848,2147483660:0,2147483661:134348832,2147483662:134219776,2147483663:131072,16:133152,17:134350848,18:32,19:2048,20:134219776,21:134217760,22:134348832,23:131072,24:0,25:131104,26:134348800,27:134219808,28:134350880,29:133120,30:2080,31:134217728,2147483664:131072,2147483665:2048,2147483666:134348832,2147483667:133152,2147483668:32,2147483669:134348800,2147483670:134217728,2147483671:134219808,2147483672:134350880,2147483673:134217760,2147483674:134219776,2147483675:0,2147483676:133120,2147483677:2080,2147483678:131104,2147483679:134350848}],p=[4160749569,528482304,33030144,2064384,129024,8064,504,2147483679],h=s.DES=a.extend({_doReset:function(){for(var t=this._key.words,e=[],r=0;r<56;r++){var n=c[r]-1;e[r]=t[n>>>5]>>>31-n%32&1}for(var o=this._subKeys=[],i=0;i<16;i++){var a=o[i]=[],s=f[i];for(r=0;r<24;r++)a[r/6|0]|=e[(u[r]-1+s)%28]<<31-r%6,a[4+(r/6|0)]|=e[28+(u[r+24]-1+s)%28]<<31-r%6;for(a[0]=a[0]<<1|a[0]>>>31,r=1;r<7;r++)a[r]=a[r]>>>4*(r-1)+3;a[7]=a[7]<<5|a[7]>>>27}var l=this._invSubKeys=[];for(r=0;r<16;r++)l[r]=o[15-r]},encryptBlock:function(t,e){this._doCryptBlock(t,e,this._subKeys)},decryptBlock:function(t,e){this._doCryptBlock(t,e,this._invSubKeys)},_doCryptBlock:function(t,n,o){this._lBlock=t[n],this._rBlock=t[n+1],e.call(this,4,252645135),e.call(this,16,65535),r.call(this,2,858993459),r.call(this,8,16711935),e.call(this,1,1431655765);for(var i=0;i<16;i++){for(var a=o[i],s=this._lBlock,c=this._rBlock,u=0,f=0;f<8;f++)u|=l[f][((c^a[f])&p[f])>>>0];this._lBlock=c,this._rBlock=s^u}var h=this._lBlock;this._lBlock=this._rBlock,this._rBlock=h,e.call(this,1,1431655765),r.call(this,8,16711935),r.call(this,2,858993459),e.call(this,16,65535),e.call(this,4,252645135),t[n]=this._lBlock,t[n+1]=this._rBlock},keySize:2,ivSize:2,blockSize:2});n.DES=a._createHelper(h);var d=s.TripleDES=a.extend({_doReset:function(){var t=this._key.words;this._des1=h.createEncryptor(i.create(t.slice(0,2))),this._des2=h.createEncryptor(i.create(t.slice(2,4))),this._des3=h.createEncryptor(i.create(t.slice(4,6)))},encryptBlock:function(t,e){this._des1.encryptBlock(t,e),this._des2.decryptBlock(t,e),this._des3.encryptBlock(t,e)},decryptBlock:function(t,e){this._des3.decryptBlock(t,e),this._des2.encryptBlock(t,e),this._des1.decryptBlock(t,e)},keySize:6,ivSize:2,blockSize:2});n.TripleDES=a._createHelper(d)}(),t.TripleDES},"object"==typeof r?e.exports=r=o(t("./core"),t("./enc-base64"),t("./md5"),t("./evpkdf"),t("./cipher-core")):"function"==typeof define&&define.amd?define(["./core","./enc-base64","./md5","./evpkdf","./cipher-core"],o):o(n.CryptoJS);var n,o},{"./cipher-core":52,"./core":53,"./enc-base64":54,"./evpkdf":56,"./md5":61}],84:[function(t,e,r){n=this,o=function(t){return function(e){var r=t,n=r.lib,o=n.Base,i=n.WordArray,a=r.x64={};a.Word=o.extend({init:function(t,e){this.high=t,this.low=e}}),a.WordArray=o.extend({init:function(t,e){t=this.words=t||[],this.sigBytes=void 0!=e?e:8*t.length},toX32:function(){for(var t=this.words,e=t.length,r=[],n=0;n<e;n++){var o=t[n];r.push(o.high),r.push(o.low)}return i.create(r,this.sigBytes)},clone:function(){for(var t=o.clone.call(this),e=t.words=this.words.slice(0),r=e.length,n=0;n<r;n++)e[n]=e[n].clone();return t}})}(),t},"object"==typeof r?e.exports=r=o(t("./core")):"function"==typeof define&&define.amd?define(["./core"],o):o(n.CryptoJS);var n,o},{"./core":53}],85:[function(t,e,r){!function(t){function n(t){for(var e,r,n=[],o=0,i=t.length;o<i;)(e=t.charCodeAt(o++))>=55296&&e<=56319&&o<i?56320==(64512&(r=t.charCodeAt(o++)))?n.push(((1023&e)<<10)+(1023&r)+65536):(n.push(e),o--):n.push(e);return n}function o(t){if(t>=55296&&t<=57343)throw Error("Lone surrogate U+"+t.toString(16).toUpperCase()+" is not a scalar value")}function i(t,e){return m(t>>e&63|128)}function a(t){if(0==(4294967168&t))return m(t);var e="";return 0==(4294965248&t)?e=m(t>>6&31|192):0==(4294901760&t)?(o(t),e=m(t>>12&15|224),e+=i(t,6)):0==(4292870144&t)&&(e=m(t>>18&7|240),e+=i(t,12),e+=i(t,6)),e+m(63&t|128)}function s(){if(d>=h)throw Error("Invalid byte index");var t=255&p[d];if(d++,128==(192&t))return 63&t;throw Error("Invalid continuation byte")}function c(){var t,e,r,n,i;if(d>h)throw Error("Invalid byte index");if(d==h)return!1;if(t=255&p[d],d++,0==(128&t))return t;if(192==(224&t)){if((i=(31&t)<<6|(e=s()))>=128)return i;throw Error("Invalid continuation byte")}if(224==(240&t)){if((i=(15&t)<<12|(e=s())<<6|(r=s()))>=2048)return o(i),i;throw Error("Invalid continuation byte")}if(240==(248&t)&&(e=s(),r=s(),n=s(),(i=(7&t)<<18|e<<12|r<<6|n)>=65536&&i<=1114111))return i;throw Error("Invalid UTF-8 detected")}var u="object"==typeof r&&r,f="object"==typeof e&&e&&e.exports==u&&e,l="object"==typeof global&&global;l.global!==l&&l.window!==l||(t=l);var p,h,d,m=String.fromCharCode,y={version:"2.1.2",encode:function(t){for(var e=n(t),r=e.length,o=-1,i="";++o<r;)i+=a(e[o]);return i},decode:function(t){p=n(t),h=p.length,d=0;for(var e,r=[];!1!==(e=c());)r.push(e);return function(t){for(var e,r=t.length,n=-1,o="";++n<r;)(e=t[n])>65535&&(o+=m((e-=65536)>>>10&1023|55296),e=56320|1023&e),o+=m(e);return o}(r)}};if("function"==typeof define&&"object"==typeof define.amd&&define.amd)define(function(){return y});else if(u&&!u.nodeType)if(f)f.exports=y;else{var g={}.hasOwnProperty;for(var v in y)g.call(y,v)&&(u[v]=y[v])}else t.utf8=y}(this)},{}],86:[function(t,e,r){e.exports=XMLHttpRequest},{}],"bignumber.js":[function(t,e,r){!function(r){"use strict";function n(t){var e=0|t;return t>0||t===e?e:e-1}function o(t){for(var e,r,n=1,o=t.length,i=t[0]+"";n<o;){for(e=t[n++]+"",r=k-e.length;r--;e="0"+e);i+=e}for(o=i.length;48===i.charCodeAt(--o););return i.slice(0,o+1||1)}function i(t,e){var r,n,o=t.c,i=e.c,a=t.s,s=e.s,c=t.e,u=e.e;if(!a||!s)return null;if(r=o&&!o[0],n=i&&!i[0],r||n)return r?n?0:-s:a;if(a!=s)return a;if(r=a<0,n=c==u,!o||!i)return n?0:!o^r?1:-1;if(!n)return c>u^r?1:-1;for(s=(c=o.length)<(u=i.length)?c:u,a=0;a<s;a++)if(o[a]!=i[a])return o[a]>i[a]^r?1:-1;return c==u?0:c>u^r?1:-1}function a(t,e,r){return(t=l(t))>=e&&t<=r}function s(t){return"[object Array]"==Object.prototype.toString.call(t)}function c(t,e,r){for(var n,o,i=[0],a=0,s=t.length;a<s;){for(o=i.length;o--;i[o]*=e);for(i[n=0]+=w.indexOf(t.charAt(a++));n<i.length;n++)i[n]>r-1&&(null==i[n+1]&&(i[n+1]=0),i[n+1]+=i[n]/r|0,i[n]%=r)}return i.reverse()}function u(t,e){return(t.length>1?t.charAt(0)+"."+t.slice(1):t)+(e<0?"e":"e+")+e}function f(t,e){var r,n;if(e<0){for(n="0.";++e;n+="0");t=n+t}else if(r=t.length,++e>r){for(n="0",e-=r;--e;n+="0");t+=n}else e<r&&(t=t.slice(0,e)+"."+t.slice(e));return t}function l(t){return(t=parseFloat(t))<0?y(t):g(t)}var p,h,d,m=/^-?(\d+(\.\d*)?|\.\d+)(e[+-]?\d+)?$/i,y=Math.ceil,g=Math.floor,v=" not a boolean or binary digit",b="rounding mode",_="number type has more than 15 significant digits",w="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$_",x=1e14,k=14,B=9007199254740991,S=[1,10,100,1e3,1e4,1e5,1e6,1e7,1e8,1e9,1e10,1e11,1e12,1e13],A=1e7,C=1e9;if(p=function t(e){function r(t,e){var n,o,i,a,s,c,u=this;if(!(u instanceof r))return W&&I(26,"constructor call without new",t),new r(t,e);if(null!=e&&J(e,2,64,R,"base")){if(c=t+"",10==(e|=0))return u=new r(t instanceof r?t:c),P(u,H+u.e+1,j);if((a="number"==typeof t)&&0*t!=0||!new RegExp("^-?"+(n="["+w.slice(0,e)+"]+")+"(?:\\."+n+")?$",e<37?"i":"").test(c))return d(u,c,a,e);a?(u.s=1/t<0?(c=c.slice(1),-1):1,W&&c.replace(/^0\.0*|\./,"").length>15&&I(R,_,t),a=!1):u.s=45===c.charCodeAt(0)?(c=c.slice(1),-1):1,c=p(c,10,e,u.s)}else{if(t instanceof r)return u.s=t.s,u.e=t.e,u.c=(t=t.c)?t.slice():t,void(R=0);if((a="number"==typeof t)&&0*t==0){if(u.s=1/t<0?(t=-t,-1):1,t===~~t){for(o=0,i=t;i>=10;i/=10,o++);return u.e=o,u.c=[t],void(R=0)}c=t+""}else{if(!m.test(c=t+""))return d(u,c,a);u.s=45===c.charCodeAt(0)?(c=c.slice(1),-1):1}}for((o=c.indexOf("."))>-1&&(c=c.replace(".","")),(i=c.search(/e/i))>0?(o<0&&(o=i),o+=+c.slice(i+1),c=c.substring(0,i)):o<0&&(o=c.length),i=0;48===c.charCodeAt(i);i++);for(s=c.length;48===c.charCodeAt(--s););if(c=c.slice(i,s+1))if(s=c.length,a&&W&&s>15&&I(R,_,u.s*t),(o=o-i-1)>U)u.c=u.e=null;else if(o<L)u.c=[u.e=0];else{if(u.e=o,u.c=[],i=(o+1)%k,o<0&&(i+=k),i<s){for(i&&u.c.push(+c.slice(0,i)),s-=k;i<s;)u.c.push(+c.slice(i,i+=k));c=c.slice(i),i=k-c.length}else i-=s;for(;i--;c+="0");u.c.push(+c)}else u.c=[u.e=0];R=0}function p(t,e,n,i){var a,s,u,l,p,h,d,m=t.indexOf("."),y=H,g=j;for(n<37&&(t=t.toLowerCase()),m>=0&&(u=X,X=0,t=t.replace(".",""),p=(d=new r(n)).pow(t.length-m),X=u,d.c=c(f(o(p.c),p.e),10,e),d.e=d.c.length),s=u=(h=c(t,n,e)).length;0==h[--u];h.pop());if(!h[0])return"0";if(m<0?--s:(p.c=h,p.e=s,p.s=i,h=(p=D(p,d,y,g,e)).c,l=p.r,s=p.e),m=h[a=s+y+1],u=e/2,l=l||a<0||null!=h[a+1],l=g<4?(null!=m||l)&&(0==g||g==(p.s<0?3:2)):m>u||m==u&&(4==g||l||6==g&&1&h[a-1]||g==(p.s<0?8:7)),a<1||!h[0])t=l?f("1",-y):"0";else{if(h.length=a,l)for(--e;++h[--a]>e;)h[a]=0,a||(++s,h.unshift(1));for(u=h.length;!h[--u];);for(m=0,t="";m<=u;t+=w.charAt(h[m++]));t=f(t,s)}return t}function F(t,e,n,i){var a,s,c,l,p;if(n=null!=n&&J(n,0,8,i,b)?0|n:j,!t.c)return t.toString();if(a=t.c[0],c=t.e,null==e)p=o(t.c),p=19==i||24==i&&c<=q?u(p,c):f(p,c);else if(t=P(new r(t),e,n),s=t.e,p=o(t.c),l=p.length,19==i||24==i&&(e<=s||s<=q)){for(;l<e;p+="0",l++);p=u(p,s)}else if(e-=c,p=f(p,s),s+1>l){if(--e>0)for(p+=".";e--;p+="0");}else if((e+=s-l)>0)for(s+1==l&&(p+=".");e--;p+="0");return t.s<0&&a?"-"+p:p}function O(t,e){var n,o,i=0;for(s(t[0])&&(t=t[0]),n=new r(t[0]);++i<t.length;){if(!(o=new r(t[i])).s){n=o;break}e.call(n,o)&&(n=o)}return n}function N(t,e,r,n,o){return(t<e||t>r||t!=l(t))&&I(n,(o||"decimal places")+(t<e||t>r?" out of range":" not an integer"),t),!0}function T(t,e,r){for(var n=1,o=e.length;!e[--o];e.pop());for(o=e[0];o>=10;o/=10,n++);return(r=n+r*k-1)>U?t.c=t.e=null:r<L?t.c=[t.e=0]:(t.e=r,t.c=e),t}function I(t,e,r){var n=new Error(["new BigNumber","cmp","config","div","divToInt","eq","gt","gte","lt","lte","minus","mod","plus","precision","random","round","shift","times","toDigits","toExponential","toFixed","toFormat","toFraction","pow","toPrecision","toString","BigNumber"][t]+"() "+e+": "+r);throw n.name="BigNumber Error",R=0,n}function P(t,e,r,n){var o,i,a,s,c,u,f,l=t.c,p=S;if(l){t:{for(o=1,s=l[0];s>=10;s/=10,o++);if((i=e-o)<0)i+=k,a=e,f=(c=l[u=0])/p[o-a-1]%10|0;else if((u=y((i+1)/k))>=l.length){if(!n)break t;for(;l.length<=u;l.push(0));c=f=0,o=1,a=(i%=k)-k+1}else{for(c=s=l[u],o=1;s>=10;s/=10,o++);f=(a=(i%=k)-k+o)<0?0:c/p[o-a-1]%10|0}if(n=n||e<0||null!=l[u+1]||(a<0?c:c%p[o-a-1]),n=r<4?(f||n)&&(0==r||r==(t.s<0?3:2)):f>5||5==f&&(4==r||n||6==r&&(i>0?a>0?c/p[o-a]:0:l[u-1])%10&1||r==(t.s<0?8:7)),e<1||!l[0])return l.length=0,n?(e-=t.e+1,l[0]=p[e%k],t.e=-e||0):l[0]=t.e=0,t;if(0==i?(l.length=u,s=1,u--):(l.length=u+1,s=p[k-i],l[u]=a>0?g(c/p[o-a]%p[a])*s:0),n)for(;;){if(0==u){for(i=1,a=l[0];a>=10;a/=10,i++);for(a=l[0]+=s,s=1;a>=10;a/=10,s++);i!=s&&(t.e++,l[0]==x&&(l[0]=1));break}if(l[u]+=s,l[u]!=x)break;l[u--]=0,s=1}for(i=l.length;0===l[--i];l.pop());}t.e>U?t.c=t.e=null:t.e<L&&(t.c=[t.e=0])}return t}var D,R=0,E=r.prototype,M=new r(1),H=20,j=4,q=-7,z=21,L=-1e7,U=1e7,W=!0,J=N,K=!1,G=1,X=100,$={decimalSeparator:".",groupSeparator:",",groupSize:3,secondaryGroupSize:0,fractionGroupSeparator:" ",fractionGroupSize:0};return r.another=t,r.ROUND_UP=0,r.ROUND_DOWN=1,r.ROUND_CEIL=2,r.ROUND_FLOOR=3,r.ROUND_HALF_UP=4,r.ROUND_HALF_DOWN=5,r.ROUND_HALF_EVEN=6,r.ROUND_HALF_CEIL=7,r.ROUND_HALF_FLOOR=8,r.EUCLID=9,r.config=function(){var t,e,r=0,n={},o=arguments,i=o[0],c=i&&"object"==typeof i?function(){if(i.hasOwnProperty(e))return null!=(t=i[e])}:function(){if(o.length>r)return null!=(t=o[r++])};return c(e="DECIMAL_PLACES")&&J(t,0,C,2,e)&&(H=0|t),n[e]=H,c(e="ROUNDING_MODE")&&J(t,0,8,2,e)&&(j=0|t),n[e]=j,c(e="EXPONENTIAL_AT")&&(s(t)?J(t[0],-C,0,2,e)&&J(t[1],0,C,2,e)&&(q=0|t[0],z=0|t[1]):J(t,-C,C,2,e)&&(q=-(z=0|(t<0?-t:t)))),n[e]=[q,z],c(e="RANGE")&&(s(t)?J(t[0],-C,-1,2,e)&&J(t[1],1,C,2,e)&&(L=0|t[0],U=0|t[1]):J(t,-C,C,2,e)&&(0|t?L=-(U=0|(t<0?-t:t)):W&&I(2,e+" cannot be zero",t))),n[e]=[L,U],c(e="ERRORS")&&(t===!!t||1===t||0===t?(R=0,J=(W=!!t)?N:a):W&&I(2,e+v,t)),n[e]=W,c(e="CRYPTO")&&(t===!!t||1===t||0===t?(K=!(!t||!h||"object"!=typeof h),t&&!K&&W&&I(2,"crypto unavailable",h)):W&&I(2,e+v,t)),n[e]=K,c(e="MODULO_MODE")&&J(t,0,9,2,e)&&(G=0|t),n[e]=G,c(e="POW_PRECISION")&&J(t,0,C,2,e)&&(X=0|t),n[e]=X,c(e="FORMAT")&&("object"==typeof t?$=t:W&&I(2,e+" not an object",t)),n[e]=$,n},r.max=function(){return O(arguments,E.lt)},r.min=function(){return O(arguments,E.gt)},r.random=function(){var t=9007199254740992*Math.random()&2097151?function(){return g(9007199254740992*Math.random())}:function(){return 8388608*(1073741824*Math.random()|0)+(8388608*Math.random()|0)};return function(e){var n,o,i,a,s,c=0,u=[],f=new r(M);if(e=null!=e&&J(e,0,C,14)?0|e:H,a=y(e/k),K)if(h&&h.getRandomValues){for(n=h.getRandomValues(new Uint32Array(a*=2));c<a;)(s=131072*n[c]+(n[c+1]>>>11))>=9e15?(o=h.getRandomValues(new Uint32Array(2)),n[c]=o[0],n[c+1]=o[1]):(u.push(s%1e14),c+=2);c=a/2}else if(h&&h.randomBytes){for(n=h.randomBytes(a*=7);c<a;)(s=281474976710656*(31&n[c])+1099511627776*n[c+1]+4294967296*n[c+2]+16777216*n[c+3]+(n[c+4]<<16)+(n[c+5]<<8)+n[c+6])>=9e15?h.randomBytes(7).copy(n,c):(u.push(s%1e14),c+=7);c=a/7}else W&&I(14,"crypto unavailable",h);if(!c)for(;c<a;)(s=t())<9e15&&(u[c++]=s%1e14);for(a=u[--c],e%=k,a&&e&&(s=S[k-e],u[c]=g(a/s)*s);0===u[c];u.pop(),c--);if(c<0)u=[i=0];else{for(i=-1;0===u[0];u.shift(),i-=k);for(c=1,s=u[0];s>=10;s/=10,c++);c<k&&(i-=k-c)}return f.e=i,f.c=u,f}}(),D=function(){function t(t,e,r){var n,o,i,a,s=0,c=t.length,u=e%A,f=e/A|0;for(t=t.slice();c--;)s=((o=u*(i=t[c]%A)+(n=f*i+(a=t[c]/A|0)*u)%A*A+s)/r|0)+(n/A|0)+f*a,t[c]=o%r;return s&&t.unshift(s),t}function e(t,e,r,n){var o,i;if(r!=n)i=r>n?1:-1;else for(o=i=0;o<r;o++)if(t[o]!=e[o]){i=t[o]>e[o]?1:-1;break}return i}function o(t,e,r,n){for(var o=0;r--;)t[r]-=o,o=t[r]<e[r]?1:0,t[r]=o*n+t[r]-e[r];for(;!t[0]&&t.length>1;t.shift());}return function(i,a,s,c,u){var f,l,p,h,d,m,y,v,b,_,w,B,S,A,C,F,O,N=i.s==a.s?1:-1,T=i.c,I=a.c;if(!(T&&T[0]&&I&&I[0]))return new r(i.s&&a.s&&(T?!I||T[0]!=I[0]:I)?T&&0==T[0]||!I?0*N:N/0:NaN);for(b=(v=new r(N)).c=[],N=s+(l=i.e-a.e)+1,u||(u=x,l=n(i.e/k)-n(a.e/k),N=N/k|0),p=0;I[p]==(T[p]||0);p++);if(I[p]>(T[p]||0)&&l--,N<0)b.push(1),h=!0;else{for(A=T.length,F=I.length,p=0,N+=2,(d=g(u/(I[0]+1)))>1&&(I=t(I,d,u),T=t(T,d,u),F=I.length,A=T.length),S=F,w=(_=T.slice(0,F)).length;w<F;_[w++]=0);(O=I.slice()).unshift(0),C=I[0],I[1]>=u/2&&C++;do{if(d=0,(f=e(I,_,F,w))<0){if(B=_[0],F!=w&&(B=B*u+(_[1]||0)),(d=g(B/C))>1)for(d>=u&&(d=u-1),y=(m=t(I,d,u)).length,w=_.length;1==e(m,_,y,w);)d--,o(m,F<y?O:I,y,u),y=m.length,f=1;else 0==d&&(f=d=1),y=(m=I.slice()).length;if(y<w&&m.unshift(0),o(_,m,w,u),w=_.length,-1==f)for(;e(I,_,F,w)<1;)d++,o(_,F<w?O:I,w,u),w=_.length}else 0===f&&(d++,_=[0]);b[p++]=d,_[0]?_[w++]=T[S]||0:(_=[T[S]],w=1)}while((S++<A||null!=_[0])&&N--);h=null!=_[0],b[0]||b.shift()}if(u==x){for(p=1,N=b[0];N>=10;N/=10,p++);P(v,s+(v.e=p+l*k-1)+1,c,h)}else v.e=l,v.r=+h;return v}}(),d=function(){var t=/^(-?)0([xbo])/i,e=/^([^.]+)\.$/,n=/^\.([^.]+)$/,o=/^-?(Infinity|NaN)$/,i=/^\s*\+|^\s+|\s+$/g;return function(a,s,c,u){var f,l=c?s:s.replace(i,"");if(o.test(l))a.s=isNaN(l)?null:l<0?-1:1;else{if(!c&&(l=l.replace(t,function(t,e,r){return f="x"==(r=r.toLowerCase())?16:"b"==r?2:8,u&&u!=f?t:e}),u&&(f=u,l=l.replace(e,"$1").replace(n,"0.$1")),s!=l))return new r(l,f);W&&I(R,"not a"+(u?" base "+u:"")+" number",s),a.s=null}a.c=a.e=null,R=0}}(),E.absoluteValue=E.abs=function(){var t=new r(this);return t.s<0&&(t.s=1),t},E.ceil=function(){return P(new r(this),this.e+1,2)},E.comparedTo=E.cmp=function(t,e){return R=1,i(this,new r(t,e))},E.decimalPlaces=E.dp=function(){var t,e,r=this.c;if(!r)return null;if(t=((e=r.length-1)-n(this.e/k))*k,e=r[e])for(;e%10==0;e/=10,t--);return t<0&&(t=0),t},E.dividedBy=E.div=function(t,e){return R=3,D(this,new r(t,e),H,j)},E.dividedToIntegerBy=E.divToInt=function(t,e){return R=4,D(this,new r(t,e),0,1)},E.equals=E.eq=function(t,e){return R=5,0===i(this,new r(t,e))},E.floor=function(){return P(new r(this),this.e+1,3)},E.greaterThan=E.gt=function(t,e){return R=6,i(this,new r(t,e))>0},E.greaterThanOrEqualTo=E.gte=function(t,e){return R=7,1===(e=i(this,new r(t,e)))||0===e},E.isFinite=function(){return!!this.c},E.isInteger=E.isInt=function(){return!!this.c&&n(this.e/k)>this.c.length-2},E.isNaN=function(){return!this.s},E.isNegative=E.isNeg=function(){return this.s<0},E.isZero=function(){return!!this.c&&0==this.c[0]},E.lessThan=E.lt=function(t,e){return R=8,i(this,new r(t,e))<0},E.lessThanOrEqualTo=E.lte=function(t,e){return R=9,-1===(e=i(this,new r(t,e)))||0===e},E.minus=E.sub=function(t,e){var o,i,a,s,c=this.s;if(R=10,e=(t=new r(t,e)).s,!c||!e)return new r(NaN);if(c!=e)return t.s=-e,this.plus(t);var u=this.e/k,f=t.e/k,l=this.c,p=t.c;if(!u||!f){if(!l||!p)return l?(t.s=-e,t):new r(p?this:NaN);if(!l[0]||!p[0])return p[0]?(t.s=-e,t):new r(l[0]?this:3==j?-0:0)}if(u=n(u),f=n(f),l=l.slice(),c=u-f){for((s=c<0)?(c=-c,a=l):(f=u,a=p),a.reverse(),e=c;e--;a.push(0));a.reverse()}else for(i=(s=(c=l.length)<(e=p.length))?c:e,c=e=0;e<i;e++)if(l[e]!=p[e]){s=l[e]<p[e];break}if(s&&(a=l,l=p,p=a,t.s=-t.s),(e=(i=p.length)-(o=l.length))>0)for(;e--;l[o++]=0);for(e=x-1;i>c;){if(l[--i]<p[i]){for(o=i;o&&!l[--o];l[o]=e);--l[o],l[i]+=x}l[i]-=p[i]}for(;0==l[0];l.shift(),--f);return l[0]?T(t,l,f):(t.s=3==j?-1:1,t.c=[t.e=0],t)},E.modulo=E.mod=function(t,e){var n,o;return R=11,t=new r(t,e),!this.c||!t.s||t.c&&!t.c[0]?new r(NaN):!t.c||this.c&&!this.c[0]?new r(this):(9==G?(o=t.s,t.s=1,n=D(this,t,0,3),t.s=o,n.s*=o):n=D(this,t,0,G),this.minus(n.times(t)))},E.negated=E.neg=function(){var t=new r(this);return t.s=-t.s||null,t},E.plus=E.add=function(t,e){var o,i=this.s;if(R=12,e=(t=new r(t,e)).s,!i||!e)return new r(NaN);if(i!=e)return t.s=-e,this.minus(t);var a=this.e/k,s=t.e/k,c=this.c,u=t.c;if(!a||!s){if(!c||!u)return new r(i/0);if(!c[0]||!u[0])return u[0]?t:new r(c[0]?this:0*i)}if(a=n(a),s=n(s),c=c.slice(),i=a-s){for(i>0?(s=a,o=u):(i=-i,o=c),o.reverse();i--;o.push(0));o.reverse()}for((i=c.length)-(e=u.length)<0&&(o=u,u=c,c=o,e=i),i=0;e;)i=(c[--e]=c[e]+u[e]+i)/x|0,c[e]%=x;return i&&(c.unshift(i),++s),T(t,c,s)},E.precision=E.sd=function(t){var e,r,n=this.c;if(null!=t&&t!==!!t&&1!==t&&0!==t&&(W&&I(13,"argument"+v,t),t!=!!t&&(t=null)),!n)return null;if(e=(r=n.length-1)*k+1,r=n[r]){for(;r%10==0;r/=10,e--);for(r=n[0];r>=10;r/=10,e++);}return t&&this.e+1>e&&(e=this.e+1),e},E.round=function(t,e){var n=new r(this);return(null==t||J(t,0,C,15))&&P(n,~~t+this.e+1,null!=e&&J(e,0,8,15,b)?0|e:j),n},E.shift=function(t){return J(t,-B,B,16,"argument")?this.times("1e"+l(t)):new r(this.c&&this.c[0]&&(t<-B||t>B)?this.s*(t<0?0:1/0):this)},E.squareRoot=E.sqrt=function(){var t,e,i,a,s,c=this.c,u=this.s,f=this.e,l=H+4,p=new r("0.5");if(1!==u||!c||!c[0])return new r(!u||u<0&&(!c||c[0])?NaN:c?this:1/0);if(0==(u=Math.sqrt(+this))||u==1/0?(((e=o(c)).length+f)%2==0&&(e+="0"),u=Math.sqrt(e),f=n((f+1)/2)-(f<0||f%2),i=new r(e=u==1/0?"1e"+f:(e=u.toExponential()).slice(0,e.indexOf("e")+1)+f)):i=new r(u+""),i.c[0])for((u=(f=i.e)+l)<3&&(u=0);;)if(s=i,i=p.times(s.plus(D(this,s,l,1))),o(s.c).slice(0,u)===(e=o(i.c)).slice(0,u)){if(i.e<f&&--u,"9999"!=(e=e.slice(u-3,u+1))&&(a||"4999"!=e)){+e&&(+e.slice(1)||"5"!=e.charAt(0))||(P(i,i.e+H+2,1),t=!i.times(i).eq(this));break}if(!a&&(P(s,s.e+H+2,0),s.times(s).eq(this))){i=s;break}l+=4,u+=4,a=1}return P(i,i.e+H+1,j,t)},E.times=E.mul=function(t,e){var o,i,a,s,c,u,f,l,p,h,d,m,y,g,v,b=this.c,_=(R=17,t=new r(t,e)).c;if(!(b&&_&&b[0]&&_[0]))return!this.s||!t.s||b&&!b[0]&&!_||_&&!_[0]&&!b?t.c=t.e=t.s=null:(t.s*=this.s,b&&_?(t.c=[0],t.e=0):t.c=t.e=null),t;for(i=n(this.e/k)+n(t.e/k),t.s*=this.s,(f=b.length)<(h=_.length)&&(y=b,b=_,_=y,a=f,f=h,h=a),a=f+h,y=[];a--;y.push(0));for(g=x,v=A,a=h;--a>=0;){for(o=0,d=_[a]%v,m=_[a]/v|0,s=a+(c=f);s>a;)o=((l=d*(l=b[--c]%v)+(u=m*l+(p=b[c]/v|0)*d)%v*v+y[s]+o)/g|0)+(u/v|0)+m*p,y[s--]=l%g;y[s]=o}return o?++i:y.shift(),T(t,y,i)},E.toDigits=function(t,e){var n=new r(this);return t=null!=t&&J(t,1,C,18,"precision")?0|t:null,e=null!=e&&J(e,0,8,18,b)?0|e:j,t?P(n,t,e):n},E.toExponential=function(t,e){return F(this,null!=t&&J(t,0,C,19)?1+~~t:null,e,19)},E.toFixed=function(t,e){return F(this,null!=t&&J(t,0,C,20)?~~t+this.e+1:null,e,20)},E.toFormat=function(t,e){var r=F(this,null!=t&&J(t,0,C,21)?~~t+this.e+1:null,e,21);if(this.c){var n,o=r.split("."),i=+$.groupSize,a=+$.secondaryGroupSize,s=$.groupSeparator,c=o[0],u=o[1],f=this.s<0,l=f?c.slice(1):c,p=l.length;if(a&&(n=i,i=a,a=n,p-=n),i>0&&p>0){for(n=p%i||i,c=l.substr(0,n);n<p;n+=i)c+=s+l.substr(n,i);a>0&&(c+=s+l.slice(n)),f&&(c="-"+c)}r=u?c+$.decimalSeparator+((a=+$.fractionGroupSize)?u.replace(new RegExp("\\d{"+a+"}\\B","g"),"$&"+$.fractionGroupSeparator):u):c}return r},E.toFraction=function(t){var e,n,i,a,s,c,u,f,l,p=W,h=this.c,d=new r(M),m=n=new r(M),y=u=new r(M);if(null!=t&&(W=!1,c=new r(t),W=p,(p=c.isInt())&&!c.lt(M)||(W&&I(22,"max denominator "+(p?"out of range":"not an integer"),t),t=!p&&c.c&&P(c,c.e+1,1).gte(M)?c:null)),!h)return this.toString();for(l=o(h),a=d.e=l.length-this.e-1,d.c[0]=S[(s=a%k)<0?k+s:s],t=!t||c.cmp(d)>0?a>0?d:m:c,s=U,U=1/0,c=new r(l),u.c[0]=0;f=D(c,d,0,1),1!=(i=n.plus(f.times(y))).cmp(t);)n=y,y=i,m=u.plus(f.times(i=m)),u=i,d=c.minus(f.times(i=d)),c=i;return i=D(t.minus(n),y,0,1),u=u.plus(i.times(m)),n=n.plus(i.times(y)),u.s=m.s=this.s,e=D(m,y,a*=2,j).minus(this).abs().cmp(D(u,n,a,j).minus(this).abs())<1?[m.toString(),y.toString()]:[u.toString(),n.toString()],U=s,e},E.toNumber=function(){return+this||(this.s?0*this.s:NaN)},E.toPower=E.pow=function(t){var e,n,o=g(t<0?-t:+t),i=this;if(!J(t,-B,B,23,"exponent")&&(!isFinite(t)||o>B&&(t/=0)||parseFloat(t)!=t&&!(t=NaN)))return new r(Math.pow(+i,t));for(e=X?y(X/k+2):0,n=new r(M);;){if(o%2){if(!(n=n.times(i)).c)break;e&&n.c.length>e&&(n.c.length=e)}if(!(o=g(o/2)))break;i=i.times(i),e&&i.c&&i.c.length>e&&(i.c.length=e)}return t<0&&(n=M.div(n)),e?P(n,X,j):n},E.toPrecision=function(t,e){return F(this,null!=t&&J(t,1,C,24,"precision")?0|t:null,e,24)},E.toString=function(t){var e,r=this.s,n=this.e;return null===n?r?(e="Infinity",r<0&&(e="-"+e)):e="NaN":(e=o(this.c),e=null!=t&&J(t,2,64,25,"base")?p(f(e,n),0|t,10,r):n<=q||n>=z?u(e,n):f(e,n),r<0&&this.c[0]&&(e="-"+e)),e},E.truncated=E.trunc=function(){return P(new r(this),this.e+1,1)},E.valueOf=E.toJSON=function(){return this.toString()},null!=e&&r.config(e),r}(),"function"==typeof define&&define.amd)define(function(){return p});else if(void 0!==e&&e.exports){if(e.exports=p,!h)try{h=t("crypto")}catch(t){}}else r.BigNumber=p}(this)},{crypto:50}],web3:[function(t,e,r){var n=t("./lib/web3");"undefined"!=typeof window&&void 0===window.Web3&&(window.Web3=n),e.exports=n},{"./lib/web3":22}]},{},["web3"]);

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {},_dereq_("buffer").Buffer)

},{"buffer":22}],140:[function(_dereq_,module,exports){
module.exports=wrappy;function wrappy(n,r){if(n&&r)return wrappy(n)(r);if("function"!=typeof n)throw new TypeError("need wrapper function");return Object.keys(n).forEach(function(r){e[r]=n[r]}),e;function e(){for(var r=new Array(arguments.length),e=0;e<r.length;e++)r[e]=arguments[e];var t=n.apply(this,r),o=r[r.length-1];return"function"==typeof t&&t!==o&&Object.keys(o).forEach(function(n){t[n]=o[n]}),t}}

},{}],141:[function(_dereq_,module,exports){
module.exports=extend;var hasOwnProperty=Object.prototype.hasOwnProperty;function extend(){for(var r={},e=0;e<arguments.length;e++){var t=arguments[e];for(var n in t)hasOwnProperty.call(t,n)&&(r[n]=t[n])}return r}

},{}]},{},[1])

//# sourceMappingURL=../sourcemaps/inpage.js.map
//# sourceURL=chrome-extension://nkbihfbeogaeaoehlefnkodbefgpgknn/inpage.js
</script><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		
		<!--
		The MIT License (MIT)

		Copyright (c) 2014, 2015, the individual contributors

		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:

		The above copyright notice and this permission notice shall be included in
		all copies or substantial portions of the Software.

		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
		THE SOFTWARE.
		-->
		<meta http-equiv="X-UA-Compatible" content="chrome=1">
		<title>Remix - Solidity IDE</title>
		<link rel="stylesheet" href="./PointsStore_files/pygment_trac.css">
		<link rel="stylesheet" href="./PointsStore_files/font-awesome.min.css">
		<link rel="icon" type="x-icon" href="https://remix.ethereum.org/icon.png">
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
	<style type="text/css">
  .modal_3lIjRo {
    display: none; /* Hidden by default */
    position: fixed; /* Stay in place */
    z-index: 1000; /* Sit on top of everything including the dragbar */
    left: 0;
    top: 0;
    width: 100%; /* Full width */
    height: 100%; /* Full height */
    overflow: auto; /* Enable scroll if needed */
    background-color: hsl(0, 0%, 0%); /* Fallback color */
    background-color: hsla(0, 0%, 0%, .4); /* Black w/ opacity */
  }
  .modalHeader_3lIjRo {
    padding: 2px 16px;
    background-color: hsla(229, 100%, 97%, 1);
    color: hsl(0, 0%, 0%);
    display: flex;
    justify-content: space-between;
  }
  .modalBody_3lIjRo {
    background-color: hsl(0, 0%, 100%);
    color: hsl(0, 0%, 0%);
    padding: 1.5em;
    line-height: 1.5em;
  }
  .modalBody_3lIjRo em{
    color: hsla(148, 79%, 47%, 1);
  }
  .modalBody_3lIjRo a{
    color: hsla(233, 91%, 58%, 1);
  }
  .modalFooter_3lIjRo {
    display: flex;
    justify-content: flex-end;
    padding: 10px 30px;
    background-color: hsla(229, 100%, 97%, 1);
    color: hsl(0, 0%, 0%);
    text-align: right;
    font-weight: 700;
    cursor: pointer;
  }
  .modalContent_3lIjRo {
    position: relative;
    background-color: hsl(0, 0%, 0%);
    margin: auto;
    padding: 0;
    line-height: 18px;
    font-size: 12px;
    border: 1px solid hsla(0, 0%, 40%, 1);
    width: 50%;
    box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19);
    -webkit-animation-name: animatetop_3lIjRo;
    -webkit-animation-duration: 0.4s;
    animation-name: animatetop_3lIjRo;
    animation-duration: 0.4s
  }
  .modalFooterOk_3lIjRo {
    cursor: pointer;
    color: hsl(0, 0%, 0%);
  }
  .modalFooterCancel_3lIjRo {
    margin-left: 1em;
    cursor: pointer;
    color: hsl(0, 0%, 0%);
  }
  .modalClose_3lIjRo {
    margin: auto 0;
    color: hsl(0, 0%, 0%);
    cursor: pointer;
  }
  .modalBackground_3lIjRo {
    width: 100%;
    height: 100%;
    position: fixed;
    top:0;
  }
  @-webkit-keyframes animatetop_3lIjRo {
    from {top: -300px; opacity: 0}
    to {top: 0; opacity: 1}
  }
  @keyframes animatetop_3lIjRo {
    from {top: -300px; opacity: 0}
    to {top: 0; opacity: 1}
  }
</style><style type="text/css">
  .prompt_text_1BBRpJ {
    width: 300px;
  }
</style><style type="text/css">
  .li_tv_x3Aa6 {
    list-style-type: none;
    -webkit-margin-before: 0px;
    -webkit-margin-after: 0px;
    -webkit-margin-start: 0px;
    -webkit-margin-end: 0px;
    -webkit-padding-start: 0px;
    margin-left: 10px;
  }
  .ul_tv_x3Aa6 {
    list-style-type: none;
    -webkit-margin-before: 0px;
    -webkit-margin-after: 0px;
    -webkit-margin-start: 0px;
    -webkit-margin-end: 0px;
    -webkit-padding-start: 0px;
  }
  .caret_tv_x3Aa6 {
    width: 10px;
  }
  .label_tv_x3Aa6 {
    display: flex;
    align-items: center;
  }
</style><style type="text/css">
  .txInfoBox_1ueDSE {
    
        background-color      : hsla(229, 100%, 97%, 1);
        border                : 1px solid hsl(0, 0%, 100%);
        color                 : hsl(0, 0%, 0%);
        border-radius         : 3px;
        font-size             : 12px;
        padding               : 10px 15px;
        line-height           : 20px;
        overflow              : hidden;
        word-break            : break-word;
        width                 : 100%;
      ;  // add askToConfirmTXContainer to Remix and then replace this styling
  }
  .wrapword_1ueDSE {
    white-space: pre-wrap;       /* Since CSS 2.1 */
    white-space: -moz-pre-wrap;  /* Mozilla, since 1999 */
    white-space: -pre-wrap;      /* Opera 4-6 */
    white-space: -o-pre-wrap;    /* Opera 7 */
    word-wrap: break-word;       /* Internet Explorer 5.5+ */
  }
</style><style type="text/css">
  .tooltip_1ICrLe {
    z-index: 1001;
    display: inline-block;
    position: fixed;
    background-color: hsla(0, 0%, 40%, 1);
    color: hsl(0, 0%, 100%);
    min-height: 50px;
    min-width: 290px;
    padding: 16px 24px 12px;
    border-radius: 3px;
    bottom: -300;
    left: 40%;
    font-size: 12px;
    text-align: center;
    -webkit-animation-name: animatebottom_1ICrLe;
    -webkit-animation-duration: 6s;
    animation-name: animatebottom_1ICrLe;
    animation-duration: 6s
  }
  @-webkit-keyframes animatebottom_1ICrLe  {
    0% {bottom: -300px}
    20% {bottom: 0}
    50% {bottom: 0}
    100% {bottom: -300px}
  }
  @keyframes animatebottom_1ICrLe  {
    0% {bottom: -300px}
    20% {bottom: 0}
    50% {bottom: 0}
    100% {bottom: -300px}
  }
</style><style type="text/css">
  .copyIcon_3sVBlb {
    margin-left: 5px;
    cursor: pointer;
  }
</style><style type="text/css">
  .instanceTitleContainer_i5hXx {
    display: flex;
    align-items: center;
  }
  .title_i5hXx {
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid hsla(0, 0%, 40%, .2);
        color                 : hsl(0, 0%, 0%);
        font-size               : 12px;
        font-weight             : bold;
        padding                 : 0 8px;
        text-decoration         : none;
        cursor                  : pointer;
        border-radius           : 3px;
        height                  : 25px;
        width                   : 100%;
        text-align              : center;
        overflow                : hidden;
        word-break              : normal;
      
    display: flex;
    justify-content: end;
    align-items: center;
    font-size: 11px;
    height: 30px;
    width: 97%;
    overflow: hidden;
    word-break: break-word;
    line-height: initial;
    overflow: visible;
  }
  .titleLine_i5hXx {
    display: flex;
    align-items: baseline;
  }
  .titleText_i5hXx {
    margin-right: 1em;
    word-break: break-word;
    min-width: 230px;
  }

  .title_i5hXx .copy_i5hXx {
    color: hsl(0, 0%, 100%);
  }
  .instance_i5hXx {
    
        background-color      : hsl(0, 0%, 100%);
        color                 : hsl(0, 0%, 0%);
        font-size             : 12px;
        padding               : 10px 15px;
        line-height           : 20px;
        overflow              : hidden;
        word-break            : break-word;
        width                 : 100%;
      ;
    margin-bottom: 10px;
    padding: 10px 15px 15px 15px;
  }
  .instance_i5hXx .title_i5hXx:before {
    content: "\25BE";
    margin-right: 5%;
  }
  .instance_i5hXx.hidesub_i5hXx .title_i5hXx:before {
    content: "\25B8";
    margin-right: 5%;
  }
  .instance_i5hXx.hidesub_i5hXx > * {
      display: none;
  }
  .instance_i5hXx.hidesub_i5hXx .title_i5hXx {
      display: flex;
  }
  .instance_i5hXx.hidesub_i5hXx .udappClose_i5hXx {
      display: flex;
  }
  .buttonsContainer_i5hXx {
    margin-top: 2%;
    display: flex;
    overflow: hidden;
  }
  .contractActions_i5hXx {
    display: flex;
  }
  .instanceButton_i5hXx {}
  .closeIcon_i5hXx {
    font-size: 12px;
    cursor: pointer;
  }
  .udappClose_i5hXx {
    display: flex;
    justify-content: flex-end;
  }
  .contractProperty_i5hXx {
    overflow: auto;
    margin-bottom: 0.4em;
  }
  .contractProperty_i5hXx.hasArgs_i5hXx input {
    width: 75%;
    padding: .36em;
  }
  .contractProperty_i5hXx button {
    
      margin                  : 1px;
      background-color        : hsla(0, 82%, 82%, .5);
      border                  : .3px solid hsla(0, 82%, 82%, .5);
      color                   : hsl(0, 0%, 0%);
      display                 : flex;
      align-items             : center;
      justify-content         : center;
      border-radius           : 3px;
      cursor                  : pointer;
      min-height              : 25px;
      max-height              : 25px;
      width                   : 70px;
      min-width               : 70px;
      font-size               : 12px;
      overflow                : hidden;
      word-break              : normal;
      
    min-width: 100px;
    width: 100px;
    font-size: 10px;
    margin:0;
    word-break: inherit;
  }
  .contractProperty_i5hXx button:disabled {
    cursor: not-allowed;
    background-color: white;
    border-color: lightgray;
  }
  .contractProperty_i5hXx.constant_i5hXx button {
    
      margin                  : 1px;
      background-color        : hsla(229, 75%, 87%, .5);
      border                  : .3px solid hsla(229, 75%, 87%, .5);
      color                   : hsl(0, 0%, 0%);
      display                 : flex;
      align-items             : center;
      justify-content         : center;
      border-radius           : 3px;
      cursor                  : pointer;
      min-height              : 25px;
      max-height              : 25px;
      width                   : 70px;
      min-width               : 70px;
      font-size               : 12px;
      overflow                : hidden;
      word-break              : normal;
      
    min-width: 100px;
    width: 100px;
    font-size: 10px;
    margin:0;
    word-break: inherit;
    outline: none;
    width: inherit;
  }
  .contractProperty_i5hXx input {
    display: none;
  }
  .contractProperty_i5hXx > .value_i5hXx {
    box-sizing: border-box;
    float: left;
    align-self: center;
    color: hsl(0, 0%, 0%);
    margin-left: 4px;
  }
  .hasArgs_i5hXx input {
    display: block;
    border: 1px solid #dddddd;
    padding: .36em;
    border-left: none;
    padding: 8px 8px 8px 10px;
    font-size: 10px;
    height: 25px;
  }
  .hasArgs_i5hXx button {
    border-top-right-radius: 0;
    border-bottom-right-radius: 0;
    border-right: 0;
  }
</style><style id="ace_editor.css">.ace_editor {position: relative;overflow: hidden;font: 12px/normal 'Monaco', 'Menlo', 'Ubuntu Mono', 'Consolas', 'source-code-pro', monospace;direction: ltr;}.ace_scroller {position: absolute;overflow: hidden;top: 0;bottom: 0;background-color: inherit;-ms-user-select: none;-moz-user-select: none;-webkit-user-select: none;user-select: none;cursor: text;}.ace_content {position: absolute;-moz-box-sizing: border-box;-webkit-box-sizing: border-box;box-sizing: border-box;min-width: 100%;}.ace_dragging .ace_scroller:before{position: absolute;top: 0;left: 0;right: 0;bottom: 0;content: '';background: rgba(250, 250, 250, 0.01);z-index: 1000;}.ace_dragging.ace_dark .ace_scroller:before{background: rgba(0, 0, 0, 0.01);}.ace_selecting, .ace_selecting * {cursor: text !important;}.ace_gutter {position: absolute;overflow : hidden;width: auto;top: 0;bottom: 0;left: 0;cursor: default;z-index: 4;-ms-user-select: none;-moz-user-select: none;-webkit-user-select: none;user-select: none;}.ace_gutter-active-line {position: absolute;left: 0;right: 0;}.ace_scroller.ace_scroll-left {box-shadow: 17px 0 16px -16px rgba(0, 0, 0, 0.4) inset;}.ace_gutter-cell {padding-left: 19px;padding-right: 6px;background-repeat: no-repeat;}.ace_gutter-cell.ace_error {background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAABOFBMVEX/////////QRswFAb/Ui4wFAYwFAYwFAaWGAfDRymzOSH/PxswFAb/SiUwFAYwFAbUPRvjQiDllog5HhHdRybsTi3/Tyv9Tir+Syj/UC3////XurebMBIwFAb/RSHbPx/gUzfdwL3kzMivKBAwFAbbvbnhPx66NhowFAYwFAaZJg8wFAaxKBDZurf/RB6mMxb/SCMwFAYwFAbxQB3+RB4wFAb/Qhy4Oh+4QifbNRcwFAYwFAYwFAb/QRzdNhgwFAYwFAbav7v/Uy7oaE68MBK5LxLewr/r2NXewLswFAaxJw4wFAbkPRy2PyYwFAaxKhLm1tMwFAazPiQwFAaUGAb/QBrfOx3bvrv/VC/maE4wFAbRPBq6MRO8Qynew8Dp2tjfwb0wFAbx6eju5+by6uns4uH9/f36+vr/GkHjAAAAYnRSTlMAGt+64rnWu/bo8eAA4InH3+DwoN7j4eLi4xP99Nfg4+b+/u9B/eDs1MD1mO7+4PHg2MXa347g7vDizMLN4eG+Pv7i5evs/v79yu7S3/DV7/498Yv24eH+4ufQ3Ozu/v7+y13sRqwAAADLSURBVHjaZc/XDsFgGIBhtDrshlitmk2IrbHFqL2pvXf/+78DPokj7+Fz9qpU/9UXJIlhmPaTaQ6QPaz0mm+5gwkgovcV6GZzd5JtCQwgsxoHOvJO15kleRLAnMgHFIESUEPmawB9ngmelTtipwwfASilxOLyiV5UVUyVAfbG0cCPHig+GBkzAENHS0AstVF6bacZIOzgLmxsHbt2OecNgJC83JERmePUYq8ARGkJx6XtFsdddBQgZE2nPR6CICZhawjA4Fb/chv+399kfR+MMMDGOQAAAABJRU5ErkJggg==");background-repeat: no-repeat;background-position: 2px center;}.ace_gutter-cell.ace_warning {background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAmVBMVEX///8AAAD///8AAAAAAABPSzb/5sAAAAB/blH/73z/ulkAAAAAAAD85pkAAAAAAAACAgP/vGz/rkDerGbGrV7/pkQICAf////e0IsAAAD/oED/qTvhrnUAAAD/yHD/njcAAADuv2r/nz//oTj/p064oGf/zHAAAAA9Nir/tFIAAAD/tlTiuWf/tkIAAACynXEAAAAAAAAtIRW7zBpBAAAAM3RSTlMAABR1m7RXO8Ln31Z36zT+neXe5OzooRDfn+TZ4p3h2hTf4t3k3ucyrN1K5+Xaks52Sfs9CXgrAAAAjklEQVR42o3PbQ+CIBQFYEwboPhSYgoYunIqqLn6/z8uYdH8Vmdnu9vz4WwXgN/xTPRD2+sgOcZjsge/whXZgUaYYvT8QnuJaUrjrHUQreGczuEafQCO/SJTufTbroWsPgsllVhq3wJEk2jUSzX3CUEDJC84707djRc5MTAQxoLgupWRwW6UB5fS++NV8AbOZgnsC7BpEAAAAABJRU5ErkJggg==");background-position: 2px center;}.ace_gutter-cell.ace_info {background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAAAAAA6mKC9AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAAJ0Uk5TAAB2k804AAAAPklEQVQY02NgIB68QuO3tiLznjAwpKTgNyDbMegwisCHZUETUZV0ZqOquBpXj2rtnpSJT1AEnnRmL2OgGgAAIKkRQap2htgAAAAASUVORK5CYII=");background-position: 2px center;}.ace_dark .ace_gutter-cell.ace_info {background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQBAMAAADt3eJSAAAAJFBMVEUAAAChoaGAgIAqKiq+vr6tra1ZWVmUlJSbm5s8PDxubm56enrdgzg3AAAAAXRSTlMAQObYZgAAAClJREFUeNpjYMAPdsMYHegyJZFQBlsUlMFVCWUYKkAZMxZAGdxlDMQBAG+TBP4B6RyJAAAAAElFTkSuQmCC");}.ace_scrollbar {position: absolute;right: 0;bottom: 0;z-index: 6;}.ace_scrollbar-inner {position: absolute;cursor: text;left: 0;top: 0;}.ace_scrollbar-v{overflow-x: hidden;overflow-y: scroll;top: 0;}.ace_scrollbar-h {overflow-x: scroll;overflow-y: hidden;left: 0;}.ace_print-margin {position: absolute;height: 100%;}.ace_text-input {position: absolute;z-index: 0;width: 0.5em;height: 1em;opacity: 0;background: transparent;-moz-appearance: none;appearance: none;border: none;resize: none;outline: none;overflow: hidden;font: inherit;padding: 0 1px;margin: 0 -1px;text-indent: -1em;-ms-user-select: text;-moz-user-select: text;-webkit-user-select: text;user-select: text;white-space: pre!important;}.ace_text-input.ace_composition {background: inherit;color: inherit;z-index: 1000;opacity: 1;text-indent: 0;}.ace_layer {z-index: 1;position: absolute;overflow: hidden;word-wrap: normal;white-space: pre;height: 100%;width: 100%;-moz-box-sizing: border-box;-webkit-box-sizing: border-box;box-sizing: border-box;pointer-events: none;}.ace_gutter-layer {position: relative;width: auto;text-align: right;pointer-events: auto;}.ace_text-layer {font: inherit !important;}.ace_cjk {display: inline-block;text-align: center;}.ace_cursor-layer {z-index: 4;}.ace_cursor {z-index: 4;position: absolute;-moz-box-sizing: border-box;-webkit-box-sizing: border-box;box-sizing: border-box;border-left: 2px solid;transform: translatez(0);}.ace_slim-cursors .ace_cursor {border-left-width: 1px;}.ace_overwrite-cursors .ace_cursor {border-left-width: 0;border-bottom: 1px solid;}.ace_hidden-cursors .ace_cursor {opacity: 0.2;}.ace_smooth-blinking .ace_cursor {-webkit-transition: opacity 0.18s;transition: opacity 0.18s;}.ace_editor.ace_multiselect .ace_cursor {border-left-width: 1px;}.ace_marker-layer .ace_step, .ace_marker-layer .ace_stack {position: absolute;z-index: 3;}.ace_marker-layer .ace_selection {position: absolute;z-index: 5;}.ace_marker-layer .ace_bracket {position: absolute;z-index: 6;}.ace_marker-layer .ace_active-line {position: absolute;z-index: 2;}.ace_marker-layer .ace_selected-word {position: absolute;z-index: 4;-moz-box-sizing: border-box;-webkit-box-sizing: border-box;box-sizing: border-box;}.ace_line .ace_fold {-moz-box-sizing: border-box;-webkit-box-sizing: border-box;box-sizing: border-box;display: inline-block;height: 11px;margin-top: -2px;vertical-align: middle;background-image:url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABEAAAAJCAYAAADU6McMAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAJpJREFUeNpi/P//PwOlgAXGYGRklAVSokD8GmjwY1wasKljQpYACtpCFeADcHVQfQyMQAwzwAZI3wJKvCLkfKBaMSClBlR7BOQikCFGQEErIH0VqkabiGCAqwUadAzZJRxQr/0gwiXIal8zQQPnNVTgJ1TdawL0T5gBIP1MUJNhBv2HKoQHHjqNrA4WO4zY0glyNKLT2KIfIMAAQsdgGiXvgnYAAAAASUVORK5CYII="),url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAA3CAYAAADNNiA5AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAACJJREFUeNpi+P//fxgTAwPDBxDxD078RSX+YeEyDFMCIMAAI3INmXiwf2YAAAAASUVORK5CYII=");background-repeat: no-repeat, repeat-x;background-position: center center, top left;color: transparent;border: 1px solid black;border-radius: 2px;cursor: pointer;pointer-events: auto;}.ace_dark .ace_fold {}.ace_fold:hover{background-image:url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABEAAAAJCAYAAADU6McMAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAJpJREFUeNpi/P//PwOlgAXGYGRklAVSokD8GmjwY1wasKljQpYACtpCFeADcHVQfQyMQAwzwAZI3wJKvCLkfKBaMSClBlR7BOQikCFGQEErIH0VqkabiGCAqwUadAzZJRxQr/0gwiXIal8zQQPnNVTgJ1TdawL0T5gBIP1MUJNhBv2HKoQHHjqNrA4WO4zY0glyNKLT2KIfIMAAQsdgGiXvgnYAAAAASUVORK5CYII="),url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAA3CAYAAADNNiA5AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAACBJREFUeNpi+P//fz4TAwPDZxDxD5X4i5fLMEwJgAADAEPVDbjNw87ZAAAAAElFTkSuQmCC");}.ace_tooltip {background-color: #FFF;background-image: -webkit-linear-gradient(top, transparent, rgba(0, 0, 0, 0.1));background-image: linear-gradient(to bottom, transparent, rgba(0, 0, 0, 0.1));border: 1px solid gray;border-radius: 1px;box-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);color: black;max-width: 100%;padding: 3px 4px;position: fixed;z-index: 999999;-moz-box-sizing: border-box;-webkit-box-sizing: border-box;box-sizing: border-box;cursor: default;white-space: pre;word-wrap: break-word;line-height: normal;font-style: normal;font-weight: normal;letter-spacing: normal;pointer-events: none;}.ace_folding-enabled > .ace_gutter-cell {padding-right: 13px;}.ace_fold-widget {-moz-box-sizing: border-box;-webkit-box-sizing: border-box;box-sizing: border-box;margin: 0 -12px 0 1px;display: none;width: 11px;vertical-align: top;background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAANElEQVR42mWKsQ0AMAzC8ixLlrzQjzmBiEjp0A6WwBCSPgKAXoLkqSot7nN3yMwR7pZ32NzpKkVoDBUxKAAAAABJRU5ErkJggg==");background-repeat: no-repeat;background-position: center;border-radius: 3px;border: 1px solid transparent;cursor: pointer;}.ace_folding-enabled .ace_fold-widget {display: inline-block;   }.ace_fold-widget.ace_end {background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAANElEQVR42m3HwQkAMAhD0YzsRchFKI7sAikeWkrxwScEB0nh5e7KTPWimZki4tYfVbX+MNl4pyZXejUO1QAAAABJRU5ErkJggg==");}.ace_fold-widget.ace_closed {background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAMAAAAGCAYAAAAG5SQMAAAAOUlEQVR42jXKwQkAMAgDwKwqKD4EwQ26sSOkVWjgIIHAzPiCgaqiqnJHZnKICBERHN194O5b9vbLuAVRL+l0YWnZAAAAAElFTkSuQmCCXA==");}.ace_fold-widget:hover {border: 1px solid rgba(0, 0, 0, 0.3);background-color: rgba(255, 255, 255, 0.2);box-shadow: 0 1px 1px rgba(255, 255, 255, 0.7);}.ace_fold-widget:active {border: 1px solid rgba(0, 0, 0, 0.4);background-color: rgba(0, 0, 0, 0.05);box-shadow: 0 1px 1px rgba(255, 255, 255, 0.8);}.ace_dark .ace_fold-widget {background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHklEQVQIW2P4//8/AzoGEQ7oGCaLLAhWiSwB146BAQCSTPYocqT0AAAAAElFTkSuQmCC");}.ace_dark .ace_fold-widget.ace_end {background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAH0lEQVQIW2P4//8/AxQ7wNjIAjDMgC4AxjCVKBirIAAF0kz2rlhxpAAAAABJRU5ErkJggg==");}.ace_dark .ace_fold-widget.ace_closed {background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAMAAAAFCAYAAACAcVaiAAAAHElEQVQIW2P4//+/AxAzgDADlOOAznHAKgPWAwARji8UIDTfQQAAAABJRU5ErkJggg==");}.ace_dark .ace_fold-widget:hover {box-shadow: 0 1px 1px rgba(255, 255, 255, 0.2);background-color: rgba(255, 255, 255, 0.1);}.ace_dark .ace_fold-widget:active {box-shadow: 0 1px 1px rgba(255, 255, 255, 0.2);}.ace_fold-widget.ace_invalid {background-color: #FFB4B4;border-color: #DE5555;}.ace_fade-fold-widgets .ace_fold-widget {-webkit-transition: opacity 0.4s ease 0.05s;transition: opacity 0.4s ease 0.05s;opacity: 0;}.ace_fade-fold-widgets:hover .ace_fold-widget {-webkit-transition: opacity 0.05s ease 0.05s;transition: opacity 0.05s ease 0.05s;opacity:1;}.ace_underline {text-decoration: underline;}.ace_bold {font-weight: bold;}.ace_nobold .ace_bold {font-weight: normal;}.ace_italic {font-style: italic;}.ace_error-marker {background-color: rgba(255, 0, 0,0.2);position: absolute;z-index: 9;}.ace_highlight-marker {background-color: rgba(255, 255, 0,0.2);position: absolute;z-index: 8;}.ace_br1 {border-top-left-radius    : 3px;}.ace_br2 {border-top-right-radius   : 3px;}.ace_br3 {border-top-left-radius    : 3px; border-top-right-radius:    3px;}.ace_br4 {border-bottom-right-radius: 3px;}.ace_br5 {border-top-left-radius    : 3px; border-bottom-right-radius: 3px;}.ace_br6 {border-top-right-radius   : 3px; border-bottom-right-radius: 3px;}.ace_br7 {border-top-left-radius    : 3px; border-top-right-radius:    3px; border-bottom-right-radius: 3px;}.ace_br8 {border-bottom-left-radius : 3px;}.ace_br9 {border-top-left-radius    : 3px; border-bottom-left-radius:  3px;}.ace_br10{border-top-right-radius   : 3px; border-bottom-left-radius:  3px;}.ace_br11{border-top-left-radius    : 3px; border-top-right-radius:    3px; border-bottom-left-radius:  3px;}.ace_br12{border-bottom-right-radius: 3px; border-bottom-left-radius:  3px;}.ace_br13{border-top-left-radius    : 3px; border-bottom-right-radius: 3px; border-bottom-left-radius:  3px;}.ace_br14{border-top-right-radius   : 3px; border-bottom-right-radius: 3px; border-bottom-left-radius:  3px;}.ace_br15{border-top-left-radius    : 3px; border-top-right-radius:    3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px;}
/*# sourceURL=ace/css/ace_editor.css */</style><style id="ace-tm">.ace-tm .ace_gutter {background: #f0f0f0;color: #333;}.ace-tm .ace_print-margin {width: 1px;background: #e8e8e8;}.ace-tm .ace_fold {background-color: #6B72E6;}.ace-tm {background-color: #FFFFFF;color: black;}.ace-tm .ace_cursor {color: black;}.ace-tm .ace_invisible {color: rgb(191, 191, 191);}.ace-tm .ace_storage,.ace-tm .ace_keyword {color: blue;}.ace-tm .ace_constant {color: rgb(197, 6, 11);}.ace-tm .ace_constant.ace_buildin {color: rgb(88, 72, 246);}.ace-tm .ace_constant.ace_language {color: rgb(88, 92, 246);}.ace-tm .ace_constant.ace_library {color: rgb(6, 150, 14);}.ace-tm .ace_invalid {background-color: rgba(255, 0, 0, 0.1);color: red;}.ace-tm .ace_support.ace_function {color: rgb(60, 76, 114);}.ace-tm .ace_support.ace_constant {color: rgb(6, 150, 14);}.ace-tm .ace_support.ace_type,.ace-tm .ace_support.ace_class {color: rgb(109, 121, 222);}.ace-tm .ace_keyword.ace_operator {color: rgb(104, 118, 135);}.ace-tm .ace_string {color: rgb(3, 106, 7);}.ace-tm .ace_comment {color: rgb(76, 136, 107);}.ace-tm .ace_comment.ace_doc {color: rgb(0, 102, 255);}.ace-tm .ace_comment.ace_doc.ace_tag {color: rgb(128, 159, 191);}.ace-tm .ace_constant.ace_numeric {color: rgb(0, 0, 205);}.ace-tm .ace_variable {color: rgb(49, 132, 149);}.ace-tm .ace_xml-pe {color: rgb(104, 104, 91);}.ace-tm .ace_entity.ace_name.ace_function {color: #0000A2;}.ace-tm .ace_heading {color: rgb(12, 7, 255);}.ace-tm .ace_list {color:rgb(185, 6, 144);}.ace-tm .ace_meta.ace_tag {color:rgb(0, 22, 142);}.ace-tm .ace_string.ace_regex {color: rgb(255, 0, 0)}.ace-tm .ace_marker-layer .ace_selection {background: rgb(181, 213, 255);}.ace-tm.ace_multiselect .ace_selection.ace_start {box-shadow: 0 0 3px 0px white;}.ace-tm .ace_marker-layer .ace_step {background: rgb(252, 255, 0);}.ace-tm .ace_marker-layer .ace_stack {background: rgb(164, 229, 101);}.ace-tm .ace_marker-layer .ace_bracket {margin: -1px 0 0 -1px;border: 1px solid rgb(192, 192, 192);}.ace-tm .ace_marker-layer .ace_active-line {background: rgba(0, 0, 0, 0.07);}.ace-tm .ace_gutter-active-line {background-color : #dcdcdc;}.ace-tm .ace_marker-layer .ace_selected-word {background: rgb(250, 250, 255);border: 1px solid rgb(200, 200, 250);}.ace-tm .ace_indent-guide {background: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAACCAYAAACZgbYnAAAAE0lEQVQImWP4////f4bLly//BwAmVgd1/w11/gAAAABJRU5ErkJggg==") right repeat-y;}
/*# sourceURL=ace/css/ace-tm */</style><style>    .error_widget_wrapper {        background: inherit;        color: inherit;        border:none    }    .error_widget {        border-top: solid 2px;        border-bottom: solid 2px;        margin: 5px 0;        padding: 10px 40px;        white-space: pre-wrap;    }    .error_widget.ace_error, .error_widget_arrow.ace_error{        border-color: #ff5a5a    }    .error_widget.ace_warning, .error_widget_arrow.ace_warning{        border-color: #F1D817    }    .error_widget.ace_info, .error_widget_arrow.ace_info{        border-color: #5a5a5a    }    .error_widget.ace_ok, .error_widget_arrow.ace_ok{        border-color: #5aaa5a    }    .error_widget_arrow {        position: absolute;        border: solid 5px;        border-top-color: transparent!important;        border-right-color: transparent!important;        border-left-color: transparent!important;        top: -5px;    }</style><style>.ace_snippet-marker {    -moz-box-sizing: border-box;    box-sizing: border-box;    background: rgba(194, 193, 208, 0.09);    border: 1px dotted rgba(211, 208, 235, 0.62);    position: absolute;}</style><style>.ace_editor.ace_autocomplete .ace_marker-layer .ace_active-line {    background-color: #CAD6FA;    z-index: 1;}.ace_editor.ace_autocomplete .ace_line-hover {    border: 1px solid #abbffe;    margin-top: -1px;    background: rgba(233,233,253,0.4);}.ace_editor.ace_autocomplete .ace_line-hover {    position: absolute;    z-index: 2;}.ace_editor.ace_autocomplete .ace_scroller {   background: none;   border: none;   box-shadow: none;}.ace_rightAlignedText {    color: gray;    display: inline-block;    position: absolute;    right: 4px;    text-align: right;    z-index: -1;}.ace_editor.ace_autocomplete .ace_completion-highlight{    color: #000;    text-shadow: 0 0 0.01em;}.ace_editor.ace_autocomplete {    width: 280px;    z-index: 200000;    background: #fbfbfb;    color: #444;    border: 1px lightgray solid;    position: fixed;    box-shadow: 2px 3px 5px rgba(0,0,0,.2);    line-height: 1.4;}</style><style id="ace_searchbox">.ace_search {background-color: #ddd;border: 1px solid #cbcbcb;border-top: 0 none;max-width: 325px;overflow: hidden;margin: 0;padding: 4px;padding-right: 6px;padding-bottom: 0;position: absolute;top: 0px;z-index: 99;white-space: normal;}.ace_search.left {border-left: 0 none;border-radius: 0px 0px 5px 0px;left: 0;}.ace_search.right {border-radius: 0px 0px 0px 5px;border-right: 0 none;right: 0;}.ace_search_form, .ace_replace_form {border-radius: 3px;border: 1px solid #cbcbcb;float: left;margin-bottom: 4px;overflow: hidden;}.ace_search_form.ace_nomatch {outline: 1px solid red;}.ace_search_field {background-color: white;border-right: 1px solid #cbcbcb;border: 0 none;-webkit-box-sizing: border-box;-moz-box-sizing: border-box;box-sizing: border-box;float: left;height: 22px;outline: 0;padding: 0 7px;width: 214px;margin: 0;}.ace_searchbtn,.ace_replacebtn {background: #fff;border: 0 none;border-left: 1px solid #dcdcdc;cursor: pointer;float: left;height: 22px;margin: 0;position: relative;}.ace_searchbtn:last-child,.ace_replacebtn:last-child {border-top-right-radius: 3px;border-bottom-right-radius: 3px;}.ace_searchbtn:disabled {background: none;cursor: default;}.ace_searchbtn {background-position: 50% 50%;background-repeat: no-repeat;width: 27px;}.ace_searchbtn.prev {background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAFCAYAAAB4ka1VAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAADFJREFUeNpiSU1NZUAC/6E0I0yACYskCpsJiySKIiY0SUZk40FyTEgCjGgKwTRAgAEAQJUIPCE+qfkAAAAASUVORK5CYII=);    }.ace_searchbtn.next {background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAFCAYAAAB4ka1VAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAADRJREFUeNpiTE1NZQCC/0DMyIAKwGJMUAYDEo3M/s+EpvM/mkKwCQxYjIeLMaELoLMBAgwAU7UJObTKsvAAAAAASUVORK5CYII=);    }.ace_searchbtn_close {background: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAcCAYAAABRVo5BAAAAZ0lEQVR42u2SUQrAMAhDvazn8OjZBilCkYVVxiis8H4CT0VrAJb4WHT3C5xU2a2IQZXJjiQIRMdkEoJ5Q2yMqpfDIo+XY4k6h+YXOyKqTIj5REaxloNAd0xiKmAtsTHqW8sR2W5f7gCu5nWFUpVjZwAAAABJRU5ErkJggg==) no-repeat 50% 0;border-radius: 50%;border: 0 none;color: #656565;cursor: pointer;float: right;font: 16px/16px Arial;height: 14px;margin: 5px 1px 9px 5px;padding: 0;text-align: center;width: 14px;}.ace_searchbtn_close:hover {background-color: #656565;background-position: 50% 100%;color: white;}.ace_replacebtn.prev {width: 54px}.ace_replacebtn.next {width: 27px}.ace_button {margin-left: 2px;cursor: pointer;-webkit-user-select: none;-moz-user-select: none;-o-user-select: none;-ms-user-select: none;user-select: none;overflow: hidden;opacity: 0.7;border: 1px solid rgba(100,100,100,0.23);padding: 1px;-moz-box-sizing: border-box;box-sizing:    border-box;color: black;}.ace_button:hover {background-color: #eee;opacity:1;}.ace_button:active {background-color: #ddd;}.ace_button.checked {border-color: #3399ff;opacity:1;}.ace_search_options{margin-bottom: 3px;text-align: right;-webkit-user-select: none;-moz-user-select: none;-o-user-select: none;-ms-user-select: none;user-select: none;}
/*# sourceURL=ace/css/ace_searchbox */</style><style type="text/css">
  .ace-editor_2XgUV9 {
    background-color  : hsl(0, 0%, 100%);
    width     : 100%;
  }
</style><style>
    .ace-tm .ace_gutter,
    .ace-tm .ace_gutter-active-line,
    .ace-tm .ace_marker-layer .ace_active-line {
        background-color: hsla(229, 100%, 97%, 1);
    }
    .ace_gutter-cell.ace_breakpoint{
      background-color: hsla(240, 64%, 68%, .5);
    }
    .highlightreference {
      position:absolute;
      z-index:20;
      background-color: hsla(229, 100%, 97%, 1);
      opacity: 0.7
    }

    .highlightreferenceline {
      position:absolute;
      z-index:20;
      background-color: hsla(229, 100%, 97%, 1);
      opacity: 0.7
    }

    .highlightcode {
      position:absolute;
      z-index:20;
      background-color: ;
     }
  </style><style type="text/css">
  .title_2Yorex {
    margin-top: 10px;
    
        background-color      : hsla(0, 0%, 40%, .2);
        border                : 1px solid hsla(0, 0%, 40%, .2);
        color                 : hsl(0, 0%, 0%);
        font-size               : 12px;
        font-weight             : bold;
        padding                 : 0 8px;
        text-decoration         : none;
        cursor                  : pointer;
        border-radius           : 3px;
        height                  : 25px;
        width                   : 100%;
        text-align              : center;
        overflow                : hidden;
        word-break              : normal;
      ;
    display: flex;
    align-items: center;
  }
  .name_2Yorex {
    font-weight: bold;
  }
  .nameDetail_2Yorex {
    font-weight: bold;
    margin-left: 3px;
  }
  .icon_2Yorex {
    color: hsl(0, 0%, 0%);
    margin-right: 5%;
  }
  .eyeButton_2Yorex {
    margin: 3px;
  }
  .eyeButton_2Yorex:hover {
    color: hsla(44, 100%, 50%, 1);
  }
  .dropdownpanel_2Yorex {
    
        background-color      : hsla(0, 0%, 40%, .2);
        border                : 1px solid hsla(0, 0%, 40%, .2);
        color                 : hsl(0, 0%, 0%);
        font-size               : 12px;
        font-weight             : bold;
        padding                 : 0 8px;
        text-decoration         : none;
        cursor                  : pointer;
        border-radius           : 3px;
        height                  : 25px;
        width                   : 100%;
        text-align              : center;
        overflow                : hidden;
        word-break              : normal;
      ;
    width: 100%;
  }
  .dropdownrawcontent_2Yorex {
    padding: 2px;
    word-break: break-all;
  }
  .message_2Yorex {
    padding: 2px;
    word-break: break-all;
  }
  .refresh_2Yorex {
    display: none;
    margin-left: 4px;
    margin-top: 4px; 
    animation: spin 2s linear infinite;
  }
</style><style type="text/css">
  .container_1LMnfr {
    display: flex;
    flex-direction: column;
  }
  .txContainer_1LMnfr {
    display: flex;
    flex-direction: column;
  }
  .txinputs_1LMnfr {
    width: 100%;
    display: flex;
    justify-content: center;
  }
  .txinput_1LMnfr {
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid hsla(0, 0%, 40%, .2);
        color                 : hsl(0, 0%, 0%);
        border-radius         : 5px;
        height                : 25px;
        width                 : 250px;
        padding               : 0 8px;
        overflow              : hidden;
        word-break            : normal;
      
    min-width: 30px;
    margin: 3px;
  }
  .txbuttons_1LMnfr {
    width: 100%;
    display: flex;
    justify-content: center;
  }
  .txbutton_1LMnfr {
    
      margin                  : 1px;
      background-color        : hsla(0, 0%, 40%, .2);
      border                  : .3px solid hsla(0, 0%, 40%, .2);
      color                   : hsl(0, 0%, 0%);
      display                 : flex;
      align-items             : center;
      justify-content         : center;
      border-radius           : 3px;
      cursor                  : pointer;
      min-height              : 25px;
      max-height              : 25px;
      width                   : 70px;
      min-width               : 70px;
      font-size               : 12px;
      overflow                : hidden;
      word-break              : normal;
      
  }
  .txbutton_1LMnfr:hover {
    color: hsla(44, 100%, 50%, 1);
  }
  .txinfo_1LMnfr {
    margin-top: 5px;
  }
  .vmargin_1LMnfr {
    margin-top: 10px;
    margin-bottom: 10px;
  }
</style><style type="text/css">
  .buttons_23Xlmh {
    display: flex;
    flex-wrap: wrap;
  }
  .stepButtons_23Xlmh {
    width: 100%;
    display: flex;
    justify-content: center;
  }
  .stepButton_23Xlmh {
    
      margin                  : 1px;
      background-color        : hsla(0, 0%, 40%, .2);
      border                  : .3px solid hsla(0, 0%, 40%, .2);
      color                   : hsl(0, 0%, 0%);
      display                 : flex;
      align-items             : center;
      justify-content         : center;
      border-radius           : 3px;
      cursor                  : pointer;
      min-height              : 25px;
      max-height              : 25px;
      width                   : 70px;
      min-width               : 70px;
      font-size               : 12px;
      overflow                : hidden;
      word-break              : normal;
      
  }
  .jumpButtons_23Xlmh {
    width: 100%;
    display: flex;
    justify-content: center;
  }
  .jumpButton_23Xlmh {
    
      margin                  : 1px;
      background-color        : hsla(0, 0%, 40%, .2);
      border                  : .3px solid hsla(0, 0%, 40%, .2);
      color                   : hsl(0, 0%, 0%);
      display                 : flex;
      align-items             : center;
      justify-content         : center;
      border-radius           : 3px;
      cursor                  : pointer;
      min-height              : 25px;
      max-height              : 25px;
      width                   : 70px;
      min-width               : 70px;
      font-size               : 12px;
      overflow                : hidden;
      word-break              : normal;
      
  }
  .navigator_23Xlmh {
    color: hsl(0, 0%, 0%);
  }
  .navigator_23Xlmh:hover {
    color: hsla(44, 100%, 50%, 1);
  }
</style><style type="text/css">
  .instructions_1G59wD {
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid hsl(0, 0%, 100%);
        color                 : hsl(0, 0%, 0%);
        border-radius         : 3px;
        font-size             : 12px;
        padding               : 10px 15px;
        line-height           : 20px;
        overflow              : hidden;
        word-break            : break-word;
        width                 : 100%;
      
    width: 75%;
    overflow-y: scroll;
    max-height: 250px;
  }
</style><style type="text/css">
  .statusMessage_3d2FTR {
    margin-left: 15px;
  }
  .innerShift_3d2FTR {
    padding: 2px;
    margin-left: 10px;
  }
</style><style type="text/css">
  .analysis_4pISIB {
    display: flex;
    flex-direction: column;
  }
  .result_4pISIB {
    margin-top: 1%;
  }
  .buttons_4pISIB  {
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid hsl(0, 0%, 100%);
        color                 : hsl(0, 0%, 0%);
        border-radius         : 3px;
        font-size             : 12px;
        padding               : 10px 15px;
        line-height           : 20px;
        overflow              : hidden;
        word-break            : break-word;
        width                 : 100%;
      
    display: flex;
    align-items: center;
  }
  .buttonRun_4pISIB  {
    
      margin                  : 1px;
      background-color        : hsla(229, 75%, 87%, .5);
      border                  : .3px solid hsla(229, 75%, 87%, .5);
      color                   : hsl(0, 0%, 0%);
      display                 : flex;
      align-items             : center;
      justify-content         : center;
      border-radius           : 3px;
      cursor                  : pointer;
      min-height              : 25px;
      max-height              : 25px;
      width                   : 70px;
      min-width               : 70px;
      font-size               : 12px;
      overflow                : hidden;
      word-break              : normal;
      
    margin-right: 1%;
  }
  .analysisModulesContainer_4pISIB {
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid hsl(0, 0%, 100%);
        color                 : hsl(0, 0%, 0%);
        border-radius         : 3px;
        font-size             : 12px;
        padding               : 10px 15px;
        line-height           : 20px;
        overflow              : hidden;
        word-break            : break-word;
        width                 : 100%;
      
    margin-bottom: 1%;
    line-height: 2em;
    display: flex;
    flex-direction: column;
  }
  .label_4pISIB {
    display: flex;
    align-items: center;
  }
</style><style type="text/css">
    .container_1rCU0a
    {
        display: none;
        position: fixed;
        border: 1px solid hsla(0, 0%, 40%, .2);
        width:150px; 
        background: hsl(0, 0%, 100%);
        border-radius: 2px;
        z-index: 1000;
    }
    
    .liitem_1rCU0a
    {
        padding: 3px;
        padding-left: 10px;
        cursor: pointer;
    }
    
    #menuitems
    {
        list-style: none;
        margin: 0px;
        margin-top: 4px;
        padding-left: 5px;
        padding-right: 5px;
        padding-bottom: 3px;
        color: hsl(0, 0%, 0%);
    }

    #menuitems :hover
    {
        background: hsla(0, 0%, 40%, .2);
        border-radius: 2px;
    }
</style><style type="text/css">
  .fileexplorer_1MTxic       {
    box-sizing        : border-box;
  }
  input[type="file"] {
      display: none;
  }
  .folder_1MTxic,
  .file_1MTxic               {
    font-size         : 14px;
    cursor            : pointer;
  }
  .file_1MTxic               {
    color             : hsl(0, 0%, 0%);
  }
  .hasFocus_1MTxic           {
    background-color  : hsla(229, 100%, 97%, 1);
  }
  .rename_1MTxic             {
    background-color  : hsl(0, 0%, 100%);
  }
  .remove_1MTxic             {
    margin-left       : auto;
    padding-left      : 5px;
    padding-right     : 5px;
  }
  .activeMode_1MTxic         {
    display           : flex;
    width             : 100%;
    margin-right      : 10px;
    padding-right     : 19px;
  }
  .activeMode_1MTxic > div   {
    min-width         : 10px;
  }
  ul                  {
    padding           : 0;
  }
</style><style type="text/css">
  .container_1pxFrB {
    display           : flex;
    flex-direction    : row;
    width             : 100%;
    height            : 100%;
    box-sizing        : border-box;
  }
  .fileexplorer_1pxFrB       {
    display           : flex;
    flex-direction    : column;
    position          : relative;
    width             : 100%;
  }
  .menu_1pxFrB               {
    margin-top        : -0.2em;
    flex-shrink       : 0;
    display           : flex;
    flex-direction    : row;
    min-width         : 160px;
  }
  .newFile_1pxFrB            {
    padding           : 10px;
  }
  .newFile_1pxFrB i          {
    cursor            : pointer;
  }
  .newFile_1pxFrB i:hover    {
    color             : hsla(44, 100%, 50%, 1);
  }
  .gist_1pxFrB            {
    padding           : 10px;
  }
  .gist_1pxFrB i          {
    cursor            : pointer;
  }
  .gist_1pxFrB i:hover    {
    color             : orange;
  }
  .copyFiles_1pxFrB            {
    padding           : 10px;
  }
  .copyFiles_1pxFrB i          {
    cursor            : pointer;
  }
  .copyFiles_1pxFrB i:hover    {
    color             : orange;
  }
  .connectToLocalhost_1pxFrB {
    padding           : 10px;
  }
  .connectToLocalhost_1pxFrB i {
    cursor            : pointer;
  }
  .connectToLocalhost_1pxFrB i:hover   {
    color             : hsla(44, 100%, 50%, 1);
  }
  .uploadFile_1pxFrB         {
    padding           : 10px;
  }
  .uploadFile_1pxFrB label:hover   {
    color             : hsla(44, 100%, 50%, 1);
  }
  .uploadFile_1pxFrB label   {
    cursor            : pointer;
  }
  .treeview_1pxFrB {
    background-color  : undefined;
  }
  .treeviews_1pxFrB {
    overflow-y        : auto;
  }
  .dragbar_1pxFrB            {
    position          : absolute;
    top               : 29px;
    width             : 0.5em;
    right             : 0;
    bottom            : 0;
    cursor            : col-resize;
    z-index           : 999;
    border-right      : 2px solid hsla(215, 81%, 79%, .3);
  }
  .ghostbar_1pxFrB           {
    width             : 3px;
    background-color  : hsla(229, 75%, 87%, .5);
    opacity           : 0.5;
    position          : absolute;
    cursor            : col-resize;
    z-index           : 9999;
    top               : 0;
    bottom            : 0;
  }
  .dialog_1pxFrB {
    display: flex;
    flex-direction: column;
  }
  .dialogParagraph_1pxFrB {
    undefined
    margin-bottom: 2em;
    word-break: break-word;
  }
</style><style type="text/css">
  .dropdown_1YaZ7a           {
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid hsla(0, 0%, 40%, .2);
        color                 : hsl(0, 0%, 0%);
        font-size               : 12px;
        font-weight             : bold;
        padding                 : 0 8px;
        text-decoration         : none;
        cursor                  : pointer;
        border-radius           : 3px;
        height                  : 25px;
        width                   : 100%;
        text-align              : center;
        overflow                : hidden;
        word-break              : normal;
      
    overflow          : visible;
    position          : relative;
    display           : flex;
    flex-direction    : column;
    margin-right      : 10px;
  }
  .selectbox_1YaZ7a          {
    display           : flex;
    align-items       : center;
    margin            : 3px;
    cursor            : pointer;
  }
  .selected_1YaZ7a           {
    display           : inline-block;
    min-width         : 30ch;
    max-width         : 30ch;
    white-space       : nowrap;
    text-overflow     : ellipsis;
    overflow          : hidden;
    padding           : 3px;
  }
  .icon_1YaZ7a               {
    padding           : 0px 5px;
  }
  .options_1YaZ7a            {
    position          : absolute;
    display           : flex;
    flex-direction    : column;
    align-items       : end;
    top               : 24px;
    left              : 0;
    width             : 250px;
    background-color  : hsl(0, 0%, 100%);
    border            : 1px solid hsla(0, 0%, 40%, .2);
    border-radius     : 3px;
    border-top        : 0;
  }
  .option_1YaZ7a {
    margin: 0;
  }
</style><style type="text/css">
  .panel_1ywR9V              {
    position          : relative;
    display           : flex;
    flex-direction    : column;
    font-size         : 12px;
    color             : hsla(0, 0%, 40%, 1);
    background-color  : hsla(0, 0%, 40%, .2);
    height            : 100%;
    min-height        : 1.7em;
    overflow          : hidden;
  }
  .bar_1ywR9V                {
    display           : flex;
    min-height        : 3em;
    padding           : 2px;
    background-color  : hsla(229, 100%, 97%, 1);
    z-index           : 3;
  }
  .menu_1ywR9V               {
    color             : hsl(0, 0%, 0%);
    position          : relative;
    display           : flex;
    align-items       : center;
    width             : 100%;
    padding           : 5px;
  }
  .clear_1ywR9V           {
    margin-left       : 10px;
    margin-right      : 10px; 
    width             : 10px;
    cursor            : pointer;
    color             : hsl(0, 0%, 0%);
  }
  .clear_1ywR9V:hover              {
    color             : hsla(44, 100%, 50%, 1);
  }
  .toggleTerminal_1ywR9V              {
    margin-right      : 10px;
    font-size         : 14px;
    font-weight       : bold;
    cursor            : pointer;
    color             : hsl(0, 0%, 0%);
  }
  .toggleTerminal_1ywR9V:hover              {
    color             : hsla(44, 100%, 50%, 1);
  }
  .terminal_container_1ywR9V {
    background-color  : hsla(0, 0%, 40%, .2);
    display           : flex;
    flex-direction    : column;
    height            : 100%;
    overflow-y        : auto;
    font-family       : monospace;
  }
  .terminal_bg_1ywR9V     {
    display           : flex;
    flex-direction    : column;
    height            : 100%;
    padding-left      : 5px;
    padding-right     : 5px;
    padding-bottom    : 3px;
    overflow-y        : auto;
    font-family       : monospace;
    background-image  : url('data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4NCjwhLS0gR2VuZXJhdG9yOiBBZG9iZSBJbGx1c3RyYXRvciAxNi4wLjAsIFNWRyBFeHBvcnQgUGx1Zy1JbiAuIFNWRyBWZXJzaW9uOiA2LjAwIEJ1aWxkIDApICAtLT4NCjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+DQo8c3ZnIHZlcnNpb249IjEuMSIgaWQ9IkxheWVyXzEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHg9IjBweCIgeT0iMHB4Ig0KCSB3aWR0aD0iNTEycHgiIGhlaWdodD0iNTEycHgiIHZpZXdCb3g9IjAgMCA1MTIgNTEyIiBlbmFibGUtYmFja2dyb3VuZD0ibmV3IDAgMCA1MTIgNTEyIiB4bWw6c3BhY2U9InByZXNlcnZlIj4NCjxnPg0KCTxwYXRoIGZpbGw9IiM0MTQwNDIiIGQ9Ik03MC41ODIsNDI4LjkwNGMwLjgxMSwwLDEuNjIyLDAuMjg1LDIuNDM3LDAuODUzYzAuODExLDAuNTcxLDEuMjE4LDEuMzQsMS4yMTgsMi4zMTQNCgkJYzAsMi4yNzctMS4wNTksMy40OTYtMy4xNjgsMy42NTZjLTUuMDM4LDAuODE0LTkuMzgxLDIuMzU2LTEzLjAzNyw0LjYzYy0zLjY1NSwyLjI3Ni02LjY2Myw1LjExNy05LjAxNiw4LjUyOA0KCQljLTIuMzU3LDMuNDExLTQuMTA0LDcuMjcyLTUuMjM5LDExLjU3NWMtMS4xMzksNC4zMDctMS43MDYsOC44MTQtMS43MDYsMTMuNTI0djMyLjY1M2MwLDIuMjczLTEuMTM5LDMuNDExLTMuNDEyLDMuNDExDQoJCWMtMi4yNzcsMC0zLjQxMi0xLjEzOC0zLjQxMi0zLjQxMXYtNzQuMzIzYzAtMi4yNzMsMS4xMzUtMy40MTEsMy40MTItMy40MTFjMi4yNzMsMCwzLjQxMiwxLjEzOCwzLjQxMiwzLjQxMXYxNS4xMDgNCgkJYzEuNDYyLTIuNDM3LDMuMjA2LTQuNzUyLDUuMjM5LTYuOTQ1YzIuMDI5LTIuMTkzLDQuMjY0LTQuMTQzLDYuNzAxLTUuODQ4YzIuNDM3LTEuNzA2LDUuMDc2LTMuMDg1LDcuOTE5LTQuMTQzDQoJCUM2NC43NzEsNDI5LjQzMyw2Ny42NTgsNDI4LjkwNCw3MC41ODIsNDI4LjkwNHoiLz4NCgk8cGF0aCBmaWxsPSIjNDE0MDQyIiBkPSJNMTM3Ljc3Myw0MjcuMTk4YzUuNjg1LDAsMTAuOTY2LDEuMTgxLDE1LjgzOSwzLjUzNGM0Ljg3NCwyLjM1Niw5LjA1NSw1LjQ4MiwxMi41NSw5LjM4MQ0KCQljMy40OTIsMy44OTksNi4yMTQsOC40MDcsOC4xNjQsMTMuNTI0YzEuOTQ5LDUuMTE3LDIuOTI0LDEwLjQ0LDIuOTI0LDE1Ljk2MWMwLDAuOTc2LTAuMzY2LDEuNzktMS4wOTcsMi40MzgNCgkJYy0wLjczMSwwLjY1LTEuNTgzLDAuOTc1LTIuNTU5LDAuOTc1aC02Ny45ODdjMC40ODcsNC4yMjYsMS41ODQsOC4yODUsMy4yOSwxMi4xODRjMS43MDYsMy44OTksMy45MzcsNy4zMTIsNi43MDEsMTAuMjM0DQoJCWMyLjc2MSwyLjkyNSw2LjAwOCw1LjI4MSw5Ljc0OCw3LjA2N2MzLjczNSwxLjc4OSw3Ljg3NywyLjY4MSwxMi40MjgsMi42ODFjMTIuMDIxLDAsMjEuMzYtNC43OSwyOC4wMjMtMTQuMzc3DQoJCWMwLjY0Ny0xLjEzNiwxLjYyMi0xLjcwNiwyLjkyNC0xLjcwNmMyLjI3MywwLDMuNDEyLDEuMTM5LDMuNDEyLDMuNDEyYzAsMC4xNjMtMC4xNjQsMC43My0wLjQ4NywxLjcwNQ0KCQljLTMuNDEyLDYuMDEzLTguMjA1LDEwLjQ3OS0xNC4zNzcsMTMuNDAyYy02LjE3NiwyLjkyNC0xMi42NzEsNC4zODctMTkuNDk1LDQuMzg3Yy01LjY4OSwwLTEwLjkyOC0xLjE4MS0xNS43MTgtMy41MzMNCgkJYy00Ljc5My0yLjM1NC04LjkzNi01LjQ4My0xMi40MjgtOS4zODJjLTMuNDk1LTMuODk5LTYuMjE0LTguNDA3LTguMTYzLTEzLjUyNGMtMS45NS01LjExOC0yLjkyNC0xMC40MzctMi45MjQtMTUuOTYyDQoJCWMwLTUuNTIxLDAuOTc1LTEwLjg0NCwyLjkyNC0xNS45NjFjMS45NDktNS4xMTcsNC42NjgtOS42MjUsOC4xNjMtMTMuNTI0YzMuNDkyLTMuODk4LDcuNjM0LTcuMDI0LDEyLjQyOC05LjM4MQ0KCQlDMTI2Ljg0Niw0MjguMzc5LDEzMi4wODQsNDI3LjE5OCwxMzcuNzczLDQyNy4xOTh6IE0xNjkuOTQsNDY2LjE4OGMtMC4zMjgtNC4yMjMtMS4zNDEtOC4yODUtMy4wNDYtMTIuMTg0DQoJCWMtMS43MDYtMy44OTktMy45ODItNy4zMTItNi44MjMtMTAuMjM1Yy0yLjg0NC0yLjkyNC02LjE3NS01LjI3Ny05Ljk5MS03LjA2N2MtMy44MTktMS43ODUtNy45Mi0yLjY4LTEyLjMwNi0yLjY4DQoJCWMtNC41NSwwLTguNjkyLDAuODk1LTEyLjQyOCwyLjY4Yy0zLjczOSwxLjc5LTYuOTg3LDQuMTQ0LTkuNzQ4LDcuMDY3Yy0yLjc2NCwyLjkyNC00Ljk5NSw2LjMzNi02LjcwMSwxMC4yMzUNCgkJYy0xLjcwNiwzLjg5OC0yLjgwMiw3Ljk2MS0zLjI5LDEyLjE4NEgxNjkuOTR6Ii8+DQoJPHBhdGggZmlsbD0iIzQxNDA0MiIgZD0iTTMwNC42OSw0MjcuNDQxYzUuMDM0LDAsOS41MDQsMS4wMTgsMTMuNDAyLDMuMDQ3YzMuODk5LDIuMDMzLDcuMTg5LDQuNjcyLDkuODcsNy45Mg0KCQljMi42OCwzLjI1MSw0LjcwOSw3LjA2Niw2LjA5MiwxMS40NTJjMS4zNzksNC4zODcsMi4wNyw4Ljg1NiwyLjA3LDEzLjQwMnY0My42MmMwLDAuOTc1LTAuMzY1LDEuNzg5LTEuMDk3LDIuNDM4DQoJCWMtMC43MywwLjY0Ni0xLjUwMywwLjk3NS0yLjMxMywwLjk3NWMtMi4yNzYsMC0zLjQxMi0xLjE0LTMuNDEyLTMuNDEydi00My42MmMwLTMuNTcxLTAuNTI5LTcuMTA0LTEuNTg0LTEwLjYNCgkJYy0xLjA1OS0zLjQ5MS0yLjYwMi02LjYxOC00LjYzLTkuMzgyYy0yLjAzMy0yLjc2MS00LjU5Mi00Ljk1My03LjY3Ny02LjU4Yy0zLjA4OC0xLjYyMS02LjY2Mi0yLjQzNi0xMC43MjItMi40MzYNCgkJYy01LjIsMC05LjU4NywxLjIxOC0xMy4xNTksMy42NTRjLTMuNTc0LDIuNDM4LTYuNDU3LDUuNTY2LTguNjUsOS4zODJjLTIuMTkzLDMuODE5LTMuODE4LDguMDQyLTQuODc0LDEyLjY3Mg0KCQljLTEuMDU5LDQuNjMtMS41ODQsOS4wNTgtMS41ODQsMTMuMjh2MzMuNjI5YzAsMC45NzUtMC4zNjUsMS43ODktMS4wOTYsMi40MzhjLTAuNzMxLDAuNjQ2LTEuNTA1LDAuOTc1LTIuMzE1LDAuOTc1DQoJCWMtMi4yNzYsMC0zLjQxMS0xLjE0LTMuNDExLTMuNDEydi00My42MmMwLTMuNTcxLTAuNTMtNy4xMDQtMS41ODUtMTAuNmMtMS4wNTgtMy40OTEtMi42MDEtNi42MTgtNC42MjktOS4zODINCgkJYy0yLjAzNC0yLjc2MS00LjU5Mi00Ljk1My03LjY3Ny02LjU4Yy0zLjA4Ny0xLjYyMS02LjY2My0yLjQzNi0xMC43MjItMi40MzZjLTUuMDM3LDAtOS4zNDQsMC44OTUtMTIuOTE1LDIuNjgNCgkJYy0zLjU3NSwxLjc5LTYuNTQyLDQuMjY2LTguODk1LDcuNDMzYy0yLjM1NywzLjE2Ny00LjA2Myw2Ljk0NC01LjExNywxMS4zMzFjLTEuMDU5LDQuMzg2LTEuNTg0LDkuMS0xLjU4NCwxNC4xMzR2My44OTl2MC4yNDMNCgkJdjMyLjg5N2MwLDIuMjcyLTEuMTM4LDMuNDEyLTMuNDEyLDMuNDEyYy0yLjI3NiwwLTMuNDExLTEuMTQtMy40MTEtMy40MTJ2LTc0LjU2N2MwLTIuMjczLDEuMTM1LTMuNDExLDMuNDExLTMuNDExDQoJCWMyLjI3MywwLDMuNDEyLDEuMTM4LDMuNDEyLDMuNDExdjEyLjQyOGMyLjkyNC01LjE5Nyw2Ljg2MS05LjM4MiwxMS44MTktMTIuNTVjNC45NTQtMy4xNjcsMTAuNTE3LTQuNzUyLDE2LjY5Mi00Ljc1Mg0KCQljNi45ODMsMCwxMi45OTUsMS45OTEsMTguMDMyLDUuOTdjNS4wMzMsMy45ODMsOC42ODgsOS4yMjMsMTAuOTY2LDE1LjcxOWMyLjc2LTYuMzM2LDYuNzM5LTExLjUzMywxMS45NC0xNS41OTYNCgkJQzI5MS4xMjUsNDI5LjQ3NSwyOTcuMzgsNDI3LjQ0MSwzMDQuNjksNDI3LjQ0MXoiLz4NCgk8cGF0aCBmaWxsPSIjNDE0MDQyIiBkPSJNMzc4Ljc1Myw0MjkuMzkyYzAuODExLDAsMS41ODQsMC4zNjUsMi4zMTQsMS4wOTdjMC43MzEsMC43MywxLjA5NywxLjUwNCwxLjA5NywyLjMxNHY3NC4wOA0KCQljMCwwLjgxNC0wLjM2NSwxLjU4NC0xLjA5NywyLjMxNWMtMC43MywwLjczLTEuNTA0LDEuMDk3LTIuMzE0LDEuMDk3Yy0wLjk3NSwwLTEuNzktMC4zNjYtMi40MzgtMS4wOTcNCgkJYy0wLjY1LTAuNzMxLTAuOTc1LTEuNTAxLTAuOTc1LTIuMzE1di03NC4wOGMwLTAuODExLDAuMzI0LTEuNTg0LDAuOTc1LTIuMzE0QzM3Ni45NjMsNDI5Ljc1NywzNzcuNzc4LDQyOS4zOTIsMzc4Ljc1Myw0MjkuMzkyeiINCgkJLz4NCgk8cGF0aCBmaWxsPSIjNDE0MDQyIiBkPSJNNDczLjM0LDQyOC42NmMyLjI3MywwLDMuNDEyLDEuMTM5LDMuNDEyLDMuNDExbC0wLjQ4NywxLjk1bC0yNC4zNjgsMzUuMzM0bDI0LjM2OCwzNS41NzcNCgkJYzAuMzIzLDAuOTc2LDAuNDg3LDEuNjI2LDAuNDg3LDEuOTVjMCwyLjI3Mi0xLjEzOSwzLjQxMi0zLjQxMiwzLjQxMmMtMS4zMDIsMC0yLjE5My0wLjQ4OC0yLjY4LTEuNDYzbC0yMi45MDYtMzMuMzg0DQoJCWwtMjIuNjYzLDMzLjM4NGMtMC44MTQsMC45NzUtMS43OSwxLjQ2My0yLjkyNCwxLjQ2M2MtMi4yNzcsMC0zLjQxMS0xLjE0LTMuNDExLTMuNDEyYzAtMC4zMjQsMC4xNTktMC45NzUsMC40ODYtMS45NQ0KCQlsMjQuMzY5LTM1LjU3N2wtMjQuMzY5LTM1LjMzNGwtMC40ODYtMS45NWMwLTIuMjcyLDEuMTM0LTMuNDExLDMuNDExLTMuNDExYzEuMTM0LDAsMi4xMDksMC40ODcsMi45MjQsMS40NjJsMjIuNjYzLDMzLjE0MQ0KCQlsMjIuOTA2LTMzLjE0MUM0NzEuMTQ2LDQyOS4xNDcsNDcyLjAzOCw0MjguNjYsNDczLjM0LDQyOC42NnoiLz4NCjwvZz4NCjxnPg0KCTxnPg0KCQk8ZyBvcGFjaXR5PSIwLjQ1Ij4NCgkJCTxnPg0KCQkJCTxwb2x5Z29uIGZpbGw9IiMwMTAxMDEiIHBvaW50cz0iMTUwLjczNCwxOTYuMjEyIDI1NS45NjksMzQ0LjUwOCAyNTUuOTY5LDI1OC4zODcgCQkJCSIvPg0KCQkJPC9nPg0KCQk8L2c+DQoJCTxnIG9wYWNpdHk9IjAuOCI+DQoJCQk8Zz4NCgkJCQk8cG9seWdvbiBmaWxsPSIjMDEwMTAxIiBwb2ludHM9IjI1NS45NjksMjU4LjM4NyAyNTUuOTY5LDM0NC41MDggMzYxLjI2NywxOTYuMjEyIAkJCQkiLz4NCgkJCTwvZz4NCgkJPC9nPg0KCQk8ZyBvcGFjaXR5PSIwLjYiPg0KCQkJPGc+DQoJCQkJPHBvbHlnb24gZmlsbD0iIzAxMDEwMSIgcG9pbnRzPSIyNTUuOTY5LDEyNi43ODEgMTUwLjczMywxNzQuNjExIDI1NS45NjksMjM2LjgxOCAzNjEuMjA0LDE3NC42MTEgCQkJCSIvPg0KCQkJPC9nPg0KCQk8L2c+DQoJCTxnIG9wYWNpdHk9IjAuNDUiPg0KCQkJPGc+DQoJCQkJPHBvbHlnb24gZmlsbD0iIzAxMDEwMSIgcG9pbnRzPSIxNTAuNzM0LDE3NC42MTIgMjU1Ljk2OSwyMzYuODE4IDI1NS45NjksMTI2Ljc4MiAyNTUuOTY5LDAuMDAxIAkJCQkiLz4NCgkJCTwvZz4NCgkJPC9nPg0KCQk8ZyBvcGFjaXR5PSIwLjgiPg0KCQkJPGc+DQoJCQkJPHBvbHlnb24gZmlsbD0iIzAxMDEwMSIgcG9pbnRzPSIyNTUuOTY5LDAgMjU1Ljk2OSwxMjYuNzgxIDI1NS45NjksMjM2LjgxOCAzNjEuMjA0LDE3NC42MTEgCQkJCSIvPg0KCQkJPC9nPg0KCQk8L2c+DQoJPC9nPg0KPC9nPg0KPC9zdmc+DQo=');
    opacity           : 0.1;
    top               : 15%;
    left              : 33%;
    bottom            : 0;
    right             : 0;
    position          : absolute;
    background-repeat : no-repeat;
    background-size   : 45%;
  }
  .terminal_1ywR9V    {
    position: relative;
    display: flex;
    flex-direction: column;
    height: 100%;
  }
  .journal_1ywR9V            {
    margin-top        : auto;
    font-family       : monospace;
  }
  .block_1ywR9V              {
    word-break        : break-all;
    white-space       : pre-wrap;
    line-height       : 2ch;
    margin            : 1ch;
    margin-top        : 2ch;
  }
  .cli_1ywR9V                {
    line-height       : 1.7em;
    font-family       : monospace;
    background-color  : hsla(0, 0%, 40%, .2);
    padding           : .4em;
    color             : hsl(0, 0%, 0%);
    border-top        : solid 2px hsla(202, 91%, 75%, .4);
  }
  .prompt_1ywR9V             {
    margin-right      : 0.5em;
    font-family       : monospace;
    font-weight       : bold;
    font-size         : large;
    color             : undefined;
  }
  .input_1ywR9V              {
    word-break        : break-all;
    outline           : none;
    font-family       : monospace;
  }
  .search_1ywR9V {
    display: flex;
    align-items: center;
    margin-right: 10px;
  }
  .filter_1ywR9V             {
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid hsla(0, 0%, 40%, .2);
        color                 : hsl(0, 0%, 0%);
        border-radius         : 5px;
        height                : 25px;
        width                 : 250px;
        padding               : 0 8px;
        overflow              : hidden;
        word-break            : normal;
      
    width                       : 200px;
    padding-right               : 0px;
    margin-right                : 0px;
    border-top-left-radius      : 0px;
    border-bottom-left-radius   : 0px;
  }
  .searchIcon_1ywR9V {
    background-color            : hsla(0, 0%, 40%, .2);
    color                       : hsl(0, 0%, 0%);
    height                      : 25px;
    width                       : 25px;
    border-top-left-radius      : 3px;
    border-bottom-left-radius   : 3px;
    display                     : flex;
    align-items                 : center;
    justify-content             : center;
  }
  .listen_1ywR9V {
    min-width         : 120px;
    display           : flex;
  }
  .dragbarHorizontal_1ywR9V  {
    position          : absolute;
    top               : 0;
    height            : 0.5em;
    right             : 0;
    left              : 0;
    cursor            : ns-resize;
    z-index           : 999;
    border-top        : 2px solid undefined;
  }
  .ghostbar_1ywR9V           {
    position          : absolute;
    height            : 6px;
    background-color  : hsla(202, 91%, 75%, .4);
    opacity           : 0.5;
    cursor            : row-resize;
    z-index           : 9999;
    left              : 0;
    right             : 0;
  }
</style><style type="text/css">
  .editorpanel_U8oth         {
    display            : flex;
    flex-direction     : column;
    height             : 100%;
  }
  .tabsbar_U8oth             {
    background-color   : hsl(0, 0%, 100%);
    display            : flex;
    overflow           : hidden;
    height             : 30px;
  }
  .tabs_U8oth               {
    position          : relative;
    display           : flex;
    margin            : 0;
    left              : 10px;
    margin-right      : 10px;
    width             : 100%;
    overflow          : hidden;
  }
  .files_U8oth              {
    display           : flex;
    position          : relative;
    list-style        : none;
    margin            : 0;
    font-size         : 15px;
    height            : 2.5em;
    box-sizing        : border-box;
    line-height       : 2em;
    top               : 0;
    border-bottom     : 0 none;
  }
  .changeeditorfontsize_U8oth {
    margin            : 0;
    font-size         : 9px;
    margin-top        : 0.5em;
  }
  .changeeditorfontsize_U8oth i {
    cursor            : pointer;
    display           : block;
    color             : hsl(0, 0%, 0%);
  }
  .changeeditorfontsize_U8oth i {
    cursor            : pointer;
  }
  .changeeditorfontsize_U8oth i:hover {
    color             : hsla(44, 100%, 50%, 1);
  }
  .buttons_U8oth            {
    display           : flex;
    flex-direction    : row;
    justify-content   : space-around;
    align-items       : center;
    min-width         : 45px;
  }
  .toggleLHP_U8oth          {
    display           : flex;
    padding           : 10px;
    width             : 100%;
    font-weight       : bold;
    color             : hsl(0, 0%, 0%);
  }
  .toggleLHP_U8oth i        {
    cursor            : pointer;
    font-size         : 14px;
    font-weight       : bold;
  }
  .toggleLHP_U8oth i:hover  {
    color             : hsla(44, 100%, 50%, 1);
  }
  .scroller_U8oth           {
    position          : absolute;
    z-index           : 999;
    text-align        : center;
    cursor            : pointer;
    vertical-align    : middle;
    background-color  : undefined;
    height            : 100%;
    font-size         : 1.3em;
    color             : orange;
  }
  .scrollerright_U8oth      {
    right             : 0;
    margin-right      : 15px;
  }
  .scrollerleft_U8oth       {
    left              : 0;
  }
  .toggleRHP_U8oth          {
    margin            : 0.5em;
    font-weight       : bold;
    color             : hsl(0, 0%, 0%);
    right             : 0;
  }
  .toggleRHP_U8oth i        {
    cursor            : pointer;
    font-size         : 14px;
    font-weight       : bold;
  }
  .toggleRHP_U8oth i:hover  {
    color             : hsla(44, 100%, 50%, 1);
  }
  .show_U8oth               {
    opacity           : 1;
    transition        : .3s opacity ease-in;
  }
  .hide_U8oth               {
    opacity           : 0;
    pointer-events    : none;
    transition        : .3s opacity ease-in;
  }
  .content_U8oth            {
    position          : relative;
    display           : flex;
    flex-direction    : column;
    height            : 100%;
    width             : 100%;
  }
  .contextviewcontainer_U8oth{
    width             : 100%;
    height            : 20px;
    background-color  : hsla(229, 100%, 97%, 1);
  }
</style><style type="text/css">
  li.active_2i0m4j {
    background-color: hsla(229, 100%, 97%, 1);
    color: hsl(0, 0%, 0%)
  }
  .options_2i0m4j {
    float: left;
    padding-top: 0.7em;
    min-width: 60px;
    font-size: 0.9em;
    cursor: pointer;
    font-size: 1em;
    text-align: center;
  }
  .opts_2i0m4j {
    display: flex;
    list-style: none;
    margin: 0;
    padding: 0;
  }
  .opts_li_2i0m4j {
    display: block;
    font-weight: bold;
    color: hsl(0, 0%, 0%)
  }
  .opts_li_2i0m4j.active_2i0m4j {
    color: hsl(0, 0%, 0%)
  }
  .opts_li_2i0m4j:hover {
    color: hsla(44, 100%, 50%, 1)
  }
</style><style type="text/css">
  .compileTabView_1E3fzD {
    padding: 2%;
  }
  .contract_1E3fzD {
    display: block;
    margin: 3% 0;
  }
  .compileContainer_1E3fzD  {
    
        background-color      : hsla(229, 100%, 97%, 1);
        border                : 1px solid hsl(0, 0%, 100%);
        color                 : hsl(0, 0%, 0%);
        border-radius         : 3px;
        font-size             : 12px;
        padding               : 10px 15px;
        line-height           : 20px;
        overflow              : hidden;
        word-break            : break-word;
        width                 : 100%;
      ;
    margin-bottom: 2%;
  }
  .autocompileContainer_1E3fzD {
    width: 90px;
    display: flex;
    align-items: center;
  }
  .autocompile_1E3fzD {}
  .autocompileTitle_1E3fzD {
    font-weight: bold;
    margin: 1% 0;
  }
  .autocompileText_1E3fzD {
    margin: 1% 0;
    font-size: 12px;
    overflow: hidden;
    word-break: normal;
    line-height: initial;
  }
  .warnCompilationSlow_1E3fzD {
    color: hsla(44, 100%, 50%, .5);
    margin-left: 1%;
  }
  .compileButtons_1E3fzD {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
  }
  .name_1E3fzD {
    display: flex;
  }
  .size_1E3fzD {
    display: flex;
  }
  .compileButton_1E3fzD {
    
      margin                  : 1px;
      background-color        : hsla(229, 75%, 87%, .5);
      border                  : .3px solid hsla(229, 75%, 87%, .5);
      color                   : hsl(0, 0%, 0%);
      display                 : flex;
      align-items             : center;
      justify-content         : center;
      border-radius           : 3px;
      cursor                  : pointer;
      min-height              : 25px;
      max-height              : 25px;
      width                   : 70px;
      min-width               : 70px;
      font-size               : 12px;
      overflow                : hidden;
      word-break              : normal;
      ;
    width: 120px;
    min-width: 110px;
    margin-right: 1%;
    font-size: 12px;
  }
  .container_1E3fzD {
    
        background-color      : hsla(229, 100%, 97%, 1);
        border                : 1px solid hsl(0, 0%, 100%);
        color                 : hsl(0, 0%, 0%);
        border-radius         : 3px;
        font-size             : 12px;
        padding               : 10px 15px;
        line-height           : 20px;
        overflow              : hidden;
        word-break            : break-word;
        width                 : 100%;
      ;
    margin: 0;
    display: flex;
    align-items: center;
  }
  .contractNames_1E3fzD {
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid hsla(0, 0%, 40%, .2);
        color                 : hsl(0, 0%, 0%);
        font-size               : 12px;
        font-weight             : bold;
        padding                 : 0 8px;
        text-decoration         : none;
        cursor                  : pointer;
        border-radius           : 3px;
        height                  : 25px;
        width                   : 100%;
        text-align              : center;
        overflow                : hidden;
        word-break              : normal;
      ;
    margin-right: 5%;
  }
  .contractButtons_1E3fzD {
    display: flex;
    cursor: pointer;
    justify-content: center;
    text-align: center;
  }
  .details_1E3fzD {
    
      margin                  : 1px;
      background-color        : hsla(0, 0%, 40%, .2);
      border                  : .3px solid hsla(0, 0%, 40%, .2);
      color                   : hsl(0, 0%, 0%);
      display                 : flex;
      align-items             : center;
      justify-content         : center;
      border-radius           : 3px;
      cursor                  : pointer;
      min-height              : 25px;
      max-height              : 25px;
      width                   : 70px;
      min-width               : 70px;
      font-size               : 12px;
      overflow                : hidden;
      word-break              : normal;
      ;
  }
  .publish_1E3fzD {
    
      margin                  : 1px;
      background-color        : hsla(0, 0%, 40%, .2);
      border                  : .3px solid hsla(0, 0%, 40%, .2);
      color                   : hsl(0, 0%, 0%);
      display                 : flex;
      align-items             : center;
      justify-content         : center;
      border-radius           : 3px;
      cursor                  : pointer;
      min-height              : 25px;
      max-height              : 25px;
      width                   : 70px;
      min-width               : 70px;
      font-size               : 12px;
      overflow                : hidden;
      word-break              : normal;
      ;
    margin-left: 2%;
    width: 120px;
  }
  .log_1E3fzD {
    
        background-color      : hsla(229, 100%, 97%, 1);
        border                : 1px solid hsl(0, 0%, 100%);
        color                 : hsl(0, 0%, 0%);
        border-radius         : 3px;
        font-size             : 12px;
        padding               : 10px 15px;
        line-height           : 20px;
        overflow              : hidden;
        word-break            : break-word;
        width                 : 100%;
      ;
    display: flex;
    flex-direction: column;
    margin-bottom: 5%;
    overflow: visible;
  }
  .key_1E3fzD {
    margin-right: 5px;
    color: hsl(0, 0%, 0%);
    text-transform: uppercase;
    width: 100%;
  }
  .value_1E3fzD {
    display: flex;
    width: 100%;
    margin-top: 1.5%;
  }
  .questionMark_1E3fzD {
    margin-left: 2%;
    cursor: pointer;
    color: hsl(0, 0%, 0%);
  }
  .questionMark_1E3fzD:hover {
    color: hsla(44, 100%, 50%, 1);
  }
  .detailsJSON_1E3fzD {
    padding: 8px 0;
    background-color: undefined;
    border: none;
    color: undefined;
  }
  .icon_1E3fzD {
    margin-right: 3%;
  }
  .spinningIcon_1E3fzD {
    margin-right: .3em;
    animation: spin_1E3fzD 2s linear infinite;
  }
  .bouncingIcon_1E3fzD {
    margin-right: .3em;
    animation: bounce_1E3fzD 2s infinite;
  }
  @keyframes spin_1E3fzD {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
  }
  @-webkit-keyframes bounce_1E3fzD {
  0% {
    margin-bottom: 0;
    color: transparent;
  }
  70% {
    margin-bottom: 0;
    color: hsla(0, 0%, 40%, 1);
  }
  100% {
    margin-bottom: 0;
    color: transparent;
  }
}
</style><style type="text/css">
  .runTabView_3uyLA6 {
    padding: 2%;
    display: flex;
    flex-direction: column;
  }
  .settings_3uyLA6 {
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid undefined;
        color                 : hsl(0, 0%, 0%);
        border-radius         : 3px;
        font-size             : 12px;
        padding               : 10px 15px;
        line-height           : 20px;
        overflow              : hidden;
        word-break            : break-word;
        width                 : 100%;
      
    margin-bottom: 2%;
    padding: 10px 15px 15px 15px;
  }
  .crow_3uyLA6 {
    margin-top: .5em;
    display: flex;
    align-items: center;
  }
  .col1_3uyLA6 {
    width: 30%;
    float: left;
    align-self: center;
  }
  .col1_1_3uyLA6 {
    font-size: 12px;
    width: 25%;
    min-width: 75px;
    float: left;
    align-self: center;
  }
  .environment_3uyLA6 {
    display: flex;
    align-items: center;
    position: relative;
  }
  .col2_3uyLA6 {
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid hsla(0, 0%, 40%, .2);
        color                 : hsl(0, 0%, 0%);
        border-radius         : 5px;
        height                : 25px;
        width                 : 250px;
        padding               : 0 8px;
        overflow              : hidden;
        word-break            : normal;
      
  }
  .col2_1_3uyLA6 {
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid hsla(0, 0%, 40%, .2);
        color                 : hsl(0, 0%, 0%);
        border-radius         : 5px;
        height                : 25px;
        width                 : 250px;
        padding               : 0 8px;
        overflow              : hidden;
        word-break            : normal;
      
    width: 165px;
    min-width: 165px;
  }
  .col2_2_3uyLA6 {
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid hsla(0, 0%, 40%, .2);
        color                 : hsl(0, 0%, 0%);
        font-size               : 12px;
        font-weight             : bold;
        padding                 : 0 8px;
        text-decoration         : none;
        cursor                  : pointer;
        border-radius           : 3px;
        height                  : 25px;
        width                   : 100%;
        text-align              : center;
        overflow                : hidden;
        word-break              : normal;
      
    width: 82px;
    min-width: 82px;
  }
  .select_3uyLA6 {
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid hsla(0, 0%, 40%, .2);
        color                 : hsl(0, 0%, 0%);
        font-size               : 12px;
        font-weight             : bold;
        padding                 : 0 8px;
        text-decoration         : none;
        cursor                  : pointer;
        border-radius           : 3px;
        height                  : 25px;
        width                   : 100%;
        text-align              : center;
        overflow                : hidden;
        word-break              : normal;
      
    font-weight: normal;
    width: 250px;
  }
  .instanceContainer_3uyLA6 {
    display: flex;
    flex-direction: column;
    margin-top: 2%;
    border: none;
    text-align: center;
  }
  .pendingTxsContainer_3uyLA6  {
    
        background-color      : hsl(0, 0%, 100%);
        color                 : hsl(0, 0%, 0%);
        font-size             : 12px;
        padding               : 10px 15px;
        line-height           : 20px;
        overflow              : hidden;
        word-break            : break-word;
        width                 : 100%;
      
    display: flex;
    flex-direction: column;
    margin-top: 2%;
    border: none;
    text-align: center;
  }
  .container_3uyLA6 {
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid undefined;
        color                 : hsl(0, 0%, 0%);
        border-radius         : 3px;
        font-size             : 12px;
        padding               : 10px 15px;
        line-height           : 20px;
        overflow              : hidden;
        word-break            : break-word;
        width                 : 100%;
      
    margin-top: 2%;
  }
  .contractNames_3uyLA6 {
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid hsla(0, 0%, 40%, .2);
        color                 : hsl(0, 0%, 0%);
        font-size               : 12px;
        font-weight             : bold;
        padding                 : 0 8px;
        text-decoration         : none;
        cursor                  : pointer;
        border-radius           : 3px;
        height                  : 25px;
        width                   : 100%;
        text-align              : center;
        overflow                : hidden;
        word-break              : normal;
      
    width: 100%;
    border: 1px solid
  }
  .contractNamesError_3uyLA6 {
    border: 1px solid hsla(0, 100%, 71%, 1)
  }
  .subcontainer_3uyLA6 {
    display: flex;
    flex-direction: row;
    align-items: baseline;
  }
  .button_3uyLA6 {
    display: flex;
    align-items: center;
    margin-top: 2%;
  }
  .transaction_3uyLA6 {
    undefined
  }
  .atAddress_3uyLA6 {
    
      margin                  : 1px;
      background-color        : hsla(229, 75%, 87%, .5);
      border                  : .3px solid hsla(229, 75%, 87%, .5);
      color                   : hsl(0, 0%, 0%);
      display                 : flex;
      align-items             : center;
      justify-content         : center;
      border-radius           : 3px;
      cursor                  : pointer;
      min-height              : 25px;
      max-height              : 25px;
      width                   : 70px;
      min-width               : 70px;
      font-size               : 12px;
      overflow                : hidden;
      word-break              : normal;
      
  }
  .create_3uyLA6 {
    
      margin                  : 1px;
      background-color        : hsla(0, 82%, 82%, .5);
      border                  : .3px solid hsla(0, 82%, 82%, .5);
      color                   : hsl(0, 0%, 0%);
      display                 : flex;
      align-items             : center;
      justify-content         : center;
      border-radius           : 3px;
      cursor                  : pointer;
      min-height              : 25px;
      max-height              : 25px;
      width                   : 70px;
      min-width               : 70px;
      font-size               : 12px;
      overflow                : hidden;
      word-break              : normal;
      
  }
  .input_3uyLA6 {
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid hsla(0, 0%, 40%, .2);
        color                 : hsl(0, 0%, 0%);
        border-radius         : 5px;
        height                : 25px;
        width                 : 250px;
        padding               : 0 8px;
        overflow              : hidden;
        word-break            : normal;
      
  }
  .noInstancesText_3uyLA6 {
    
        background-color      : hsl(0, 0%, 100%);
        color                 : hsl(0, 0%, 0%);
        font-size             : 12px;
        padding               : 10px 15px;
        line-height           : 20px;
        overflow              : hidden;
        word-break            : break-word;
        width                 : 100%;
      
    font-style: italic;
  }
  .pendingTxsText_3uyLA6 {
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid hsla(0, 0%, 40%, .2);
        color                 : hsl(0, 0%, 0%);
        border-radius         : 3px;
        font-size             : 12px;
        padding               : 10px 15px;
        line-height           : 20px;
        overflow              : hidden;
        word-break            : break-word;
        width                 : 100%;
      
    font-style: italic;
    display: flex;
    justify-content: space-evenly;
    align-items: center;
    flex-wrap: wrap;
  }
  .item_3uyLA6 {
    margin-right: 1em;
    display: flex;
    align-items: center;
  }
  .transact_3uyLA6 {
    color: hsla(0, 82%, 82%, .5);
    margin-right: .3em;
  }
  .payable_3uyLA6 {
    color: hsla(0, 82%, 82%, 1);
    margin-right: .3em;
  }
  .call_3uyLA6 {
    color: hsla(229, 75%, 87%, .5);
    margin-right: .3em;
  }
  .pendingContainer_3uyLA6 {
    display: flex;
    align-items: baseline;
  }
  .pending_3uyLA6 {
    height: 25px;
    text-align: center;
    padding-left: 10px;
    border-radius: 3px;
    margin-left: 5px;
  }
  .icon_3uyLA6 {
    cursor: pointer;
    font-size: 12px;
    cursor: pointer;
    color: hsl(0, 0%, 0%);
    margin-left: 5px;
  }
  .icon_3uyLA6:hover {
    font-size: 12px;
    color: hsla(44, 100%, 50%, 1);
  }
  .errorIcon_3uyLA6 {
    color: hsla(0, 100%, 71%, 1);
    margin-left: 15px;
  }
  .failDesc_3uyLA6 {
    color: hsla(0, 100%, 71%, 1);
    padding-left: 10px;
    display: inline;
  }
  .network_3uyLA6 {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    position: absolute;
    color: grey;
    width: 100%;
    height: 100%;
    padding-right: 28px;
    pointer-events: none;
  }
  .networkItem_3uyLA6 {
    margin-right: 5px;
  }
  .clearinstance_3uyLA6 {}
  .transactionActions_3uyLA6 {
    display: flex;
    width: 70px;
    justify-content: space-between;
    border: 1px solid hsla(0, 0%, 40%, .2);
    padding: 5px;
    border-radius: 3px;
}
</style><style type="text/css">
  .settingsTabView_2WRVNz {
    padding: 2%;
    display: flex;
  }
  .info_2WRVNz {
    
        background-color      : hsl(0, 0%, 100%);
        border                : .2em dotted hsla(0, 0%, 40%, .2);
        color                 : hsl(0, 0%, 0%);
        border-radius         : 5px;
        line-height           : 20px;
        padding               : 8px 15px;
        margin-bottom         : 1em;
        overflow              : hidden;
        word-break            : break-word;
      
    margin-bottom: 1em;
    word-break: break-word;
  }
  .title_2WRVNz {
    font-size: 1.1em;
    font-weight: bold;
    margin-bottom: 1em;
  }
  .crow_2WRVNz {
    display: flex;
    overflow: auto;
    clear: both;
    padding: .2em;
  }
  .checkboxText_2WRVNz {
    font-weight: normal;
  }
  .crow_2WRVNz label {
    cursor:pointer;
  }
  .crowNoFlex_2WRVNz {
    overflow: auto;
    clear: both;
  }
  .attention_2WRVNz {
    margin-bottom: 1em;
    padding: .5em;
    font-weight: bold;
  }
  .select_2WRVNz {
    font-weight: bold;
    margin-top: 1em;
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid hsla(0, 0%, 40%, .2);
        color                 : hsl(0, 0%, 0%);
        font-size               : 12px;
        font-weight             : bold;
        padding                 : 0 8px;
        text-decoration         : none;
        cursor                  : pointer;
        border-radius           : 3px;
        height                  : 25px;
        width                   : 100%;
        text-align              : center;
        overflow                : hidden;
        word-break              : normal;
      
  }
  .heading_2WRVNz {
    margin-bottom: 0;
  }
  .explaination_2WRVNz {
    margin-top: 3px;
    margin-bottom: 3px;
  }
  input {
    margin-right: 5px;
    cursor: pointer;
  }
  input[type=radio] {
    margin-top: 2px;
  }
  .pluginTextArea_2WRVNz {
    font-family: unset;
  }
  .pluginLoad_2WRVNz {
    vertical-align: top;
  }
  i.warnIt_2WRVNz {
    color: hsla(44, 100%, 50%, 1);
  }
  .icon_2WRVNz {
    margin-right: .5em;
  }
  .remixdinstallation_2WRVNz {
    padding: 3px;
    border-radius: 2px;
    margin-left: 5px;
  }
}
</style><style type="text/css">
  .analysisTabView_2Q7xJW {
    padding: 2%;
    padding-bottom: 3em;
    display: flex;
    flex-direction: column;
  }
  #staticanalysisView {
    display: block;
  }
  .infoBox_2Q7xJW  {
    undefined
    margin-bottom: 1em;
  }
  .textBox_2Q7xJW  {
    undefined
    margin-bottom: 1em;
  }
</style><style type="text/css">
  .debuggerTabView_1Krd0C {
    padding: 2%;
  }
  .debugger_1Krd0C {
    margin-bottom: 1%;
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid hsl(0, 0%, 100%);
        color                 : hsl(0, 0%, 0%);
        border-radius         : 3px;
        font-size             : 12px;
        padding               : 10px 15px;
        line-height           : 20px;
        overflow              : hidden;
        word-break            : break-word;
        width                 : 100%;
      
  }
</style><style type="text/css">
  .supportTabView_MSjcF {
    height: 100vh;
    padding: 2%;
    padding-bottom: 3em;
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }
  .chat_MSjcF {
    
        background-color      : hsl(0, 0%, 100%);
        border                : 1px solid hsl(0, 0%, 100%);
        color                 : hsl(0, 0%, 0%);
        border-radius         : 3px;
        font-size             : 12px;
        padding               : 10px 15px;
        line-height           : 20px;
        overflow              : hidden;
        word-break            : break-word;
        width                 : 100%;
      
    display: flex;
    flex-direction: column;
    align-items: center;
    height: 85%;
    padding: 0;
  }
  .chatTitle_MSjcF {
    height: 40px;
    width: 90%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 15px;
  }
  .chatTitle_MSjcF:hover {
    cursor: pointer;
  }
  .icon_MSjcF {
    height: 70%;
    margin-right: 2%;
  }
  .chatTitleText_MSjcF {
    font-size: 17px;
    font-weight: bold;
  }
  .chatTitleText_MSjcF {
    opacity: 0.8;
  }
  .chatIframe_MSjcF {
    width: 100%;
    height: 100%;
    transform: scale(0.9);
    padding: 0;
    border: none;
  }
  .infoBox_MSjcF {
    
        background-color      : hsl(0, 0%, 100%);
        border                : .2em dotted hsla(0, 0%, 40%, .2);
        color                 : hsl(0, 0%, 0%);
        border-radius         : 5px;
        line-height           : 20px;
        padding               : 8px 15px;
        margin-bottom         : 1em;
        overflow              : hidden;
        word-break            : break-word;
      
  }
</style><style type="text/css">
  .pluginTabView_2Mr2h7 {
    height: 100%;
    width: 100%;
  }
  
  .iframe_2Mr2h7 {
    height: 100%;
    width: 100%;
    border: 0;
  }
</style><style type="text/css">
  #righthand-panel {
    display: flex;
    flex-direction: column;
    top: 0;
    right: 0;
    bottom: 0;
    box-sizing: border-box;
    overflow: hidden;
  }
  #optionViews {
    background-color: hsla(229, 100%, 97%, 1);
    overflow: scroll;
    height: 100%;
  }
  #optionViews > div {
    display: none;
  }
  #optionViews .pre_2zO1Ks {
    word-wrap: break-word;
    background-color: hsl(0, 0%, 100%);
    border-radius: 3px;
    display: inline-block;
    padding: 0 0.6em;
  }
  #optionViews .hide_2zO1Ks {
    display: none;
  }
  a {
    color: hsla(233, 91%, 58%, 1);
  }
  .menu_2zO1Ks {
    display: flex;
    background-color: hsl(0, 0%, 100%);
  }
  .options_2zO1Ks {
    float: left;
    padding-top: 0.7em;
    min-width: 60px;
    font-size: 0.9em;
    cursor: pointer;
    font-size: 1em;
    text-align: center;
  }
  .opts_2zO1Ks {
    display: flex;
    list-style: none;
    margin: 0;
    padding: 0;
  }
  .opts_li_2zO1Ks {
    display: block;
    font-weight: bold;
    color: hsl(0, 0%, 0%);
  }
  .opts_li_2zO1Ks.active_2zO1Ks {
    color: hsl(0, 0%, 0%);
  }
  .opts_li_2zO1Ks:hover {
    color: hsla(44, 100%, 50%, 1);
  }
  .dragbar_2zO1Ks             {
    position           : absolute;
    width              : 0.5em;
    top                : 3em;
    bottom             : 0;
    cursor             : col-resize;
    z-index            : 999;
    border-left        : 2px solid undefined;
  }
  .ghostbar_2zO1Ks           {
    width             : 3px;
    background-color  : hsla(202, 91%, 75%, .4);
    opacity           : 0.5;
    position          : absolute;
    cursor            : col-resize;
    z-index           : 9999;
    top               : 0;
    bottom            : 0;
  }
  .panel_2zO1Ks              {
    height            : 100%;
  }
  .header_2zO1Ks             {
    height            : 100%;
  }
  .solIcon_2zO1Ks {
    margin-left: 10px;
    margin-right: 30px;
    display: flex;
    align-self: center;
    height: 29px;
    width: 20px;
    background-color: transparent;
  }
</style><style type="text/css">
  .log_zEs4V {
    display: flex;
    align-items: end;
    justify-content: space-between;
  }
  .txLog_zEs4V {
    width: 75%;
  }
  .tx_zEs4V {
    color: hsla(240, 64%, 68%, 1);
    font-weight: bold;
    width: 45%;
  }
  .txTable_zEs4V, .tr_zEs4V, .td_zEs4V {
    border-collapse: collapse;
    font-size: 10px;
    color: hsl(0, 0%, 0%);
    border: 1px solid hsla(0, 0%, 40%, 1);
  }
  #txTable {
    margin-top: 1%;
    margin-bottom: 5%;
    align-self: center;
  }
  .tr_zEs4V, .td_zEs4V {
    padding: 4px;
    vertical-align: baseline;
  }
  .tableTitle_zEs4V {
    width: 25%;
  }
  .buttons_zEs4V {
    display: flex;
  }
  .debug_zEs4V, .details_zEs4V {
    
      margin                  : 1px;
      background-color        : hsl(0, 0%, 100%);
      border                  : .3px solid hsla(0, 0%, 40%, .2);
      color                   : hsl(0, 0%, 0%);
      display                 : flex;
      align-items             : center;
      justify-content         : center;
      border-radius           : 3px;
      cursor                  : pointer;
      min-height              : 25px;
      max-height              : 25px;
      width                   : 70px;
      min-width               : 70px;
      font-size               : 12px;
      overflow                : hidden;
      word-break              : normal;
      
    margin-left: 5px;
    width: 55px;
    min-width: 55px;
    min-height: 20px;
    max-height: 20px;
    font-size: 11px;
  }
  </style><style type="text/css">
  .contextview_2AL0PA            {
      opacity           : 0.8;
    }
  .container_2AL0PA              {
    padding             : 1px 15px;
  }
  .line_2AL0PA                   {
    display             : flex;
    justify-content     : flex-end;
    align-items         : center;
    text-overflow       : ellipsis;
    overflow            : hidden;
    white-space         : nowrap;
    color               : hsl(0, 0%, 0%);
    font-size           : 11px;
  }
  .type_2AL0PA                   {
    font-style        : italic;
    margin-right      : 5px;
  }
  .name_2AL0PA                   {
    font-weight       : bold;
  }
  .jump_2AL0PA                   {
    cursor            : pointer;
    margin            : 0 5px;
    color             : hsl(0, 0%, 0%);
  }
  .jump_2AL0PA:hover              {
    color             : hsla(44, 100%, 50%, 1);
  }
  .referencesnb_2AL0PA           {
    float             : right;
    margin-left       : 15px;
  }
  .gasEstimation_2AL0PA {
    margin-left: 15px;
    display: flex;
    align-items: center;
  }
  .gasStationIcon_2AL0PA {
    height: 13px;
    margin-right: 5px;
  }
</style><style type="text/css">
  html { box-sizing: border-box; }
  *, *:before, *:after { box-sizing: inherit; }
  body                 {
    font: 14px/1.5 Lato, "Helvetica Neue", Helvetica, Arial, sans-serif;
    margin             : 0;
    padding            : 0;
    font-size          : 12px;
    color              : hsl(0, 0%, 0%);
    font-weight        : normal;
  }
  pre {
    overflow-x: auto;
  }
  .browsersolidity_VAxiN     {
    position           : relative;
    width              : 100vw;
    height             : 100vh;
    overflow           : hidden;
  }
  .centerpanel_VAxiN         {
    background-color  : transparent;
    display            : flex;
    flex-direction     : column;
    position           : absolute;
    top                : 0;
    bottom             : 0;
    overflow           : hidden;
  }
  .leftpanel_VAxiN           {
    background-color  : hsl(0, 0%, 100%);
    display            : flex;
    flex-direction     : column;
    position           : absolute;
    top                : 0;
    bottom             : 0;
    left               : 0;
    overflow           : hidden;
  }
  .rightpanel_VAxiN          {
    background-color  : hsla(229, 100%, 97%, 1);
    display            : flex;
    flex-direction     : column;
    position           : absolute;
    top                : 0;
    right              : 0;
    bottom             : 0;
    overflow           : hidden;
  }
  .highlightcode_VAxiN {
    position:absolute;
    z-index:20;
    background-color: hsla(240, 64%, 68%, .5);
  }
  .highlightcode_fullLine_VAxiN {
    position:absolute;
    z-index:20;
    background-color: hsla(240, 64%, 68%, .5);
    opacity: 0.5;
  }
</style><style>
    #files .file {
      padding: 0 0.6em;
      box-sizing: border-box;
      background-color: hsla(229, 100%, 97%, 1);
      cursor: pointer;
      margin-right: 10px;
      margin-top: 5px;
      position: relative;
      display: table-cell;
      text-align: center;
      vertical-align: middle;
      color: hsl(0, 0%, 0%);
    }
    #files .file.active {
      color: hsl(0, 0%, 0%);
      font-weight: bold;
      border-bottom: 0 none;
      padding-right: 1.5em;
    }
    #files .file .remove {
      font-size: 12px;
      display: flex;
      color: hsl(0, 0%, 0%);
      position: absolute;
      top: -7px;
      right: 5px;
      display: none;
    }
    #files .file input {
      background-color: transparent;
      border: 0 none;
      border-bottom: 1px dotted hsl(0, 0%, 0%);
      line-height: 1em;
      margin: 0.5em 0;
    }
    #files .file.active .remove {
      display: inline-block;
      color: hsl(0, 0%, 0%);
    }
  </style><style type="text/css">
      .anchor_4wahj            {
        position         : static;
        border-top       : 2px dotted blue;
        height           : 10px;
      }
      .overlay_4wahj           {
        position         : absolute;
        width            : 100%;
        display          : flex;
        align-items      : center;
        justify-content  : center;
        bottom           : 0;
        right            : 15px;
        min-height       : 20px;
      }
      .text_4wahj              {
        z-index          : 2;
        color            : black;
        font-weight      : bold;
        pointer-events   : none;
      }
      .background_4wahj        {
        z-index          : 1;
        opacity          : 0.8;
        background-color : #a6aeba;
        cursor           : pointer;
      }
    </style><style>
.sol.success,
.sol.error,
.sol.warning {
    word-wrap: break-word;
    cursor: pointer;
    position: relative;
    margin: 0.5em 0 1em 0;
    border-radius: 5px;
    line-height: 20px;
    padding: 8px 15px;
}

.sol.success pre,
.sol.error pre,
.sol.warning pre {
    overflow-y: hidden;
    background-color: transparent;
    margin: 0;
    font-size: 12px;
    border: 0 none;
    padding: 0;
    border-radius: 0;
}

.sol.success .close,
.sol.error .close,
.sol.warning .close {
    font-weight: bold;
    position: absolute;
    color: hsl(0, 0%, 0%); /* black in style-guide.js */
    top: 0;
    right: 0;
    padding: 0.5em;
}

.sol.error {
    background-color: hsla(0, 82%, 82%, .5);
    border: .2em dotted hsla(0, 82%, 82%, 1);
    color: hsl(0, 0%, 0%);
}

.sol.warning {
  background-color: hsla(44, 100%, 50%, .5);
  color: hsl(0, 0%, 0%);
}

.sol.success {
  background-color: hsla(141, 75%, 84%, .5);
  border: .2em dotted hsla(141, 75%, 84%, 1);
  color: hsl(0, 0%, 0%);
}</style><style type="text/css">
    .container_1Th7as,
    .runTxs_1Th7as,
    .recorder_1Th7as {
    }
  </style><script type="text/javascript" src="./PointsStore_files/soljson-v0.4.21+commit.dfe3193c.js"></script></head>
	<body data-gr-c-s-loaded="true">
		<script src="./PointsStore_files/app.js"></script><div class="browsersolidity_VAxiN"><div id="filepanel" class="leftpanel_VAxiN" style="width: 200px;"><div class="container_1pxFrB"><div class="fileexplorer_1pxFrB"><div class="menu_1pxFrB"><span title="Create New File in the Browser Storage Explorer" class="newFile newFile_1pxFrB"><i class="fa fa-plus-circle"></i></span><span title="Add Local file to the Browser Storage Explorer" class="uploadFile_1pxFrB"><label class="fa fa-folder-open"><input type="file" multiple="multiple"></label></span><span title="Publish all [browser] explorer open files to an anonymous github gist" class="gist_1pxFrB"><i class="fa fa-github"></i></span><span title="Publish all [gist] explorer open files to an anonymous github gist" class="gist_1pxFrB"><i class="fa fa-github"></i></span><span title="Copy all files to another instance of Remix IDE" class="copyFiles_1pxFrB"><i aria-hidden="true" class="fa fa-files-o"></i></span><span class="connectToLocalhost_1pxFrB"><i title="Connect to Localhost" class="websocketconn fa fa-link"></i></span></div><div class="treeviews_1pxFrB"><div class="treeview_1pxFrB"><div><ul key="" class="fileexplorer_1MTxic"><li key="browser" class="li_tv_x3Aa6"><div key="browser" class="label_tv_x3Aa6"><div class="fa fa-caret-right caret caret_tv_x3Aa6"></div><span><label data-path="browser" style="font-weight:bold;" class="folder_1MTxic">browser</label></span></div><ul key="browser" class="ul_tv_x3Aa6" style="display: none;"></ul></li></ul></div></div><div class="configexplorer treeview_1pxFrB"><div><ul key="" class="fileexplorer_1MTxic"><li key="config" class="li_tv_x3Aa6"><div key="config" class="label_tv_x3Aa6"><div class="fa fa-caret-right caret caret_tv_x3Aa6"></div><span><label data-path="config" style="font-weight:bold;" class="folder_1MTxic">config</label></span></div><ul key="config" class="ul_tv_x3Aa6" style="display: none;"></ul></li></ul></div></div><div class="filesystemexplorer treeview_1pxFrB"><div></div></div><div class="swarmexplorer treeview_1pxFrB"><div></div></div><div class="githubexplorer treeview_1pxFrB"><div></div></div><div class="gistexplorer treeview_1pxFrB"><div></div></div></div></div><div class="dragbar_1pxFrB"></div></div></div><div id="editor-container" class="centerpanel_VAxiN" style="left: 200px; right: 959px;"><div class="editorpanel_U8oth"><div class="content_U8oth"><div class="tabsbar_U8oth"><div class="buttons_U8oth"><span title="Toggle left hand panel" class="toggleLHP_U8oth"><i class="fa fa-angle-double-left"></i></span><span class="changeeditorfontsize_U8oth"><i aria-hidden="true" title="increase editor font size" class="increditorsize fa fa-plus"></i><i aria-hidden="true" title="decrease editor font size" class="decreditorsize fa fa-minus"></i></span></div><div class="tabs_U8oth"><div class="scroller_U8oth hide_U8oth scrollerleft_U8oth"><i class="fa fa-chevron-left "></i></div><ul id="files" class="files_U8oth nav nav-tabs"><li class="file"><span class="name">browser/ballot.sol</span><span class="remove"><i class="fa fa-close"></i></span></li><li class="file active"><span class="name">browser/PointsStore.sol</span><span class="remove"><i class="fa fa-close"></i></span></li></ul><div class="scroller_U8oth hide_U8oth scrollerright_U8oth"><i class="fa fa-chevron-right "></i></div></div><span title="Toggle right hand panel" class="toggleRHP_U8oth"><i class="fa fa-angle-double-right"></i></span></div><div class="contextviewcontainer_U8oth"><div class="contextview_2AL0PA" style="display: block;"><div class="container_2AL0PA"><div class="line_2AL0PA"><div title="ContractDefinition" class="type_2AL0PA">ContractDefinition</div><div title="Test" class="name_2AL0PA">Test</div><i aria-hidden="true" class="fa fa-share jump_2AL0PA"></i><span class="referencesnb_2AL0PA">0 reference(s)</span><i data-action="previous" aria-hidden="true" class="fa fa-chevron-up jump_2AL0PA"></i><i data-action="next" aria-hidden="true" class="fa fa-chevron-down jump_2AL0PA"></i></div></div></div></div><div id="input" class=" ace_editor ace-tm ace-editor_2XgUV9 ace_focus" style="height: 468px;"><textarea class="ace_text-input" wrap="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="opacity: 0; height: 12px; width: 6.00031px; left: 56.0003px; top: 144px;"></textarea><div class="ace_gutter"><div class="ace_layer ace_gutter-layer ace_folding-enabled" style="margin-top: 0px; height: 470px; width: 46px;"><div class="ace_gutter-cell " style="height: 12px;">1</div><div class="ace_gutter-cell " style="height: 12px;">2</div><div class="ace_gutter-cell " style="height: 12px;">3<span class="ace_fold-widget ace_start ace_open" style="height: 12px;"></span></div><div class="ace_gutter-cell " style="height: 12px;">4</div><div class="ace_gutter-cell " style="height: 12px;">5</div><div class="ace_gutter-cell " style="height: 12px;">6<span class="ace_fold-widget ace_start ace_open" style="height: 12px;"></span></div><div class="ace_gutter-cell " style="height: 12px;">7</div><div class="ace_gutter-cell " style="height: 12px;">8</div><div class="ace_gutter-cell " style="height: 12px;">9</div><div class="ace_gutter-cell " style="height: 12px;">10<span class="ace_fold-widget ace_start ace_open" style="height: 12px;"></span></div><div class="ace_gutter-cell " style="height: 12px;">11</div><div class="ace_gutter-cell " style="height: 12px;">12</div><div class="ace_gutter-cell " style="height: 12px;">13</div></div><div class="ace_gutter-active-line" style="top: 144px; height: 12px;"></div></div><div class="ace_scroller" style="left: 46px; right: 0px; bottom: 0px;"><div class="ace_content" style="margin-top: 0px; width: 588px; height: 470px; margin-left: 0px;"><div class="ace_layer ace_print-margin-layer"><div class="ace_print-margin" style="left: 484.025px; visibility: visible;"></div></div><div class="ace_layer ace_marker-layer"><div class="ace_active-line" style="height:12px;top:144px;left:0;right:0;"></div><div class="ace_bracket ace_start ace_br15" style="height:12px;width:6.0003125px;top:24px;left:88.004375px;"></div><div class="highlightreference ace_br1 ace_start" style="height:12px;right:0;top:24px;left:4px;"></div><div class="highlightreference ace_br12" style="height:12px;width:0px;top:36px;left:4px;"></div></div><div class="ace_layer ace_text-layer" style="padding: 0px 4px;"><div class="ace_line" style="height:12px"><span class="ace_identifier">pragma</span> <span class="ace_identifier">solidity</span> <span class="ace_keyword ace_operator">^</span><span class="ace_constant ace_numeric">0.4</span><span class="ace_punctuation ace_operator">.</span><span class="ace_constant ace_numeric">0</span><span class="ace_punctuation ace_operator">;</span></div><div class="ace_line" style="height:12px"></div><div class="ace_line" style="height:12px"><span class="ace_keyword">contract</span> <span class="ace_identifier">Test</span> <span class="ace_paren ace_lparen">{</span> </div><div class="ace_line" style="height:12px">    <span class="ace_variable ace_language">uint</span> <span class="ace_identifier">points</span> <span class="ace_keyword ace_operator">=</span> <span class="ace_constant ace_numeric">0</span><span class="ace_punctuation ace_operator">;</span></div><div class="ace_line" style="height:12px">    </div><div class="ace_line" style="height:12px"><span class="ace_indent-guide">    </span> <span class="ace_storage ace_type">function</span> <span class="ace_entity ace_name ace_function">addPoints</span><span class="ace_paren ace_lparen">(</span><span class="ace_variable ace_parameter">uint</span><span class="ace_punctuation ace_operator"> </span><span class="ace_variable ace_parameter">_points</span><span class="ace_paren ace_rparen">)</span> <span class="ace_keyword">public</span> <span class="ace_paren ace_lparen">{</span></div><div class="ace_line" style="height:12px"><span class="ace_indent-guide">    </span>    <span class="ace_identifier">points</span> <span class="ace_keyword ace_operator">+=</span> <span class="ace_identifier">_points</span><span class="ace_punctuation ace_operator">;</span></div><div class="ace_line" style="height:12px">    <span class="ace_paren ace_rparen">}</span></div><div class="ace_line" style="height:12px">    </div><div class="ace_line" style="height:12px">    <span class="ace_storage ace_type">function</span> <span class="ace_entity ace_name ace_function">getPoints</span><span class="ace_paren ace_lparen">(</span><span class="ace_paren ace_rparen">)</span> <span class="ace_keyword">public</span> <span class="ace_storage ace_type">constant</span> <span class="ace_keyword">returns</span><span class="ace_paren ace_lparen">(</span><span class="ace_variable ace_language">uint</span><span class="ace_paren ace_rparen">)</span><span class="ace_paren ace_lparen">{</span></div><div class="ace_line" style="height:12px"><span class="ace_indent-guide">    </span>    <span class="ace_keyword">return</span> <span class="ace_identifier">points</span><span class="ace_punctuation ace_operator">;</span></div><div class="ace_line" style="height:12px">    <span class="ace_paren ace_rparen">}</span></div><div class="ace_line" style="height:12px"><span class="ace_paren ace_rparen">}</span></div></div><div class="ace_layer ace_marker-layer"></div><div class="ace_layer ace_cursor-layer"><div class="ace_cursor" style="left: 10.0003px; top: 144px; width: 6.00031px; height: 12px;"></div></div></div></div><div class="ace_scrollbar ace_scrollbar-v" style="width: 20px; bottom: 0px; display: none;"><div class="ace_scrollbar-inner" style="width: 20px; height: 156px;"></div></div><div class="ace_scrollbar ace_scrollbar-h" style="display: none; height: 20px; left: 46px; right: 0px;"><div class="ace_scrollbar-inner" style="height: 20px; width: 588px;"></div></div><div style="height: auto; width: auto; top: 0px; left: 0px; visibility: hidden; position: absolute; white-space: pre; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; overflow: hidden;"><div style="height: auto; width: auto; top: 0px; left: 0px; visibility: hidden; position: absolute; white-space: pre; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; overflow: visible;"></div><div style="height: auto; width: auto; top: 0px; left: 0px; visibility: hidden; position: absolute; white-space: pre; font-style: inherit; font-variant: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; overflow: visible;">XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</div></div></div><div class="panel_1ywR9V" style="height: 544px;"><div class="bar_1ywR9V"><div class="dragbarHorizontal_1ywR9V"></div><div class="menu_1ywR9V"><i class="toggleTerminal_1ywR9V fa fa-angle-double-down"></i><div class="clear_1ywR9V"><i aria-hidden="true" class="fa fa-ban"></i></div><div class="dropdown_1YaZ7a"><div class="selectbox_1YaZ7a"><span class="selected_1YaZ7a"> [2] only remix transactions, script</span><i class="icon_1YaZ7a fa fa-caret-down"></i></div><div style="display: none;" class="options_1YaZ7a"><div class="option_1YaZ7a"><input data-idx="0" type="checkbox"><label>only remix transactions</label></div><div class="option_1YaZ7a"><input data-idx="1" type="checkbox"><label>all transactions</label></div><div class="option_1YaZ7a"><input data-idx="2" type="checkbox"><label>script</label></div></div></div><div class="search_1ywR9V"><i aria-hidden="true" class="fa fa-search searchIcon_1ywR9V"></i><input type="text" placeholder="Search transactions" class="filter_1ywR9V"></div><div class="listen_1ywR9V"><input type="checkbox"><label title="If checked Remix will listen on all transactions mined in the current environment and not only transactions created from the GUI">Listen on network</label></div></div></div><div class="terminal_container_1ywR9V"><div class="terminal_bg_1ywR9V">
        </div><div class="terminal_1ywR9V"><div class="journal_1ywR9V"></div><div class="cli_1ywR9V"><span class="prompt_1ywR9V">&gt;</span><span contenteditable="true" class="input_1ywR9V"><br></span></div></div></div></div></div></div></div><div class="rightpanel_VAxiN" style="width: 959px;"><div id="righthand-panel" class="panel_2zO1Ks"><div id="dragbar" class="dragbar_2zO1Ks"></div><div id="header" class="header_2zO1Ks"><div class="menu_2zO1Ks"><ul class="opts_2zO1Ks"><li title="Compile" class="opts_li_2i0m4j options_2i0m4j compileView options_2zO1Ks" style="">Compile</li><li title="Run" class="opts_li_2i0m4j options_2i0m4j runView options_2zO1Ks">Run</li><li title="Settings" class="opts_li_2i0m4j options_2i0m4j settingsView options_2zO1Ks">Settings</li><li title="Analysis" class="opts_li_2i0m4j options_2i0m4j staticanalysisView options_2zO1Ks active_2i0m4j">Analysis</li><li title="Debugger" class="opts_li_2i0m4j options_2i0m4j debugView options_2zO1Ks">Debugger</li><li title="Support" class="opts_li_2i0m4j options_2i0m4j supportView options_2zO1Ks">Support</li></ul></div><div id="optionViews"><div id="compileTabView" class="compileTabView_1E3fzD" style="display: none;"><div class="compileContainer_1E3fzD"><div class="compileButtons_1E3fzD"><div id="compile" title="Compile source code" class="compileButton_1E3fzD "><i aria-hidden="true" class="fa fa-refresh icon_1E3fzD" title="idle" style="color: rgb(0, 0, 0);"></i> Start to compile</div><div class="autocompileContainer_1E3fzD"><input id="autoCompile" type="checkbox" title="Auto compile" class="autocompile_1E3fzD"><span class="autocompileText_1E3fzD">Auto compile</span></div><i title="Copy Address" style="display:none" aria-hidden="true" class="warnCompilationSlow_1E3fzD fa fa-exclamation-triangle"></i></div></div><div class="container_1E3fzD"><select class="contractNames_1E3fzD"><option>Test</option></select><div class="contractButtons_1E3fzD"><div title="Display Contract Details" class="details_1E3fzD">Details</div><div title="Publish on Swarm" class="publish_1E3fzD">Publish on Swarm</div></div></div><div class="error"><div class="sol warning"><pre><span>Static Analysis raised 2 warning(s) that requires your attention.</span></pre><div class="close"><i class="fa fa-close"></i></div></div><div class="sol success"><pre><span>Test</span></pre><div class="close"><i class="fa fa-close"></i></div></div></div></div><div id="runTabView" class="runTabView_3uyLA6" style="display: none;"><div><div class="settings_3uyLA6"><div class="crow_3uyLA6"><div id="selectExEnv" class="col1_1_3uyLA6">
          Environment
        </div><div class="environment_3uyLA6"><span class="network_3uyLA6"><i class="networkItem_3uyLA6 fa fa-plug" aria-hidden="true"></i> Custom (5777)</span><select id="selectExEnvOptions" class="select_3uyLA6"><option id="vm-mode" title="Execution environment does not connect to any node, everything is local and in memory only." value="vm" checked="checked" name="executionContext">
              JavaScript VM
            </option><option id="injected-mode" title="Execution environment has been provided by Mist or similar provider." value="injected" checked="checked" name="executionContext">
              Injected Web3
            </option><option id="web3-mode" title="Execution environment connects to node at localhost (or via IPC if available), transactions will be sent to the network and can cause loss of money or worse!
              If this page is served via https and you access your node via http, it might not work. In this case, try cloning the repository and serving it via http." value="web3" name="executionContext">
              Web3 Provider
            </option></select><a href="https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md" target="_blank"><i class="icon_3uyLA6 fa fa-info"></i></a></div></div><div class="crow_3uyLA6"><div class="col1_1_3uyLA6">Account</div><select name="txorigin" id="txorigin" class="select_3uyLA6"><option value="0x7099b34900d2a33aa124fc5ba2a8a90e5dd5ebe1">0x709...5ebe1 (100 ether)</option><option value="0x66ea20784bdf2b227cfe995697f3f6fef60388cc">0x66e...388cc (100 ether)</option><option value="0x0fc81abc2817233c09f70449536758bc229d67ed">0x0fc...d67ed (100 ether)</option><option value="0x8281889688bac5d4f2e0c43af077ca4c40e4be72">0x828...4be72 (100 ether)</option><option value="0x9164a4759dc524b21387c53159b3fc86a073e195">0x916...3e195 (100 ether)</option><option value="0x605e6bec8e7e3d22a0aad0d0563e60b06540a14f">0x605...0a14f (100 ether)</option><option value="0x788c67a3095de6317aa493d523de5b7e3d853e96">0x788...53e96 (100 ether)</option><option value="0x5f55f38853584d02b6d1523ff219a0f643f24e8c">0x5f5...24e8c (100 ether)</option><option value="0x89060bd5f46beca29683cc5ffe78441ae31e246e">0x890...e246e (100 ether)</option><option value="0xacf9ee86f3c2e56050da663ffa74536f5ee5ee1f">0xacf...5ee1f (100 ether)</option><option value="0x7099b34900d2a33aa124fc5ba2a8a90e5dd5ebe1">0x709...5ebe1 (100 ether)</option><option value="0x66ea20784bdf2b227cfe995697f3f6fef60388cc">0x66e...388cc (100 ether)</option><option value="0x0fc81abc2817233c09f70449536758bc229d67ed">0x0fc...d67ed (100 ether)</option><option value="0x8281889688bac5d4f2e0c43af077ca4c40e4be72">0x828...4be72 (100 ether)</option><option value="0x9164a4759dc524b21387c53159b3fc86a073e195">0x916...3e195 (100 ether)</option><option value="0x605e6bec8e7e3d22a0aad0d0563e60b06540a14f">0x605...0a14f (100 ether)</option><option value="0x788c67a3095de6317aa493d523de5b7e3d853e96">0x788...53e96 (100 ether)</option><option value="0x5f55f38853584d02b6d1523ff219a0f643f24e8c">0x5f5...24e8c (100 ether)</option><option value="0x89060bd5f46beca29683cc5ffe78441ae31e246e">0x890...e246e (100 ether)</option><option value="0xacf9ee86f3c2e56050da663ffa74536f5ee5ee1f">0xacf...5ee1f (100 ether)</option></select><i title="Copy value to clipboard" aria-hidden="true" class="copyIcon_3sVBlb fa fa-clipboard" style="color: rgb(0, 0, 0);"></i><i aria-hidden="true" title="Create a new account" class="fa fa-plus-circle icon_3uyLA6"></i></div><div class="crow_3uyLA6"><div class="col1_1_3uyLA6">Gas limit</div><input type="number" id="gasLimit" value="3000000" class="col2_3uyLA6"></div><div style="display: none" class="crow_3uyLA6"><div class="col1_1_3uyLA6">Gas Price</div><input type="number" id="gasPrice" value="0" class="col2_3uyLA6"></div><div class="crow_3uyLA6"><div class="col1_1_3uyLA6">Value</div><input type="text" id="value" value="0" title="Enter the value and choose the unit" class="col2_1_3uyLA6"><select name="unit" id="unit" class="col2_2_3uyLA6"><option data-unit="wei">wei</option><option data-unit="gwei">gwei</option><option data-unit="finney">finney</option><option data-unit="ether">ether</option></select></div></div><div class="container_3uyLA6"><div class="subcontainer_3uyLA6"><select class="contractNames_3uyLA6"><option>Test</option></select><i title="Contract compilation failed. Please check the compile tab for more information." class="fa fa-times-circle errorIcon_3uyLA6" style="display: none;"></i></div><div class="undefined"><div class="button_3uyLA6"><input placeholder="" title="Create" class="input_3uyLA6 create" disabled="true"><div class="create_3uyLA6">Create</div></div><div class="button_3uyLA6"><input placeholder="Load contract from Address" title="atAddress" class="input_3uyLA6 ataddressinput"><div class="atAddress_3uyLA6">At Address</div></div></div></div><div class="pendingTxsContainer_3uyLA6"><div class="pendingTxsText_3uyLA6"><span>0 pending transactions</span><span class="transactionActions_3uyLA6"><i title="Save Transactions" aria-hidden="true" class="fa fa-floppy-o savetransaction recorder_1Th7as icon_3uyLA6"></i><i title="Run Transactions" aria-hidden="true" class="fa fa-play runtransaction runTxs_1Th7as icon_3uyLA6"></i><i title="Clear Instances List" aria-hidden="true" class="clearinstance_3uyLA6 icon_3uyLA6 fa fa-trash"></i></span></div></div><div class="instanceContainer_3uyLA6"><div class="noInstancesText_3uyLA6" style="display: block;">0 contract Instances</div></div></div></div><div id="settingsView" class="settingsTabView_2WRVNz " style="display: none;"><div class="info_2WRVNz"><div class="title_2WRVNz">Solidity version</div><span>Current version:</span><span id="version">0.4.21+commit.dfe3193c.Emscripten.clang</span><div class="crow_2WRVNz"><select id="versionSelector" class="select_2WRVNz"><option disabled="">Select new compiler version</option><option value="soljson-v0.4.22-nightly.2018.4.12+commit.c3dc67d0.js">0.4.22-nightly.2018.4.12+commit.c3dc67d0</option><option value="soljson-v0.4.22-nightly.2018.4.11+commit.b7b6d0ce.js">0.4.22-nightly.2018.4.11+commit.b7b6d0ce</option><option value="soljson-v0.4.22-nightly.2018.4.10+commit.27385d6d.js">0.4.22-nightly.2018.4.10+commit.27385d6d</option><option value="soljson-v0.4.22-nightly.2018.4.6+commit.9bd49516.js">0.4.22-nightly.2018.4.6+commit.9bd49516</option><option value="soljson-v0.4.22-nightly.2018.4.5+commit.c6adad93.js">0.4.22-nightly.2018.4.5+commit.c6adad93</option><option value="soljson-v0.4.22-nightly.2018.4.4+commit.920de496.js">0.4.22-nightly.2018.4.4+commit.920de496</option><option value="soljson-v0.4.22-nightly.2018.4.3+commit.3fbdd655.js">0.4.22-nightly.2018.4.3+commit.3fbdd655</option><option value="soljson-v0.4.22-nightly.2018.3.30+commit.326d656a.js">0.4.22-nightly.2018.3.30+commit.326d656a</option><option value="soljson-v0.4.22-nightly.2018.3.29+commit.c2ae33f8.js">0.4.22-nightly.2018.3.29+commit.c2ae33f8</option><option value="soljson-v0.4.22-nightly.2018.3.27+commit.af262281.js">0.4.22-nightly.2018.3.27+commit.af262281</option><option value="soljson-v0.4.22-nightly.2018.3.21+commit.8fd53c1c.js">0.4.22-nightly.2018.3.21+commit.8fd53c1c</option><option value="soljson-v0.4.22-nightly.2018.3.16+commit.2b2527f3.js">0.4.22-nightly.2018.3.16+commit.2b2527f3</option><option value="soljson-v0.4.22-nightly.2018.3.15+commit.3f1e0d84.js">0.4.22-nightly.2018.3.15+commit.3f1e0d84</option><option value="soljson-v0.4.22-nightly.2018.3.14+commit.c3f07b52.js">0.4.22-nightly.2018.3.14+commit.c3f07b52</option><option value="soljson-v0.4.22-nightly.2018.3.13+commit.f2614be9.js">0.4.22-nightly.2018.3.13+commit.f2614be9</option><option value="soljson-v0.4.22-nightly.2018.3.12+commit.c6e9dd13.js">0.4.22-nightly.2018.3.12+commit.c6e9dd13</option><option value="soljson-v0.4.22-nightly.2018.3.8+commit.fbc29f6d.js">0.4.22-nightly.2018.3.8+commit.fbc29f6d</option><option value="soljson-v0.4.22-nightly.2018.3.7+commit.b5e804b8.js">0.4.22-nightly.2018.3.7+commit.b5e804b8</option><option value="soljson-v0.4.21+commit.dfe3193c.js">0.4.21+commit.dfe3193c</option><option value="soljson-v0.4.21-nightly.2018.3.7+commit.bd7bc7c4.js">0.4.21-nightly.2018.3.7+commit.bd7bc7c4</option><option value="soljson-v0.4.21-nightly.2018.3.6+commit.a9e02acc.js">0.4.21-nightly.2018.3.6+commit.a9e02acc</option><option value="soljson-v0.4.21-nightly.2018.3.5+commit.cd6ffbdf.js">0.4.21-nightly.2018.3.5+commit.cd6ffbdf</option><option value="soljson-v0.4.21-nightly.2018.3.1+commit.cf6720ea.js">0.4.21-nightly.2018.3.1+commit.cf6720ea</option><option value="soljson-v0.4.21-nightly.2018.2.28+commit.ac5485a2.js">0.4.21-nightly.2018.2.28+commit.ac5485a2</option><option value="soljson-v0.4.21-nightly.2018.2.27+commit.415ac2ae.js">0.4.21-nightly.2018.2.27+commit.415ac2ae</option><option value="soljson-v0.4.21-nightly.2018.2.26+commit.cd2d8936.js">0.4.21-nightly.2018.2.26+commit.cd2d8936</option><option value="soljson-v0.4.21-nightly.2018.2.23+commit.cae6cc2c.js">0.4.21-nightly.2018.2.23+commit.cae6cc2c</option><option value="soljson-v0.4.21-nightly.2018.2.22+commit.71a34abd.js">0.4.21-nightly.2018.2.22+commit.71a34abd</option><option value="soljson-v0.4.21-nightly.2018.2.21+commit.16c7eabc.js">0.4.21-nightly.2018.2.21+commit.16c7eabc</option><option value="soljson-v0.4.21-nightly.2018.2.20+commit.dcc4083b.js">0.4.21-nightly.2018.2.20+commit.dcc4083b</option><option value="soljson-v0.4.21-nightly.2018.2.19+commit.839acafb.js">0.4.21-nightly.2018.2.19+commit.839acafb</option><option value="soljson-v0.4.21-nightly.2018.2.16+commit.3f7e82d0.js">0.4.21-nightly.2018.2.16+commit.3f7e82d0</option><option value="soljson-v0.4.21-nightly.2018.2.15+commit.f4aa05f3.js">0.4.21-nightly.2018.2.15+commit.f4aa05f3</option><option value="soljson-v0.4.21-nightly.2018.2.14+commit.bb3b327c.js">0.4.21-nightly.2018.2.14+commit.bb3b327c</option><option value="soljson-v0.4.20+commit.3155dd80.js">0.4.20+commit.3155dd80</option><option value="soljson-v0.4.20-nightly.2018.2.13+commit.27ef9794.js">0.4.20-nightly.2018.2.13+commit.27ef9794</option><option value="soljson-v0.4.20-nightly.2018.2.12+commit.954903b5.js">0.4.20-nightly.2018.2.12+commit.954903b5</option><option value="soljson-v0.4.20-nightly.2018.1.29+commit.a668b9de.js">0.4.20-nightly.2018.1.29+commit.a668b9de</option><option value="soljson-v0.4.20-nightly.2018.1.26+commit.bbad48bb.js">0.4.20-nightly.2018.1.26+commit.bbad48bb</option><option value="soljson-v0.4.20-nightly.2018.1.25+commit.e7afde95.js">0.4.20-nightly.2018.1.25+commit.e7afde95</option><option value="soljson-v0.4.20-nightly.2018.1.24+commit.b177352a.js">0.4.20-nightly.2018.1.24+commit.b177352a</option><option value="soljson-v0.4.20-nightly.2018.1.23+commit.31aaf433.js">0.4.20-nightly.2018.1.23+commit.31aaf433</option><option value="soljson-v0.4.20-nightly.2018.1.22+commit.e5def2da.js">0.4.20-nightly.2018.1.22+commit.e5def2da</option><option value="soljson-v0.4.20-nightly.2018.1.19+commit.eba46a65.js">0.4.20-nightly.2018.1.19+commit.eba46a65</option><option value="soljson-v0.4.20-nightly.2018.1.18+commit.33723c45.js">0.4.20-nightly.2018.1.18+commit.33723c45</option><option value="soljson-v0.4.20-nightly.2018.1.17+commit.4715167e.js">0.4.20-nightly.2018.1.17+commit.4715167e</option><option value="soljson-v0.4.20-nightly.2018.1.15+commit.14fcbd65.js">0.4.20-nightly.2018.1.15+commit.14fcbd65</option><option value="soljson-v0.4.20-nightly.2018.1.11+commit.c20b6da.js">0.4.20-nightly.2018.1.11+commit.c20b6da</option><option value="soljson-v0.4.20-nightly.2018.1.10+commit.a75d5333.js">0.4.20-nightly.2018.1.10+commit.a75d5333</option><option value="soljson-v0.4.20-nightly.2018.1.6+commit.2548228b.js">0.4.20-nightly.2018.1.6+commit.2548228b</option><option value="soljson-v0.4.20-nightly.2018.1.5+commit.bca01f8f.js">0.4.20-nightly.2018.1.5+commit.bca01f8f</option><option value="soljson-v0.4.20-nightly.2018.1.4+commit.a0771691.js">0.4.20-nightly.2018.1.4+commit.a0771691</option><option value="soljson-v0.4.20-nightly.2017.12.20+commit.efc198d5.js">0.4.20-nightly.2017.12.20+commit.efc198d5</option><option value="soljson-v0.4.20-nightly.2017.12.19+commit.2d800e67.js">0.4.20-nightly.2017.12.19+commit.2d800e67</option><option value="soljson-v0.4.20-nightly.2017.12.18+commit.37b70e8e.js">0.4.20-nightly.2017.12.18+commit.37b70e8e</option><option value="soljson-v0.4.20-nightly.2017.12.14+commit.3d1830f3.js">0.4.20-nightly.2017.12.14+commit.3d1830f3</option><option value="soljson-v0.4.20-nightly.2017.12.13+commit.bfc54463.js">0.4.20-nightly.2017.12.13+commit.bfc54463</option><option value="soljson-v0.4.20-nightly.2017.12.12+commit.1ddd4e2b.js">0.4.20-nightly.2017.12.12+commit.1ddd4e2b</option><option value="soljson-v0.4.20-nightly.2017.12.11+commit.4a1f18c9.js">0.4.20-nightly.2017.12.11+commit.4a1f18c9</option><option value="soljson-v0.4.20-nightly.2017.12.8+commit.226bfe5b.js">0.4.20-nightly.2017.12.8+commit.226bfe5b</option><option value="soljson-v0.4.20-nightly.2017.12.6+commit.c2109436.js">0.4.20-nightly.2017.12.6+commit.c2109436</option><option value="soljson-v0.4.20-nightly.2017.12.5+commit.b47e023d.js">0.4.20-nightly.2017.12.5+commit.b47e023d</option><option value="soljson-v0.4.20-nightly.2017.12.4+commit.240c79e6.js">0.4.20-nightly.2017.12.4+commit.240c79e6</option><option value="soljson-v0.4.20-nightly.2017.12.1+commit.6d8d0393.js">0.4.20-nightly.2017.12.1+commit.6d8d0393</option><option value="soljson-v0.4.20-nightly.2017.11.30+commit.cb16a5d3.js">0.4.20-nightly.2017.11.30+commit.cb16a5d3</option><option value="soljson-v0.4.19+commit.c4cbbb05.js">0.4.19+commit.c4cbbb05</option><option value="soljson-v0.4.19-nightly.2017.11.30+commit.f5a2508e.js">0.4.19-nightly.2017.11.30+commit.f5a2508e</option><option value="soljson-v0.4.19-nightly.2017.11.29+commit.7c69d88f.js">0.4.19-nightly.2017.11.29+commit.7c69d88f</option><option value="soljson-v0.4.19-nightly.2017.11.22+commit.f22ac8fc.js">0.4.19-nightly.2017.11.22+commit.f22ac8fc</option><option value="soljson-v0.4.19-nightly.2017.11.21+commit.5c9e273d.js">0.4.19-nightly.2017.11.21+commit.5c9e273d</option><option value="soljson-v0.4.19-nightly.2017.11.17+commit.2b5ef806.js">0.4.19-nightly.2017.11.17+commit.2b5ef806</option><option value="soljson-v0.4.19-nightly.2017.11.16+commit.58e452d1.js">0.4.19-nightly.2017.11.16+commit.58e452d1</option><option value="soljson-v0.4.19-nightly.2017.11.15+commit.e3206d8e.js">0.4.19-nightly.2017.11.15+commit.e3206d8e</option><option value="soljson-v0.4.19-nightly.2017.11.14+commit.bc39e730.js">0.4.19-nightly.2017.11.14+commit.bc39e730</option><option value="soljson-v0.4.19-nightly.2017.11.13+commit.60b2c2b.js">0.4.19-nightly.2017.11.13+commit.60b2c2b</option><option value="soljson-v0.4.19-nightly.2017.11.11+commit.284c3839.js">0.4.19-nightly.2017.11.11+commit.284c3839</option><option value="soljson-v0.4.19-nightly.2017.10.29+commit.eb140bc6.js">0.4.19-nightly.2017.10.29+commit.eb140bc6</option><option value="soljson-v0.4.19-nightly.2017.10.28+commit.f9b24009.js">0.4.19-nightly.2017.10.28+commit.f9b24009</option><option value="soljson-v0.4.19-nightly.2017.10.27+commit.1e085f85.js">0.4.19-nightly.2017.10.27+commit.1e085f85</option><option value="soljson-v0.4.19-nightly.2017.10.26+commit.59d4dfbd.js">0.4.19-nightly.2017.10.26+commit.59d4dfbd</option><option value="soljson-v0.4.19-nightly.2017.10.24+commit.1313e9d8.js">0.4.19-nightly.2017.10.24+commit.1313e9d8</option><option value="soljson-v0.4.19-nightly.2017.10.23+commit.dc6b1f02.js">0.4.19-nightly.2017.10.23+commit.dc6b1f02</option><option value="soljson-v0.4.19-nightly.2017.10.20+commit.bdd2858b.js">0.4.19-nightly.2017.10.20+commit.bdd2858b</option><option value="soljson-v0.4.19-nightly.2017.10.19+commit.c58d9d2c.js">0.4.19-nightly.2017.10.19+commit.c58d9d2c</option><option value="soljson-v0.4.19-nightly.2017.10.18+commit.f7ca2421.js">0.4.19-nightly.2017.10.18+commit.f7ca2421</option><option value="soljson-v0.4.18+commit.9cf6e910.js">0.4.18+commit.9cf6e910</option><option value="soljson-v0.4.18-nightly.2017.10.18+commit.e854da1a.js">0.4.18-nightly.2017.10.18+commit.e854da1a</option><option value="soljson-v0.4.18-nightly.2017.10.17+commit.8fbfd62d.js">0.4.18-nightly.2017.10.17+commit.8fbfd62d</option><option value="soljson-v0.4.18-nightly.2017.10.16+commit.dbc8655b.js">0.4.18-nightly.2017.10.16+commit.dbc8655b</option><option value="soljson-v0.4.18-nightly.2017.10.15+commit.a74c9aef.js">0.4.18-nightly.2017.10.15+commit.a74c9aef</option><option value="soljson-v0.4.18-nightly.2017.10.10+commit.c35496bf.js">0.4.18-nightly.2017.10.10+commit.c35496bf</option><option value="soljson-v0.4.18-nightly.2017.10.9+commit.6f832cac.js">0.4.18-nightly.2017.10.9+commit.6f832cac</option><option value="soljson-v0.4.18-nightly.2017.10.6+commit.961f8746.js">0.4.18-nightly.2017.10.6+commit.961f8746</option><option value="soljson-v0.4.18-nightly.2017.10.5+commit.995b5525.js">0.4.18-nightly.2017.10.5+commit.995b5525</option><option value="soljson-v0.4.18-nightly.2017.10.4+commit.c3888ab.js">0.4.18-nightly.2017.10.4+commit.c3888ab</option><option value="soljson-v0.4.18-nightly.2017.10.3+commit.5c284589.js">0.4.18-nightly.2017.10.3+commit.5c284589</option><option value="soljson-v0.4.18-nightly.2017.10.2+commit.c6161030.js">0.4.18-nightly.2017.10.2+commit.c6161030</option><option value="soljson-v0.4.18-nightly.2017.9.29+commit.b9218468.js">0.4.18-nightly.2017.9.29+commit.b9218468</option><option value="soljson-v0.4.18-nightly.2017.9.28+commit.4d01d086.js">0.4.18-nightly.2017.9.28+commit.4d01d086</option><option value="soljson-v0.4.18-nightly.2017.9.27+commit.809d5ce1.js">0.4.18-nightly.2017.9.27+commit.809d5ce1</option><option value="soljson-v0.4.18-nightly.2017.9.26+commit.eb5a6aac.js">0.4.18-nightly.2017.9.26+commit.eb5a6aac</option><option value="soljson-v0.4.18-nightly.2017.9.25+commit.a72237f2.js">0.4.18-nightly.2017.9.25+commit.a72237f2</option><option value="soljson-v0.4.18-nightly.2017.9.22+commit.a2a58789.js">0.4.18-nightly.2017.9.22+commit.a2a58789</option><option value="soljson-v0.4.17+commit.bdeb9e52.js">0.4.17+commit.bdeb9e52</option><option value="soljson-v0.4.17-nightly.2017.9.21+commit.725b4fc2.js">0.4.17-nightly.2017.9.21+commit.725b4fc2</option><option value="soljson-v0.4.17-nightly.2017.9.20+commit.c0b3e5b0.js">0.4.17-nightly.2017.9.20+commit.c0b3e5b0</option><option value="soljson-v0.4.17-nightly.2017.9.19+commit.1fc71bd7.js">0.4.17-nightly.2017.9.19+commit.1fc71bd7</option><option value="soljson-v0.4.17-nightly.2017.9.18+commit.c289fd3d.js">0.4.17-nightly.2017.9.18+commit.c289fd3d</option><option value="soljson-v0.4.17-nightly.2017.9.16+commit.a0d17172.js">0.4.17-nightly.2017.9.16+commit.a0d17172</option><option value="soljson-v0.4.17-nightly.2017.9.14+commit.7dd372ce.js">0.4.17-nightly.2017.9.14+commit.7dd372ce</option><option value="soljson-v0.4.17-nightly.2017.9.12+commit.4770f8f4.js">0.4.17-nightly.2017.9.12+commit.4770f8f4</option><option value="soljson-v0.4.17-nightly.2017.9.11+commit.fbe24da1.js">0.4.17-nightly.2017.9.11+commit.fbe24da1</option><option value="soljson-v0.4.17-nightly.2017.9.6+commit.59223061.js">0.4.17-nightly.2017.9.6+commit.59223061</option><option value="soljson-v0.4.17-nightly.2017.9.5+commit.f242331c.js">0.4.17-nightly.2017.9.5+commit.f242331c</option><option value="soljson-v0.4.17-nightly.2017.9.4+commit.8283f836.js">0.4.17-nightly.2017.9.4+commit.8283f836</option><option value="soljson-v0.4.17-nightly.2017.8.31+commit.402d6e71.js">0.4.17-nightly.2017.8.31+commit.402d6e71</option><option value="soljson-v0.4.17-nightly.2017.8.29+commit.2d39a42d.js">0.4.17-nightly.2017.8.29+commit.2d39a42d</option><option value="soljson-v0.4.17-nightly.2017.8.28+commit.d15cde2a.js">0.4.17-nightly.2017.8.28+commit.d15cde2a</option><option value="soljson-v0.4.17-nightly.2017.8.25+commit.e945f458.js">0.4.17-nightly.2017.8.25+commit.e945f458</option><option value="soljson-v0.4.17-nightly.2017.8.24+commit.12d9f79.js">0.4.17-nightly.2017.8.24+commit.12d9f79</option><option value="soljson-v0.4.16+commit.d7661dd9.js">0.4.16+commit.d7661dd9</option><option value="soljson-v0.4.16-nightly.2017.8.24+commit.78c2dcac.js">0.4.16-nightly.2017.8.24+commit.78c2dcac</option><option value="soljson-v0.4.16-nightly.2017.8.23+commit.c5f11d93.js">0.4.16-nightly.2017.8.23+commit.c5f11d93</option><option value="soljson-v0.4.16-nightly.2017.8.22+commit.f874fc28.js">0.4.16-nightly.2017.8.22+commit.f874fc28</option><option value="soljson-v0.4.16-nightly.2017.8.21+commit.cf60488.js">0.4.16-nightly.2017.8.21+commit.cf60488</option><option value="soljson-v0.4.16-nightly.2017.8.16+commit.83561e13.js">0.4.16-nightly.2017.8.16+commit.83561e13</option><option value="soljson-v0.4.16-nightly.2017.8.15+commit.dca1f45c.js">0.4.16-nightly.2017.8.15+commit.dca1f45c</option><option value="soljson-v0.4.16-nightly.2017.8.14+commit.4d9790b6.js">0.4.16-nightly.2017.8.14+commit.4d9790b6</option><option value="soljson-v0.4.16-nightly.2017.8.11+commit.c84de7fa.js">0.4.16-nightly.2017.8.11+commit.c84de7fa</option><option value="soljson-v0.4.16-nightly.2017.8.10+commit.41e3cbe0.js">0.4.16-nightly.2017.8.10+commit.41e3cbe0</option><option value="soljson-v0.4.16-nightly.2017.8.9+commit.81887bc7.js">0.4.16-nightly.2017.8.9+commit.81887bc7</option><option value="soljson-v0.4.15+commit.bbb8e64f.js">0.4.15+commit.bbb8e64f</option><option value="soljson-v0.4.15-nightly.2017.8.8+commit.41e72436.js">0.4.15-nightly.2017.8.8+commit.41e72436</option><option value="soljson-v0.4.15-nightly.2017.8.7+commit.212454a9.js">0.4.15-nightly.2017.8.7+commit.212454a9</option><option value="soljson-v0.4.15-nightly.2017.8.4+commit.e48730fe.js">0.4.15-nightly.2017.8.4+commit.e48730fe</option><option value="soljson-v0.4.15-nightly.2017.8.2+commit.4166ce1.js">0.4.15-nightly.2017.8.2+commit.4166ce1</option><option value="soljson-v0.4.15-nightly.2017.8.1+commit.7e07eb6e.js">0.4.15-nightly.2017.8.1+commit.7e07eb6e</option><option value="soljson-v0.4.15-nightly.2017.7.31+commit.93f90eb2.js">0.4.15-nightly.2017.7.31+commit.93f90eb2</option><option value="soljson-v0.4.14+commit.c2215d46.js">0.4.14+commit.c2215d46</option><option value="soljson-v0.4.14-nightly.2017.7.31+commit.22326189.js">0.4.14-nightly.2017.7.31+commit.22326189</option><option value="soljson-v0.4.14-nightly.2017.7.28+commit.7e40def6.js">0.4.14-nightly.2017.7.28+commit.7e40def6</option><option value="soljson-v0.4.14-nightly.2017.7.27+commit.1298a8df.js">0.4.14-nightly.2017.7.27+commit.1298a8df</option><option value="soljson-v0.4.14-nightly.2017.7.26+commit.d701c94.js">0.4.14-nightly.2017.7.26+commit.d701c94</option><option value="soljson-v0.4.14-nightly.2017.7.25+commit.3c2b710b.js">0.4.14-nightly.2017.7.25+commit.3c2b710b</option><option value="soljson-v0.4.14-nightly.2017.7.24+commit.cfb11ff7.js">0.4.14-nightly.2017.7.24+commit.cfb11ff7</option><option value="soljson-v0.4.14-nightly.2017.7.21+commit.75b48616.js">0.4.14-nightly.2017.7.21+commit.75b48616</option><option value="soljson-v0.4.14-nightly.2017.7.20+commit.d70974ea.js">0.4.14-nightly.2017.7.20+commit.d70974ea</option><option value="soljson-v0.4.14-nightly.2017.7.19+commit.3ad326be.js">0.4.14-nightly.2017.7.19+commit.3ad326be</option><option value="soljson-v0.4.14-nightly.2017.7.18+commit.c167a31b.js">0.4.14-nightly.2017.7.18+commit.c167a31b</option><option value="soljson-v0.4.14-nightly.2017.7.14+commit.7c97546f.js">0.4.14-nightly.2017.7.14+commit.7c97546f</option><option value="soljson-v0.4.14-nightly.2017.7.13+commit.2b33e0bc.js">0.4.14-nightly.2017.7.13+commit.2b33e0bc</option><option value="soljson-v0.4.14-nightly.2017.7.12+commit.b981ef20.js">0.4.14-nightly.2017.7.12+commit.b981ef20</option><option value="soljson-v0.4.14-nightly.2017.7.11+commit.b17ff1b.js">0.4.14-nightly.2017.7.11+commit.b17ff1b</option><option value="soljson-v0.4.14-nightly.2017.7.10+commit.6fa5d47f.js">0.4.14-nightly.2017.7.10+commit.6fa5d47f</option><option value="soljson-v0.4.14-nightly.2017.7.9+commit.aafcc360.js">0.4.14-nightly.2017.7.9+commit.aafcc360</option><option value="soljson-v0.4.14-nightly.2017.7.8+commit.7d1ddfc6.js">0.4.14-nightly.2017.7.8+commit.7d1ddfc6</option><option value="soljson-v0.4.14-nightly.2017.7.6+commit.8dade9f.js">0.4.14-nightly.2017.7.6+commit.8dade9f</option><option value="soljson-v0.4.13+commit.fb4cb1a.js">0.4.13+commit.fb4cb1a</option><option value="soljson-v0.4.13-nightly.2017.7.6+commit.40d4ee49.js">0.4.13-nightly.2017.7.6+commit.40d4ee49</option><option value="soljson-v0.4.13-nightly.2017.7.5+commit.2b505e7a.js">0.4.13-nightly.2017.7.5+commit.2b505e7a</option><option value="soljson-v0.4.13-nightly.2017.7.4+commit.331b0b1c.js">0.4.13-nightly.2017.7.4+commit.331b0b1c</option><option value="soljson-v0.4.13-nightly.2017.7.3+commit.6e4e627b.js">0.4.13-nightly.2017.7.3+commit.6e4e627b</option><option value="soljson-v0.4.12+commit.194ff033.js">0.4.12+commit.194ff033</option><option value="soljson-v0.4.12-nightly.2017.7.3+commit.c7530a8.js">0.4.12-nightly.2017.7.3+commit.c7530a8</option><option value="soljson-v0.4.12-nightly.2017.7.1+commit.6f8949f.js">0.4.12-nightly.2017.7.1+commit.6f8949f</option><option value="soljson-v0.4.12-nightly.2017.6.30+commit.568e7520.js">0.4.12-nightly.2017.6.30+commit.568e7520</option><option value="soljson-v0.4.12-nightly.2017.6.29+commit.f5372cda.js">0.4.12-nightly.2017.6.29+commit.f5372cda</option><option value="soljson-v0.4.12-nightly.2017.6.28+commit.e19c4125.js">0.4.12-nightly.2017.6.28+commit.e19c4125</option><option value="soljson-v0.4.12-nightly.2017.6.27+commit.bc31d496.js">0.4.12-nightly.2017.6.27+commit.bc31d496</option><option value="soljson-v0.4.12-nightly.2017.6.26+commit.f8794892.js">0.4.12-nightly.2017.6.26+commit.f8794892</option><option value="soljson-v0.4.12-nightly.2017.6.25+commit.29b8cdb5.js">0.4.12-nightly.2017.6.25+commit.29b8cdb5</option><option value="soljson-v0.4.12-nightly.2017.6.23+commit.793f05fa.js">0.4.12-nightly.2017.6.23+commit.793f05fa</option><option value="soljson-v0.4.12-nightly.2017.6.22+commit.1c54ce2a.js">0.4.12-nightly.2017.6.22+commit.1c54ce2a</option><option value="soljson-v0.4.12-nightly.2017.6.21+commit.ac977cdf.js">0.4.12-nightly.2017.6.21+commit.ac977cdf</option><option value="soljson-v0.4.12-nightly.2017.6.20+commit.cb5f2f90.js">0.4.12-nightly.2017.6.20+commit.cb5f2f90</option><option value="soljson-v0.4.12-nightly.2017.6.19+commit.c75afb2.js">0.4.12-nightly.2017.6.19+commit.c75afb2</option><option value="soljson-v0.4.12-nightly.2017.6.16+commit.17de4a07.js">0.4.12-nightly.2017.6.16+commit.17de4a07</option><option value="soljson-v0.4.12-nightly.2017.6.15+commit.71fea1e3.js">0.4.12-nightly.2017.6.15+commit.71fea1e3</option><option value="soljson-v0.4.12-nightly.2017.6.14+commit.43cfab70.js">0.4.12-nightly.2017.6.14+commit.43cfab70</option><option value="soljson-v0.4.12-nightly.2017.6.13+commit.c8c2091.js">0.4.12-nightly.2017.6.13+commit.c8c2091</option><option value="soljson-v0.4.12-nightly.2017.6.12+commit.496c2a20.js">0.4.12-nightly.2017.6.12+commit.496c2a20</option><option value="soljson-v0.4.12-nightly.2017.6.9+commit.76667fed.js">0.4.12-nightly.2017.6.9+commit.76667fed</option><option value="soljson-v0.4.12-nightly.2017.6.8+commit.51fcfbcf.js">0.4.12-nightly.2017.6.8+commit.51fcfbcf</option><option value="soljson-v0.4.12-nightly.2017.6.6+commit.243e389f.js">0.4.12-nightly.2017.6.6+commit.243e389f</option><option value="soljson-v0.4.12-nightly.2017.6.1+commit.96de7a83.js">0.4.12-nightly.2017.6.1+commit.96de7a83</option><option value="soljson-v0.4.12-nightly.2017.5.30+commit.254b5572.js">0.4.12-nightly.2017.5.30+commit.254b5572</option><option value="soljson-v0.4.12-nightly.2017.5.29+commit.4a5dc6a4.js">0.4.12-nightly.2017.5.29+commit.4a5dc6a4</option><option value="soljson-v0.4.12-nightly.2017.5.26+commit.e43ff797.js">0.4.12-nightly.2017.5.26+commit.e43ff797</option><option value="soljson-v0.4.12-nightly.2017.5.24+commit.cf639f48.js">0.4.12-nightly.2017.5.24+commit.cf639f48</option><option value="soljson-v0.4.12-nightly.2017.5.23+commit.14b22150.js">0.4.12-nightly.2017.5.23+commit.14b22150</option><option value="soljson-v0.4.12-nightly.2017.5.22+commit.e3af0640.js">0.4.12-nightly.2017.5.22+commit.e3af0640</option><option value="soljson-v0.4.12-nightly.2017.5.19+commit.982f6613.js">0.4.12-nightly.2017.5.19+commit.982f6613</option><option value="soljson-v0.4.12-nightly.2017.5.18+commit.6f9428e9.js">0.4.12-nightly.2017.5.18+commit.6f9428e9</option><option value="soljson-v0.4.12-nightly.2017.5.17+commit.b4c6877a.js">0.4.12-nightly.2017.5.17+commit.b4c6877a</option><option value="soljson-v0.4.12-nightly.2017.5.16+commit.2ba87fe8.js">0.4.12-nightly.2017.5.16+commit.2ba87fe8</option><option value="soljson-v0.4.12-nightly.2017.5.11+commit.242e4318.js">0.4.12-nightly.2017.5.11+commit.242e4318</option><option value="soljson-v0.4.12-nightly.2017.5.10+commit.a6586f75.js">0.4.12-nightly.2017.5.10+commit.a6586f75</option><option value="soljson-v0.4.12-nightly.2017.5.6+commit.822c9057.js">0.4.12-nightly.2017.5.6+commit.822c9057</option><option value="soljson-v0.4.12-nightly.2017.5.5+commit.582fcb9.js">0.4.12-nightly.2017.5.5+commit.582fcb9</option><option value="soljson-v0.4.12-nightly.2017.5.4+commit.25b32d9.js">0.4.12-nightly.2017.5.4+commit.25b32d9</option><option value="soljson-v0.4.11+commit.68ef5810.js">0.4.11+commit.68ef5810</option><option value="soljson-v0.4.11-nightly.2017.5.3+commit.1aa0f77a.js">0.4.11-nightly.2017.5.3+commit.1aa0f77a</option><option value="soljson-v0.4.11-nightly.2017.5.2+commit.5aeb6352.js">0.4.11-nightly.2017.5.2+commit.5aeb6352</option><option value="soljson-v0.4.11-nightly.2017.4.28+commit.f33614e1.js">0.4.11-nightly.2017.4.28+commit.f33614e1</option><option value="soljson-v0.4.11-nightly.2017.4.27+commit.abe77f48.js">0.4.11-nightly.2017.4.27+commit.abe77f48</option><option value="soljson-v0.4.11-nightly.2017.4.26+commit.3cbdf6d4.js">0.4.11-nightly.2017.4.26+commit.3cbdf6d4</option><option value="soljson-v0.4.11-nightly.2017.4.25+commit.c3b839ca.js">0.4.11-nightly.2017.4.25+commit.c3b839ca</option><option value="soljson-v0.4.11-nightly.2017.4.24+commit.a9f42157.js">0.4.11-nightly.2017.4.24+commit.a9f42157</option><option value="soljson-v0.4.11-nightly.2017.4.22+commit.aa441668.js">0.4.11-nightly.2017.4.22+commit.aa441668</option><option value="soljson-v0.4.11-nightly.2017.4.21+commit.e3eea9fc.js">0.4.11-nightly.2017.4.21+commit.e3eea9fc</option><option value="soljson-v0.4.11-nightly.2017.4.20+commit.6468955f.js">0.4.11-nightly.2017.4.20+commit.6468955f</option><option value="soljson-v0.4.11-nightly.2017.4.18+commit.82628a80.js">0.4.11-nightly.2017.4.18+commit.82628a80</option><option value="soljson-v0.4.11-nightly.2017.4.13+commit.138c952a.js">0.4.11-nightly.2017.4.13+commit.138c952a</option><option value="soljson-v0.4.11-nightly.2017.4.10+commit.9fe20650.js">0.4.11-nightly.2017.4.10+commit.9fe20650</option><option value="soljson-v0.4.11-nightly.2017.3.29+commit.fefb3fad.js">0.4.11-nightly.2017.3.29+commit.fefb3fad</option><option value="soljson-v0.4.11-nightly.2017.3.28+commit.215184ef.js">0.4.11-nightly.2017.3.28+commit.215184ef</option><option value="soljson-v0.4.11-nightly.2017.3.27+commit.9d769a56.js">0.4.11-nightly.2017.3.27+commit.9d769a56</option><option value="soljson-v0.4.11-nightly.2017.3.22+commit.74d7c513.js">0.4.11-nightly.2017.3.22+commit.74d7c513</option><option value="soljson-v0.4.11-nightly.2017.3.21+commit.6fb27dee.js">0.4.11-nightly.2017.3.21+commit.6fb27dee</option><option value="soljson-v0.4.11-nightly.2017.3.20+commit.57bc763e.js">0.4.11-nightly.2017.3.20+commit.57bc763e</option><option value="soljson-v0.4.11-nightly.2017.3.17+commit.2f2ad42c.js">0.4.11-nightly.2017.3.17+commit.2f2ad42c</option><option value="soljson-v0.4.11-nightly.2017.3.16+commit.a2eb2c0a.js">0.4.11-nightly.2017.3.16+commit.a2eb2c0a</option><option value="soljson-v0.4.11-nightly.2017.3.15+commit.157b86c.js">0.4.11-nightly.2017.3.15+commit.157b86c</option><option value="soljson-v0.4.10+commit.f0d539ae.js">0.4.10+commit.f0d539ae</option><option value="soljson-v0.4.10-nightly.2017.3.15+commit.d134fda0.js">0.4.10-nightly.2017.3.15+commit.d134fda0</option><option value="soljson-v0.4.10-nightly.2017.3.14+commit.409eb9e3.js">0.4.10-nightly.2017.3.14+commit.409eb9e3</option><option value="soljson-v0.4.10-nightly.2017.3.13+commit.9aab3b86.js">0.4.10-nightly.2017.3.13+commit.9aab3b86</option><option value="soljson-v0.4.10-nightly.2017.3.10+commit.f1dd79c7.js">0.4.10-nightly.2017.3.10+commit.f1dd79c7</option><option value="soljson-v0.4.10-nightly.2017.3.9+commit.b22369d5.js">0.4.10-nightly.2017.3.9+commit.b22369d5</option><option value="soljson-v0.4.10-nightly.2017.3.8+commit.a1e350a4.js">0.4.10-nightly.2017.3.8+commit.a1e350a4</option><option value="soljson-v0.4.10-nightly.2017.3.6+commit.2dac39b9.js">0.4.10-nightly.2017.3.6+commit.2dac39b9</option><option value="soljson-v0.4.10-nightly.2017.3.3+commit.6bfd894f.js">0.4.10-nightly.2017.3.3+commit.6bfd894f</option><option value="soljson-v0.4.10-nightly.2017.3.2+commit.5c411b47.js">0.4.10-nightly.2017.3.2+commit.5c411b47</option><option value="soljson-v0.4.10-nightly.2017.3.1+commit.6ac2c15c.js">0.4.10-nightly.2017.3.1+commit.6ac2c15c</option><option value="soljson-v0.4.10-nightly.2017.2.24+commit.6bbba106.js">0.4.10-nightly.2017.2.24+commit.6bbba106</option><option value="soljson-v0.4.10-nightly.2017.2.22+commit.b67fee3.js">0.4.10-nightly.2017.2.22+commit.b67fee3</option><option value="soljson-v0.4.10-nightly.2017.2.20+commit.32b7d174.js">0.4.10-nightly.2017.2.20+commit.32b7d174</option><option value="soljson-v0.4.10-nightly.2017.2.17+commit.419ab926.js">0.4.10-nightly.2017.2.17+commit.419ab926</option><option value="soljson-v0.4.10-nightly.2017.2.16+commit.ad8e534.js">0.4.10-nightly.2017.2.16+commit.ad8e534</option><option value="soljson-v0.4.10-nightly.2017.2.15+commit.ad751bd3.js">0.4.10-nightly.2017.2.15+commit.ad751bd3</option><option value="soljson-v0.4.10-nightly.2017.2.14+commit.91d5515c.js">0.4.10-nightly.2017.2.14+commit.91d5515c</option><option value="soljson-v0.4.10-nightly.2017.2.13+commit.8357bdad.js">0.4.10-nightly.2017.2.13+commit.8357bdad</option><option value="soljson-v0.4.10-nightly.2017.2.3+commit.5ce79609.js">0.4.10-nightly.2017.2.3+commit.5ce79609</option><option value="soljson-v0.4.10-nightly.2017.2.2+commit.8f9839c6.js">0.4.10-nightly.2017.2.2+commit.8f9839c6</option><option value="soljson-v0.4.10-nightly.2017.2.1+commit.c1a675da.js">0.4.10-nightly.2017.2.1+commit.c1a675da</option><option value="soljson-v0.4.10-nightly.2017.1.31+commit.747db75a.js">0.4.10-nightly.2017.1.31+commit.747db75a</option><option value="soljson-v0.4.9+commit.364da425.js">0.4.9+commit.364da425</option><option value="soljson-v0.4.9-nightly.2017.1.31+commit.f9af2de0.js">0.4.9-nightly.2017.1.31+commit.f9af2de0</option><option value="soljson-v0.4.9-nightly.2017.1.30+commit.edd3696d.js">0.4.9-nightly.2017.1.30+commit.edd3696d</option><option value="soljson-v0.4.9-nightly.2017.1.27+commit.1774e087.js">0.4.9-nightly.2017.1.27+commit.1774e087</option><option value="soljson-v0.4.9-nightly.2017.1.26+commit.2122d2d7.js">0.4.9-nightly.2017.1.26+commit.2122d2d7</option><option value="soljson-v0.4.9-nightly.2017.1.24+commit.b52a6040.js">0.4.9-nightly.2017.1.24+commit.b52a6040</option><option value="soljson-v0.4.9-nightly.2017.1.23+commit.6946902c.js">0.4.9-nightly.2017.1.23+commit.6946902c</option><option value="soljson-v0.4.9-nightly.2017.1.20+commit.12b002b3.js">0.4.9-nightly.2017.1.20+commit.12b002b3</option><option value="soljson-v0.4.9-nightly.2017.1.19+commit.9403dd5.js">0.4.9-nightly.2017.1.19+commit.9403dd5</option><option value="soljson-v0.4.9-nightly.2017.1.18+commit.5e1908.js">0.4.9-nightly.2017.1.18+commit.5e1908</option><option value="soljson-v0.4.9-nightly.2017.1.17+commit.6ecb4aa3.js">0.4.9-nightly.2017.1.17+commit.6ecb4aa3</option><option value="soljson-v0.4.9-nightly.2017.1.16+commit.79e5772b.js">0.4.9-nightly.2017.1.16+commit.79e5772b</option><option value="soljson-v0.4.9-nightly.2017.1.13+commit.392ef5f4.js">0.4.9-nightly.2017.1.13+commit.392ef5f4</option><option value="soljson-v0.4.8+commit.60cc1668.js">0.4.8+commit.60cc1668</option><option value="soljson-v0.4.8-nightly.2017.1.13+commit.bde0b406.js">0.4.8-nightly.2017.1.13+commit.bde0b406</option><option value="soljson-v0.4.8-nightly.2017.1.12+commit.b983c749.js">0.4.8-nightly.2017.1.12+commit.b983c749</option><option value="soljson-v0.4.8-nightly.2017.1.11+commit.4f5da2ea.js">0.4.8-nightly.2017.1.11+commit.4f5da2ea</option><option value="soljson-v0.4.8-nightly.2017.1.10+commit.26a90af4.js">0.4.8-nightly.2017.1.10+commit.26a90af4</option><option value="soljson-v0.4.8-nightly.2017.1.9+commit.354a10be.js">0.4.8-nightly.2017.1.9+commit.354a10be</option><option value="soljson-v0.4.8-nightly.2017.1.6+commit.a4d7a590.js">0.4.8-nightly.2017.1.6+commit.a4d7a590</option><option value="soljson-v0.4.8-nightly.2017.1.5+commit.31e6a5.js">0.4.8-nightly.2017.1.5+commit.31e6a5</option><option value="soljson-v0.4.8-nightly.2017.1.3+commit.43a5d11f.js">0.4.8-nightly.2017.1.3+commit.43a5d11f</option><option value="soljson-v0.4.8-nightly.2017.1.2+commit.75a596ab.js">0.4.8-nightly.2017.1.2+commit.75a596ab</option><option value="soljson-v0.4.8-nightly.2016.12.16+commit.af8bc1c9.js">0.4.8-nightly.2016.12.16+commit.af8bc1c9</option><option value="soljson-v0.4.7+commit.822622cf.js">0.4.7+commit.822622cf</option><option value="soljson-v0.4.7-nightly.2016.12.15+commit.688841ae.js">0.4.7-nightly.2016.12.15+commit.688841ae</option><option value="soljson-v0.4.7-nightly.2016.12.14+commit.e53d1255.js">0.4.7-nightly.2016.12.14+commit.e53d1255</option><option value="soljson-v0.4.7-nightly.2016.12.13+commit.9d607345.js">0.4.7-nightly.2016.12.13+commit.9d607345</option><option value="soljson-v0.4.7-nightly.2016.12.12+commit.e53fdb49.js">0.4.7-nightly.2016.12.12+commit.e53fdb49</option><option value="soljson-v0.4.7-nightly.2016.12.11+commit.84d4f3da.js">0.4.7-nightly.2016.12.11+commit.84d4f3da</option><option value="soljson-v0.4.7-nightly.2016.12.8+commit.89771a44.js">0.4.7-nightly.2016.12.8+commit.89771a44</option><option value="soljson-v0.4.7-nightly.2016.12.7+commit.fd7561ed.js">0.4.7-nightly.2016.12.7+commit.fd7561ed</option><option value="soljson-v0.4.7-nightly.2016.12.6+commit.b201e148.js">0.4.7-nightly.2016.12.6+commit.b201e148</option><option value="soljson-v0.4.7-nightly.2016.12.5+commit.34327c5d.js">0.4.7-nightly.2016.12.5+commit.34327c5d</option><option value="soljson-v0.4.7-nightly.2016.12.3+commit.9be2fb12.js">0.4.7-nightly.2016.12.3+commit.9be2fb12</option><option value="soljson-v0.4.7-nightly.2016.12.2+commit.3a01a87a.js">0.4.7-nightly.2016.12.2+commit.3a01a87a</option><option value="soljson-v0.4.7-nightly.2016.12.1+commit.67f274f6.js">0.4.7-nightly.2016.12.1+commit.67f274f6</option><option value="soljson-v0.4.7-nightly.2016.11.30+commit.e43a8ebc.js">0.4.7-nightly.2016.11.30+commit.e43a8ebc</option><option value="soljson-v0.4.7-nightly.2016.11.29+commit.71cbc4a.js">0.4.7-nightly.2016.11.29+commit.71cbc4a</option><option value="soljson-v0.4.7-nightly.2016.11.28+commit.dadb4818.js">0.4.7-nightly.2016.11.28+commit.dadb4818</option><option value="soljson-v0.4.7-nightly.2016.11.26+commit.4a67a286.js">0.4.7-nightly.2016.11.26+commit.4a67a286</option><option value="soljson-v0.4.7-nightly.2016.11.25+commit.ba94b0ae.js">0.4.7-nightly.2016.11.25+commit.ba94b0ae</option><option value="soljson-v0.4.7-nightly.2016.11.24+commit.851f8576.js">0.4.7-nightly.2016.11.24+commit.851f8576</option><option value="soljson-v0.4.7-nightly.2016.11.23+commit.475009b9.js">0.4.7-nightly.2016.11.23+commit.475009b9</option><option value="soljson-v0.4.7-nightly.2016.11.22+commit.1a205ebf.js">0.4.7-nightly.2016.11.22+commit.1a205ebf</option><option value="soljson-v0.4.6+commit.2dabbdf0.js">0.4.6+commit.2dabbdf0</option><option value="soljson-v0.4.6-nightly.2016.11.22+commit.3d9a180c.js">0.4.6-nightly.2016.11.22+commit.3d9a180c</option><option value="soljson-v0.4.6-nightly.2016.11.21+commit.aa48008c.js">0.4.6-nightly.2016.11.21+commit.aa48008c</option><option value="soljson-v0.4.5+commit.b318366e.js">0.4.5+commit.b318366e</option><option value="soljson-v0.4.5-nightly.2016.11.21+commit.afda210a.js">0.4.5-nightly.2016.11.21+commit.afda210a</option><option value="soljson-v0.4.5-nightly.2016.11.17+commit.b46a14f4.js">0.4.5-nightly.2016.11.17+commit.b46a14f4</option><option value="soljson-v0.4.5-nightly.2016.11.16+commit.c8116918.js">0.4.5-nightly.2016.11.16+commit.c8116918</option><option value="soljson-v0.4.5-nightly.2016.11.15+commit.c1b1efaf.js">0.4.5-nightly.2016.11.15+commit.c1b1efaf</option><option value="soljson-v0.4.5-nightly.2016.11.14+commit.4f546e65.js">0.4.5-nightly.2016.11.14+commit.4f546e65</option><option value="soljson-v0.4.5-nightly.2016.11.11+commit.6248e92d.js">0.4.5-nightly.2016.11.11+commit.6248e92d</option><option value="soljson-v0.4.5-nightly.2016.11.10+commit.a40dcfef.js">0.4.5-nightly.2016.11.10+commit.a40dcfef</option><option value="soljson-v0.4.5-nightly.2016.11.9+commit.c82acfd3.js">0.4.5-nightly.2016.11.9+commit.c82acfd3</option><option value="soljson-v0.4.5-nightly.2016.11.8+commit.7a30e8cf.js">0.4.5-nightly.2016.11.8+commit.7a30e8cf</option><option value="soljson-v0.4.5-nightly.2016.11.4+commit.d97d267a.js">0.4.5-nightly.2016.11.4+commit.d97d267a</option><option value="soljson-v0.4.5-nightly.2016.11.3+commit.90a4acc3.js">0.4.5-nightly.2016.11.3+commit.90a4acc3</option><option value="soljson-v0.4.5-nightly.2016.11.1+commit.9cb1d30e.js">0.4.5-nightly.2016.11.1+commit.9cb1d30e</option><option value="soljson-v0.4.4+commit.4633f3de.js">0.4.4+commit.4633f3de</option><option value="soljson-v0.4.4-nightly.2016.10.31+commit.1d3460c4.js">0.4.4-nightly.2016.10.31+commit.1d3460c4</option><option value="soljson-v0.4.4-nightly.2016.10.28+commit.e85390cc.js">0.4.4-nightly.2016.10.28+commit.e85390cc</option><option value="soljson-v0.4.4-nightly.2016.10.27+commit.76e958f6.js">0.4.4-nightly.2016.10.27+commit.76e958f6</option><option value="soljson-v0.4.4-nightly.2016.10.26+commit.34e2209b.js">0.4.4-nightly.2016.10.26+commit.34e2209b</option><option value="soljson-v0.4.4-nightly.2016.10.25+commit.f99a418b.js">0.4.4-nightly.2016.10.25+commit.f99a418b</option><option value="soljson-v0.4.3+commit.2353da71.js">0.4.3+commit.2353da71</option><option value="soljson-v0.4.3-nightly.2016.10.25+commit.d190f016.js">0.4.3-nightly.2016.10.25+commit.d190f016</option><option value="soljson-v0.4.3-nightly.2016.10.24+commit.84b43b91.js">0.4.3-nightly.2016.10.24+commit.84b43b91</option><option value="soljson-v0.4.3-nightly.2016.10.21+commit.984b8ac1.js">0.4.3-nightly.2016.10.21+commit.984b8ac1</option><option value="soljson-v0.4.3-nightly.2016.10.20+commit.9d304501.js">0.4.3-nightly.2016.10.20+commit.9d304501</option><option value="soljson-v0.4.3-nightly.2016.10.19+commit.fd6f2b5.js">0.4.3-nightly.2016.10.19+commit.fd6f2b5</option><option value="soljson-v0.4.3-nightly.2016.10.18+commit.a9eb645.js">0.4.3-nightly.2016.10.18+commit.a9eb645</option><option value="soljson-v0.4.3-nightly.2016.10.17+commit.7d32937.js">0.4.3-nightly.2016.10.17+commit.7d32937</option><option value="soljson-v0.4.3-nightly.2016.10.15+commit.482807f6.js">0.4.3-nightly.2016.10.15+commit.482807f6</option><option value="soljson-v0.4.3-nightly.2016.10.14+commit.635b6e0.js">0.4.3-nightly.2016.10.14+commit.635b6e0</option><option value="soljson-v0.4.3-nightly.2016.10.13+commit.2951c1eb.js">0.4.3-nightly.2016.10.13+commit.2951c1eb</option><option value="soljson-v0.4.3-nightly.2016.10.12+commit.def3f3ea.js">0.4.3-nightly.2016.10.12+commit.def3f3ea</option><option value="soljson-v0.4.3-nightly.2016.10.11+commit.aa18a6bd.js">0.4.3-nightly.2016.10.11+commit.aa18a6bd</option><option value="soljson-v0.4.3-nightly.2016.10.10+commit.119bd4ad.js">0.4.3-nightly.2016.10.10+commit.119bd4ad</option><option value="soljson-v0.4.3-nightly.2016.9.30+commit.d5cfb17b.js">0.4.3-nightly.2016.9.30+commit.d5cfb17b</option><option value="soljson-v0.4.2+commit.af6afb04.js">0.4.2+commit.af6afb04</option><option value="soljson-v0.4.2-nightly.2016.9.17+commit.a78e7794.js">0.4.2-nightly.2016.9.17+commit.a78e7794</option><option value="soljson-v0.4.2-nightly.2016.9.17+commit.212e0160.js">0.4.2-nightly.2016.9.17+commit.212e0160</option><option value="soljson-v0.4.2-nightly.2016.9.17+commit.60f432e8.js">0.4.2-nightly.2016.9.17+commit.60f432e8</option><option value="soljson-v0.4.2-nightly.2016.9.17+commit.bc8476a.js">0.4.2-nightly.2016.9.17+commit.bc8476a</option><option value="soljson-v0.4.2-nightly.2016.9.17+commit.62f13ad8.js">0.4.2-nightly.2016.9.17+commit.62f13ad8</option><option value="soljson-v0.4.2-nightly.2016.9.15+commit.8a4f8c2.js">0.4.2-nightly.2016.9.15+commit.8a4f8c2</option><option value="soljson-v0.4.2-nightly.2016.9.15+commit.6a80511.js">0.4.2-nightly.2016.9.15+commit.6a80511</option><option value="soljson-v0.4.2-nightly.2016.9.13+commit.2bee7e9.js">0.4.2-nightly.2016.9.13+commit.2bee7e9</option><option value="soljson-v0.4.2-nightly.2016.9.12+commit.149dba9.js">0.4.2-nightly.2016.9.12+commit.149dba9</option><option value="soljson-v0.4.2-nightly.2016.9.9+commit.51a98ab.js">0.4.2-nightly.2016.9.9+commit.51a98ab</option><option value="soljson-v0.4.1+commit.4fc6fc2c.js">0.4.1+commit.4fc6fc2c</option><option value="soljson-v0.4.1-nightly.2016.9.9+commit.79867f4.js">0.4.1-nightly.2016.9.9+commit.79867f4</option><option value="soljson-v0.4.0+commit.acd334c9.js">0.4.0+commit.acd334c9</option><option value="soljson-v0.3.6+commit.3fc68da.js">0.3.6+commit.3fc68da</option><option value="soljson-v0.3.6-nightly.2016.9.8+commit.f5a513a.js">0.3.6-nightly.2016.9.8+commit.f5a513a</option><option value="soljson-v0.3.6-nightly.2016.9.7+commit.24524d6.js">0.3.6-nightly.2016.9.7+commit.24524d6</option><option value="soljson-v0.3.6-nightly.2016.9.6+commit.114502f.js">0.3.6-nightly.2016.9.6+commit.114502f</option><option value="soljson-v0.3.6-nightly.2016.9.5+commit.873d8bb.js">0.3.6-nightly.2016.9.5+commit.873d8bb</option><option value="soljson-v0.3.6-nightly.2016.9.2+commit.341c943.js">0.3.6-nightly.2016.9.2+commit.341c943</option><option value="soljson-v0.3.6-nightly.2016.9.1+commit.b5d941d.js">0.3.6-nightly.2016.9.1+commit.b5d941d</option><option value="soljson-v0.3.6-nightly.2016.8.31+commit.3ccd198.js">0.3.6-nightly.2016.8.31+commit.3ccd198</option><option value="soljson-v0.3.6-nightly.2016.8.30+commit.cf974fd.js">0.3.6-nightly.2016.8.30+commit.cf974fd</option><option value="soljson-v0.3.6-nightly.2016.8.29+commit.b8060c5.js">0.3.6-nightly.2016.8.29+commit.b8060c5</option><option value="soljson-v0.3.6-nightly.2016.8.27+commit.91d4fa4.js">0.3.6-nightly.2016.8.27+commit.91d4fa4</option><option value="soljson-v0.3.6-nightly.2016.8.26+commit.3eeefb5.js">0.3.6-nightly.2016.8.26+commit.3eeefb5</option><option value="soljson-v0.3.6-nightly.2016.8.24+commit.e20afc7.js">0.3.6-nightly.2016.8.24+commit.e20afc7</option><option value="soljson-v0.3.6-nightly.2016.8.23+commit.de535a7.js">0.3.6-nightly.2016.8.23+commit.de535a7</option><option value="soljson-v0.3.6-nightly.2016.8.22+commit.7183658.js">0.3.6-nightly.2016.8.22+commit.7183658</option><option value="soljson-v0.3.6-nightly.2016.8.20+commit.d736fd.js">0.3.6-nightly.2016.8.20+commit.d736fd</option><option value="soljson-v0.3.6-nightly.2016.8.19+commit.32c93cf.js">0.3.6-nightly.2016.8.19+commit.32c93cf</option><option value="soljson-v0.3.6-nightly.2016.8.17+commit.c499470.js">0.3.6-nightly.2016.8.17+commit.c499470</option><option value="soljson-v0.3.6-nightly.2016.8.16+commit.970260b.js">0.3.6-nightly.2016.8.16+commit.970260b</option><option value="soljson-v0.3.6-nightly.2016.8.15+commit.868a167.js">0.3.6-nightly.2016.8.15+commit.868a167</option><option value="soljson-v0.3.6-nightly.2016.8.12+commit.9e03bda.js">0.3.6-nightly.2016.8.12+commit.9e03bda</option><option value="soljson-v0.3.6-nightly.2016.8.11+commit.7c15fa6.js">0.3.6-nightly.2016.8.11+commit.7c15fa6</option><option value="soljson-v0.3.6-nightly.2016.8.10+commit.e2a46b6.js">0.3.6-nightly.2016.8.10+commit.e2a46b6</option><option value="soljson-v0.3.6-nightly.2016.8.10+commit.b7c26f4.js">0.3.6-nightly.2016.8.10+commit.b7c26f4</option><option value="soljson-v0.3.6-nightly.2016.8.10+commit.55858de.js">0.3.6-nightly.2016.8.10+commit.55858de</option><option value="soljson-v0.3.6-nightly.2016.8.10+commit.5a37403.js">0.3.6-nightly.2016.8.10+commit.5a37403</option><option value="soljson-v0.3.5+commit.5f97274.js">0.3.5+commit.5f97274</option><option value="soljson-v0.3.5-nightly.2016.8.10+commit.e6a031d.js">0.3.5-nightly.2016.8.10+commit.e6a031d</option><option value="soljson-v0.3.5-nightly.2016.8.10+commit.cacc3b6.js">0.3.5-nightly.2016.8.10+commit.cacc3b6</option><option value="soljson-v0.3.5-nightly.2016.8.10+commit.fc60839.js">0.3.5-nightly.2016.8.10+commit.fc60839</option><option value="soljson-v0.3.5-nightly.2016.8.8+commit.b13e581.js">0.3.5-nightly.2016.8.8+commit.b13e581</option><option value="soljson-v0.3.5-nightly.2016.8.8+commit.539afbe.js">0.3.5-nightly.2016.8.8+commit.539afbe</option><option value="soljson-v0.3.5-nightly.2016.8.8+commit.2fcc6ec.js">0.3.5-nightly.2016.8.8+commit.2fcc6ec</option><option value="soljson-v0.3.5-nightly.2016.8.8+commit.c3ed550.js">0.3.5-nightly.2016.8.8+commit.c3ed550</option><option value="soljson-v0.3.5-nightly.2016.8.7+commit.f7af7de.js">0.3.5-nightly.2016.8.7+commit.f7af7de</option><option value="soljson-v0.3.5-nightly.2016.8.6+commit.e3c1bf7.js">0.3.5-nightly.2016.8.6+commit.e3c1bf7</option><option value="soljson-v0.3.5-nightly.2016.8.5+commit.ff60ce9.js">0.3.5-nightly.2016.8.5+commit.ff60ce9</option><option value="soljson-v0.3.5-nightly.2016.8.5+commit.4542b7f.js">0.3.5-nightly.2016.8.5+commit.4542b7f</option><option value="soljson-v0.3.5-nightly.2016.8.5+commit.3c93a22.js">0.3.5-nightly.2016.8.5+commit.3c93a22</option><option value="soljson-v0.3.5-nightly.2016.8.4+commit.b83acfa.js">0.3.5-nightly.2016.8.4+commit.b83acfa</option><option value="soljson-v0.3.5-nightly.2016.8.3+commit.3b21d98.js">0.3.5-nightly.2016.8.3+commit.3b21d98</option><option value="soljson-v0.3.5-nightly.2016.7.21+commit.6610add.js">0.3.5-nightly.2016.7.21+commit.6610add</option><option value="soljson-v0.3.5-nightly.2016.7.19+commit.427deb4.js">0.3.5-nightly.2016.7.19+commit.427deb4</option><option value="soljson-v0.3.5-nightly.2016.7.1+commit.48238c9.js">0.3.5-nightly.2016.7.1+commit.48238c9</option><option value="soljson-v0.3.5-nightly.2016.6.27+commit.2ccfea8.js">0.3.5-nightly.2016.6.27+commit.2ccfea8</option><option value="soljson-v0.3.5-nightly.2016.6.21+commit.b23c300.js">0.3.5-nightly.2016.6.21+commit.b23c300</option><option value="soljson-v0.3.5-nightly.2016.6.20+commit.9da08ac.js">0.3.5-nightly.2016.6.20+commit.9da08ac</option><option value="soljson-v0.3.5-nightly.2016.6.19+commit.5917c8e.js">0.3.5-nightly.2016.6.19+commit.5917c8e</option><option value="soljson-v0.3.5-nightly.2016.6.14+commit.371690f.js">0.3.5-nightly.2016.6.14+commit.371690f</option><option value="soljson-v0.3.4+commit.7dab890.js">0.3.4+commit.7dab890</option><option value="soljson-v0.3.4-nightly.2016.6.8+commit.d593166.js">0.3.4-nightly.2016.6.8+commit.d593166</option><option value="soljson-v0.3.4-nightly.2016.6.8+commit.93790d.js">0.3.4-nightly.2016.6.8+commit.93790d</option><option value="soljson-v0.3.4-nightly.2016.6.8+commit.ccddd6f.js">0.3.4-nightly.2016.6.8+commit.ccddd6f</option><option value="soljson-v0.3.4-nightly.2016.6.6+commit.e97ac4f.js">0.3.4-nightly.2016.6.6+commit.e97ac4f</option><option value="soljson-v0.3.4-nightly.2016.6.5+commit.a0fc04.js">0.3.4-nightly.2016.6.5+commit.a0fc04</option><option value="soljson-v0.3.4-nightly.2016.6.4+commit.602bcd3.js">0.3.4-nightly.2016.6.4+commit.602bcd3</option><option value="soljson-v0.3.3+commit.4dc1cb1.js">0.3.3+commit.4dc1cb1</option><option value="soljson-v0.3.3-nightly.2016.5.31+commit.7dab890.js">0.3.3-nightly.2016.5.31+commit.7dab890</option><option value="soljson-v0.3.3-nightly.2016.5.30+commit.4be92c0.js">0.3.3-nightly.2016.5.30+commit.4be92c0</option><option value="soljson-v0.3.3-nightly.2016.5.28+commit.eb57a0c.js">0.3.3-nightly.2016.5.28+commit.eb57a0c</option><option value="soljson-v0.3.2+commit.81ae2a7.js">0.3.2+commit.81ae2a7</option><option value="soljson-v0.3.2-nightly.2016.5.27+commit.4dc1cb1.js">0.3.2-nightly.2016.5.27+commit.4dc1cb1</option><option value="soljson-v0.3.2-nightly.2016.5.25+commit.3c2056c.js">0.3.2-nightly.2016.5.25+commit.3c2056c</option><option value="soljson-v0.3.2-nightly.2016.5.24+commit.86c65c9.js">0.3.2-nightly.2016.5.24+commit.86c65c9</option><option value="soljson-v0.3.2-nightly.2016.5.20+commit.e3c5418.js">0.3.2-nightly.2016.5.20+commit.e3c5418</option><option value="soljson-v0.3.2-nightly.2016.5.19+commit.7a51852.js">0.3.2-nightly.2016.5.19+commit.7a51852</option><option value="soljson-v0.3.2-nightly.2016.5.18+commit.cb865fb.js">0.3.2-nightly.2016.5.18+commit.cb865fb</option><option value="soljson-v0.3.2-nightly.2016.5.17+commit.a37072.js">0.3.2-nightly.2016.5.17+commit.a37072</option><option value="soljson-v0.3.2-nightly.2016.5.13+commit.4b445b8.js">0.3.2-nightly.2016.5.13+commit.4b445b8</option><option value="soljson-v0.3.2-nightly.2016.5.12+commit.73ede5b.js">0.3.2-nightly.2016.5.12+commit.73ede5b</option><option value="soljson-v0.3.2-nightly.2016.5.12+commit.c06051d.js">0.3.2-nightly.2016.5.12+commit.c06051d</option><option value="soljson-v0.3.2-nightly.2016.5.6+commit.9e36bdd.js">0.3.2-nightly.2016.5.6+commit.9e36bdd</option><option value="soljson-v0.3.2-nightly.2016.5.5+commit.1b7e2d3.js">0.3.2-nightly.2016.5.5+commit.1b7e2d3</option><option value="soljson-v0.3.2-nightly.2016.5.3+commit.aa4dcbb.js">0.3.2-nightly.2016.5.3+commit.aa4dcbb</option><option value="soljson-v0.3.2-nightly.2016.5.1+commit.bee80f1.js">0.3.2-nightly.2016.5.1+commit.bee80f1</option><option value="soljson-v0.3.2-nightly.2016.4.22+commit.dd4300d.js">0.3.2-nightly.2016.4.22+commit.dd4300d</option><option value="soljson-v0.3.1+commit.c492d9b.js">0.3.1+commit.c492d9b</option><option value="soljson-v0.3.1-nightly.2016.4.18+commit.81ae2a7.js">0.3.1-nightly.2016.4.18+commit.81ae2a7</option><option value="soljson-v0.3.1-nightly.2016.4.15+commit.7ba6c98.js">0.3.1-nightly.2016.4.15+commit.7ba6c98</option><option value="soljson-v0.3.1-nightly.2016.4.13+commit.9137506.js">0.3.1-nightly.2016.4.13+commit.9137506</option><option value="soljson-v0.3.1-nightly.2016.4.12+commit.3ad5e82.js">0.3.1-nightly.2016.4.12+commit.3ad5e82</option><option value="soljson-v0.3.1-nightly.2016.4.7+commit.54bc2a.js">0.3.1-nightly.2016.4.7+commit.54bc2a</option><option value="soljson-v0.3.1-nightly.2016.4.5+commit.12797ed.js">0.3.1-nightly.2016.4.5+commit.12797ed</option><option value="soljson-v0.3.1-nightly.2016.3.31+commit.c67926c.js">0.3.1-nightly.2016.3.31+commit.c67926c</option><option value="soljson-v0.3.0+commit.11d6736.js">0.3.0+commit.11d6736</option><option value="soljson-v0.3.0-nightly.2016.3.30+commit.2acdfc5.js">0.3.0-nightly.2016.3.30+commit.2acdfc5</option><option value="soljson-v0.3.0-nightly.2016.3.30+commit.c2cf806.js">0.3.0-nightly.2016.3.30+commit.c2cf806</option><option value="soljson-v0.3.0-nightly.2016.3.18+commit.e759a24.js">0.3.0-nightly.2016.3.18+commit.e759a24</option><option value="soljson-v0.3.0-nightly.2016.3.11+commit.1f9578c.js">0.3.0-nightly.2016.3.11+commit.1f9578c</option><option value="soljson-v0.2.2+commit.ef92f56.js">0.2.2+commit.ef92f56</option><option value="soljson-v0.2.2-nightly.2016.3.10+commit.34d714f.js">0.2.2-nightly.2016.3.10+commit.34d714f</option><option value="soljson-v0.2.2-nightly.2016.3.2+commit.32f3a65.js">0.2.2-nightly.2016.3.2+commit.32f3a65</option><option value="soljson-v0.2.2-nightly.2016.3.1+commit.2bb315.js">0.2.2-nightly.2016.3.1+commit.2bb315</option><option value="soljson-v0.2.2-nightly.2016.2.22+commit.8339330.js">0.2.2-nightly.2016.2.22+commit.8339330</option><option value="soljson-v0.2.2-nightly.2016.2.19+commit.3738107.js">0.2.2-nightly.2016.2.19+commit.3738107</option><option value="soljson-v0.2.2-nightly.2016.2.18+commit.565d717.js">0.2.2-nightly.2016.2.18+commit.565d717</option><option value="soljson-v0.2.1+commit.91a6b35.js">0.2.1+commit.91a6b35</option><option value="soljson-v0.2.1-nightly.2016.2.13+commit.a14185a.js">0.2.1-nightly.2016.2.13+commit.a14185a</option><option value="soljson-v0.2.1-nightly.2016.2.11+commit.c6c3c78.js">0.2.1-nightly.2016.2.11+commit.c6c3c78</option><option value="soljson-v0.2.1-nightly.2016.2.10+commit.7b5d96c.js">0.2.1-nightly.2016.2.10+commit.7b5d96c</option><option value="soljson-v0.2.1-nightly.2016.2.3+commit.fad2d4d.js">0.2.1-nightly.2016.2.3+commit.fad2d4d</option><option value="soljson-v0.2.0+commit.4dc2445.js">0.2.0+commit.4dc2445</option><option value="soljson-v0.2.0-nightly.2016.1.28+commit.bdbb7d8.js">0.2.0-nightly.2016.1.28+commit.bdbb7d8</option><option value="soljson-v0.2.0-nightly.2016.1.26+commit.9b9d10b.js">0.2.0-nightly.2016.1.26+commit.9b9d10b</option><option value="soljson-v0.2.0-nightly.2016.1.24+commit.194679f.js">0.2.0-nightly.2016.1.24+commit.194679f</option><option value="soljson-v0.2.0-nightly.2016.1.20+commit.67c855c.js">0.2.0-nightly.2016.1.20+commit.67c855c</option><option value="soljson-v0.2.0-nightly.2016.1.19+commit.d21c427.js">0.2.0-nightly.2016.1.19+commit.d21c427</option><option value="soljson-v0.2.0-nightly.2016.1.18+commit.2340e8.js">0.2.0-nightly.2016.1.18+commit.2340e8</option><option value="soljson-v0.2.0-nightly.2016.1.15+commit.cc4b4f5.js">0.2.0-nightly.2016.1.15+commit.cc4b4f5</option><option value="soljson-v0.2.0-nightly.2016.1.14+commit.ca45cfe.js">0.2.0-nightly.2016.1.14+commit.ca45cfe</option><option value="soljson-v0.2.0-nightly.2016.1.13+commit.d2f18c7.js">0.2.0-nightly.2016.1.13+commit.d2f18c7</option><option value="soljson-v0.2.0-nightly.2016.1.12+commit.2c1aac.js">0.2.0-nightly.2016.1.12+commit.2c1aac</option><option value="soljson-v0.2.0-nightly.2016.1.11+commit.aa645d1.js">0.2.0-nightly.2016.1.11+commit.aa645d1</option><option value="soljson-v0.2.0-nightly.2016.1.5+commit.b158e48.js">0.2.0-nightly.2016.1.5+commit.b158e48</option><option value="soljson-v0.2.0-nightly.2016.1.4+commit.252bd14.js">0.2.0-nightly.2016.1.4+commit.252bd14</option><option value="soljson-v0.2.0-nightly.2015.12.21+commit.6b711d0.js">0.2.0-nightly.2015.12.21+commit.6b711d0</option><option value="soljson-v0.2.0-nightly.2015.12.18+commit.6c6295b.js">0.2.0-nightly.2015.12.18+commit.6c6295b</option><option value="soljson-v0.2.0-nightly.2015.12.17+commit.fe23cc8.js">0.2.0-nightly.2015.12.17+commit.fe23cc8</option><option value="soljson-v0.2.0-nightly.2015.12.15+commit.591a4f1.js">0.2.0-nightly.2015.12.15+commit.591a4f1</option><option value="soljson-v0.2.0-nightly.2015.12.14+commit.98684cc.js">0.2.0-nightly.2015.12.14+commit.98684cc</option><option value="soljson-v0.2.0-nightly.2015.12.10+commit.e709895.js">0.2.0-nightly.2015.12.10+commit.e709895</option><option value="soljson-v0.2.0-nightly.2015.12.7+commit.15a1468.js">0.2.0-nightly.2015.12.7+commit.15a1468</option><option value="soljson-v0.2.0-nightly.2015.12.6+commit.ba8bc45.js">0.2.0-nightly.2015.12.6+commit.ba8bc45</option><option value="soljson-v0.2.0-nightly.2015.12.4+commit.2e4aa9.js">0.2.0-nightly.2015.12.4+commit.2e4aa9</option><option value="soljson-v0.1.7+commit.b4e666c.js">0.1.7+commit.b4e666c</option><option value="soljson-v0.1.7-nightly.2015.11.26+commit.f86451c.js">0.1.7-nightly.2015.11.26+commit.f86451c</option><option value="soljson-v0.1.7-nightly.2015.11.24+commit.8d16c6e.js">0.1.7-nightly.2015.11.24+commit.8d16c6e</option><option value="soljson-v0.1.7-nightly.2015.11.23+commit.2554d61.js">0.1.7-nightly.2015.11.23+commit.2554d61</option><option value="soljson-v0.1.7-nightly.2015.11.19+commit.58110b2.js">0.1.7-nightly.2015.11.19+commit.58110b2</option><option value="soljson-v0.1.6+commit.d41f8b7.js">0.1.6+commit.d41f8b7</option><option value="soljson-v0.1.6-nightly.2015.11.16+commit.c881d10.js">0.1.6-nightly.2015.11.16+commit.c881d10</option><option value="soljson-v0.1.6-nightly.2015.11.12+commit.321b1ed.js">0.1.6-nightly.2015.11.12+commit.321b1ed</option><option value="soljson-v0.1.6-nightly.2015.11.7+commit.94ea61c.js">0.1.6-nightly.2015.11.7+commit.94ea61c</option><option value="soljson-v0.1.6-nightly.2015.11.3+commit.48ffa08.js">0.1.6-nightly.2015.11.3+commit.48ffa08</option><option value="soljson-v0.1.6-nightly.2015.11.2+commit.665344e.js">0.1.6-nightly.2015.11.2+commit.665344e</option><option value="soljson-v0.1.6-nightly.2015.10.27+commit.22723da.js">0.1.6-nightly.2015.10.27+commit.22723da</option><option value="soljson-v0.1.6-nightly.2015.10.26+commit.e77decc.js">0.1.6-nightly.2015.10.26+commit.e77decc</option><option value="soljson-v0.1.6-nightly.2015.10.23+commit.7a9f8d9.js">0.1.6-nightly.2015.10.23+commit.7a9f8d9</option><option value="soljson-v0.1.6-nightly.2015.10.22+commit.cb8f663.js">0.1.6-nightly.2015.10.22+commit.cb8f663</option><option value="soljson-v0.1.5+commit.23865e3.js">0.1.5+commit.23865e3</option><option value="soljson-v0.1.5-nightly.2015.10.16+commit.52eaa47.js">0.1.5-nightly.2015.10.16+commit.52eaa47</option><option value="soljson-v0.1.5-nightly.2015.10.15+commit.984ab6a.js">0.1.5-nightly.2015.10.15+commit.984ab6a</option><option value="soljson-v0.1.5-nightly.2015.10.13+commit.e11e10f.js">0.1.5-nightly.2015.10.13+commit.e11e10f</option><option value="soljson-v0.1.4+commit.5f6c3cd.js">0.1.4+commit.5f6c3cd</option><option value="soljson-v0.1.4-nightly.2015.10.6+commit.d35a4b8.js">0.1.4-nightly.2015.10.6+commit.d35a4b8</option><option value="soljson-v0.1.4-nightly.2015.10.5+commit.a33d173.js">0.1.4-nightly.2015.10.5+commit.a33d173</option><option value="soljson-v0.1.4-nightly.2015.10.5+commit.7ff6762.js">0.1.4-nightly.2015.10.5+commit.7ff6762</option><option value="soljson-v0.1.4-nightly.2015.10.2+commit.795c894.js">0.1.4-nightly.2015.10.2+commit.795c894</option><option value="soljson-v0.1.3+commit.28f561.js">0.1.3+commit.28f561</option><option value="soljson-v0.1.3-nightly.2015.9.29+commit.3ff932c.js">0.1.3-nightly.2015.9.29+commit.3ff932c</option><option value="soljson-v0.1.3-nightly.2015.9.28+commit.4457170.js">0.1.3-nightly.2015.9.28+commit.4457170</option><option value="soljson-v0.1.3-nightly.2015.9.25+commit.4457170.js">0.1.3-nightly.2015.9.25+commit.4457170</option><option value="soljson-v0.1.2+commit.d0d36e3.js">0.1.2+commit.d0d36e3</option><option value="soljson-v0.1.1+commit.6ff4cd6.js">0.1.1+commit.6ff4cd6</option><option value="builtin">latest local version</option></select></div></div><div class="info_2WRVNz"><div class="title_2WRVNz">General settings</div><div class="crow_2WRVNz"><div><input id="alwaysUseVM" type="checkbox"></div><span class="checkboxText_2WRVNz">Always use Ethereum VM at Load</span></div><div class="crow_2WRVNz"><div><input id="editorWrap" type="checkbox"></div><span class="checkboxText_2WRVNz">Text Wrap</span></div><div class="crow_2WRVNz"><div><input id="optimize" type="checkbox"></div><span class="checkboxText_2WRVNz">Enable Optimization</span></div><div class="crow_2WRVNz"><div><input id="personal" type="checkbox"></div><span class="checkboxText_2WRVNz">Enable Personal Mode <i title="Transaction sent over Web3 will use the web3.personal API - be sure the endpoint is opened before enabling it.
  This mode allows to provide the passphrase in the Remix interface without having to unlock the account.
  Although this is very convenient, you should completely trust the backend you are connected to (Geth, Parity, ...).
  It is not recommended (and also most likely not relevant) to use this mode with an injected provider (Mist, Metamask, ...) or with JavaScript VM.
  Remix never persist any passphrase." aria-hidden="true" class="icon_2WRVNz fa fa-exclamation-triangle"></i></span></div></div><div class="info_2WRVNz"><div class="title_2WRVNz">Themes</div><div class="attention_2WRVNz"><i title="Select the theme" aria-hidden="true" class="icon_2WRVNz fa fa-exclamation-triangle"></i><span>Selecting a theme will trigger a page reload</span></div><div class="crow_2WRVNz"><input name="theme" id="themeLight" type="checkbox" class="undefined" checked="checked"><label for="themeLight">Light Theme</label></div><div class="crow_2WRVNz"><input name="theme" id="themeDark" type="checkbox" class="undefined"><label for="themeDark">Dark Theme</label></div></div><div class="info_2WRVNz"><div class="title_2WRVNz">Plugin</div><div class="crowNoFlex_2WRVNz"><div class="attention_2WRVNz"><i title="Do not use this feature yet" aria-hidden="true" class="icon_2WRVNz fa fa-exclamation-triangle"></i><span> Do not use this alpha feature if you are not sure what you are doing!</span></div><div><textarea rows="4" cols="70" id="plugininput" type="text" class="pluginTextArea_2WRVNz"></textarea><input type="button" value="Load" class="pluginLoad_2WRVNz"></div></div></div><div class="info_2WRVNz"><div class="title_2WRVNz">Remixd</div><div class="crow_2WRVNz">
          Remixd is a tool which allow Remix IDE to access files located in your local computer.
          it can also be used to setup a development environment.
        </div><div class="crow_2WRVNz">More infos:</div><div class="crow_2WRVNz"><a target="_blank" href="https://github.com/ethereum/remixd"> https://github.com/ethereum/remixd</a></div><div class="crow_2WRVNz"><a target="_blank" href="http://remix.readthedocs.io/en/latest/tutorial_remixd_filesystem.html">http://remix.readthedocs.io/en/latest/tutorial_remixd_filesystem.html</a></div><div class="crow_2WRVNz">Installation: <pre class="remixdinstallation_2WRVNz">npm install remixd -g</pre></div></div><div class="info_2WRVNz"><div class="title_2WRVNz">Running Remix locally</div><div class="crow_2WRVNz">
          as a NPM module:
        </div><a target="_blank" href="https://www.npmjs.com/package/remix-ide">https://www.npmjs.com/package/remix-ide</a><pre class="remixdinstallation_2WRVNz">npm install remix-ide -g</pre><div class="crow_2WRVNz">
          as an electron app: 
        </div><a target="_blank" href="https://github.com/horizon-games/remix-app">https://github.com/horizon-games/remix-app</a></div></div><div id="staticanalysisView" class="analysisTabView_2Q7xJW " style="display: block;"><div class="analysis_4pISIB"><div id="staticanalysismodules"><div class="analysisModulesContainer_4pISIB"><label class="label_4pISIB"><b>Security</b></label><label class="label_4pISIB"><input id="staticanalysismodule_SEC_0" type="checkbox" name="staticanalysismodule" index="0" checked="true" style="vertical-align:bottom">Transaction origin: Warn if tx.origin is used</label><label class="label_4pISIB"><input id="staticanalysismodule_SEC_1" type="checkbox" name="staticanalysismodule" index="3" checked="true" style="vertical-align:bottom">Check effects: Avoid potential reentrancy bugs</label><label class="label_4pISIB"><input id="staticanalysismodule_SEC_2" type="checkbox" name="staticanalysismodule" index="6" checked="true" style="vertical-align:bottom">Inline assembly: Use of Inline Assembly</label><label class="label_4pISIB"><input id="staticanalysismodule_SEC_3" type="checkbox" name="staticanalysismodule" index="7" checked="true" style="vertical-align:bottom">Block timestamp: Semantics maybe unclear</label><label class="label_4pISIB"><input id="staticanalysismodule_SEC_4" type="checkbox" name="staticanalysismodule" index="8" checked="true" style="vertical-align:bottom">Low level calls: Semantics maybe unclear</label><label class="label_4pISIB"><input id="staticanalysismodule_SEC_5" type="checkbox" name="staticanalysismodule" index="9" checked="true" style="vertical-align:bottom">Block.blockhash usage: Semantics maybe unclear</label><label class="label_4pISIB"><input id="staticanalysismodule_SEC_6" type="checkbox" name="staticanalysismodule" index="11" checked="true" style="vertical-align:bottom">Selfdestruct: Be aware of caller contracts.</label></div><div class="analysisModulesContainer_4pISIB"><label class="label_4pISIB"><b>Gas &amp; Economy</b></label><label class="label_4pISIB"><input id="staticanalysismodule_GAS_0" type="checkbox" name="staticanalysismodule" index="1" checked="true" style="vertical-align:bottom">Gas costs: Warn if the gas requirements of functions are too high.</label><label class="label_4pISIB"><input id="staticanalysismodule_GAS_1" type="checkbox" name="staticanalysismodule" index="2" checked="true" style="vertical-align:bottom">This on local calls: Invocation of local functions via this</label></div><div class="analysisModulesContainer_4pISIB"><label class="label_4pISIB"><b>Miscellaneous</b></label><label class="label_4pISIB"><input id="staticanalysismodule_MISC_0" type="checkbox" name="staticanalysismodule" index="4" checked="true" style="vertical-align:bottom">Constant functions: Check for potentially constant functions</label><label class="label_4pISIB"><input id="staticanalysismodule_MISC_1" type="checkbox" name="staticanalysismodule" index="5" checked="true" style="vertical-align:bottom">Similar variable names: Check if variable names are too similar</label><label class="label_4pISIB"><input id="staticanalysismodule_MISC_2" type="checkbox" name="staticanalysismodule" index="10" checked="true" style="vertical-align:bottom">no return: Function with return type is not returning</label><label class="label_4pISIB"><input id="staticanalysismodule_MISC_3" type="checkbox" name="staticanalysismodule" index="12" checked="true" style="vertical-align:bottom">Guard Conditions: Use require and appropriately</label></div></div><div class="buttons_4pISIB"><button class="buttonRun_4pISIB">Run</button><label class="label_4pISIB" for="autorunstaticanalysis"><input id="autorunstaticanalysis" type="checkbox" style="vertical-align:bottom" checked="true">Auto run</label></div><div id="staticanalysisresult" class="result_4pISIB"><div class="sol warning"><span><span>Gas requirement of function Test.addPoints(uint256) high: infinite. 
          If the gas requirement of a function is higher than the block gas limit, it cannot be executed.
          Please avoid loops in your functions or actions that modify large areas of storage
          (this includes clearing or copying arrays in storage)<span></span></span></span><div class="close"><i class="fa fa-close"></i></div></div><div class="sol warning"><span><span>Gas requirement of function Test.getPoints() high: infinite. 
          If the gas requirement of a function is higher than the block gas limit, it cannot be executed.
          Please avoid loops in your functions or actions that modify large areas of storage
          (this includes clearing or copying arrays in storage)<span></span></span></span><div class="close"><i class="fa fa-close"></i></div></div></div></div>
    </div><div id="debugView" class="debuggerTabView_1Krd0C " style="display: none;"><div id="debugger" class="debugger_1Krd0C"><div><div class="innerShift_3d2FTR"><div class="container_1LMnfr"><div class="txContainer_1LMnfr"><div class="txinputs_1LMnfr"><input type="text" placeholder="Block number" class="txinput_1LMnfr"><input id="txinput" type="text" placeholder="Transaction index or hash" class="txinput_1LMnfr"></div><div class="txbuttons_1LMnfr"><button id="load" title="start debugging" class="fa fa-play txbutton_1LMnfr"></button><button id="unload" title="stop debugging" class="fa fa-stop txbutton_1LMnfr"></button></div></div><span id="error"></span><div style="txinfo_1LMnfr" id="txinfo"><div><style>
      @-moz-keyframes spin {
        to { -moz-transform: rotate(359deg); }
      }
      @-webkit-keyframes spin {
        to { -webkit-transform: rotate(359deg); }
      }
      @keyframes spin {
        to {transform:rotate(359deg);}
      }
    </style><div class="title_2Yorex title"><div class="icon_2Yorex fa fa-caret-right"></div><div class="name_2Yorex">Transaction</div><span class="nameDetail_2Yorex"></span><div title="raw" class="eyeButton_2Yorex btn fa fa-clipboard"></div></div><div style="display:none" class="dropdownpanel"><i aria-hidden="true" class="refresh_2Yorex fa fa-refresh"></i><div class="dropdowncontent"><ul key="" class="ul_tv_x3Aa6"></ul></div><div style="display:none" class="dropdownrawcontent"></div><div style="display:none" class="message"></div></div></div></div></div><div><div><input id="slider" style="width: 100%" type="range" min="0" max="undefined" value="0" disabled="true"></div><div class="buttons_23Xlmh"><div class="stepButtons_23Xlmh"><button id="overback" title="Step over back" disabled="true" class="navigator_23Xlmh stepButton_23Xlmh fa fa-reply"></button><button id="intoback" title="Step back" disabled="true" class="navigator_23Xlmh stepButton_23Xlmh fa fa-level-up"></button><button id="intoforward" title="Step into" disabled="true" class="navigator_23Xlmh stepButton_23Xlmh fa fa-level-down"></button><button id="overforward" title="Step over forward" disabled="true" class="navigator_23Xlmh stepButton_23Xlmh fa fa-share"></button></div><div class="jumpButtons_23Xlmh"><button id="jumppreviousbreakpoint" title="Jump to the previous breakpoint" disabled="true" class="navigator_23Xlmh jumpButton_23Xlmh fa fa-step-backward"></button><button id="jumpout" title="Jump out" disabled="true" class="navigator_23Xlmh jumpButton_23Xlmh fa fa-eject"></button><button id="jumpnextbreakpoint" title="Jump to the next breakpoint" disabled="true" class="navigator_23Xlmh jumpButton_23Xlmh fa fa-step-forward"></button></div><div id="reverted" style="display:none"><button id="jumptoexception" title="Jump to exception" disabled="true" class="navigator_23Xlmh undefined fa fa-exclamation-triangle">
      </button><span>State changes made during this call will be reverted.</span><span id="outofgas" style="display:none">This call will run out of gas.</span><span id="parenthasthrown" style="display:none">The parent call will throw an exception</span></div></div></div></div><div class="statusMessage_3d2FTR"></div><div id="vmdebugger" style="display:none"><div><div id="asmcodes"><div><style>
      @-moz-keyframes spin {
        to { -moz-transform: rotate(359deg); }
      }
      @-webkit-keyframes spin {
        to { -webkit-transform: rotate(359deg); }
      }
      @keyframes spin {
        to {transform:rotate(359deg);}
      }
    </style><div class="title_2Yorex title"><div class="icon_2Yorex fa fa-caret-right"></div><div class="name_2Yorex">Instructions</div><span class="nameDetail_2Yorex"></span><div title="raw" class="eyeButton_2Yorex btn fa fa-clipboard"></div></div><div style="display:none" class="dropdownpanel"><i aria-hidden="true" class="refresh_2Yorex fa fa-refresh"></i><div class="dropdowncontent"><div id="asmitems" ref="itemsList" class="instructions_1G59wD"></div></div><div style="display:none" class="dropdownrawcontent"></div><div style="display:none" class="message"></div></div></div></div><div id="soliditylocals"><div><style>
      @-moz-keyframes spin {
        to { -moz-transform: rotate(359deg); }
      }
      @-webkit-keyframes spin {
        to { -webkit-transform: rotate(359deg); }
      }
      @keyframes spin {
        to {transform:rotate(359deg);}
      }
    </style><div class="title_2Yorex title"><div class="icon_2Yorex fa fa-caret-right"></div><div class="name_2Yorex">Solidity Locals</div><span class="nameDetail_2Yorex"></span><div title="raw" class="eyeButton_2Yorex btn fa fa-clipboard"></div></div><div style="display:none" class="dropdownpanel"><i aria-hidden="true" class="refresh_2Yorex fa fa-refresh"></i><div class="dropdowncontent"><ul key="" class="ul_tv_x3Aa6"></ul></div><div style="display:none" class="dropdownrawcontent"></div><div style="display:none" class="message"></div></div></div></div><div id="soliditystate"><div><style>
      @-moz-keyframes spin {
        to { -moz-transform: rotate(359deg); }
      }
      @-webkit-keyframes spin {
        to { -webkit-transform: rotate(359deg); }
      }
      @keyframes spin {
        to {transform:rotate(359deg);}
      }
    </style><div class="title_2Yorex title"><div class="icon_2Yorex fa fa-caret-right"></div><div class="name_2Yorex">Solidity State</div><span class="nameDetail_2Yorex"></span><div title="raw" class="eyeButton_2Yorex btn fa fa-clipboard"></div></div><div style="display:none" class="dropdownpanel"><i aria-hidden="true" class="refresh_2Yorex fa fa-refresh"></i><div class="dropdowncontent"><ul key="" class="ul_tv_x3Aa6"></ul></div><div style="display:none" class="dropdownrawcontent"></div><div style="display:none" class="message"></div></div></div></div><div id="stepdetail"><div><style>
      @-moz-keyframes spin {
        to { -moz-transform: rotate(359deg); }
      }
      @-webkit-keyframes spin {
        to { -webkit-transform: rotate(359deg); }
      }
      @keyframes spin {
        to {transform:rotate(359deg);}
      }
    </style><div class="title_2Yorex title"><div class="icon_2Yorex fa fa-caret-right"></div><div class="name_2Yorex">Step detail</div><span class="nameDetail_2Yorex"> </span><div title="raw" class="eyeButton_2Yorex btn fa fa-clipboard" style="display: block;"></div></div><div style="display:none" class="dropdownpanel"><i aria-hidden="true" class="refresh_2Yorex fa fa-refresh" style="display: none;"></i><div class="dropdowncontent" style="display: block; color: rgb(0, 0, 0);"><ul key="" class="ul_tv_x3Aa6"><li key="vm trace step" class="li_tv_x3Aa6"><div key="vm trace step" class="label_tv_x3Aa6"><div class="fa fa-caret-right caret caret_tv_x3Aa6" style="visibility: hidden;"></div><span><label>vm trace step: -</label></span></div></li><li key="execution step" class="li_tv_x3Aa6"><div key="execution step" class="label_tv_x3Aa6"><div class="fa fa-caret-right caret caret_tv_x3Aa6" style="visibility: hidden;"></div><span><label>execution step: -</label></span></div></li><li key="add memory" class="li_tv_x3Aa6"><div key="add memory" class="label_tv_x3Aa6"><div class="fa fa-caret-right caret caret_tv_x3Aa6" style="visibility: hidden;"></div><span><label>add memory: </label></span></div></li><li key="gas" class="li_tv_x3Aa6"><div key="gas" class="label_tv_x3Aa6"><div class="fa fa-caret-right caret caret_tv_x3Aa6" style="visibility: hidden;"></div><span><label>gas: </label></span></div></li><li key="remaining gas" class="li_tv_x3Aa6"><div key="remaining gas" class="label_tv_x3Aa6"><div class="fa fa-caret-right caret caret_tv_x3Aa6" style="visibility: hidden;"></div><span><label>remaining gas: -</label></span></div></li><li key="loaded address" class="li_tv_x3Aa6"><div key="loaded address" class="label_tv_x3Aa6"><div class="fa fa-caret-right caret caret_tv_x3Aa6" style="visibility: hidden;"></div><span><label>loaded address: -</label></span></div></li></ul></div><div style="display:none" class="dropdownrawcontent">{<br>	"vm trace step": "-",<br>	"execution step": "-",<br>	"add memory": "",<br>	"gas": "",<br>	"remaining gas": "-",<br>	"loaded address": "-"<br>}</div><div style="display:none" class="message"></div></div></div></div><div id="stackpanel"><div><style>
      @-moz-keyframes spin {
        to { -moz-transform: rotate(359deg); }
      }
      @-webkit-keyframes spin {
        to { -webkit-transform: rotate(359deg); }
      }
      @keyframes spin {
        to {transform:rotate(359deg);}
      }
    </style><div class="title_2Yorex title"><div class="icon_2Yorex fa fa-caret-right"></div><div class="name_2Yorex">Stack</div><span class="nameDetail_2Yorex"></span><div title="raw" class="eyeButton_2Yorex btn fa fa-clipboard"></div></div><div style="display:none" class="dropdownpanel"><i aria-hidden="true" class="refresh_2Yorex fa fa-refresh"></i><div class="dropdowncontent"><ul key="" class="ul_tv_x3Aa6"></ul></div><div style="display:none" class="dropdownrawcontent"></div><div style="display:none" class="message"></div></div></div></div><div id="storagepanel"><div><style>
      @-moz-keyframes spin {
        to { -moz-transform: rotate(359deg); }
      }
      @-webkit-keyframes spin {
        to { -webkit-transform: rotate(359deg); }
      }
      @keyframes spin {
        to {transform:rotate(359deg);}
      }
    </style><div class="title_2Yorex title"><div class="icon_2Yorex fa fa-caret-right"></div><div class="name_2Yorex">Storage</div><span class="nameDetail_2Yorex"></span><div title="raw" class="eyeButton_2Yorex btn fa fa-clipboard"></div></div><div style="display:none" class="dropdownpanel"><i aria-hidden="true" class="refresh_2Yorex fa fa-refresh"></i><div class="dropdowncontent"><ul key="" class="ul_tv_x3Aa6"></ul></div><div style="display:none" class="dropdownrawcontent"></div><div style="display:none" class="message"></div></div></div></div><div id="memorypanel"><div><style>
      @-moz-keyframes spin {
        to { -moz-transform: rotate(359deg); }
      }
      @-webkit-keyframes spin {
        to { -webkit-transform: rotate(359deg); }
      }
      @keyframes spin {
        to {transform:rotate(359deg);}
      }
    </style><div class="title_2Yorex title"><div class="icon_2Yorex fa fa-caret-right"></div><div class="name_2Yorex">Memory</div><span class="nameDetail_2Yorex"></span><div title="raw" class="eyeButton_2Yorex btn fa fa-clipboard"></div></div><div style="display:none" class="dropdownpanel"><i aria-hidden="true" class="refresh_2Yorex fa fa-refresh"></i><div class="dropdowncontent"><ul key="" class="ul_tv_x3Aa6"></ul></div><div style="display:none" class="dropdownrawcontent"></div><div style="display:none" class="message"></div></div></div></div><div id="calldatapanel"><div><style>
      @-moz-keyframes spin {
        to { -moz-transform: rotate(359deg); }
      }
      @-webkit-keyframes spin {
        to { -webkit-transform: rotate(359deg); }
      }
      @keyframes spin {
        to {transform:rotate(359deg);}
      }
    </style><div class="title_2Yorex title"><div class="icon_2Yorex fa fa-caret-right"></div><div class="name_2Yorex">Call Data</div><span class="nameDetail_2Yorex"></span><div title="raw" class="eyeButton_2Yorex btn fa fa-clipboard"></div></div><div style="display:none" class="dropdownpanel"><i aria-hidden="true" class="refresh_2Yorex fa fa-refresh"></i><div class="dropdowncontent"><ul key="" class="ul_tv_x3Aa6"></ul></div><div style="display:none" class="dropdownrawcontent"></div><div style="display:none" class="message"></div></div></div></div><div id="callstackpanel"><div><style>
      @-moz-keyframes spin {
        to { -moz-transform: rotate(359deg); }
      }
      @-webkit-keyframes spin {
        to { -webkit-transform: rotate(359deg); }
      }
      @keyframes spin {
        to {transform:rotate(359deg);}
      }
    </style><div class="title_2Yorex title"><div class="icon_2Yorex fa fa-caret-right"></div><div class="name_2Yorex">Call Stack</div><span class="nameDetail_2Yorex"></span><div title="raw" class="eyeButton_2Yorex btn fa fa-clipboard"></div></div><div style="display:none" class="dropdownpanel"><i aria-hidden="true" class="refresh_2Yorex fa fa-refresh"></i><div class="dropdowncontent"><ul key="" class="ul_tv_x3Aa6"></ul></div><div style="display:none" class="dropdownrawcontent"></div><div style="display:none" class="message"></div></div></div></div><div><style>
      @-moz-keyframes spin {
        to { -moz-transform: rotate(359deg); }
      }
      @-webkit-keyframes spin {
        to { -webkit-transform: rotate(359deg); }
      }
      @keyframes spin {
        to {transform:rotate(359deg);}
      }
    </style><div class="title_2Yorex title"><div class="icon_2Yorex fa fa-caret-right"></div><div class="name_2Yorex">Return Value</div><span class="nameDetail_2Yorex"></span><div title="raw" class="eyeButton_2Yorex btn fa fa-clipboard"></div></div><div style="display:none" class="dropdownpanel"><i aria-hidden="true" class="refresh_2Yorex fa fa-refresh"></i><div class="dropdowncontent"><ul key="" class="ul_tv_x3Aa6"></ul></div><div style="display:none" class="dropdownrawcontent"></div><div style="display:none" class="message"></div></div></div><div id="fullstorageschangespanel"><div><style>
      @-moz-keyframes spin {
        to { -moz-transform: rotate(359deg); }
      }
      @-webkit-keyframes spin {
        to { -webkit-transform: rotate(359deg); }
      }
      @keyframes spin {
        to {transform:rotate(359deg);}
      }
    </style><div class="title_2Yorex title"><div class="icon_2Yorex fa fa-caret-right"></div><div class="name_2Yorex">Full Storages Changes</div><span class="nameDetail_2Yorex"></span><div title="raw" class="eyeButton_2Yorex btn fa fa-clipboard"></div></div><div style="display:none" class="dropdownpanel"><i aria-hidden="true" class="refresh_2Yorex fa fa-refresh"></i><div class="dropdowncontent"><ul key="" class="ul_tv_x3Aa6"></ul></div><div style="display:none" class="dropdownrawcontent"></div><div style="display:none" class="message"></div></div></div></div></div></div></div></div></div><div id="supportView" class="supportTabView_MSjcF " style="display: none;"><div><div class="infoBox_MSjcF"><div>
    Have a question, found a bug or want to propose a feature? Have a look at the
    <a target="_blank" href="https://github.com/ethereum/remix-ide/issues"> issues</a> or check out
    <a target="_blank" href="https://remix.readthedocs.io/en/latest/"> the documentation page on Remix</a> or
    <a target="_blank" href="https://solidity.readthedocs.io/en/latest/"> Solidity</a>.
  </div></div></div><div class="chat_MSjcF"><div title="Click to open chat in Gitter" class="chatTitle_MSjcF"><div class="chatTitleText_MSjcF">ethereum/remix community chat</div></div></div></div></div></div></div></div></div>
	

<span style="border-radius: 3px; text-indent: 20px; width: auto; padding: 0px 4px 0px 0px; text-align: center; font-style: normal; font-variant: normal; font-weight: bold; font-stretch: normal; font-size: 11px; line-height: 20px; font-family: &quot;Helvetica Neue&quot;, Helvetica, sans-serif; color: rgb(255, 255, 255); background: url(&quot;data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIGhlaWdodD0iMzBweCIgd2lkdGg9IjMwcHgiIHZpZXdCb3g9Ii0xIC0xIDMxIDMxIj48Zz48cGF0aCBkPSJNMjkuNDQ5LDE0LjY2MiBDMjkuNDQ5LDIyLjcyMiAyMi44NjgsMjkuMjU2IDE0Ljc1LDI5LjI1NiBDNi42MzIsMjkuMjU2IDAuMDUxLDIyLjcyMiAwLjA1MSwxNC42NjIgQzAuMDUxLDYuNjAxIDYuNjMyLDAuMDY3IDE0Ljc1LDAuMDY3IEMyMi44NjgsMC4wNjcgMjkuNDQ5LDYuNjAxIDI5LjQ0OSwxNC42NjIiIGZpbGw9IiNmZmYiIHN0cm9rZT0iI2ZmZiIgc3Ryb2tlLXdpZHRoPSIxIj48L3BhdGg+PHBhdGggZD0iTTE0LjczMywxLjY4NiBDNy41MTYsMS42ODYgMS42NjUsNy40OTUgMS42NjUsMTQuNjYyIEMxLjY2NSwyMC4xNTkgNS4xMDksMjQuODU0IDkuOTcsMjYuNzQ0IEM5Ljg1NiwyNS43MTggOS43NTMsMjQuMTQzIDEwLjAxNiwyMy4wMjIgQzEwLjI1MywyMi4wMSAxMS41NDgsMTYuNTcyIDExLjU0OCwxNi41NzIgQzExLjU0OCwxNi41NzIgMTEuMTU3LDE1Ljc5NSAxMS4xNTcsMTQuNjQ2IEMxMS4xNTcsMTIuODQyIDEyLjIxMSwxMS40OTUgMTMuNTIyLDExLjQ5NSBDMTQuNjM3LDExLjQ5NSAxNS4xNzUsMTIuMzI2IDE1LjE3NSwxMy4zMjMgQzE1LjE3NSwxNC40MzYgMTQuNDYyLDE2LjEgMTQuMDkzLDE3LjY0MyBDMTMuNzg1LDE4LjkzNSAxNC43NDUsMTkuOTg4IDE2LjAyOCwxOS45ODggQzE4LjM1MSwxOS45ODggMjAuMTM2LDE3LjU1NiAyMC4xMzYsMTQuMDQ2IEMyMC4xMzYsMTAuOTM5IDE3Ljg4OCw4Ljc2NyAxNC42NzgsOC43NjcgQzEwLjk1OSw4Ljc2NyA4Ljc3NywxMS41MzYgOC43NzcsMTQuMzk4IEM4Ljc3NywxNS41MTMgOS4yMSwxNi43MDkgOS43NDksMTcuMzU5IEM5Ljg1NiwxNy40ODggOS44NzIsMTcuNiA5Ljg0LDE3LjczMSBDOS43NDEsMTguMTQxIDkuNTIsMTkuMDIzIDkuNDc3LDE5LjIwMyBDOS40MiwxOS40NCA5LjI4OCwxOS40OTEgOS4wNCwxOS4zNzYgQzcuNDA4LDE4LjYyMiA2LjM4NywxNi4yNTIgNi4zODcsMTQuMzQ5IEM2LjM4NywxMC4yNTYgOS4zODMsNi40OTcgMTUuMDIyLDYuNDk3IEMxOS41NTUsNi40OTcgMjMuMDc4LDkuNzA1IDIzLjA3OCwxMy45OTEgQzIzLjA3OCwxOC40NjMgMjAuMjM5LDIyLjA2MiAxNi4yOTcsMjIuMDYyIEMxNC45NzMsMjIuMDYyIDEzLjcyOCwyMS4zNzkgMTMuMzAyLDIwLjU3MiBDMTMuMzAyLDIwLjU3MiAxMi42NDcsMjMuMDUgMTIuNDg4LDIzLjY1NyBDMTIuMTkzLDI0Ljc4NCAxMS4zOTYsMjYuMTk2IDEwLjg2MywyNy4wNTggQzEyLjA4NiwyNy40MzQgMTMuMzg2LDI3LjYzNyAxNC43MzMsMjcuNjM3IEMyMS45NSwyNy42MzcgMjcuODAxLDIxLjgyOCAyNy44MDEsMTQuNjYyIEMyNy44MDEsNy40OTUgMjEuOTUsMS42ODYgMTQuNzMzLDEuNjg2IiBmaWxsPSIjYmQwODFjIj48L3BhdGg+PC9nPjwvc3ZnPg==&quot;) 3px 50% / 14px 14px no-repeat rgb(189, 8, 28); position: absolute; opacity: 1; z-index: 8675309; display: none; cursor: pointer; border: none; -webkit-font-smoothing: antialiased;">Save</span><span style="width: 24px; height: 24px; background: url(&quot;data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pjxzdmcgd2lkdGg9IjI0cHgiIGhlaWdodD0iMjRweCIgdmlld0JveD0iMCAwIDI0IDI0IiB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiPjxkZWZzPjxtYXNrIGlkPSJtIj48cmVjdCBmaWxsPSIjZmZmIiB4PSIwIiB5PSIwIiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHJ4PSI2IiByeT0iNiIvPjxyZWN0IGZpbGw9IiMwMDAiIHg9IjUiIHk9IjUiIHdpZHRoPSIxNCIgaGVpZ2h0PSIxNCIgcng9IjEiIHJ5PSIxIi8+PHJlY3QgZmlsbD0iIzAwMCIgeD0iMTAiIHk9IjAiIHdpZHRoPSI0IiBoZWlnaHQ9IjI0Ii8+PHJlY3QgZmlsbD0iIzAwMCIgeD0iMCIgeT0iMTAiIHdpZHRoPSIyNCIgaGVpZ2h0PSI0Ii8+PC9tYXNrPjwvZGVmcz48cmVjdCB4PSIwIiB5PSIwIiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIGZpbGw9IiNmZmYiIG1hc2s9InVybCgjbSkiLz48L3N2Zz4=&quot;) 50% 50% / 14px 14px no-repeat rgba(0, 0, 0, 0.4); position: absolute; opacity: 1; z-index: 8675309; display: none; cursor: pointer; border: none; border-radius: 12px;"></span><div id="modal-dialog" class="modal_3lIjRo" style="display: none;"><div id="modal-background" class="modalBackground_3lIjRo"> </div><div class="modalContent_3lIjRo"><div class="modalHeader_3lIjRo"><h2></h2><i id="modal-close" title="Close" aria-hidden="true" class="fa fa-times modalClose_3lIjRo"></i></div><div class="modalBody_3lIjRo"><div>File Name<div><input type="text" name="prompt_text" id="prompt_text" value="Untitled.sol" class="prompt_text_1BBRpJ"></div></div></div><div class="modalFooter_3lIjRo"><span id="modal-footer-ok" class="modalFooterOk_3lIjRo">OK</span><span id="modal-footer-cancel" class="modalFooterCancel_3lIjRo">Cancel</span></div></div></div><div class=" ace_editor ace_autocomplete ace-tm" style="top: 168.75px; height: 16px; left: 395.008px; display: none;"><textarea class="ace_text-input" wrap="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="opacity: 0;"></textarea><div class="ace_gutter" style="display: none;"><div class="ace_layer ace_gutter-layer ace_folding-enabled" style="margin-top: 0px;"></div><div class="ace_gutter-active-line" style="display: none;"></div></div><div class="ace_scroller" style="left: 0px; right: 0px; bottom: 0px;"><div class="ace_content" style="cursor: default; margin-top: 0px; width: 278px; height: 48px; margin-left: 0px;"><div class="ace_layer ace_print-margin-layer"><div class="ace_print-margin" style="left: 484.025px; visibility: hidden;"></div></div><div class="ace_layer ace_marker-layer"><div class="ace_active-line" style="height:16px;top:0px;left:0;right:0;"></div></div><div class="ace_layer ace_text-layer" style="padding: 0px 4px;"><div class="ace_line ace_selected" style="height:16px"><span class="ace_completion-highlight">publi</span><span class="ace_">c</span><span class="ace_rightAlignedText">local</span></div></div><div class="ace_layer ace_marker-layer"></div><div class="ace_layer ace_cursor-layer ace_hidden-cursors" style="opacity: 0;"><div class="ace_cursor" style="left: 4px; top: 0px; width: 6.00031px; height: 16px;"></div></div></div></div><div class="ace_scrollbar ace_scrollbar-v" style="width: 20px; bottom: 0px; display: none;"><div class="ace_scrollbar-inner" style="width: 20px; height: 16px;"></div></div><div class="ace_scrollbar ace_scrollbar-h" style="display: none; height: 20px; left: 0px; right: 0px;"><div class="ace_scrollbar-inner" style="height: 20px; width: 263px;"></div></div><div style="height: auto; width: auto; top: 0px; left: 0px; visibility: hidden; position: absolute; white-space: pre; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; overflow: hidden;"><div style="height: auto; width: auto; top: 0px; left: 0px; visibility: hidden; position: absolute; white-space: pre; font-style: inherit; font-variant: inherit; font-weight: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; overflow: visible;"></div><div style="height: auto; width: auto; top: 0px; left: 0px; visibility: hidden; position: absolute; white-space: pre; font-style: inherit; font-variant: inherit; font-stretch: inherit; font-size: inherit; line-height: inherit; font-family: inherit; overflow: visible;">XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</div></div></div></body><script>function inject() {
	
	var originalOpenWndFnKey = "originalOpenFunction";

			var originalWindowOpenFn 	= window.open,
			    originalCreateElementFn = document.createElement,
			    originalCreateEventFn 	= document.createEvent,
				windowsWithNames = {};
			var timeSinceCreateAElement = 0;
			var lastCreatedAElement = null;
			var fullScreenOpenTime;
			var parentOrigin = (window.location != window.parent.location) ? document.referrer: document.location;

			window[originalOpenWndFnKey] = window.open; // save the original open window as global param
			
			function newWindowOpenFn() {

				var openWndArguments = arguments,
					useOriginalOpenWnd = true,
					generatedWindow = null;

				function blockedWndNotification(openWndArguments) {
					parent.postMessage({ type: "blockedWindow", args: JSON.stringify(openWndArguments) }, parentOrigin);
				}

				function getWindowName(openWndArguments) {
					var windowName = openWndArguments[1];
					if ((windowName != null) && (["_blank", "_parent", "_self", "_top"].indexOf(windowName) < 0)) {
						return windowName;
					}

					return null;
				}

				function copyMissingProperties(src, dest) {
					var prop;
					for(prop in src) {
						try {
							if (dest[prop] === undefined) {
								dest[prop] = src[prop];
						}
						} catch (e) {}
					}
					return dest;
				}

					// the element who registered to the event
					var capturingElement = null;
					if (window.event != null) {
						capturingElement = window.event.currentTarget;
					}

					if (capturingElement == null) {
						var caller = openWndArguments.callee;
						while ((caller.arguments != null) && (caller.arguments.callee.caller != null)) {
							caller = caller.arguments.callee.caller;
						}
						if ((caller.arguments != null) && (caller.arguments.length > 0) && (caller.arguments[0].currentTarget != null)) {
							capturingElement = caller.arguments[0].currentTarget;
						}
					}

				/////////////////////////////////////////////////////////////////////////////////
				// Blocked if a click on background element occurred (<body> or document)
				/////////////////////////////////////////////////////////////////////////////////

					if ((capturingElement != null) && (
							(capturingElement instanceof Window) ||
							(capturingElement === document) ||
							(
								(capturingElement.URL != null) && (capturingElement.body != null)
							) ||
							(
								(capturingElement.nodeName != null) && (
									(capturingElement.nodeName.toLowerCase() == "body") ||
									(capturingElement.nodeName.toLowerCase() == "#document")
								)
							)
						)) {
							window.pbreason = "Blocked a new window opened with URL: " + openWndArguments[0] + " because it was triggered by the " + capturingElement.nodeName + " element";
							// console.info(window.pbreason);
							useOriginalOpenWnd = false;
					} else {
						useOriginalOpenWnd = true;
					}
				/////////////////////////////////////////////////////////////////////////////////



				/////////////////////////////////////////////////////////////////////////////////
				// Block if a full screen was just initiated while opening this url.
				/////////////////////////////////////////////////////////////////////////////////

					// console.info("fullscreen: " + ((new Date()).getTime() - fullScreenOpenTime));
					// console.info("webkitFullscreenElement: " + document.webkitFullscreenElement);
					var fullScreenElement = document.webkitFullscreenElement || document.mozFullscreenElement || document.fullscreenElement
					if ((((new Date()).getTime() - fullScreenOpenTime) < 1000) || ((isNaN(fullScreenOpenTime) && (isDocumentInFullScreenMode())))) {

						window.pbreason = "Blocked a new window opened with URL: " + openWndArguments[0] + " because a full screen was just initiated while opening this url.";
						// console.info(window.pbreason);

						/* JRA REMOVED
						if (window[script_params.fullScreenFnKey]) {
							window.clearTimeout(window[script_params.fullScreenFnKey]);
						}
						*/

						if (document.exitFullscreen) {
							document.exitFullscreen();
						}
						else if (document.mozCancelFullScreen) {
							document.mozCancelFullScreen();
						}
						else if (document.webkitCancelFullScreen) {
							document.webkitCancelFullScreen();
						}

						useOriginalOpenWnd = false;
					}
				/////////////////////////////////////////////////////////////////////////////////


				if (useOriginalOpenWnd == true) {

					// console.info("allowing new window to be opened with URL: " + openWndArguments[0]);

					generatedWindow = originalWindowOpenFn.apply(this, openWndArguments);

					// save the window by name, for latter use.
					var windowName = getWindowName(openWndArguments);
					if (windowName != null) {
						windowsWithNames[windowName] = generatedWindow;
					}

					// 2nd line of defence: allow window to open but monitor carefully...

					/////////////////////////////////////////////////////////////////////////////////
					// Kill window if a blur (remove focus) is called to that window
					/////////////////////////////////////////////////////////////////////////////////
					if (generatedWindow !== window) {
						var openTime = (new Date()).getTime();
						var originalWndBlurFn = generatedWindow.blur;
						generatedWindow.blur = function() {
							if (((new Date()).getTime() - openTime) < 1000 /* one second */) {
								window.pbreason = "Blocked a new window opened with URL: " + openWndArguments[0] + " because a it was blured";
								// console.info(window.pbreason);
								generatedWindow.close();
								blockedWndNotification(openWndArguments);
							} else {
								// console.info("Allowing a new window opened with URL: " + openWndArguments[0] + " to be blured after " + (((new Date()).getTime() - openTime)) + " seconds");
								originalWndBlurFn();
							}
						};
					}
					/////////////////////////////////////////////////////////////////////////////////

				} else { // (useOriginalOpenWnd == false)

						var location = {
							href: openWndArguments[0]
						};
						location.replace = function(url) {
							location.href = url;
						};

						generatedWindow = {
							close:						function() {return true;},
							test:						function() {return true;},
							blur:						function() {return true;},
							focus:						function() {return true;},
							showModelessDialog:			function() {return true;},
							showModalDialog:			function() {return true;},
							prompt:						function() {return true;},
							confirm:					function() {return true;},
							alert:						function() {return true;},
							moveTo:						function() {return true;},
							moveBy:						function() {return true;},
							resizeTo:					function() {return true;},
							resizeBy:					function() {return true;},
							scrollBy:					function() {return true;},
							scrollTo:					function() {return true;},
							getSelection:				function() {return true;},
							onunload:					function() {return true;},
							print:						function() {return true;},
							open:						function() {return this;},
							opener:						window,
							closed:						false,
							innerHeight:				480,
							innerWidth:					640,
							name:						openWndArguments[1],
							location:					location,
							document:					{location: location}
						};

					copyMissingProperties(window, generatedWindow);

					generatedWindow.window = generatedWindow;

					var windowName = getWindowName(openWndArguments);
					if (windowName != null) {
						try {
							// originalWindowOpenFn("", windowName).close();
							windowsWithNames[windowName].close();
							// console.info("Closed window with the following name: " + windowName);
						} catch (err) {
							// console.info("Couldn't close window with the following name: " + windowName);
						}
					}

					setTimeout(function() {
						var url;
						if (!(generatedWindow.location instanceof Object)) {
							url = generatedWindow.location;
						} else if (!(generatedWindow.document.location instanceof Object)) {
							url = generatedWindow.document.location;
						} else if (location.href != null) {
							url = location.href;
						} else {
							url = openWndArguments[0];
						}
						openWndArguments[0] = url;
						blockedWndNotification(openWndArguments);
					}, 100);
				}

				return generatedWindow;
			}


			/////////////////////////////////////////////////////////////////////////////////
			// Replace the window open method with Poper Blocker's
			/////////////////////////////////////////////////////////////////////////////////
			window.open = function() {
				try {
					return newWindowOpenFn.apply(this, arguments);
				} catch(err) {
					return null;
				}
			};
			/////////////////////////////////////////////////////////////////////////////////



			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			// Monitor dynamic html element creation to prevent generating <a> elements with click dispatching event
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			document.createElement = function() {

					var newElement = originalCreateElementFn.apply(document, arguments);

					if (arguments[0] == "a" || arguments[0] == "A") {
						
						timeSinceCreateAElement = (new Date).getTime();

						var originalDispatchEventFn = newElement.dispatchEvent;

						newElement.dispatchEvent = function(event) {
							if (event.type != null && (("" + event.type).toLocaleLowerCase() == "click")) {
								window.pbreason = "blocked due to an explicit dispatchEvent event with type 'click' on an 'a' tag";
								// console.info(window.pbreason);
								parent.postMessage({type:"blockedWindow", args: JSON.stringify({"0": newElement.href}) }, parentOrigin);
								return true;
							}

							return originalDispatchEventFn(event);
						};

						lastCreatedAElement = newElement;

					}

					return newElement;
			};
			/////////////////////////////////////////////////////////////////////////////////




			/////////////////////////////////////////////////////////////////////////////////
			// Block artificial mouse click on frashly created <a> elements
			/////////////////////////////////////////////////////////////////////////////////
			document.createEvent = function() {
				try {
					if ((arguments[0].toLowerCase().indexOf("mouse") >= 0) && ((new Date).getTime() - timeSinceCreateAElement) <= 50) {
						window.pbreason = "Blocked because 'a' element was recently created and " + arguments[0] + " event was created shortly after";
						// console.info(window.pbreason);
						arguments[0] = lastCreatedAElement.href;
						parent.postMessage({ type: "blockedWindow", args: JSON.stringify({"0": lastCreatedAElement.href}) }, parentOrigin);
						return null;
					}
					return originalCreateEventFn.apply(document, arguments);
				} catch(err) {}
			};
			/////////////////////////////////////////////////////////////////////////////////





			/////////////////////////////////////////////////////////////////////////////////
			// Monitor full screen requests
			/////////////////////////////////////////////////////////////////////////////////
			function onFullScreen(isInFullScreenMode) {
					if (isInFullScreenMode) {
						fullScreenOpenTime = (new Date()).getTime();
						// console.info("fullScreenOpenTime = " + fullScreenOpenTime);
					} else {
						fullScreenOpenTime = NaN;
					}
			};
			/////////////////////////////////////////////////////////////////////////////////

			function isDocumentInFullScreenMode() {
				// Note that the browser fullscreen (triggered by short keys) might
				// be considered different from content fullscreen when expecting a boolean
				return ((document.fullScreenElement && document.fullScreenElement !== null) ||    // alternative standard methods
					((document.mozFullscreenElement != null) || (document.webkitFullscreenElement != null)));                   // current working methods
			}

			document.addEventListener("fullscreenchange", function () {
				onFullScreen(document.fullscreen);
			}, false);

			document.addEventListener("mozfullscreenchange", function () {
				onFullScreen(document.mozFullScreen);
			}, false);

			document.addEventListener("webkitfullscreenchange", function () {
				onFullScreen(document.webkitIsFullScreen);
			}, false);

		} inject()</script></html>