Feature: Test the open API weather station

  Background:
    * url 'http://api.openweathermap.org'

  Scenario: Validating attempt to register a weather station without an API key should throw 401
    Given path '/data/3.0/stations'
    * header Content-Type = 'application/json'
    And request { "external_id": "SF_TEST001","name": "San Francisco Test Station","latitude": 37.76,"longitude": -122.43,"altitude": 150 }
    When method post
    Then status 401
    And match response == { "cod": 401,"message": "Invalid API key. Please see http://openweathermap.org/faq#error401 for more info." }

  Scenario Outline: Successfully register two stations and verify that HTTP response code is 201
    Given path '/data/3.0/stations'
    And params { id: 'saldiApiTest', appid: 'd6a592752fd559d509f4b2cb6fc93904' }
    * header Content-Type = 'application/json'
    And request requestJson
    When method post
    Then status 201
    Examples:
    |requestJson|
    | { "external_id": "DEMO_TEST001","name": "Team Demo Test Station 001","latitude": 33.33,"longitude": -122.43,"altitude": 222 }     |
    | { "external_id": "DEMO_TEST002","name": "Team Demo Test Station 002","latitude": 44.44,"longitude": -122.44,"altitude": 111 }     |


  Scenario: Get API verify that the stations were successfully stored in the DB and their values are the same as specified in the registration request
    Given path '/data/3.0/stations'
    And params { id: 'saldiApiTest', appid: 'd6a592752fd559d509f4b2cb6fc93904' }
    * header Content-Type = 'application/json'
    When method get
    Then status 200
    * def arrDEMO_TEST001 = $[?(@.external_id =~ /.*DEMO_TEST001/i)]
    Then match each arrDEMO_TEST001 contains { "external_id": "DEMO_TEST001","name": "Team Demo Test Station 001","latitude": 33.33,"longitude": -122.43,"altitude": 222 }
    * def arrDEMO_TEST002 = $[?(@.external_id =~ /.*DEMO_TEST002/i)]
    Then match each arrDEMO_TEST002 contains { "external_id": "DEMO_TEST002","name": "Team Demo Test Station 002","latitude": 44.44,"longitude": -122.44,"altitude": 111 }