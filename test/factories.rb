
Factory.define :user do |u|  
  u.login "claudi"
	u.email "claudi@aon.at"
	u.password "123456"
  u.family "huber"
	u.family_password "huber"
end

Factory.define :fam do |f|  
   f.title "huber"
end

Factory.define :calendar do |c|  
  c.title "huber"
end

Factory.define :reward do |r|
	r.title "Konzert Ticket"
	r.points 30
	r.finished 0
end

#Factory.define :video do |v|
#	v.name "TestName"
#	v.beschreibung "Test Beschreibung"
#	v.active 1
#	v.user_id 1
#	v.video File.new(File.join(Rails.root, "/test/files/", "Blumen.png"))
#end
