# Get current Projects and Tickets from LighthouseApp.com
#
# Add to heroku :
# % heroku config:add HUBOT_LIGHTHOUSE_PROJECT ="..."
# % heroku config:add HUBOT_LIGHTHOUSE_TOKEN="..."
# Example error and further API :
# http://help.lighthouseapp.com/kb/api/
#
module.exports = (robot) ->

  # Get all project
  # Hubot> hubot show me all projects  
  robot.respond /(show me all )(lighthouse|lh)( projects)$/i, (msg) ->
    token = process.env.HUBOT_LIGHTHOUSE_TOKEN
    project = process.env.HUBOT_LIGHTHOUSE_PROJECT
  
    msg.http("http://#{project}.lighthouseapp.com/projects.json")
      .headers("X-LighthouseToken": "#{token}")
      .get() (err, res, body) ->
        body = JSON.parse(body)
        body.projects.forEach (p) ->
          msg.send "1.[##{p.project.id}] [#{p.project.name}] Tickets Open - #{p.project.open_tickets_count} - http://#{project}.lighthouseapp.com/projects/#{p.project.id}-#{p.project.permalink}"

  # Get information on a single projects
  # Hubot> hubot show me (lighthouse|lh) project <project_id>
  robot.respond /(show me )(lighthouse|lh)?( project)(.*)$/i, (msg) ->
    project_id = msg.match[4]
    token = process.env.HUBOT_LIGHTHOUSE_TOKEN
    project = process.env.HUBOT_LIGHTHOUSE_PROJECT
    
    msg.http("http://#{project}.lighthouseapp.com/projects/#{project_id}.json")
      .headers("X-LighthouseToken": "#{token}")
      .get() (err, res, body) ->
        body = JSON.parse(body)
        msg.send "2.[##{body.project.id}] [#{body.project.name}] Tickets Open - #{body.project.open_tickets_count} - http://#{project}.lighthouseapp.com/projects/#{body.project.id}-#{body.project.permalink}"

  # Get all tickets for a Given project
  # Hubot> show me (lighthouse|lh) tickets for <project_id>
  robot.respond /(show me )(lighthouse|lh)( tickets for)(.*)$/i, (msg) ->
    project_id = msg.match[4]
    token = process.env.HUBOT_LIGHTHOUSE_TOKEN
    project = process.env.HUBOT_LIGHTHOUSE_PROJECT
   
    msg.http("http://#{project}.lighthouseapp.com/projects/#{project_id}/tickets.json")
      .headers("X-LighthouseToken": "#{token}")
      .get() (err, res, body) ->
        body = JSON.parse(body)
        body.tickets.forEach (t) ->
          msg.send "3.[##{t.ticket.project_id}] [Userid##{t.ticket.assigned_user_id}] [Ticket##{t.ticket.number}] #{t.ticket.state.toUpperCase()} '#{t.ticket.title}' - #{t.ticket.url}"

  # Get information on a single ticket
  # Hubot> show me (lighthouse|lh) <ticket_id> in <project_id>
  robot.respond /(show me )(lighthouse|lh )?(ticket )(.*)( in)(.*)$/i, (msg) ->
    ticket_id = msg.match[4]
    project_id = msg.match[6]
    token = process.env.HUBOT_LIGHTHOUSE_TOKEN
    project = process.env.HUBOT_LIGHTHOUSE_PROJECT
    
    msg.http("http://#{project}.lighthouseapp.com/projects/#{project_id}}/tickets/#{ticket_id}.json")
      .headers("X-LighthouseToken": "#{token}")
      .get() (err, res, body) ->
        body = JSON.parse(body)
        msg.send "4.[##{body.ticket.project_id}] [UserId##{body.ticket.user_id}] [Number#{body.ticket.number}] #{body.ticket.state.toUpperCase()}  '#{body.ticket.title}' - #{body.ticket.url}"