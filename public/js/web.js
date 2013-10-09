var support_app = angular.module('portal', ['$strap.directives']).
	config(['$routeProvider', '$locationProvider', function app_route_config($routeProvider, $locationProvider) {
		$routeProvider.
			when('/', {
				controller: SupportController,
				templateUrl: 'articles.html'
			})
		$locationProvider.html5Mode(true);
	}]);

function SupportController($scope) {
	$scope.get_articles = function() {
		$.ajax({
			dataType: 'json',
			url: '/content.json',
			method: 'GET',
			success: function(reply) {
				$scope.$apply(function() {
					var values = [];
					for (var key in reply) {
						values.push(reply[key]);
					};
					$scope.articles = values;
				});
			}
		});
	};

	$scope.get_articles();
}