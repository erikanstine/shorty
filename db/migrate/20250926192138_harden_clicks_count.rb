class HardenClicksCount < ActiveRecord::Migration[8.0]
  def up
    execute 'UPDATE links SET clicks_count = 0 WHERE clicks_count IS NULL'
    change_column_default :links, :clicks_count, from: nil, to: 0
    change_column_null :links, :clicks_count, false
  end

  def down
    change_column_null :links, :clicks_count, true
    change_column_default :links, :clicks_count, from: 0, to: nil
  end
end
