require 'sinatra'
require 'mysql'

$db = Mysql.connect 'pandora', 'avensis', '64bf7fdb', 'avensis'

class Forums
  @db

  def initialize db
    @db = db
  end

  def list
    forums = {}
    res = @db.query 'select `forum_id`, `forum_name` from `avensis_forums` where 1;'

    res.each do |row|
      forums[row[0]] = row[1]
    end

    forums
  end

  def get id
    Forum.new @db, id
  end
end

class Forum
  @db
  @id

  def initialize db, id
    @db = db
    @id = id
  end

  def name
    res = @db.query "select `forum_name` from `avensis_forums` where `forum_id` = #{@id};"

    return res.fetch_row[0]
  end

  def topics
    topics = {} 
    res = @db.query "select `topic_id`, `topic_title` from `avensis_topics` where `forum_id` = #{@id};"

    res.each do |topic|
      topics[topic[0].to_i] = topic[1]
    end

    topics 
  end
end

$forums = Forums.new $db

$forums.list.each do |forum|
  get "/forum/#{forum[0]}" do
    res = ''
    forum_desc = $forums.get forum[0]

    res << forum_desc.name << '<br />'

    forum_desc.topics.each do |topic|
      res << topic[0].to_s + '&nbsp;' + topic[1] + '<br />'
    end

    res
  end
end

get '/forums' do
  res = ''

  $forums.list.each do |forum|
    res << forum[0] + '&nbsp;' + forum[1] + '<br />'
  end

  res
end

# vim: sw=2 sts=2 ts=2:

