LOCAL  = 'http://localhost:9200'
REMOTE = 'http://hackersleague.org:9200'

MIGRATE_TYPES = [Wargame, User]

class String
  def clean
    self.underscore.parameterize('_')
  end
end

def migrate_dev
  MIGRATE_TYPES.each{ |type| create_local_index type }
  MIGRATE_TYPES.each{ |type| migrate_index type }
end

def delete_local_indexes
  MIGRATE_TYPES.each{ |klass| delete_local_index(klass) }
end

def delete_local_index(klass)
  Tire::Configuration.url LOCAL
  klass.index.delete
end

def migrate_index(klass)
  get_pages_from_remote(klass).times{ |page| save_local_data get_remote_data(klass, page+1) }
end

def get_pages_from_remote(klass)
  get_remote_data(klass, 1).total_pages
end

def create_local_index(klass)
  Tire::Configuration.url LOCAL
  klass.create_elasticsearch_index  
end

def get_remote_data(klass, page)
  Tire::Configuration.url REMOTE
  klass.search(page: page){query{all}}
end

def save_local_data(data)
  Tire::Configuration.url LOCAL
  data.each &:save
end

def migrate_schema(klass, new_index, old_index=klass.name.underscore.pluralize)
  klass.index_name new_index
  klass.create_elasticsearch_index
  Tire::Search::Scan.new(old_index).each_document{ |doc| klass.new(doc.attributes).save }
  klass.index_name old_index
  klass.index.delete
  klass.index_name new_index
  klass.index.add_alias old_index
end
