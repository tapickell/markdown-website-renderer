var support_app = angular.module('portal', ['$strap.directives']).
	config(['$routeProvider', '$locationProvider', function app_route_config($routeProvider, $locationProvider) {
		$routeProvider.
			when('/', {
				controller: SupportController,
				templateUrl: 'articles.html'
			})
		$locationProvider.html5Mode(true);
	}]);

support_app.filter('fuzzy_search', function() {
	return function(data_set, scope) {
		var keyword = scope.filter_keyword;
		if (!keyword || keyword == '') {
			return data_set;
		}
		var fuse = new Fuse(data_set);
		var indexes = fuse.search(keyword);
		var filtered_dataset = [];
		for (var index in indexes) {
			filtered_dataset.push(data_set[index]);
		}
		return filtered_dataset;
	};
});

function SupportController($scope, $location, $anchorScroll) {
	$scope.get_articles = function() {
		$.ajax({
			dataType: 'json',
			url: '/content.json',
			method: 'GET',
			success: function(reply) {
				$scope.$apply(function() {
					var values = [];
					var keys = [];
					for (var key in reply) {
						keys.push(key)
						values.push(reply[key]);
					};
					$scope.headings = keys;
					$scope.articles = values;
				});
			}
		});
	};

	$scope.go_to_id = function(div_id) {
		$scope.$apply(function() {
			$scope.hash = div_id;
			$location.hash(div_id);
			$anchorScroll();
		});
	};

	$scope.get_articles();
}