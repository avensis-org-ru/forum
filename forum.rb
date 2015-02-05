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
    ids = [] 
    res = @db.query "select `topic_id` from `avensis_topics` where `forum_id` = #{@id};"

    res.each do |row|
      ids << row[0]
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

$sim = Simpozium.new $db

$sim.forum_indexes.each do |index|
  get "/forum/#{index}" do
    res = ''
    forum_desc = $sim.forum index

    res << "<h1>#{forum_desc.name}</h1>"

    forum_desc.topic_indexes.each do |index|
      res << "#{index.to_s}&nbsp;<a href=/topic/#{index.to_s}>#{forum_desc.topic(index).title}</a><br />"
    end

    res
  end
end

get '/forums' do
  res = ''

  $sim.forum_indexes.each do |index|
    res << "#{index}&nbsp;<a href=/forum/#{index}>#{$sim.forum(index).name}</a><br />"
  end

  res
end

# vim: sw=2 sts=2 ts=2:

