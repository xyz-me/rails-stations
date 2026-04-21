class CreateSites < ActiveRecord::Migration[7.1]
  def up
    # 映画館（サイト）追加
    create_table :sites do |t|
      t.string 'name', null: false, default: ''
      t.timestamps
    end

    # 映画館（シネマ部屋）追加
    create_table :rooms do |t|
      t.integer 'screen_number', null: false
      t.references 'site', limit: 8, null: false, foreign_key: true
      t.timestamps
    end

    # 劇場（サイト）を追加
    default_site = Site.create!(name: '映画館1')

    # 既存のスクリーンに対するRoomを作成する
    room_ids = {}
    [1, 2, 3].each do |n|
      room = Room.create!(site_id: default_site.id, screen_number: n)
      room_ids[n] = room.id
    end

    # screenパラメータに外部キー制約を追加
    add_reference :screens, :room, foreign_key: true

    # データ移行: screen_number から room_id へ値をコピー
    room_ids.each do |old_number, new_id|
      execute "UPDATE screens SET room_id = #{new_id} WHERE screen_number = #{old_number}"
    end

    change_column_null :screens, :room_id, false
    remove_column :screens, :screen_number, :integer
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
