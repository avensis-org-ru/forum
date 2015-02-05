require 'sinatra'
require 'mysql'


$db = Mysql.connect 'pandora', 'avensis', '64bf7fdb', 'avensis'


class Simpozium
  @db

  def initialize db
    @db = db
  end

  def forum_indexes
    ids = []
    res = @db.query 'select `forum_id` from `avensis_forums` where 1;'

    res.each do |row|
      ids << row[0]
    end

   ids 
  end

  def forum id
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

  def topic_indexes
    ids = {} 
    res = @db.query "select `topic_id` from `avensis_topics` where `forum_id` = #{@id};"

    res.each do |row|
      ids << = row[0]
    end

     ids
  end

  def topic id
    Topic.new @db, id
  end
end

class Topic
  @db
  @id

  def initialize db, id
    @db = db
    @id = id
  end

  def title
    res = @db.query "select `topic_title` from `avensis_topics` where `topic_id` = #{@id};"

    return res.fetch_row[0]
  end

  def text
    res = @db.query "select `topic_text` from `avensis_topics` where `topic_id` = #{@id};"

    return res.fetch_row[0]
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

