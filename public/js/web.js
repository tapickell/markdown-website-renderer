var support_app = angular.module('portal', ['$strap.directives']).
	config(['$routeProvider', '$locationProvider', function app_route_config($routeProvider, $locationProvider) {
		$routeProvider.
			when('/', {
				controller: SupportController,
				templateUrl: 'articles.html'
			})
		$locationProvider.html5Mode(true);
	}]);

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