# provides simple database agnostic solution for random records for small result sets (performance hits on large results sets)
# sample usage: profile.friends.find(:all, :limit => 10, :order => ActiveRecord::Base.connection.rand)

module ActiveRecord
  module ConnectionAdaptersExt
    module Random 
      def rand
        'RANDOM()'
      end
    end
    module Rand
      def rand
        'RAND()'
      end
    end
  end
end

case ActiveRecord::Base.connection.adapter_name
when 'MySQL'
  ActiveRecord::ConnectionAdapters::MysqlAdapter.send(:include, ActiveRecord::ConnectionAdaptersExt::Rand)
else # 'PostgreSQL', 'SQLite3'
  ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, ActiveRecord::ConnectionAdaptersExt::Random)
end
