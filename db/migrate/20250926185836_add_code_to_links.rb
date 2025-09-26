class AddCodeToLinks < ActiveRecord::Migration[7.1]
  # Needed because we're dropping/creating indexes CONCURRENTLY
  disable_ddl_transaction!

  def up
    # 1) Drop any old non-unique index so we can add a unique one
    execute 'DROP INDEX CONCURRENTLY IF EXISTS index_links_on_code'

    # 2) Backfill NULL codes (Postgres). 8 hex chars ~ 16^8 ≈ 4.3B combos.
    #    For a tiny table this is effectively collision-free.
    execute <<~SQL
      UPDATE links
      SET code = LOWER(SUBSTRING(MD5(random()::text), 1, 8))
      WHERE code IS NULL;
    SQL

    # 3) Add a unique index (outside transaction)
    add_index :links, :code, unique: true, algorithm: :concurrently

    # 4) Only now can we enforce NOT NULL
    change_column_null :links, :code, false
  end

  def down
    change_column_null :links, :code, true
    # leave the unique index, or drop it if you really want symmetry:
    # execute 'DROP INDEX CONCURRENTLY IF EXISTS index_links_on_code'
  end
end
