
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

Factory.define :event do |e|
	e.description "im Wohnzimmer"
	e.finished 0
	e.start_on Date.today
end


