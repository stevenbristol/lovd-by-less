module PseudoCursors
  
  def self.included (base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    
    DEFAULT_BATCH_SIZE = 100
    
    def find_each (options = {})
      return nil unless block_given?
      
      batch_size = options[:batch_size] || DEFAULT_BATCH_SIZE
      options.delete(:batch_size)
      batch_size = batch_size.to_i
      batch_size = 1 if batch_size < 1
      
      wrap_in_transaction = options[:transaction]
      options.delete(:transaction)
      
      select_cursor_ids(options).in_groups_of(batch_size, false) do |row_ids|
        records = find(:all, :conditions => {primary_key => row_ids})
        
        if options[:order]
          sort_cursor_rows!(records, row_ids)
        end
        
        if wrap_in_transaction
          transaction do
            records.each{|record| yield(record)}
          end
        else
          records.each{|record| yield(record)}
        end
      end
      
      nil
    end
    
    protected
    
    def sort_cursor_rows! (records, row_ids)
      sort_hash = {}
      row_ids.each_with_index{|row_id, i| sort_hash[row_id] = i}
      records.sort!{|a, b| sort_hash[a.id] <=> sort_hash[b.id]}
    end
    
    def select_cursor_ids (options)
      ids_sql = send(:construct_finder_sql, options.merge(:select => "#{table_name}.#{primary_key}"))
      connection.select_all(ids_sql, "#{table_name} pseudo cursor").collect{|row| row['id'].to_i}
    end
    
  end
  
end
