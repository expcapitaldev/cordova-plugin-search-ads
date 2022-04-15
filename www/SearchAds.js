'use strict';

var SearchAdsPlugin = (function () {

	var exec = require('cordova/exec');

	function SearchAdsPlugin () {}

	SearchAdsPlugin.prototype = {

		requestAttributionDetails: function () {
			return new Promise(function (resolve, reject) {
				exec(resolve, reject, 'SearchAdsPlugin', 'requestAttributionDetails', []);
			});
		},

	};
	return SearchAdsPlugin;
})();

var SearchAds = new SearchAdsPlugin();

module.exports = SearchAds;
