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

        getAttributionToken: function () {
            return new Promise(function (resolve, reject) {
                exec(resolve, reject, 'SearchAdsPlugin', 'getAttributionToken', []);
            });
        }

	};
	return SearchAdsPlugin;
})();

var SearchAds = new SearchAdsPlugin();

module.exports = SearchAds;
