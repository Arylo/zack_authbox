'use strict'

app = angular.module('zack', [ ], angular.noop)

app.constant 'DEBUG', false

app.config (DEBUG) ->

    if not DEBUG
        (console[key] = angular.noop) for own key of console

    return

app.controller 'BaseController', ($scope, $rootScope) ->

    $rootScope.logined = false
    $rootScope.auth = null

    console.log 'BaseCtrl'

    setLoginStatus = (auth) ->

        $rootScope.logined = true
        $rootScope.auth = auth
        console.log auth

        $rootScope.$broadcast 'login', auth

        if not /^\/member/.test window.location.pathname
            window.location.href = "/member/?" + (
                "#{key}=#{val}" for key, val of auth
            ).join('&')
        return

    action_logout =
    $scope.action_logout = ->
        localStorage.clear()
        window.location.href = '/'
        return true

    do ->
        zack = if localStorage.getItem('zack')?
            JSON.parse localStorage.getItem 'zack'
        else
            null

        # Use Localstroage
        if zack?.auth?.token? and
                zack?.auth?.id_card?
            setLoginStatus zack.auth
            return

        # Use Search
        searchs = window.location.search
                .replace(/^\?/, '')
                .split('&');

        search = { };
        for item in searchs
            [key, value] = item.split '='
            search[key] = value
            continue

        if search.token? and search.id_card?
            setLoginStatus {
                id_card: search.id_card
                token: search.token
            }
        else if window.location.pathname isnt '/'
            action_logout()
    return
