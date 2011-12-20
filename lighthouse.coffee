# Get current stories from Lighthouse
#
# You need to set the following variables:
#   HUBOT_LIGHTHOUSE_TOKEN = <API token>
#
# If you're working on a single project, you can set it once:
#   HUBOT_LIGHTHOUSE_PROJECT = <project name>
#
# Otherwise, include the project name in your message to Hubot.
#
# > show me all lighthouse projects
# > show me tickets for <project_id>

module.exports = (robot) ->
  robot.respond /show\s+(me\s+)?(all\s+)?( lighthouse|lh)\s+(projects\s+)?(.*)/i, (msg) ->
    token = process.env.HUBOT_LIGHTHOUSE_TOKEN
    project = process.env.HUBOT_LIGHTHOUSE_PROJECT
    
    msg.http("http://#{project}.lighthouseapp.com/projects.json")
      .headers("X-LighthouseToken": "#{token}")
      .get() (err, res, body) ->
        body = JSON.parse(body)
        body.projects.forEach (p) ->
          msg.send "Lighthouse Project Information ##{p.project.id}: #{p.project.name} Open tickets: #{p.project.open_tickets_count} Permalink: http://#{project}.lighthouseapp.com/projects"

  robot.respond /show\s+(me\s+)?tickets\s+(for\s+)?(.*)/i, (msg) ->
    query = msg.match[3]
    token = process.env.HUBOT_LIGHTHOUSE_TOKEN
    project = process.env.HUBOT_LIGHTHOUSE_PROJECT
 
    msg.http("http://#{project}.lighthouseapp.com/projects/#{query}/tickets.json")
      .headers("X-LighthouseToken": "#{token}")
      .get() (err, res, body) ->
        body = JSON.parse(body)
        body.tickets.forEach (t) ->
          msg.send "Project ##{t.ticket.project_id} Id ##{t.ticket.number} [#{t.ticket.state.toUpperCase()}] TITLE - #{t.ticket.title} ASSIGNED - #{t.ticket.assigned_user_id} [#{t.ticket.closed == 'false' ? 'Closed' : 'Open'}]  Milestone - #{t.ticket.milestone_id == 'null' ? 'Empty' : t.ticket.milestone_id}"
          
