# Lighthouse.coffee

Talk to LighthouseApp.com from Hubot

## Configuration

    HUBOT_LIGHTHOUSE_ACCOUNT="..." # lighthouse subdomain
    HUBOT_LIGHTHOUSE_TOKEN="..." # lighthouse api token

## Commands

__Find all lighthouse current projects:__

    hubot (lighthouse|lh) projects 

__Find a lighthouse project by Id:__

    hubot (lighthouse|lh) project <project_id>

__Find all current lighthouse tickets for a project:__

    hubot (lighthouse|lh) tickets for <project_id>

__Find a lighthouse ticket by Id:__

    hubot (lighthouse|lh) ticket <ticket_id> in <project_id>

## Author

[Dustin Eichler](http://github.com/dustineichler)

