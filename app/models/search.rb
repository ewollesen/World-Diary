class Search
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::AttributeMethods

  attr_reader :query
  attr_reader :results


  def initialize(*args)
    super

    self.attributes = args.extract_options!
  end

  def attributes
    {results: @results, query: @query}
  end

  def attributes=(hash)
    @results = hash[:results] || @results
    @query = hash[:query] || @query
  end

  def persisted?
    false
  end

  def execute(user=User.new)
    s = Subject.arel_table
    q = "%#{@query}%"

    @results = Subject.find_by_sql(sql(user))

    self
  end


  private

  def sql(user)
    q = "%#{@query}%"
    vp_user_id_clause = user.id ? " = %d" % [user.id] : "IS NULL"

    <<EOF
SELECT subjects.*
  FROM subjects
  WHERE subjects.id IN (
        SELECT subjects.id
          FROM subjects
          WHERE name ILIKE '#{q}'

        UNION

        SELECT subjects.id
          FROM subjects
          WHERE anon_text ILIKE '#{q}'

        UNION

        SELECT subjects.id
          FROM subjects
          INNER JOIN veil_passes ON veil_passes.subject_id = subjects.id AND
                     veil_passes.user_id #{vp_user_id_clause}
          WHERE vp_text ILIKE '#{q}'

        UNION

        SELECT subjects.id
          FROM subjects
          WHERE text ILIKE '#{q}' AND #{user.dm?}
  )
EOF
  end

end
