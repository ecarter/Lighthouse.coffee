### Lighthouse.coffee
====================

### Installation (Rails 3)

<pre>
  Bash$ heroku config:add HUBOT_LIGHTHOUSE_PROJECT ="..."
  Bash$ heroku config:add HUBOT_LIGHTHOUSE_TOKEN="..."
</pre>

### Classes

*[Lighthouse.coffee](https://github.com/dustineichler/Lighthouse.coffee/blob/master/lighthouse.coffee) Lighthouse Hubot main file

### Usage

***Find all lighthouse current projects***
<pre>
  Hubot> hubot show me all projects 
</pre>

***Find a lighthouse project by Id***
<pre>
  Hubot> hubot show me (lighthouse|lh) project <project_id>
</pre>

***Find all current lighthouse tickets for a project***
<pre>
  Hubot> show me (lighthouse|lh) tickets for <project_id>
</pre>

***Find a lighthouse ticket by Id***
<pre>
  Hubot> show me (lighthouse|lh) ticket <ticket_id> in <project_id>
</pre>