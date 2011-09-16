class CreateAmfSessions < ActiveRecord::Migration
  def change
    create_table :amf_sessions do |t|
      t.references :characters
	    t.string   "expire"
#	    t.string   "mid"
#	    t.string   "secret"
	    t.string   "sid"
#	    t.string   "sig"
	    t.integer  "user_id"
	    t.text		 "data"
      t.timestamps
    end
  end
end
