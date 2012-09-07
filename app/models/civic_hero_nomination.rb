class CivicHeroNomination < ActiveRecord::Base
  attr_accessible :nominator_email, :nominator_name, :nominee_email, :nominee_name, :reason, :community_id

  after_create :create_residents

  # This will create two resident files:
  # One for the nominee and one for the nominator
  #
  # The Resident model will take care of correlation
  # ...or at least, try to
  def create_residents
    # TODO: r.notes isn't updating when !r.notes.nil?...
    if r = Community.find(community_id).residents.find_by_email(nominee_email)
      new_notes = "Nominated by " << nominator_name << " with reason: " << reason
      if r.notes.nil?
        r.notes = new_notes
      else
        new_notes = r.notes << ", " << new_notes
        r.notes = nil
        r.save
        r.notes = new_notes
      end

      r.save
    else
      nominee_full = nominee_name.split(" ")
      nominee_first = nominee_full.first
      nominee_last = nominee_full[1]

      r = Resident.create(
        community_id: community_id,
        first_name: nominee_first,
        last_name: nominee_last,
        email: nominee_email,
        notes: "Nominated by " << nominator_name << " with reason: " << reason
      )

      r.add_tags("Type: Nominee")
      r.correlate
    end

    s = Community.find(community_id).residents.find_by_email(nominator_email)
    if !s.nil?
      new_notes = "Nominated: " << nominee_name
      if s.notes.nil?
        s.notes = new_notes
      else
        new_notes = s.notes << ", " << new_notes
        s.notes = nil
        s.save
        s.notes = new_notes
      end

      s.save
    else
      nominator_full = nominator_name.split(" ")
      nominator_first = nominator_full.first
      nominator_last = nominator_full[1]

      s = Resident.create(
        community_id: community_id,
        first_name: nominator_first,
        last_name: nominator_last,
        email: nominator_email,
        notes: "Nominated: " << nominee_name
      )

      s.add_tags("Type: Nominator")
      s.correlate
    end
  end
end
