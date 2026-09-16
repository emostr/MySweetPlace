class Api::InterestsController < ApplicationController
  def index
    labels = Place.discoverable.select("unnest(interests) AS label").to_sql
    rows = Place.connection.select_rows(<<~SQL)
      SELECT label, COUNT(*) FROM (#{labels}) AS interests
      GROUP BY label ORDER BY COUNT(*) DESC, label LIMIT 60
    SQL
    render json: { items: rows.map { |label, count| { label:, count: } } }
  end
end
