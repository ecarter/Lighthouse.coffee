# Talk to LighthouseApp.com from Hubot
#
# Add to heroku:
# Bash$ heroku config:add HUBOT_LIGHTHOUSE_PROJECT ="..."
# Bash$ heroku config:add HUBOT_LIGHTHOUSE_TOKEN="..."
#
# Explore API further:
# http://help.lighthouseapp.com/kb/api/
#
# Created_by Dustin Eichler 12/19/2011
 
findAllProjects = (project) ->
  project.http("http://#{@lighthouse.project_name}.lighthouseapp.com/projects.json")
    .headers("X-LighthouseToken": "#{@lighthouse.token}")
    .get() (err, res, body) ->
      if err
        project.send "Error #{err}"
        return

      if res.statusCode == 200
        body = JSON.parse(body)
        body.projects.forEach (p) ->
          message = [
            "Project-Id #{p.project.id}\n",
            "Project-Name #{p.project.name}\n",
            "Open Tickets #{p.project.open_tickets_count}\n",
            "http://#{@lighthouse.project_name}.lighthouseapp.com/projects/#{p.project.id}-#{p.project.permalink}\n"
          ]
          project.send message.join(",")
      else
        project.send "Error #{res.message}"

findProjectById = (project) ->
  project_id = project.match[4]
  
  if project_id
    project_id.trim()
  else
    proeject.send "Error"
    return

  project.http("http://#{@lighthouse.project_name}.lighthouseapp.com/projects/#{project_id}.json")
    .headers("X-LighthouseToken": "#{@lighthouse.token}")
    .get() (err, res, body) ->
      if err
        project.send "Error #{err}"
        return

      if res.statusCode == 200
        body = JSON.parse(body)
        message = [
          "Project-Id #{body.project.id}\n",
          "Project-Name #{body.project.name}\n",
          "Open Tickets #{body.projects.open_tickets_count}\n",
          "http://#{@lighthouse.project_name}.lighthouseapp.com/projects/#{body.project.id}-#{body.project.permalink}\n"
        ]
        project.send message.join(",")
      else
        project.send "Error #{res}"


findAllTickets = (ticket) ->
  ticket_id = ticket.match[4]
  ticket.http("http://#{@lighthouse.project_name}.lighthouseapp.com/projects/#{ticket_id}/tickets.json")
    .headers("X-LighthouseToken": "#{@lighthouse.token}")
    .get() (err, res, body) ->
      if err
        ticket.send "Error"
        return

      if res.statusCode == 200
        body = JSON.parse(body)
        body.tickets.forEach (t) ->
          message = [
            "Project-Id #{t.ticket.project_id}\n",
            "Title #{t.ticket.title}\n",
            "Assigned #{t.ticket.assigned_user_id}\n",
            "Ticket-Number #{t.ticket.number}\n",
            "#{t.ticket.url}\n"
          ]
          ticket.send message.join(",")
      else
        ticket.send "Error #{res.message}"
        
findTicketByIds = (ticket) ->
  ticket_id  = ticket.match[6]
  project_id = ticket.match[4]
  
  ticket.http("http://#{@lighthouse.project_name}.lighthouseapp.com/projects/#{project_id}}/tickets/#{ticket_id}.json")
    .headers("X-LighthouseToken": "#{@lighthouse.token}")
    .get() (err, res, body) ->
      if err
        ticket.send "Error"
        return

      if res.statusCode == 200
        body = JSON.parse(body)
        message = [
          "Project-Id #{body.ticket.project_id}\n",
          "Title #{body.ticket.title}\n",
          "Assigned #{body.ticket.user_id}\n",
          "Ticket-Number #{body.ticket.number}\n",
          "#{body.ticket.url}"
        ]
        ticket.send message.join(",")
      else
        ticket.send "Error #{res.message}"

class Lighthouse
  constructor: (rawDescription) ->
    @token = process.env.HUBOT_LIGHTHOUSE_TOKEN
    @project_name = process.env.HUBOT_LIGHTHOUSE_PROJECT

module.exports = (robot) ->

  @lighthouse = new Lighthouse
   
  # Find all projects
  # Hubot> hubot show me all projects  
  robot.respond /(show me all )(lighthouse|lh)( projects)$/i, (msg) ->
    findAllProjects msg

  # Find information on a single project
  # Hubot> hubot show me (lighthouse|lh) project <project_id>
  robot.respond /(show me )(lighthouse|lh)?( project)(.*)$/i, (msg) ->
    findProjectById msg

  # Find all tickets for a Given project
  # Hubot> show me (lighthouse|lh) tickets for <project_id>
  robot.respond /(show me )(lighthouse|lh)( tickets for)(.*)$/i, (msg) ->
    findAllTickets msg
   
  # Find information on a single ticket
  # Hubot> show me (lighthouse|lh) ticket <ticket_id> in <project_id>
  robot.respond /(show me )(lighthouse|lh )?(ticket )(.*)( in)(.*)$/i, (msg) ->
    findTicketByIds msg
