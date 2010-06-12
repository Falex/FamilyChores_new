class IcalfilesController < ApplicationController

  def index
    #@chores = Chore.all
	
	#my_file = File.new("famcalendar.ics", "w")
	#my_file.save
	

    respond_to do |format|
	  #format.ics {render :ics => generate_ics()}
      format.html # index.html.erb
	  
      #format.xml  { render :xml => @icalfiles }
    end
  end
  
  def show
    #@chores = Chore.all
	
	#my_file = File.new("famcalendar.ics", "w")
	#my_file.save
	

    respond_to do |format|
	  #format.html # index.html.erb
	  format.ics {render :ics => generate_ics() }
      
      #format.xml  { render :xml => @icalfiles }
    end
  end
  
  def generate_ics
	my_file = File.new("famcalendar.ics", "r+")
	my_file.write "BEGIN:VCALENDAR" + "\n"
	
	my_file.write "METHOD:PUBLISH" + "\n"
	my_file.write "BEGIN:VEVENT" + "\n"
	my_file.write "SUMMARY:Staubsaugen" + "- Paul"+ "\n"
	my_file.write "DTSTART;VALUE=DATE:20100610" + "\n"
	my_file.write "DTEND;VALUE=DATE:20100611" + "\n"
	my_file.write "CATEGORIES:Family" + "\n"
	my_file.write "DESCRIPTION:Paul" + "\n"
	my_file.write "ATTENDEE;CN=\"Paul\";" + "\n"
	my_file.write "SEQUENCE:0" + "\n"
	my_file.write "END:VEVENT" + "\n"
	my_file.write "END:VCALENDAR" + "\n"

	my_file.write "END:VEVENT" + "\n"
	my_file.write "END:VCALENDAR"
  end
end
