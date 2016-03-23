class Wargame
  include Tire::Model::Persistence

  property :name,       type: 'string', index: 'not_analyzed'
  property :admin,      type: 'string', index: 'not_analyzed'
  property :status,     type: 'string', index: 'not_analyzed'
  property :http,       type: 'string', index: 'not_analyzed'
  property :ssh_port,   type: 'string', index: 'not_analyzed'
  property :http_port,  type: 'string', index: 'not_analyzed'
  property :details,    type: 'string', index: 'not_analyzed'
  property :logo,       type: 'string', index: 'not_analyzed'
  property :created_by, type: 'string', index: 'not_analyzed'

  def create
    self.id = name
    self.created_by = current_user.name
  end

  def self.find_by_name(name)
    search(size: 1){ |s| s.query{ |q| q.term :name, name } }.first
  end
end
