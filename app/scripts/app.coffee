'use strict'

angular.module('nenokApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'google-maps',
  'nenokFilters'
])
  .config ($routeProvider, $locationProvider, $httpProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'partials/main'
        controller: 'MainCtrl'
      .when '/login',
        templateUrl: 'partials/login'
        controller: 'LoginCtrl'
      .when '/signup',
        templateUrl: 'partials/signup'
        controller: 'SignupCtrl'
      .when '/commands',
        templateUrl: 'partials/commands'
        controller: 'CommandsCtrl'
        authenticate: true
      .when '/settings',
        templateUrl: 'partials/settings'
        controller: 'SettingsCtrl'
        authenticate: true
      .when '/tracking',
        templateUrl: 'partials/tracking'
        controller: 'TrackingCtrl'
        authenticate: true
      # .when '/map',
      #   templateUrl: 'partials/map'
      #   controller: 'MapCtrl'
      #   authenticate: true
      # .when '/numbers',
      #   templateUrl: 'partials/numbers'
      #   controller: 'NumbersCtrl'
      #   authenticate: true
      .otherwise
        redirectTo: '/'

    $locationProvider.html5Mode true

    # Intercept 401s and redirect you to login
    $httpProvider.interceptors.push ['$q', '$location', ($q, $location) ->
      responseError: (response) ->
        if response.status is 401
          $location.path '/login'
          $q.reject response
        else
          $q.reject response
    ]
  .run ($rootScope, $location, Auth) ->

    # Redirect to login if route requires auth and you're not logged in
    $rootScope.$on '$routeChangeStart', (event, next) ->
      $location.path '/login'  if next.authenticate and not Auth.isLoggedIn()
