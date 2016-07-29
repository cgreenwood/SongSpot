@logged_in
Feature: Create various playlists as a user

  Scenario: Create a playlist using Song URI's
    Given I am on the new playlist page
    When I set the number of tracks to 90
      And I set the minimum song popularity to 75
      And I provide "spotify:track:5UuVC9noWHcsOX08ctdbDD" as a track URI
    Then a playlist is created
      And the view playlist page is loaded
